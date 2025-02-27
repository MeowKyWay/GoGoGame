import { Injectable } from '@nestjs/common';
import { ConnectedPlayer, QueuingPlayer } from '../types/player.type';
import { GameFormat } from '../types/game-format.type';
import { WebSocketService } from 'src/web-socket/web-socket.service';
import { MatchService } from '../match/match.service';

@Injectable()
export class MatchmakingService {
  private queue: QueuingPlayer[] = []; // Waiting players

  constructor(
    private readonly webSocketService: WebSocketService,
    private readonly matchService: MatchService,
  ) {}

  async addToQueue({
    connectedPlayer,
    boardSize,
    initialTime,
    increment,
  }: {
    connectedPlayer: ConnectedPlayer;
    boardSize: number;
    initialTime: number;
    increment: number;
  }) {
    if (this.queue.some((e) => e.player.user.id === connectedPlayer.user.id)) {
      throw new Error(
        `Player ${connectedPlayer.user.username} is already in queue`,
      );
    }

    const newPlayer: QueuingPlayer = {
      player: connectedPlayer,
      format: new GameFormat(boardSize, initialTime, increment),
      timestamp: Date.now(),
    };

    this.queue.push(newPlayer);
    console.log(
      `[Matchmaking] ${connectedPlayer.user.username} joined the queue`,
    );

    this.webSocketService.message(connectedPlayer.socket, 'Queue joined');

    await this.matchPlayers();
  }

  removeFromQueue(connectedPlayer: ConnectedPlayer) {
    const initialLength = this.queue.length;
    this.queue = this.queue.filter(
      (e) => e.player.user.id !== connectedPlayer.user.id,
    );

    if (this.queue.length < initialLength) {
      console.log(
        `[Matchmaking] ${connectedPlayer.user.username} left the queue`,
      );
    }
  }

  private async matchPlayers() {
    for (let i = 0; i < this.queue.length; i++) {
      const player1 = this.queue[i];

      for (let j = i + 1; j < this.queue.length; j++) {
        const player2 = this.queue[j];

        if (player1.format.equals(player2.format)) {
          // Remove matched players from the queue
          this.queue.splice(j, 1);
          this.queue.splice(i, 1);
          console.log(
            `[Matchmaking] Match found: ${player1.player.user.username} vs ${player2.player.user.username}`,
          );

          const isPlayer1White = Math.random() < 0.5;

          const match = this.matchService.createMatch(
            player1.player,
            player2.player,
            player1.format.boardSize,
            player1.format.initialTime,
            player1.format.increment,
          );

          await this.webSocketService.emitWithAck(
            player1.player.socket,
            'match_found',
            {
              gameID: match.id, // TODO: Generate unique game ID
              opponent: player2.player.user,
              format: player1.format,
              isWhite: isPlayer1White,
            },
          );
          await this.webSocketService.emitWithAck(
            player2.player.socket,
            'match_found',
            {
              gameID: match.id, // TODO: Generate unique game ID
              opponent: player1.player.user,
              format: player2.format,
              isWhite: !isPlayer1White,
            },
          );

          return; // Stop further matching after a successful match
        }
      }
    }
  }
}
