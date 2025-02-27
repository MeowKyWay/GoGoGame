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
import { validate } from 'class-validator';
import { WebSocketService } from 'src/web-socket/web-socket.service';
import { MatchService } from './match/match.service';
import { MoveDto } from './dto/move.dto';
import { WebSocketEvent } from './types/websocket-event.type';

@WebSocketGateway(3001)
export class GameGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;

  private activeSockets: Record<string, ConnectedPlayer> = {}; // Store active connections

  constructor(
    private readonly matchmakingService: MatchmakingService,
    private readonly authService: AuthService,
    private readonly webSocketService: WebSocketService,
    private readonly matchService: MatchService,
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
    await this.webSocketService.emitWithAck(client, 'authenticated');
    console.log(
      `[WebSocket] Client authenticated: ${user.username} (${client.id})`,
    );
  }

  handleDisconnect(client: Socket) {
    console.log(`[WebSocket] Client disconnected: ${client.id}`);

    const connectedPlayer = this.activeSockets[client.id];
    if (connectedPlayer) {
      this.matchmakingService.removeFromQueue(connectedPlayer);
      delete this.activeSockets[client.id];
    }
  }

  @SubscribeMessage(WebSocketEvent.JOIN_QUEUE)
  async handleJoinQueue(
    @ConnectedSocket() client: Socket,
    @MessageBody() joinQueueDto: JoinQueueDto,
  ) {
    console.log(`[WebSocket] Client ${client.id} joined the queue`);

    const errors = await this.validateDto(joinQueueDto);
    if (errors) {
      this.webSocketService.error(client, errors.join(', '));
      return;
    }

    const connectedPlayer = this.activeSockets[client.id];
    if (!connectedPlayer) {
      this.webSocketService.error(client, 'You are not authenticated');
      return;
    }

    try {
      await this.matchmakingService.addToQueue({
        connectedPlayer,
        ...joinQueueDto,
      });
    } catch (error) {
      console.error(`[Matchmaking] Failed to join queue:`, error);
      this.webSocketService.error(
        client,
        error instanceof Error ? error.message : 'Failed to join queue',
      );
    }
  }

  @SubscribeMessage(WebSocketEvent.LEAVE_QUEUE)
  handleLeaveQueue(@ConnectedSocket() client: Socket) {
    const connectedPlayer = this.activeSockets[client.id];
    if (connectedPlayer) {
      this.matchmakingService.removeFromQueue(connectedPlayer);
    } else {
      this.webSocketService.error(client, 'You are not in the queue');
    }
  }

  @SubscribeMessage(WebSocketEvent.MOVE)
  async handleMove(
    @ConnectedSocket() client: Socket,
    @MessageBody() moveDto: MoveDto,
  ) {
    const connectedPlayer = this.activeSockets[client.id];
    if (!connectedPlayer) {
      this.webSocketService.error(client, 'You are not authenticated');
      return;
    }
    const errors = await this.validateDto(moveDto);
    if (errors) {
      this.webSocketService.validationError(client, errors.join(', '));
      return;
    }

    const match = this.matchService.getMatchById(moveDto.matchId);
    if (!match) {
      this.webSocketService.error(client, 'Match not found');
      return;
    }
    if (
      ![match.whitePlayer.user.id, match.blackPlayer.user.id].includes(
        connectedPlayer.user.id,
      )
    ) {
      this.webSocketService.error(client, 'You are not a player in this match');
    }

    try {
      this.matchService.move(moveDto);
    } catch (error) {
      console.error(`[Match] Failed to move:`, error);
      this.webSocketService.error(
        client,
        error instanceof Error ? error.message : 'Failed to move',
      );
    }
  }

  private rejectClient(client: Socket, message: string) {
    console.warn(`[WebSocket] Rejected client ${client.id}: ${message}`);
    client.emit('error', { message });
    client.disconnect();
  }

  private async validateDto(dto: object) {
    return await validate(dto).then((errors) => {
      if (errors.length > 0) {
        const errorMessages = errors.map((e) =>
          Object.values(e.constraints ?? {}).join(', '),
        );
        console.warn(`[Validation] Failed:`, errorMessages);
        return errorMessages;
      }
    });
  }
}
