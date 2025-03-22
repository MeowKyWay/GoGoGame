type Winner = 'black' | 'white' | 'draw';

export class CreateMatchDto {
  initialTime: number;
  incrementTime: number;

  blackPlayerId: number;
  whitePlayerId: number;

  winner: Winner;
  endReason: string;

  blackScore: number;
  whiteScore: number;

  timeLeftBlack: number;
  timeLeftWhite: number;
}
