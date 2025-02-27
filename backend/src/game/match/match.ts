import { Color, Move, Stone } from '../types/game.type';
import { ConnectedPlayer } from '../types/player.type';

export class Match {
  readonly timestamp: number = Date.now();
  private moves: Move[] = [];
  private board: Stone[][];

  turn: Color = 'black';

  constructor(
    readonly id: string,
    readonly whitePlayer: ConnectedPlayer,
    readonly blackPlayer: ConnectedPlayer,
    readonly size: number,
    readonly initialTime: number,
    readonly increment: number,
  ) {
    this.board = Array.from({ length: size }, () =>
      Array.from({ length: size }, () => ''),
    );
  }

  move(move: Move) {
    const { color, x, y } = move;

    // Validate move
    if (x < 0 || x >= this.size || y < 0 || y >= this.size) {
      throw new Error('Move out of bounds');
    }
    if (this.board[x][y] !== '') {
      throw new Error('Cell already occupied');
    }
    if (color !== this.turn) {
      throw new Error('Not your turn');
    }

    // Place stone
    this.board[x][y] = color;
    this.moves.push(move);

    console.log(`[Match ${this.id}] ${color} moved to ${x},${y}`);
    console.log(this.board.map((row) => row.join(' ')).join('\n'));
    this.turn = this.turn === 'black' ? 'white' : 'black';
  }
}
