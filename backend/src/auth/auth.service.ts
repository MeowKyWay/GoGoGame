import {
  ConflictException,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { PublicUser, User, UsersService } from 'src/users/users.service';
import { verify } from 'argon2';
import { CreateUserDto } from 'src/users/dto/create-user.dto';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class AuthService {
  constructor(
    private readonly usersService: UsersService,
    private readonly jwtService: JwtService,
  ) {}

  async registerUser(createUserDto: CreateUserDto): Promise<User> {
    const user = await this.usersService.findByName(createUserDto.name);
    if (user) throw new ConflictException('User already exists!');
    return this.usersService.create(createUserDto);
  }

  async validateUser(name: string, password: string): Promise<PublicUser> {
    const user = (await this.usersService.findByName(name)) as User;
    if (user && (await verify(user.password, password))) {
      const result = {
        id: user.id,
        name: user.name,
      } as PublicUser;
      return result;
    }
    throw new UnauthorizedException('Invalid credentials');
  }

  login(user: PublicUser) {
    const payload = { username: user.name, sub: user.id };
    return {
      access_token: this.jwtService.sign(payload),
    };
  }
}
