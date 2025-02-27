export class GameFormat {
  boardSize: number;
  initialTime: number;
  increment: number;

  constructor(boardSize: number, initialTime: number, increment: number) {
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
