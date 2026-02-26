import '../repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;
  const LoginUseCase(this._repository);

  Future<String> call(String username, String password) =>
      _repository.login(username, password);
}
