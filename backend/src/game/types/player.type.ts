import { Socket } from 'socket.io';
import { PublicUser } from 'src/users/users.service';
import { GameFormat } from './game-format.type';

export type ConnectedPlayer = {
  socket: Socket;
  user: PublicUser;
};

export type QueuingPlayer = {
  player: ConnectedPlayer;
  format: GameFormat;
  timestamp: number;
};
