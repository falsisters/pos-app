import 'package:falsisters_pos_app/features/sales/data/models/product_type_enum.dart';

class DeliveryItem {
  final String productId;
  final String name;
  final int quantity;
  final double price;
  final ProductType type;

  DeliveryItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.type,
  });
}
