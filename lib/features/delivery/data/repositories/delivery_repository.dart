import 'package:dio/dio.dart';
import 'package:falsisters_pos_app/core/services/dio_client.dart';

class DeliveryRepository {
  final Dio _dio;

  DeliveryRepository(DioClient dioClient) : _dio = dioClient.dio;

  Future<void> createDelivery(Map<String, dynamic> deliveryData) async {
    try {
      await _dio.post('/delivery/create', data: deliveryData);
    } catch (e) {
      throw Exception('Failed to create delivery: ${e.toString()}');
    }
  }
}
