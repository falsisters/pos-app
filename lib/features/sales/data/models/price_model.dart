import 'package:falsisters_pos_app/features/sales/data/models/product_type_enum.dart';
import 'package:falsisters_pos_app/features/sales/data/models/special_price_model.dart';

class Price {
  final String id;
  final double price;
  final int stock;
  final ProductType type;
  final String productId;
  final List<SpecialPrice> specialPrices;

  const Price({
    required this.id,
    required this.price,
    required this.stock,
    required this.type,
    required this.productId,
    this.specialPrices = const [],
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      id: json['id'],
      price: json['price'].toDouble(),
      stock: json['stock'],
      type: ProductType.values.firstWhere(
        (e) => e.toString() == 'ProductType.${json['type']}',
      ),
      productId: json['productId'],
      specialPrices: (json['SpecialPrice'] as List?)
              ?.map((e) => SpecialPrice.fromJson(e))
              .toList() ??
          [],
    );
  }
}
