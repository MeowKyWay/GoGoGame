import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { GameModule } from './game/game.module';
import { WebSocketService } from './web-socket/web-socket.service';
import { MatchesModule } from './matches/matches.module';

@Module({
  imports: [AuthModule, UsersModule, GameModule, MatchesModule],
  controllers: [AppController],
  providers: [AppService, WebSocketService],
})
export class AppModule {}
