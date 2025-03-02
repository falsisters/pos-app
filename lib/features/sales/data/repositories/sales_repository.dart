import 'package:dio/dio.dart';
import 'package:falsisters_pos_app/core/services/dio_client.dart';

class SalesRepository {
  final Dio _dio;

  SalesRepository(DioClient dioClient) : _dio = dioClient.dio;

  Future<List<dynamic>> getProducts() async {
    try {
      final response = await _dio.get('/product/cashier');

      if (response.data['error'] == true) {
        final message = response.data['message'];
        if (message is List) {
          throw Exception(message.join(', '));
        } else if (message is String) {
          throw Exception(message);
        } else {
          throw Exception('An error has occurred');
        }
      }

      return response.data;
    } catch (e) {
      String message = 'An error has occurred';

      if (e is DioException && e.response?.data != null) {
        message = e.response?.data['message'] ?? message;
      } else if (e is Exception) {
        message = e.toString().replaceFirst('Exception: ', '');
      } else {
        message = e.toString();
      }
      throw Exception('Failed to get products: $message');
    }
  }

  Future<void> createSale(Map<String, dynamic> saleData) async {
    try {
      final response = await _dio.post('/sale/create', data: saleData);

      if (response.data['error'] == true) {
        final message = response.data['message'];
        if (message is List) {
          throw Exception(message.join(', '));
        } else if (message is String) {
          throw Exception(message);
        } else {
          throw Exception('An error has occurred');
        }
      }
    } catch (e) {
      String message = 'An error has occurred';

      if (e is DioException && e.response?.data != null) {
        message = e.response?.data['message'] ?? message;
      } else if (e is Exception) {
        message = e.toString().replaceFirst('Exception: ', '');
      } else {
        message = e.toString();
      }

      throw Exception('Failed to create sale: $message');
    }
  }
}
