import 'package:falsisters_pos_app/features/sales/data/models/product_model.dart';
import 'package:falsisters_pos_app/features/sales/data/models/product_type_enum.dart';

class PriceWithProduct {
  final String id;
  final double price;
  final int stock;
  final ProductType type;
  final Product product;
  final String productId;

  const PriceWithProduct({
    required this.id,
    required this.product,
    required this.price,
    required this.stock,
    required this.type,
    required this.productId,
  });

  factory PriceWithProduct.fromJson(Map<String, dynamic> json) {
    return PriceWithProduct(
      id: json['id'],
      price: json['price'].toDouble(),
      stock: json['stock'],
      product: Product.fromJson(json['product']),
      type: ProductType.values.firstWhere(
        (e) => e.toString() == 'ProductType.${json['type']}',
      ),
      productId: json['productId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
      'stock': stock,
      'type': type.toString().split('.').last,
      'productId': productId,
    };
  }
}

class KahonTransferredItem {
  final String id;
  final int qty;
  final String? name; // Make nullable since it might be missing
  final PriceWithProduct? price; // Make price nullable
  final String? priceId; // Add priceId field
  final String kahonId;
  final double value;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<KahonTransferredItemModifier> kahonTransferredItemModifier;

  KahonTransferredItem({
    required this.id,
    required this.qty,
    this.price,
    this.name,
    this.priceId,
    required this.value,
    required this.kahonId,
    required this.createdAt,
    required this.updatedAt,
    this.kahonTransferredItemModifier = const [],
  });

  factory KahonTransferredItem.fromJson(Map<String, dynamic> json) {
    return KahonTransferredItem(
      id: json['id'],
      qty: json['qty'],
      name: json['name'],
      // Handle both cases - full price object or just priceId
      price: json['price'] != null
          ? PriceWithProduct.fromJson(json['price'])
          : null,
      priceId: json['priceId'],
      kahonId: json['kahonId'],
      value: json['value'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      kahonTransferredItemModifier:
          (json['KahonTransferredItemModifier'] as List?)
                  ?.map((e) => KahonTransferredItemModifier.fromJson(e))
                  .toList() ??
              [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'qty': qty,
      'kahonId': kahonId,
      'value': value.toDouble(),
      'kahonTransferredItemModifier':
          kahonTransferredItemModifier.map((e) => e.toJson()).toList(),
    };

    // Add conditional fields
    if (name != null) data['name'] = name;
    if (price != null) data['price'] = price!.toJson();
    if (priceId != null) data['priceId'] = priceId;

    return data;
  }
}

enum OperationType { ADDITION, SUBTRACTION, MULTIPLICATION, DIVISION, TOTAL }

class KahonTransferredItemModifier {
  final String id;
  final int index;
  final OperationType operation;
  final double value;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String kahonTransferredItemId;

  KahonTransferredItemModifier({
    required this.id,
    required this.index,
    required this.operation,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
    required this.kahonTransferredItemId,
  });

  factory KahonTransferredItemModifier.fromJson(Map<String, dynamic> json) {
    return KahonTransferredItemModifier(
      id: json['id'],
      index: json['index'],
      value: (json['value'] as num).toDouble(),
      operation: OperationType.values
          .firstWhere((e) => e.toString().split('.').last == json['operation']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      kahonTransferredItemId: json['kahonTransferredItemId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'index': index,
      'value': value.toDouble(),
      'operation': operation.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'kahonTransferredItemId': kahonTransferredItemId,
    };
  }
}
