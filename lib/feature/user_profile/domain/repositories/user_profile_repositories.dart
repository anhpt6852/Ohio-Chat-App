import 'package:ohio_chat_app/feature/user_profile/data/models/user_profile_model.dart';

abstract class UserProfileRepositories {
  Future<UserModel> fetchUserInfo();
}
