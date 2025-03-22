import { Injectable } from '@nestjs/common';
import { Match } from './match';
import { ConnectedPlayer } from '../types/player.type';
import { MoveDto } from '../dto/move.dto';
import { WebSocketService } from 'src/web-socket/web-socket.service';
import { WebSocketEvent } from '../types/web-socket-event.type';
import { oppositeColor } from '../types/game.type';
import { MatchesService } from 'src/matches/matches.service';
import { CreateMatchDto } from 'src/matches/dto/create-match.dto';
import { Winner } from '@prisma/client';

@Injectable()
export class MatchService {
  private matches: Match[] = [];

  constructor(
    private readonly webSocketService: WebSocketService,
    private readonly matchesService: MatchesService,
  ) {}

  async createMatch(
    whitePlayer: ConnectedPlayer,
    blackPlayer: ConnectedPlayer,
    initialTime: number,
    incrementTime: number,
  ): Promise<Match> {
    const createMatchDto = {
      whitePlayerId: whitePlayer.user.id,
      blackPlayerId: blackPlayer.user.id,
      initialTime,
      incrementTime: incrementTime,
    } as CreateMatchDto;

    const matchModel = await this.matchesService.createMatch(createMatchDto);

    const match = new Match(
      matchModel.id,
      whitePlayer,
      blackPlayer,
      initialTime,
      incrementTime,
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

  async gameOver(data: { match: Match; winner: Winner; message: string }) {
    const payload = {
      winner: data.winner,
      message: data.message,
      matchId: data.match.id,
    };
    console.log('Game Over', payload);
    // Notify both players about the game over
    const players = [data.match.whitePlayer, data.match.blackPlayer];

    for (const player of players) {
      try {
        if (player.socket.connected) {
          await this.webSocketService.emitWithAck(
            player.socket,
            WebSocketEvent.GAME_OVER,
            payload,
          );
        }
      } catch (error) {
        console.warn(
          `[WebSocket] Failed to send game over event to ${player.user.username}:`,
          error,
        );
      }
    }

    const score = data.match.score();

    await this.matchesService.updateMatch(data.match.id, {
      winner: data.winner,
      endReason: data.message,
      blackScore: score.black,
      whiteScore: score.white,
      timeLeftBlack: data.match.timeLeft.black,
      timeLeftWhite: data.match.timeLeft.white,
    });

    // Remove the match from the list
    this.matches = this.matches.filter((m) => m.id !== data.match.id);
  }

  getMatchById(id: number) {
    return this.matches.find((match) => match.id == id);
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
