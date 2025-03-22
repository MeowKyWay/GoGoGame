import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';
import { CreateMatchDto } from './dto/create-match.dto';
import { Match } from '@prisma/client';

@Injectable()
export class MatchesService {
  constructor(private readonly prisma: PrismaService) {}

  async createMatch(createMatchDto: CreateMatchDto): Promise<Match> {
    return await this.prisma.match.create({
      data: {
        ...createMatchDto,
      },
    });
  }

  async getUsersMatches(userId: number): Promise<Match[]> {
    return await this.prisma.match.findMany({
      where: {
        OR: [{ blackPlayerId: userId }, { whitePlayerId: userId }],
      },
      include: {
        blackPlayer: {
          select: { id: true, username: true }, // Only send id & username
        },
        whitePlayer: {
          select: { id: true, username: true }, // Only send id & username
        },
      },
    });
  }
}
