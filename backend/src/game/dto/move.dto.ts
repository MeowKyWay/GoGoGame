import {
  IsIn,
  IsNotEmpty,
  IsNumber,
  IsPositive,
  IsString,
} from 'class-validator';
export class MoveDto {
  @IsNotEmpty()
  @IsString()
  matchId: number;

  @IsNotEmpty()
  @IsString()
  @IsIn(['black', 'white'])
  color: 'black' | 'white';

  @IsNotEmpty()
  @IsNumber()
  @IsPositive()
  x: number;

  @IsNotEmpty()
  @IsNumber()
  @IsPositive()
  y: number;
}
