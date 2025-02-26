import { BoardSize } from '../types/game-format.type';
import { ConnectedPlayer } from '../types/player.type';

export class Match {
  private whitePlayer: ConnectedPlayer;
  private blackPlayer: ConnectedPlayer;

  private size: BoardSize;
  private initialTime: number;
  private increment: number;

  private timestamp: number;

  constructor(
    whitePlayer: ConnectedPlayer,
    blackPlayer: ConnectedPlayer,
    size: BoardSize,
    initialTime: number,
    increment: number,
  ) {
    this.whitePlayer = whitePlayer;
    this.blackPlayer = blackPlayer;

    this.size = size;
    this.initialTime = initialTime;
    this.increment = increment;

    this.timestamp = Date.now();
  }
}

export type Move = {
  player: 'white' | 'black';
  x: number;
  y: number;
};
