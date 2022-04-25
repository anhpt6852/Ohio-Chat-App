import 'package:ohio_chat_app/feature/register/data/models/register_response.dart';

abstract class RegisterRepositories {
  Future<RegisterResponse> register(
      {required String phoneNumber,
      required String password,
      required String email,
      required String fullname});
}
