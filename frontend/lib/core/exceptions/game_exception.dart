class InvalidMoveException implements Exception {
  final String message;

  InvalidMoveException([this.message = "Invalid move."]);

  @override
  String toString() => "InvalidMoveException: $message";
}

class IllegalMoveException implements Exception {
  final String message;

  IllegalMoveException([this.message = "Illegal move."]);

  @override
  String toString() => "IllegalMoveException: $message";
}

class NotYourTurnException implements Exception {
  final String message;

  NotYourTurnException([this.message = "Not your turn."]);

  @override
  String toString() => "NotYourTurnException: $message";
}
