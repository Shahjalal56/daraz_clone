import '../entity/product_entity.dart';
import '../repository/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository _repository;
  const GetProductsUseCase(this._repository);

  Future<List<ProductEntity>> call({String? category}) =>
      _repository.getProducts(category: category);
}
