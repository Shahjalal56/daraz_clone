import 'package:provider/provider.dart';
import '../../core/di/di_config.dart';
import '../../features/auth/domain/use_case/get_profile_use_case.dart';
import '../../features/auth/domain/use_case/login_use_case.dart';
import '../../features/auth/presentation/view_model/auth_view_model.dart';
import '../../features/products/domain/use_case/get_products_use_case.dart';
import '../../features/products/presentation/view_model/product_view_model.dart';
import '../../core/services/storage/token_storage.dart';

class AppViewModels {
  AppViewModels._();

  static List<ChangeNotifierProvider> get viewmodels => [
        ChangeNotifierProvider<AuthViewModel>(
          create: (_) => AuthViewModel(
            loginUseCase: sl<LoginUseCase>(),
            getProfileUseCase: sl<GetProfileUseCase>(),
            tokenStorage: sl<TokenStorage>(),
          ),
        ),
        ChangeNotifierProvider<ProductViewModel>(
          create: (_) =>
              ProductViewModel(getProductsUseCase: sl<GetProductsUseCase>()),
        ),
      ];
}
