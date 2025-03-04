import 'package:falsisters_pos_app/features/sales/data/models/product_type_enum.dart';

class ProductPrice {
  final String id;
  final ProductType type;

  ProductPrice({
    required this.id,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
    };
  }
}

class TransferKahonRequest {
  final String id;
  final int qty;
  final ProductPrice price;

  TransferKahonRequest({
    required this.id,
    required this.qty,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'qty': qty,
      'price': price.toJson(),
    };
  }
}
