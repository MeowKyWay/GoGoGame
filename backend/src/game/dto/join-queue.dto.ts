import { IsIn, IsNotEmpty, IsNumber, IsPositive, Min } from 'class-validator';
export class JoinQueueDto {
  @IsNotEmpty()
  @IsNumber()
  @IsIn([9, 13, 19], { message: 'Board size must be 9, 13, or 19' })
  boardSize: number;

  @IsNotEmpty()
  @IsNumber()
  @IsPositive()
  initialTime: number;

  @IsNotEmpty()
  @IsNumber()
  @Min(0, { message: 'Increment must be a positive number' })
  increment: number;
}
