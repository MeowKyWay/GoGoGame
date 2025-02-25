import { Injectable } from '@nestjs/common';
import { Socket } from 'socket.io';

@Injectable()
export class WebSocketService {
  emit(client: Socket, event: string, data: any = null): void {
    client.emit(event, data);
  }

  message(client: Socket, message: string): void {
    this.emit(client, 'message', { message: message });
  }

  async emitWithAck(
    client: Socket,
    event: string,
    data: any = null,
    maxRetries = 3,
    delayMs = 1000,
  ): Promise<boolean> {
    let attempts = 0;

    const attemptEmit = (): Promise<boolean> => {
      return new Promise((resolve) => {
        client.emit(event, data, (ack: boolean) => {
          if (ack) {
            resolve(true); // Success
          } else if (attempts < maxRetries) {
            attempts++;
            console.warn(
              `[WebSocket] ${event} event failed, retrying (${attempts}/${maxRetries})`,
            );
            setTimeout(() => resolve(attemptEmit()), delayMs); // Retry after delay
          } else {
            console.error(
              `[WebSocket] ${event} event failed permanently after ${maxRetries} attempts`,
            );
            resolve(false); // Failure
          }
        });
      });
    };

    return attemptEmit();
  }
}
