import 'package:falsisters_pos_app/core/providers/dio_provider.dart';
import 'package:falsisters_pos_app/features/sales/data/models/cart_item_model.dart';
import 'package:falsisters_pos_app/features/sales/data/models/product_type_enum.dart';
import 'package:falsisters_pos_app/features/sales/data/repositories/sales_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final salesRepositoryProvider = Provider((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return SalesRepository(dioClient);
});

final productsProvider = FutureProvider((ref) {
  final repository = ref.watch(salesRepositoryProvider);
  return repository.getProducts();
});

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addItem(CartItem item) {
    final existingIndex = state.indexWhere(
        (i) => i.productId == item.productId && i.type == item.type);

    if (existingIndex >= 0) {
      state = [
        ...state.sublist(0, existingIndex),
        CartItem(
          productId: item.productId,
          name: item.name,
          price: item.price,
          quantity: item.type == ProductType.SPECIAL_PRICE
              ? item.minimumQty
              : state[existingIndex].quantity + 1,
          type: item.type,
          minimumQty: item.minimumQty,
        ),
        ...state.sublist(existingIndex + 1),
      ];
    } else {
      state = [...state, item];
    }
  }

  void removeItem(String productId, ProductType type) {
    state = state
        .where((item) => !(item.productId == productId && item.type == type))
        .toList();
  }

  void updateQuantity(String productId, ProductType type, int quantity) {
    state = state.map((item) {
      if (item.productId == productId && item.type == type) {
        return CartItem(
          productId: item.productId,
          name: item.name,
          price: item.price,
          quantity: quantity,
          type: item.type,
          minimumQty: item.minimumQty,
        );
      }
      return item;
    }).toList();
  }

  void clearCart() {
    state = [];
  }

  double get total => state.fold(0, (sum, item) => sum + item.total);
}
