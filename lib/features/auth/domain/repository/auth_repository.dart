import '../entity/user_entity.dart';

abstract class AuthRepository {
  Future<String> login(String username, String password);
  Future<UserEntity> getProfile(int id);
}
