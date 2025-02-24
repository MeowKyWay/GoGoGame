import { Socket } from 'socket.io';
import { PublicUser } from 'src/users/users.service';

export type ConnectedPlayer = {
  socket: Socket;
  user: PublicUser;
};
