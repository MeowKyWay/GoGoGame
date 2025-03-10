export class GameFormat {
  initialTime: number;
  increment: number;

  constructor(initialTime: number, increment: number) {
    this.initialTime = initialTime;
    this.increment = increment;
  }

  equals(other: GameFormat): boolean {
    return (
      this.initialTime === other.initialTime &&
      this.increment === other.increment
    );
  }
}
