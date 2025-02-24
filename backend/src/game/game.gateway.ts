import {
  WebSocketGateway,
  SubscribeMessage,
  ConnectedSocket,
  OnGatewayConnection,
  OnGatewayDisconnect,
  WebSocketServer,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { MatchmakingService } from './match-making/match-making.service';
import { ConnectedPlayer } from './types/connected-player.type';
import { AuthService } from 'src/auth/auth.service';
import { PublicUser } from 'src/users/users.service';
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
    const token = client.handshake.headers?.authorization?.split(' ')[1];
    if (!token) throw new Error('No token provided');

    let user: PublicUser;
    try {
      user = await this.authService.validateToken(token);
    } catch {
      throw new Error('Invalid token');
    }

    console.log(`Client connected: ${client.id}`);
    this.activeSockets[client.id] = {
      socket: client,
      user: user,
    };
  }

  handleDisconnect(client: Socket) {
    console.log(`Client disconnected: ${client.id}`);
    delete this.activeSockets[client.id];
  }

  @SubscribeMessage('joinQueue')
  handleJoinQueue(@ConnectedSocket() client: Socket) {
    this.matchmakingService.addToQueue(this.activeSockets[client.id]);
  }
}
