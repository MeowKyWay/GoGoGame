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
    size: number,
    initialTime: number,
    increment: number,
  ): Match {
    const match = new Match(
      uuidv4(),
      whitePlayer,
      blackPlayer,
      size,
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
    match.move(moveDto);
    if (match.turn === 'black') {
      await this.webSocketService.emitWithAck(
        match.blackPlayer.socket,
        WebSocketEvent.MOVE,
        moveDto,
      );
    }
    if (match.turn === 'white') {
      await this.webSocketService.emitWithAck(
        match.blackPlayer.socket,
        WebSocketEvent.MOVE,
        moveDto,
      );
    }
  }

  getMatchById(id: string) {
    return this.matches.find((match) => match.id == id);
  }
}
