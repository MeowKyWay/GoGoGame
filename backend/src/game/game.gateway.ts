import {
  WebSocketGateway,
  SubscribeMessage,
  MessageBody,
  ConnectedSocket,
  OnGatewayConnection,
  OnGatewayDisconnect,
  WebSocketServer,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
// import { GameService } from './game.service';

@WebSocketGateway(3001)
export class GameGateway implements OnGatewayConnection, OnGatewayDisconnect {
  constructor(/*private readonly gameService: GameService*/) {}

  @WebSocketServer()
  server: Server;

  private activeSockets: Record<string, Socket> = {}; // Store active connections

  onModuleInit() {
    this.server.on('connection', (socket) => this.handleConnection(socket));
  }

  handleConnection(client: Socket) {
    console.log(`Client connected: ${client.id}`);
    this.activeSockets[client.id] = client;
  }

  handleDisconnect(client: Socket) {
    console.log(`Client disconnected: ${client.id}`);
    delete this.activeSockets[client.id];
  }

  @SubscribeMessage('move')
  handleMove(
    @MessageBody() move: { gameId: string; x: number; y: number },
    @ConnectedSocket() client: Socket,
  ) {
    console.log(`Received move: Game ${move.gameId} - (${move.x}, ${move.y})`);

    // Save move to PostgreSQL
    // await this.gameService.saveMove(move);

    // Notify all players
    this.server.emit(`game-${move.gameId}`, move);
  }
}
