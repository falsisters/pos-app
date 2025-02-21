import 'package:falsisters_pos_app/core/providers/dio_provider.dart';
import 'package:falsisters_pos_app/features/delivery/data/models/delivery_item_model.dart';
import 'package:falsisters_pos_app/features/delivery/data/repositories/delivery_repository.dart';
import 'package:falsisters_pos_app/features/sales/data/models/product_type_enum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deliveryRepositoryProvider = Provider((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return DeliveryRepository(dioClient);
});

final deliveryCartProvider =
    StateNotifierProvider<DeliveryCartNotifier, List<DeliveryItem>>((ref) {
  return DeliveryCartNotifier();
});

class DeliveryCartNotifier extends StateNotifier<List<DeliveryItem>> {
  DeliveryCartNotifier() : super([]);

  void addItem(DeliveryItem item) {
    final existingIndex = state.indexWhere(
        (i) => i.productId == item.productId && i.type == item.type);

    if (existingIndex >= 0) {
      state = [
        ...state.sublist(0, existingIndex),
        DeliveryItem(
          productId: item.productId,
          name: item.name,
          quantity: item.quantity,
          type: item.type,
          price: item.price,
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
        return DeliveryItem(
          productId: item.productId,
          name: item.name,
          quantity: quantity,
          price: item.price,
          type: item.type,
        );
      }
      return item;
    }).toList();
  }

  void clearCart() {
    state = [];
  }
}
