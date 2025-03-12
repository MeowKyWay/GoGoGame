import { Color, Move, Stone } from '../types/game.type';
import { ConnectedPlayer } from '../types/player.type';

export class Match {
  static size = 8;

  readonly timestamp: number = Date.now();
  private _moves: Move[] = [];
  private _board: Stone[][];
  private _turn: Color = 'black';

  state: 'playing' | 'finished' = 'playing';
  winner: Color | null = null;

  get board(): Stone[][] {
    return this._board;
  }

  get moves(): Move[] {
    return this._moves;
  }

  get turn(): Color {
    return this._turn;
  }

  constructor(
    readonly id: string,
    readonly whitePlayer: ConnectedPlayer,
    readonly blackPlayer: ConnectedPlayer,
    readonly initialTime: number,
    readonly increment: number,
  ) {
    this._board = Array.from({ length: Match.size }, () =>
      Array.from({ length: Match.size }, () => ''),
    );

    // Initial board setup
    this._board[3][3] = this._board[4][4] = 'white';
    this._board[3][4] = this._board[4][3] = 'black';
  }

  move(move: Move) {
    const { color, x, y } = move;

    if (this._turn !== color) {
      throw new Error('Not your turn');
    }

    if (!this.isValidMove(color, x, y)) {
      throw new Error('Invalid move');
    }

    this.place(color, x, y);
    this._moves.push(move);

    console.log(`[Match ${this.id}] ${color} moved to ${x},${y}`);
    this.logBoard();

    this.switchTurn();
    this.checkGameOver();
  }

  isValidMove(color: Color, x: number, y: number): boolean {
    return (
      x >= 0 &&
      x < Match.size &&
      y >= 0 &&
      y < Match.size &&
      this._board[x][y] === '' &&
      this.canFlip(color, x, y).length > 0
    );
  }

  place(color: Color, x: number, y: number) {
    const flipped = this.canFlip(color, x, y);

    if (flipped.length === 0) {
      throw new Error('Invalid move: no pieces flipped');
    }

    this._board[x][y] = color;
    for (const [fx, fy] of flipped) {
      this._board[fx][fy] = color;
    }
  }

  canFlip(color: Color, x: number, y: number): number[][] {
    const directions = [
      [-1, -1],
      [-1, 0],
      [-1, 1],
      [0, -1],
      [0, 1],
      [1, -1],
      [1, 0],
      [1, 1],
    ];

    return directions.flatMap(([dx, dy]) => {
      const flipped: number[][] = [];
      let nx = x + dx,
        ny = y + dy;

      while (
        nx >= 0 &&
        nx < Match.size &&
        ny >= 0 &&
        ny < Match.size &&
        this._board[nx][ny] !== '' &&
        this._board[nx][ny] !== color
      ) {
        flipped.push([nx, ny]);
        nx += dx;
        ny += dy;
      }

      return flipped.length > 0 &&
        nx >= 0 &&
        nx < Match.size &&
        ny >= 0 &&
        ny < Match.size &&
        this._board[nx][ny] === color
        ? flipped
        : [];
    });
  }

  hasLegalMove(color: Color): boolean {
    return this._board.some((row, x) =>
      row.some(
        (cell, y) => cell === '' && this.canFlip(color, x, y).length > 0,
      ),
    );
  }

  switchTurn() {
    this._turn = this._turn === 'black' ? 'white' : 'black';

    if (!this.hasLegalMove(this._turn)) {
      console.log(`${this._turn} has no moves. Turn skipped.`);
      this._turn = this._turn === 'black' ? 'white' : 'black';
    }
  }

  checkGameOver() {
    if (!this.hasLegalMove('black') && !this.hasLegalMove('white')) {
      console.log('Game over: No legal moves left for both players.');
    }
  }

  logBoard() {
    console.log(
      this._board
        .map((row) =>
          row
            .map((cell) =>
              cell === 'black' ? '⚫' : cell === 'white' ? '⚪' : '⬜',
            )
            .join(' '),
        )
        .join('\n'),
    );
  }
}
