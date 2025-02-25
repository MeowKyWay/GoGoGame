import {
  WebSocketGateway,
  SubscribeMessage,
  ConnectedSocket,
  OnGatewayConnection,
  OnGatewayDisconnect,
  WebSocketServer,
  MessageBody,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { MatchmakingService } from './match-making/match-making.service';
import { ConnectedPlayer } from './types/player.type';
import { AuthService } from 'src/auth/auth.service';
import { PublicUser } from 'src/users/users.service';
import { JoinQueueDto } from './dto/join-queue.dto';
import { plainToInstance } from 'class-transformer';
import { validate } from 'class-validator';
// import { GameService } from './game.service';

@WebSocketGateway(3001)
export class GameGateway implements OnGatewayConnection, OnGatewayDisconnect {
  constructor(
    private readonly matchmakingService: MatchmakingService,
    private readonly authService: AuthService,
  ) {}

  @WebSocketServer()
  server: Server;

  private activeSockets: Record<string, ConnectedPlayer> = {}; // Store active connections

  onModuleInit() {
    this.server.on('connection', (socket) => this.handleConnection(socket));
  }

  async handleConnection(client: Socket) {
    console.log('Client connected:', client.id);
    const token = client.handshake.headers?.authorization?.split(' ')[1];

    let user: PublicUser;
    try {
      user = await this.authService.validateToken(token!);
    } catch {
      client.emit('error', {
        message: 'Invalid access token',
      });
      client.disconnect();
      return;
    }

    console.log(`Client connected: ${client.id}`);
    this.activeSockets[client.id] = {
      socket: client,
      user: user,
    };
  }

  handleDisconnect(client: Socket) {
    console.log(`Client disconnected: ${client.id}`);
    this.matchmakingService.removeFromQueue(this.activeSockets[client.id]);
    delete this.activeSockets[client.id];
  }

  @SubscribeMessage('joinQueue')
  async handleJoinQueue(
    @ConnectedSocket() client: Socket,
    @MessageBody() joinQueueDto: JoinQueueDto,
  ) {
    const dtoInstance = plainToInstance(JoinQueueDto, joinQueueDto);
    const errors = await validate(dtoInstance);

    if (errors.length > 0) {
      console.log(`Validation failed:`, errors);
      client.emit('validationError', {
        message: errors.map((e) => e.toString()),
      });
      return;
    }

    this.matchmakingService.addToQueue({
      connectedPlayer: this.activeSockets[client.id],
      ...joinQueueDto,
    });
  }

  @SubscribeMessage('leaveQueue')
  handleLeaveQueue(@ConnectedSocket() client: Socket) {
    this.matchmakingService.removeFromQueue(this.activeSockets[client.id]);
  }
}
