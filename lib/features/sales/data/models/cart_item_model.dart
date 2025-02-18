import 'package:falsisters_pos_app/features/sales/data/models/product_type_enum.dart';

class CartItem {
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final ProductType type;
  final int minimumQty;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.type,
    required this.minimumQty,
  });

  double get total => price * quantity;
}
