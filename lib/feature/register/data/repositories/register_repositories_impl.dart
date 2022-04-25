import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_templates/core/results/failures.dart';
import 'package:ohio_templates/core/services/network_module.dart';
import 'package:ohio_templates/core/values/endpoints.dart';
import 'package:ohio_templates/feature/register/data/models/register_response.dart';
import 'package:ohio_templates/feature/register/domain/repositories/register_repositories.dart';

final registerRepositoryProvider =
    Provider.autoDispose<RegisterRepositoriesImpl>(
        (ref) => RegisterRepositoriesImpl(ref));

class RegisterRepositoriesImpl implements RegisterRepositories {
  final ProviderRef ref;

  RegisterRepositoriesImpl(this.ref);

  @override
  Future<RegisterResponse> register(
      {required String phoneNumber,
      required String password,
      required String email,
      required String fullname}) async {
    var body = {
      "name": fullname,
      "phone_number": phoneNumber,
      "email": email,
      "password": password
    };
    var networkModule = ref.read(networkModuleProvider);

    var response = await networkModule.post(Endpoints.register, data: body);

    var result = response.data;

    return RegisterResponse.fromJson(result);
  }
}
