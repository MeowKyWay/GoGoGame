import { Injectable } from '@nestjs/common';
import { MatchType } from './match';
import { ConnectedPlayer } from '../types/player.type';
import { MoveDto } from '../dto/move.dto';
import { WebSocketService } from 'src/web-socket/web-socket.service';
import { WebSocketEvent } from '../types/web-socket-event.type';
import { oppositeColor } from '../types/game.type';
import { MatchesService } from 'src/matches/matches.service';
import { Winner } from '@prisma/client';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class MatchService {
  private matches: MatchType[] = [];

  constructor(
    private readonly webSocketService: WebSocketService,
    private readonly matchesService: MatchesService,
  ) {}

  createMatch(
    whitePlayer: ConnectedPlayer,
    blackPlayer: ConnectedPlayer,
    initialTime: number,
    incrementTime: number,
  ): MatchType {
    const match = new MatchType(
      uuidv4(),
      whitePlayer,
      blackPlayer,
      initialTime,
      incrementTime,
    );

    console.log(
      `[MatchService] Match ${blackPlayer.user.username} vs ${whitePlayer.user.username} is created`,
    );

    this.matches.push(match);
    match.on('game_over', (data: { winner: Winner; message: string }) => {
      console.log(data);
      this.gameOver({
        match,
        ...data,
      }).catch((error) => console.log(error));
    });
    return match;
  }

  async move(moveDto: MoveDto) {
    const match = this.getMatchById(moveDto.matchId);
    if (!match) {
      throw new Error('Match not found');
    }

    try {
      match.move(moveDto);

      // Notify both players about the move
      await this.webSocketService.emitWithAck(
        match.whitePlayer.socket,
        WebSocketEvent.MOVE,
        {
          ...moveDto,
          timeLeft: match.timeLeft,
          turn: match.turn,
          timeStamp: Date.now(),
        },
      );
      await this.webSocketService.emitWithAck(
        match.blackPlayer.socket,
        WebSocketEvent.MOVE,
        {
          ...moveDto,
          timeLeft: match.timeLeft,
          turn: match.turn,
          timeStamp: Date.now(),
        },
      );
    } catch (error) {
      if (error instanceof Error) {
        console.log(error.message);
        const currentPlayer =
          moveDto.color === 'black' ? match.whitePlayer : match.blackPlayer;
        this.webSocketService.message(currentPlayer.socket, error.message);
      }
    }
  }

  async resign(userId: number) {
    const match = this.getMatchByPlayerId(userId);
    if (!match) {
      throw new Error('Match not found');
    }

    const winner = match.whitePlayer.user.id == userId ? 'black' : 'white';
    await this.gameOver({
      match,
      winner,
      message: `${oppositeColor(winner)} player resigned`,
    }).catch((error) => console.log(error));
  }

  async gameOver(data: { match: MatchType; winner: Winner; message: string }) {
    console.log(
      `[MatchService] Match ${data.match.blackPlayer.user.username} vs ${data.match.whitePlayer.user.username} is over with ${data.winner} as winner`,
    );

    const score = data.match.score();

    const match = await this.matchesService.createMatch({
      initialTime: data.match.initialTime,
      incrementTime: data.match.incrementTime,

      blackPlayerId: data.match.blackPlayer.user.id,
      whitePlayerId: data.match.whitePlayer.user.id,

      winner: data.winner,
      endReason: data.message,
      blackScore: score.black,
      whiteScore: score.white,
      timeLeftBlack: data.match.timeLeft.black,
      timeLeftWhite: data.match.timeLeft.white,
    });
    // Notify both players about the game over
    const players = [data.match.whitePlayer, data.match.blackPlayer];

    for (const player of players) {
      if (player.socket.connected) {
        await this.webSocketService.emitWithAck(
          player.socket,
          WebSocketEvent.GAME_OVER,
          {
            ...match,
            blackPlayer: data.match.blackPlayer.user,
            whitePlayer: data.match.whitePlayer.user,
          },
        );
      }
    }

    // Remove the match from the list
    this.matches = this.matches.filter((m) => m.id !== data.match.id);
  }

  getMatchById(id: string) {
    return this.matches.find((match) => match.id == id);
  }

  getMatchByPlayerId(playerId: number) {
    return this.matches.find(
      (match) =>
        match.whitePlayer.user.id === playerId ||
        match.blackPlayer.user.id === playerId,
    );
  }

  /// On disconnect, the player will lose the match
  onDisconnect(socketId: string) {
    const match = this.matches.find(
      (match) =>
        match.whitePlayer.socket.id === socketId ||
        match.blackPlayer.socket.id === socketId,
    );
    if (match) {
      const winner =
        match.whitePlayer.socket.id === socketId ? 'black' : 'white';
      this.gameOver({
        match,
        winner,
        message: `${oppositeColor(winner)} player disconnected`,
      }).catch((error) => console.log(error));
    }
  }
}
