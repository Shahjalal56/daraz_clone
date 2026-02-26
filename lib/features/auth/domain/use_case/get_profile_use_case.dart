import '../entity/user_entity.dart';
import '../repository/auth_repository.dart';

class GetProfileUseCase {
  final AuthRepository _repository;
  const GetProfileUseCase(this._repository);

  Future<UserEntity> call(int id) => _repository.getProfile(id);
}
