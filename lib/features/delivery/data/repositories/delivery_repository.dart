import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:falsisters_pos_app/core/services/dio_client.dart';
import 'package:image_picker/image_picker.dart';

class DeliveryRepository {
  final Dio _dio;

  DeliveryRepository(DioClient dioClient) : _dio = dioClient.dio;

  Future<void> createDelivery(
      Map<String, dynamic> deliveryData, List<XFile> attachments) async {
    try {
      final formData = FormData();

      // Add the base delivery data
      formData.fields.addAll([
        MapEntry('total', deliveryData['total'].toString()),
        MapEntry('driver', deliveryData['driver']),
        MapEntry('deliveryItems', jsonEncode(deliveryData['deliveryItems'])),
      ]);

      // Add attachments if present
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
              'path': 'deliveries',
              // The actual file will be handled by NestJS as Express.Multer.File
            }),
          ));
        }
      }

      await _dio.post(
        '/delivery/create',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
    } catch (e) {
      throw Exception('Failed to create delivery: ${e.toString()}');
    }
  }
}
