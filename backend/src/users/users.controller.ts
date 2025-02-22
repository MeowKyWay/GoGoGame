import { Controller, Get, Param } from '@nestjs/common';
import { UsersService } from './users.service';

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get('check-username/:username')
  async checkUsername(@Param('username') username: string) {
    return (await this.usersService.findByUsername(username)) !== undefined;
  }
}
