export enum BoardSize {
  b9x9 = 9,
  b13x13 = 13,
  b19x19 = 19,
}

export class GameFormat {
  boardSize: BoardSize;
  initialTime: number;
  increment: number;

  constructor(boardSize: BoardSize, initialTime: number, increment: number) {
    this.boardSize = boardSize;
    this.initialTime = initialTime;
    this.increment = increment;
  }

  equals(other: GameFormat): boolean {
    return (
      this.boardSize === other.boardSize &&
      this.initialTime === other.initialTime &&
      this.increment === other.increment
    );
  }
}
