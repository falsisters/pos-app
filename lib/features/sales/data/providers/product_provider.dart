import 'package:falsisters_pos_app/features/sales/data/providers/sales_provider.dart';
import 'package:falsisters_pos_app/features/sales/data/repositories/sales_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productsNotifierProvider =
    StateNotifierProvider<ProductsNotifier, AsyncValue<List<dynamic>>>((ref) {
  return ProductsNotifier(ref.watch(salesRepositoryProvider));
});

class ProductsNotifier extends StateNotifier<AsyncValue<List<dynamic>>> {
  final SalesRepository _repository;

  ProductsNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      state = const AsyncValue.loading();
      final products = await _repository.getProducts();
      state = AsyncValue.data(products);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> refreshProducts() async {
    loadProducts();
  }
}
