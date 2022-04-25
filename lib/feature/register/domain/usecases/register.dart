import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_templates/feature/register/data/repositories/register_repositories_impl.dart';

registerProvider(
        {required String phoneNumber,
        required String password,
        required String email,
        required String fullname}) =>
    Provider.autoDispose((ref) {
      final registerRepositories = ref.watch(registerRepositoryProvider);
      return registerRepositories.register(
          email: email,
          fullname: fullname,
          password: password,
          phoneNumber: phoneNumber);
    });
