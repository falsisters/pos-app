import 'package:dio/dio.dart';
import 'package:falsisters_pos_app/core/constants/api_constants.dart';
import 'package:falsisters_pos_app/core/models/cashier.dart';
import 'package:falsisters_pos_app/core/services/dio_client.dart';
import 'package:falsisters_pos_app/core/services/secure_storage.dart';

class AuthRepository {
  final Dio _dio;

  AuthRepository(DioClient dioClient) : _dio = dioClient.dio;

  Future<String> login(String name, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.loginEndpoint,
        data: {
          'name': name,
          'accessKey': password,
        },
      );

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

      return response.data['access_token'];
    } catch (e) {
      String message = 'An error has occurred';

      if (e is DioException && e.response?.data != null) {
        message = e.response?.data['message'] ?? message;
      } else if (e is Exception) {
        message = e.toString().replaceFirst('Exception: ', '');
      } else {
        message = e.toString();
      }

      throw Exception('Login failed: $message');
    }
  }

  Future<Cashier> getCashierInfo() async {
    try {
      final response = await _dio.get(ApiConstants.cashierInfoEndpoint);

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

      return Cashier.fromJson(response.data);
    } catch (e) {
      String message = 'An error has occurred';

      if (e is DioException && e.response?.data != null) {
        message = e.response?.data['message'] ?? message;
      } else if (e is Exception) {
        message = e.toString().replaceFirst('Exception: ', '');
      } else {
        message = e.toString();
      }

      await SecureStorage.deleteToken();
      throw Exception('Failed to get cashier info: $message');
    }
  }
}
