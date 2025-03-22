import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';
import { CreateMatchDto } from './dto/create-match.dto';
import { Match } from '@prisma/client';
import { UpdateMatchDto } from './dto/update-match.dto';

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

  async updateMatch(
    id: number,
    updateMatchDto: UpdateMatchDto,
  ): Promise<Match> {
    return await this.prisma.match.update({
      where: { id },
      data: updateMatchDto,
    });
  }

  async getUsersMatches(userId: number): Promise<Match[]> {
    return await this.prisma.match.findMany({
      where: {
        OR: [{ blackPlayerId: userId }, { whitePlayerId: userId }],
      },
    });
  }
}
