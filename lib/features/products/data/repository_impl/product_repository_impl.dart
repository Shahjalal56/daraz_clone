import '../../domain/entity/product_entity.dart';
import '../../domain/repository/product_repository.dart';
import '../data_source/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;

  const ProductRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<ProductEntity>> getProducts({String? category}) async {
    final models =
        await _remoteDataSource.getProducts(category: category);
    return models.map((m) => m.toEntity()).toList();
  }
}
