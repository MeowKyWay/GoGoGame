import { Module } from '@nestjs/common';
import { GameGateway } from './game.gateway';
import { MatchmakingService } from './match-making/match-making.service';
import { MatchService } from './match/match.service';
import { AuthModule } from 'src/auth/auth.module';
import { WebSocketService } from 'src/web-socket/web-socket.service';
import { MatchesModule } from 'src/matches/matches.module';

@Module({
  imports: [AuthModule, MatchesModule],
  providers: [GameGateway, MatchmakingService, MatchService, WebSocketService],
})
export class GameModule {}
