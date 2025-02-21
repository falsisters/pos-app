import 'package:falsisters_pos_app/features/sales/data/models/price_model.dart';
import 'package:falsisters_pos_app/features/sales/data/models/product_type_enum.dart';

class Product {
  final String id;
  final String name;
  final String picture;
  final List<Price> prices;

  const Product({
    required this.id,
    required this.name,
    required this.picture,
    required this.prices,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      picture: json['picture'],
      prices:
          (json['Price'] as List?)?.map((e) => Price.fromJson(e)).toList() ??
              [],
    );
  }

  Price? getPriceByType(ProductType type) {
    try {
      return prices.firstWhere(
        (price) => price.type == type,
      );
    } catch (e) {
      return null;
    }
  }
}
