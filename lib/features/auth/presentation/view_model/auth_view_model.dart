import 'package:flutter/foundation.dart';
import '../../../auth/domain/entity/user_entity.dart';
import '../../../auth/domain/use_case/login_use_case.dart';
import '../../../auth/domain/use_case/get_profile_use_case.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/services/storage/token_storage.dart';

enum AuthState { initial, loading, success, error }

class AuthViewModel extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final GetProfileUseCase getProfileUseCase;
  final TokenStorage tokenStorage;

  AuthViewModel({
    required this.loginUseCase,
    required this.getProfileUseCase,
    required this.tokenStorage,
  });

  AuthState _state = AuthState.initial;
  UserEntity? _user;
  String? _errorMessage;

  AuthState get state => _state;
  UserEntity? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == AuthState.loading;

  Future<bool> login(String username, String password) async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await loginUseCase(username, password);
      await tokenStorage.saveToken(token);

      // FakeStore: fetch user id=1 after login
      _user = await getProfileUseCase(1);
      await tokenStorage.saveUserId(_user!.id);

      _state = AuthState.success;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = ErrorHandler.handle(e);
      _state = AuthState.error;
      notifyListeners();
      return false;
    }
  }

  Future<void> loadProfile() async {
    try {
      final userId = await tokenStorage.getUserId();
      if (userId != null) {
        _user = await getProfileUseCase(userId);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Profile load error: $e');
    }
  }

  Future<void> logout() async {
    await tokenStorage.clearToken();
    _user = null;
    _state = AuthState.initial;
    notifyListeners();
  }

  Future<bool> isLoggedIn() => tokenStorage.hasToken();
}
