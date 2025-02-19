import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import { UsersModule } from 'src/users/users.module';
import { LocalStrategy } from './strategies/local.strategy';
import { PassportModule } from '@nestjs/passport';
import { AuthController } from './auth.controller';

@Module({
  providers: [AuthService, LocalStrategy],
  imports: [UsersModule, PassportModule],
  controllers: [AuthController],
})
export class AuthModule {}
