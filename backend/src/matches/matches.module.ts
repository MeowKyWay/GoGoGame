import { Module } from '@nestjs/common';
import { MatchesService } from './matches.service';
import { PrismaService } from 'src/prisma/prisma.service';
import { MatchesController } from './matches.controller';
import { AuthModule } from 'src/auth/auth.module';

@Module({
  imports: [AuthModule],
  providers: [MatchesService, PrismaService],
  exports: [MatchesService],
  controllers: [MatchesController],
})
export class MatchesModule {}
