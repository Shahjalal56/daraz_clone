import 'package:flutter/foundation.dart';
import '../../../products/domain/entity/product_entity.dart';
import '../../../products/domain/use_case/get_products_use_case.dart';
import '../../../../core/error/error_handler.dart';

enum ProductState { initial, loading, loaded, error }

class ProductViewModel extends ChangeNotifier {
  final GetProductsUseCase getProductsUseCase;

  ProductViewModel({required this.getProductsUseCase});

  // Per-category state
  final Map<String, List<ProductEntity>> _products = {};
  final Map<String, ProductState> _states = {};
  final Map<String, String?> _errors = {};

  List<ProductEntity> getProducts(String category) =>
      _products[category] ?? [];

  ProductState getState(String category) =>
      _states[category] ?? ProductState.initial;

  String? getError(String category) => _errors[category];

  Future<void> fetchProducts(String category,
      {bool refresh = false}) async {
    if (!refresh && _states[category] == ProductState.loaded) return;

    _states[category] = ProductState.loading;
    _errors[category] = null;
    notifyListeners();

    try {
      final cat = category == 'all' ? null : category;
      _products[category] = await getProductsUseCase(category: cat);
      _states[category] = ProductState.loaded;
    } catch (e) {
      _errors[category] = ErrorHandler.handle(e);
      _states[category] = ProductState.error;
    }
    notifyListeners();
  }
}
