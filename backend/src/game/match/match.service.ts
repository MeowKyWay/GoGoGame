import { Injectable } from '@nestjs/common';
import { Match } from './match';
import { ConnectedPlayer } from '../types/player.type';
import { v4 as uuidv4 } from 'uuid';
import { MoveDto } from '../dto/move.dto';
import { WebSocketService } from 'src/web-socket/web-socket.service';
import { WebSocketEvent } from '../types/websocket-event.type';
import { log } from 'console';

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
          timeStamp: Date.now(),
        },
      );
      await this.webSocketService.emitWithAck(
        match.blackPlayer.socket,
        WebSocketEvent.MOVE,
        {
          ...moveDto,
          timeLeft: match.timeLeft,
          timeStamp: Date.now(),
        },
      );
    } catch (error) {
      if (error instanceof Error) {
        log(error.message);
        const currentPlayer =
          moveDto.color === 'black' ? match.whitePlayer : match.blackPlayer;
        this.webSocketService.message(currentPlayer.socket, error.message);
      }
    }
  }

  getMatchById(id: string) {
    return this.matches.find((match) => match.id == id);
  }
}
