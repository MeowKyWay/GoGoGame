export enum WebSocketEvent {
  // These are the events that the server can send to the client
  MATCH_FOUND = 'match_found',
  MESSAGE = 'message',

  ERROR = 'error',
  VALIDATION_ERROR = 'validation_error',

  // These are the events that the client can send to the server
  JOIN_QUEUE = 'join_queue',
  LEAVE_QUEUE = 'leave_queue',
  MOVE = 'move',
}
