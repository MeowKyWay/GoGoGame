import { Injectable } from '@nestjs/common';
import { Match } from './match';
import { ConnectedPlayer } from '../types/player.type';
import { v4 as uuidv4 } from 'uuid';
import { MoveDto } from '../dto/move.dto';
import { WebSocketService } from 'src/web-socket/web-socket.service';
import { WebSocketEvent } from '../types/websocket-event.type';

@Injectable()
export class MatchService {
  private matches: Match[] = [];

  constructor(private readonly webSocketService: WebSocketService) {}

  createMatch(
    whitePlayer: ConnectedPlayer,
    blackPlayer: ConnectedPlayer,
    initialTime: number,
    increment: number,
  ): Match {
    const match = new Match(
      uuidv4(),
      whitePlayer,
      blackPlayer,
      initialTime,
      increment,
    );

    this.matches.push(match);
    match.on('game_over', (data: { winner: string; message: string }) => {
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

  async gameOver(data: { match: Match; winner: string; message: string }) {
    const payload = {
      winner: data.winner,
      message: data.message,
      matchId: data.match.id,
    };
    // Notify both players about the game over
    await this.webSocketService.emitWithAck(
      data.match.whitePlayer.socket,
      WebSocketEvent.GAME_OVER,
      payload,
    );
    await this.webSocketService.emitWithAck(
      data.match.blackPlayer.socket,
      WebSocketEvent.GAME_OVER,
      payload,
    );

    // Remove the match from the list
    this.matches = this.matches.filter((m) => m.id !== data.match.id);
  }

  getMatchById(id: string) {
    return this.matches.find((match) => match.id == id);
  }
}
