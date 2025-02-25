import { Module } from '@nestjs/common';
import { GameGateway } from './game.gateway';
import { MatchmakingService } from './match-making/match-making.service';
import { MatchService } from './match/match.service';
import { AuthModule } from 'src/auth/auth.module';
import { WebSocketService } from 'src/web-socket/web-socket.service';

@Module({
  imports: [AuthModule],
  providers: [GameGateway, MatchmakingService, MatchService, WebSocketService],
})
export class GameModule {}
