import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';

export type User = {
  id: number;
  email: string;
  name: string | null;
  password: string;
  hashedRefreshToken: string | null;
};

@Injectable()
export class UsersService {
  constructor(private readonly prisma: PrismaService) {}

  async findByEmail(email: string): Promise<User | undefined> {
    const user = await this.prisma.user.findUnique({
      where: {
        email,
      },
    });
    if (!user) {
      return undefined;
    }
    return {
      id: user.id,
      email: user.email,
      name: user.name,
      password: user.password,
      hashedRefreshToken: user.hashedRefreshToken,
    };
  }
}
