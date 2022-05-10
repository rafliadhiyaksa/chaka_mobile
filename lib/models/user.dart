import 'dart:convert';
import 'package:equatable/equatable.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User extends Equatable {
  const User({this.username = '', this.password = ''});

  final String username;
  final String password;

  @override
  List<Object?> get props => [username, password];

  factory User.fromJson(Map<String, dynamic> json) =>
      User(username: json['username'], password: json['password']);

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
      };
}
