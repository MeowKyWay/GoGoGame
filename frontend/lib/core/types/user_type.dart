import 'package:gogogame_frontend/core/interfaces/jsonable.dart';

class UserType implements Jsonable {
  final int id;
  final String username;

  UserType({required this.id, required this.username});

  @override
  Map<String, dynamic> toJson() {
    return {'id': id, 'username': username};
  }

  @override
  String toString() {
    return 'UserType{id: $id, username: $username}';
  }

  factory UserType.fromJson(Map<String, dynamic> json) {
    return UserType(id: json['sub'] ?? json['id'], username: json['username']);
  }
}
