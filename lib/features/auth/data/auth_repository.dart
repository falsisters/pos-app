import 'package:dio/dio.dart';
import 'package:falsisters_pos_app/core/constants/api_constants.dart';
import 'package:falsisters_pos_app/core/models/cashier.dart';
import 'package:falsisters_pos_app/core/services/dio_client.dart';

class AuthRepository {
  final Dio _dio;

  AuthRepository(DioClient dioClient) : _dio = dioClient.dio;

  Future<String> login(String name, String password) async {
    try {
      print('name: $name, password: $password');
      final response = await _dio.post(
        ApiConstants.loginEndpoint,
        data: {
          'name': name,
          'accessKey': password,
        },
      );

      return response.data['access_token'];
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<Cashier> getCashierInfo() async {
    try {
      final response = await _dio.get(ApiConstants.cashierInfoEndpoint);
      return Cashier.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get cashier info: ${e.toString()}');
    }
  }
}
