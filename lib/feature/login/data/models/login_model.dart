import 'package:equatable/equatable.dart';

class LoginModel extends Equatable {
  final String userName;

  const LoginModel({
    required this.userName,
  });

  @override
  List<Object?> get props => [
        userName,
      ];
}
