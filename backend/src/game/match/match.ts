import { Color, Move, Stone } from '../types/game.type';
import { ConnectedPlayer } from '../types/player.type';

export class Match {
  static readonly size = 8;

  readonly timestamp: number = Date.now();
  private _moves: Move[] = [];
  private _board: Stone[][];
  private _turn: Color = 'black';

  state: 'playing' | 'finished' = 'playing';
  winner: Color | null = null;

  private _timeLeft: Record<Color, number>;
  private _lastMoveTimestamp: number;

  get board(): Stone[][] {
    return this._board;
  }

  get moves(): Move[] {
    return this._moves;
  }

  get turn(): Color {
    return this._turn;
  }

  get timeLeft(): Record<Color, number> {
    return this._timeLeft;
  }

  constructor(
    readonly id: string,
    readonly whitePlayer: ConnectedPlayer,
    readonly blackPlayer: ConnectedPlayer,
    readonly initialTime: number, // Time in **minute** (✅ Marked Change)
    readonly increment: number, // Time increment per move in **seconds** (✅ Marked Change)
  ) {
    this._board = Array.from({ length: Match.size }, () =>
      Array.from({ length: Match.size }, () => ''),
    );

    this._board[3][3] = this._board[4][4] = 'white';
    this._board[3][4] = this._board[4][3] = 'black';

    this._timeLeft = {
      black: initialTime * 1000 * 60, // ✅ Convert minute to milliseconds
      white: initialTime * 1000 * 60, // ✅ Convert minute to milliseconds
    };

    this._lastMoveTimestamp = Date.now();
  }

  move(move: Move) {
    const { color, x, y } = move;

    if (this._turn !== color) {
      throw new Error(`It's not ${color}'s turn`);
    }

    this.updateTime();

    if (this._timeLeft[color] <= 0) {
      this.winner = color === 'black' ? 'white' : 'black';
      this.state = 'finished';
      console.log(`Game over: ${color} ran out of time. ${this.winner} wins!`);
      return;
    }

    if (!this.isValidMove(color, x, y)) {
      throw new Error(`Invalid move at (${x}, ${y})`);
    }

    this.place(color, x, y);
    this._moves.push(move);

    console.log(`[Match ${this.id}] ${color} moved to (${x},${y})`);
    this.logBoard();

    this._timeLeft[color] += this.increment * 1000; // ✅ Convert increment to milliseconds
    this._lastMoveTimestamp = Date.now();

    this.switchTurn();
  }

  updateTime() {
    const now = Date.now();
    const elapsed = now - this._lastMoveTimestamp;
    this._timeLeft[this._turn] -= elapsed;
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
      throw new Error(`Invalid move: No pieces flipped at (${x}, ${y})`);
    }

    this._board[x][y] = color;
    flipped.forEach(([fx, fy]) => (this._board[fx][fy] = color));
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
      console.log(`No legal moves for ${this._turn}. Skipping turn.`);
      this._turn = this._turn === 'black' ? 'white' : 'black';

      if (!this.hasLegalMove(this._turn)) {
        console.log(`Game over: No moves for either player.`);
        this.checkGameOver();
      }
    }

    this._lastMoveTimestamp = Date.now();
  }

  checkGameOver() {
    this.state = 'finished';

    const blackCount = this._board
      .flat()
      .filter((cell) => cell === 'black').length;
    const whiteCount = this._board
      .flat()
      .filter((cell) => cell === 'white').length;

    if (blackCount > whiteCount) {
      this.winner = 'black';
      console.log('Black wins!');
    } else if (whiteCount > blackCount) {
      this.winner = 'white';
      console.log('White wins!');
    } else {
      this.winner = null;
      console.log('Game ends in a draw.');
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

    console.log(
      `Time left - Black: ${this._timeLeft.black / 1000}s, White: ${this._timeLeft.white / 1000}s`,
    ); // ✅ Convert time back to seconds for display
  }
}
