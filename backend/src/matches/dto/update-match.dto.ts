type Winner = 'black' | 'white' | 'draw';

export class UpdateMatchDto {
  winner: Winner;
  endReason: string;

  blackScore: number;
  whiteScore: number;

  timeLeftBlack: number;
  timeLeftWhite: number;
}
