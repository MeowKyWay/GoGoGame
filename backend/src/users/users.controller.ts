import { Body, Controller, Get } from '@nestjs/common';
import { UsersService } from './users.service';
import { CheckUsernameDto } from './dto/check-username.dto';

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get('check-username')
  async checkUsername(@Body() checkUsernameDto: CheckUsernameDto) {
    return (
      (await this.usersService.findByUsername(checkUsernameDto.username)) !==
      undefined
    );
  }
}
