import 'package:dio/dio.dart';
import 'package:falsisters_pos_app/core/services/dio_client.dart';

class SalesRepository {
  final Dio _dio;

  SalesRepository(DioClient dioClient) : _dio = dioClient.dio;

  Future<List<dynamic>> getProducts() async {
    try {
      final response = await _dio.get('/product/cashier');
      return response.data;
    } catch (e) {
      throw Exception('Failed to get products: ${e.toString()}');
    }
  }

  Future<void> createSale(Map<String, dynamic> saleData) async {
    try {
      await _dio.post('/sale/create', data: saleData);
    } catch (e) {
      throw Exception('Failed to create sale: ${e.toString()}');
    }
  }
}
