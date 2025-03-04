import 'package:falsisters_pos_app/features/stocks/data/models/stock_model.dart';
import 'package:image_picker/image_picker.dart';

enum TransferType {
  OWN_CONSUMPTION,
  RETURN_TO_WAREHOUSE,
  REPACK,
}

class TransferStockRequest {
  final StockUpdate price;
  final int qty;
  final TransferType type;

  TransferStockRequest({
    required this.price,
    required this.qty,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'price': price.toJson(),
      'qty': qty,
      'type': type.toString().split('.').last,
    };
  }
}

class TransferResponse {
  final String id;
  final List<XFile> attachments;
  final String priceId;
  final int qty;
  final TransferType type;
  final DateTime createdAt;
  final DateTime updatedAt;

  TransferResponse({
    required this.id,
    required this.attachments,
    required this.priceId,
    required this.qty,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });
}
