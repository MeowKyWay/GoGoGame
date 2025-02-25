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

    connectedPlayer.socket.emit('message', { message: 'Joined queue' });

    this.matchPlayers();
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

  private matchPlayers() {
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

          player1.player.socket.emit('matchFound', {
            gameID: '123', // TODO: Generate unique game ID
            opponent: player2.player.user,
            format: player1.format,
          });

          player2.player.socket.emit('matchFound', {
            gameID: '123', // TODO: Generate unique game ID
            opponent: player1.player.user,
            format: player2.format,
          });

          // TODO: Create the actual game instance
          // this.gameService.createGame(player1, player2);

          return; // Stop further matching after a successful match
        }
      }
    }
  }
}
