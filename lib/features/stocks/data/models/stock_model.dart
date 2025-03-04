import 'package:falsisters_pos_app/features/sales/data/models/product_type_enum.dart';

class StockUpdate {
  final String id;
  final int stock;
  final ProductType type;

  StockUpdate({
    required this.id,
    required this.stock,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stock': stock,
      'type': type.toString().split('.').last,
    };
  }
}

class EditStockRequest {
  final List<StockUpdate> price;

  EditStockRequest({
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'price': price.map((p) => p.toJson()).toList(),
    };
  }
}
