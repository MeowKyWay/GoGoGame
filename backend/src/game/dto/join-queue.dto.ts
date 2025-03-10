import { IsNotEmpty, IsNumber, IsPositive, Min } from 'class-validator';
export class JoinQueueDto {
  @IsNotEmpty()
  @IsNumber()
  @IsPositive()
  initialTime: number;

  @IsNotEmpty()
  @IsNumber()
  @Min(0, { message: 'Increment must be a positive number' })
  increment: number;
}
