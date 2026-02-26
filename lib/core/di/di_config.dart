import 'package:get_it/get_it.dart';
import '../services/api/api_services.dart';
import '../services/storage/token_storage.dart';
import '../../features/auth/data/data_source/auth_remote_data_source.dart';
import '../../features/auth/data/repository_impl/auth_repository_impl.dart';
import '../../features/auth/domain/repository/auth_repository.dart';
import '../../features/auth/domain/use_case/get_profile_use_case.dart';
import '../../features/auth/domain/use_case/login_use_case.dart';
import '../../features/products/data/data_source/product_remote_data_source.dart';
import '../../features/products/data/repository_impl/product_repository_impl.dart';
import '../../features/products/domain/repository/product_repository.dart';
import '../../features/products/domain/use_case/get_products_use_case.dart';

final GetIt sl = GetIt.instance;

Future<void> diConfig() async {
  // ── Core Services ─────────────────────────────────────────────────────────
  sl.registerLazySingleton<ApiService>(() => ApiService());
  sl.registerLazySingleton<TokenStorage>(() => TokenStorage());

  // ── Auth ──────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSource(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));
  sl.registerLazySingleton<GetProfileUseCase>(() => GetProfileUseCase(sl()));

  // ── Products ──────────────────────────────────────────────────────────────
  sl.registerLazySingleton<ProductRemoteDataSource>(
      () => ProductRemoteDataSource(sl()));
  sl.registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(sl()));
  sl.registerLazySingleton<GetProductsUseCase>(() => GetProductsUseCase(sl()));
}
