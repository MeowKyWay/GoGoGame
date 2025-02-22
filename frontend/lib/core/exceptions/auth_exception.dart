class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([this.message = "Invalid credential."]);

  @override
  String toString() => message;
}

class ForbiddenException implements Exception {
  final String message;
  ForbiddenException([
    this.message = "You don't have permission to access this resource.",
  ]);

  @override
  String toString() => message;
}
