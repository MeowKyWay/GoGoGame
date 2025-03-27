type Winner = 'black' | 'white' | 'draw';

export class CreateMatchDto {
  initialTime: number;
  incrementTime: number;

  winner: Winner;
  endReason: string;

  blackScore: number;
  whiteScore: number;

  timeLeftBlack: number;
  timeLeftWhite: number;

  blackPlayer: {
    connect: {
      id: number;
    };
  };
  whitePlayer: {
    connect: {
      id: number;
    };
  };
}
