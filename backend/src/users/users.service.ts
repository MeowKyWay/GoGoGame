import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';
import { CreateUserDto } from './dto/create-user.dto';
import { hash } from 'argon2';

export type User = {
  id: number;
  email: string;
  name: string | null;
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
