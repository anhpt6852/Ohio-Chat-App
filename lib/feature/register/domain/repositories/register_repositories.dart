import 'package:ohio_templates/feature/register/data/models/register_response.dart';

abstract class RegisterRepositories {
  Future<RegisterResponse> register(
      {required String phoneNumber,
      required String password,
      required String email,
      required String fullname});
}
