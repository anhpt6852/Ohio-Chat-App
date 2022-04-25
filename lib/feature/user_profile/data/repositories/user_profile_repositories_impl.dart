import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_templates/feature/user_profile/data/models/user_profile_model.dart';
import 'package:ohio_templates/feature/user_profile/domain/repositories/user_profile_repositories.dart';

final userProfileRepositoryProvider =
    Provider.autoDispose<UserProfileRepositoriesImpl>(
        (ref) => UserProfileRepositoriesImpl());

class UserProfileRepositoriesImpl implements UserProfileRepositories {
  @override
  Future<UserModel> fetchUserInfo() async {
    return UserModel(
        userCountry: 'USA',
        userEmail: 'temp@gmail.com',
        userDob: '28/07/1997',
        userName: 'User1',
        userAvatar:
            'https://www.shareicon.net/data/512x512/2016/05/24/770137_man_512x512.png');
  }
}
