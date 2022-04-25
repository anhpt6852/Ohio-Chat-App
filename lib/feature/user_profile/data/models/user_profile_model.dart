import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  String? userName;
  String? userDob;
  String? userCountry;
  String? userEmail;
  String? userAvatar;

  UserModel({
    this.userName,
    this.userDob,
    this.userCountry,
    this.userEmail,
    this.userAvatar,
  });

  @override
  List<Object?> get props => [
        userName,
        userDob,
        userCountry,
        userEmail,
        userAvatar,
      ];
}
