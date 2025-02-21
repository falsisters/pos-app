import 'package:falsisters_pos_app/features/sales/data/models/product_type_enum.dart';

class CartItem {
  final String productId;
  final String name;
  final String picture;
  final double price;
  final int quantity;
  final ProductType type;
  final bool isSpecialPrice;

  CartItem({
    required this.productId,
    required this.name,
    required this.picture,
    required this.price,
    required this.quantity,
    required this.type,
    required this.isSpecialPrice,
  });

  double get total => price * quantity;
}
