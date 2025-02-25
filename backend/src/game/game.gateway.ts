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

@WebSocketGateway(3001)
export class GameGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;

  private activeSockets: Record<string, ConnectedPlayer> = {}; // Store active connections

  constructor(
    private readonly matchmakingService: MatchmakingService,
    private readonly authService: AuthService,
  ) {}

  async handleConnection(client: Socket) {
    console.log(`[WebSocket] Client connected: ${client.id}`);

    const token = client.handshake.headers?.authorization?.split(' ')[1];
    if (!token) {
      this.rejectClient(client, 'Missing access token');
      return;
    }

    let user: PublicUser;
    try {
      user = await this.authService.validateToken(token);
    } catch {
      this.rejectClient(client, 'Invalid access token');
      return;
    }

    this.activeSockets[client.id] = { socket: client, user };
    //Send authenticated event to client
    client.emit('authenticated');
    console.log(`[WebSocket] Client authenticated: ${user.id} (${client.id})`);
  }

  handleDisconnect(client: Socket) {
    console.log(`[WebSocket] Client disconnected: ${client.id}`);

    const connectedPlayer = this.activeSockets[client.id];
    if (connectedPlayer) {
      this.matchmakingService.removeFromQueue(connectedPlayer);
      delete this.activeSockets[client.id];
    }
  }

  @SubscribeMessage('joinQueue')
  async handleJoinQueue(
    @ConnectedSocket() client: Socket,
    @MessageBody() joinQueueDto: JoinQueueDto,
  ) {
    console.log(`[WebSocket] Client ${client.id} joined the queue`);

    const dtoInstance = plainToInstance(JoinQueueDto, joinQueueDto);
    const errors = await validate(dtoInstance);

    if (errors.length > 0) {
      const errorMessages = errors.map((e) =>
        Object.values(e.constraints ?? {}).join(', '),
      );
      console.warn(
        `[Validation] Failed for client ${client.id}:`,
        errorMessages,
      );
      client.emit('error', { message: errorMessages });
      return;
    }

    const connectedPlayer = this.activeSockets[client.id];
    if (!connectedPlayer) {
      client.emit('error', { message: 'You are not authenticated' });
      return;
    }

    try {
      this.matchmakingService.addToQueue({
        connectedPlayer,
        ...joinQueueDto,
      });
    } catch (error) {
      console.error(`[Matchmaking] Failed to join queue:`, error);
      client.emit('error', {
        message:
          error instanceof Error ? error.message : 'Failed to join queue',
      });
    }
  }

  @SubscribeMessage('leaveQueue')
  handleLeaveQueue(@ConnectedSocket() client: Socket) {
    const connectedPlayer = this.activeSockets[client.id];
    if (connectedPlayer) {
      this.matchmakingService.removeFromQueue(connectedPlayer);
    } else {
      client.emit('error', { message: 'You are not in the queue' });
    }
  }

  private rejectClient(client: Socket, message: string) {
    console.warn(`[WebSocket] Rejected client ${client.id}: ${message}`);
    client.emit('error', { message });
    client.disconnect();
  }
}
