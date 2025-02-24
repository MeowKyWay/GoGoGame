import { Injectable } from '@nestjs/common';
import { ConnectedPlayer } from '../types/connected-player.type';

@Injectable()
export class MatchmakingService {
  private queue: ConnectedPlayer[] = []; // Waiting players

  addToQueue(connectedPlayer: ConnectedPlayer) {
    console.log(`Player ${connectedPlayer.user.username} joined the queue`);
    this.queue.push(connectedPlayer);
    this.matchPlayers();
  }

  removeFromQueue(connectedPlayer: ConnectedPlayer) {
    this.queue = this.queue.filter(
      (e) => e.socket.id !== connectedPlayer.socket.id,
    );
  }

  private matchPlayers() {
    if (this.queue.length >= 2) {
      // Match two players
      const player1 = this.queue.shift();
      const player2 = this.queue.shift();

      if (player1 && player2) {
        const gameId = `game-${player1.socket.id}-${player2.socket.id}`;

        console.log(
          `Match created: ${player1.socket.id} vs ${player2.socket.id}`,
        );

        // Notify players
        player1.socket.emit('matchFound', { gameId, opponent: player2.user });
        player2.socket.emit('matchFound', { gameId, opponent: player1.user });
      }
    }
  }
}
