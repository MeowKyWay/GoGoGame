import { Injectable } from '@nestjs/common';
import { ConnectedPlayer, QueuingPlayer } from '../types/player.type';
import { GameFormat } from '../types/game-format.type';

@Injectable()
export class MatchmakingService {
  private queue: QueuingPlayer[] = []; // Waiting players

  addToQueue({
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
    console.log(`Player ${connectedPlayer.user.username} joined the queue`);
    this.queue.push({
      player: connectedPlayer,
      format: new GameFormat(boardSize, initialTime, increment),
      timestamp: Date.now(),
    });
    this.matchPlayers();
  }

  removeFromQueue(connectedPlayer: ConnectedPlayer) {
    this.queue = this.queue.filter(
      (e) => e.player.socket.id !== connectedPlayer.socket.id,
    );
  }

  private matchPlayers() {
    const player1 = this.queue[this.queue.length - 1];

    for (let i = 0; i < this.queue.length - 1; i++) {
      const player2 = this.queue[i];
      if (player1 === player2) continue;
      if (player1.format.equals(player2.format)) {
        this.queue = this.queue.filter(
          (e) => e.player.socket.id !== player1.player.socket.id,
        );
        this.queue.splice(i - 1, 1);
        this.queue.splice(0, 1);
        console.log(
          `Match found: ${player1.player.user.username} vs ${player2.player.user.username}`,
        );
        //TODO game id
        player1.player.socket.emit('matchFound', {
          gameID: '123',
          opponent: player2.player.user,
          format: player1.format,
        });
        player2.player.socket.emit('matchFound', {
          gameID: '123',
          opponent: player1.player.user,
          format: player2.format,
        });
        // this.gameService.createGame(player1, player2);
        return;
      }
    }
  }
}
