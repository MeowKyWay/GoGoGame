import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';
import { CreateUserDto } from './dto/create-user.dto';
import { hash } from 'argon2';

export type User = {
  id: number;
  name: string;
  password: string;
  hashedRefreshToken: string | null;
};

export type PublicUser = Omit<User, 'password' | 'hashedRefreshToken'>;

@Injectable()
export class UsersService {
  constructor(private readonly prisma: PrismaService) {}

  async create(createUserDto: CreateUserDto): Promise<User> {
    const { password, ...user } = createUserDto;
    const hashedPassword = await hash(password);
    return await this.prisma.user.create({
      data: {
        password: hashedPassword,
        ...user,
      },
    });
  }

  async findByName(name: string): Promise<User | undefined> {
    const user = await this.prisma.user.findUnique({
      where: {
        name,
      },
    });
    if (!user) {
      return undefined;
    }
    return {
      id: user.id,
      name: user.name,
      password: user.password,
      hashedRefreshToken: user.hashedRefreshToken,
    };
  }
}
