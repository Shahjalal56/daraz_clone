import '../../domain/entity/user_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../data_source/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  const AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<String> login(String username, String password) async {
    final response = await _remoteDataSource.login(username, password);
    return response.token;
  }

  @override
  Future<UserEntity> getProfile(int id) async {
    final model = await _remoteDataSource.getProfile(id);
    return model.toEntity();
  }
}
