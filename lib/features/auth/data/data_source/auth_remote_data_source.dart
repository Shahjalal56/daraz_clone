import '../../../../core/endpoints/api_endpoints.dart';
import '../../../../core/services/api/api_services.dart';
import '../model/login_response_model.dart';
import '../model/user_model.dart';

class AuthRemoteDataSource {
  final ApiService _apiService;

  const AuthRemoteDataSource(this._apiService);

  Future<LoginResponseModel> login(String username, String password) async {
    final response = await _apiService.post(
      ApiEndpoints.login,
      data: {'username': username, 'password': password},
    );
    return LoginResponseModel.fromJson(response.data);
  }

  Future<UserModel> getProfile(int id) async {
    final response = await _apiService.get(ApiEndpoints.user(id));
    return UserModel.fromJson(response.data);
  }
}
