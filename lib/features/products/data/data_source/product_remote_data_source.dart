import '../../../../core/endpoints/api_endpoints.dart';
import '../../../../core/services/api/api_services.dart';
import '../model/product_model.dart';

class ProductRemoteDataSource {
  final ApiService _apiService;

  const ProductRemoteDataSource(this._apiService);

  Future<List<ProductModel>> getProducts({String? category}) async {
    final path = category != null
        ? ApiEndpoints.productsByCategory(Uri.encodeComponent(category))
        : ApiEndpoints.products;

    final response = await _apiService.get(path);
    final list = response.data as List;
    return list
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
