import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:falsisters_pos_app/core/services/dio_client.dart';
import 'package:falsisters_pos_app/features/sales/data/models/product_model.dart';
import 'package:falsisters_pos_app/features/stocks/data/models/stock_model.dart';
import 'package:falsisters_pos_app/features/stocks/data/models/transfer_kahon_model.dart';
import 'package:falsisters_pos_app/features/stocks/data/models/transfer_stock_model.dart';

import 'package:image_picker/image_picker.dart';

class StockRepository {
  final Dio _dio;

  StockRepository(DioClient dioClient) : _dio = dioClient.dio;

  Future<List<Product>> getAllStocks() async {
    try {
      final response = await _dio.get('/stock');

      return (response.data as List)
          .map((json) => Product.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get stocks: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> transferToKahon(
      String productId, TransferKahonRequest request) async {
    try {
      final response =
          await _dio.post('/kahon/transfer/product', data: request.toJson());

      return response.data;
    } catch (e) {
      throw Exception('Failed to transfer to kahon: ${e.toString()}');
    }
  }

  Future<Product> editStock(String productId, EditStockRequest request) async {
    try {
      final response =
          await _dio.put('/stock/$productId', data: request.toJson());

      return Product.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to edit stock: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> transferStock(
      TransferStockRequest request, List<XFile> attachments) async {
    try {
      final formData = FormData();

      formData.fields.addAll([
        MapEntry('price', jsonEncode(request.price.toJson())),
        MapEntry('qty', request.qty.toString()),
        MapEntry('type', request.type.toString().split('.').last),
      ]);

      if (attachments.isNotEmpty) {
        for (var attachment in attachments) {
          // Create MultipartFile
          final file = await MultipartFile.fromFile(
            attachment.path,
            filename: attachment.name,
          );

          // Add attachment data matching the Upload DTO structure
          formData.files.add(MapEntry('attachments', file));
          formData.fields.add(MapEntry(
            'attachments',
            jsonEncode({
              'fileName': attachment.name,
              'path': 'transfers',
              // The actual file will be handled by NestJS as Express.Multer.File
            }),
          ));
        }
      }

      final response = await _dio.post(
        '/stock/transfer',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      return response.data;
    } catch (e) {
      throw Exception('Failed to transfer stock: ${e.toString()}');
    }
  }
}
