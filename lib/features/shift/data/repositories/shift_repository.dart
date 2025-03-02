import 'package:dio/dio.dart';
import 'package:falsisters_pos_app/core/services/dio_client.dart';
import 'package:falsisters_pos_app/features/shift/data/models/shift.dart';

class ShiftRepository {
  final Dio _dio;

  ShiftRepository(DioClient dioClient) : _dio = dioClient.dio;

  Future<List<Shift>> getShiftsByCashierId(String cashierId) async {
    try {
      final response = await _dio.get('/shift/cashier/$cashierId');

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

      return (response.data as List)
          .map((shift) => Shift.fromJson(shift))
          .toList();
    } catch (e) {
      String message = 'An error has occurred';

      if (e is DioException && e.response?.data != null) {
        message = e.response?.data['message'] ?? message;
      } else if (e is Exception) {
        message = e.toString().replaceFirst('Exception: ', '');
      } else {
        message = e.toString();
      }
      throw Exception('Failed to get shifts: $message');
    }
  }

  Future<Shift> createShift(String cashierId, String employee) async {
    try {
      final response = await _dio.post('/shift', data: {
        'cashierId': cashierId,
        'employee': employee,
      });

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

      return Shift.fromJson(response.data);
    } catch (e) {
      String message = 'An error has occurred';

      if (e is DioException && e.response?.data != null) {
        message = e.response?.data['message'] ?? message;
      } else if (e is Exception) {
        message = e.toString().replaceFirst('Exception: ', '');
      } else {
        message = e.toString();
      }
      throw Exception('Failed to create shifts: $message');
    }
  }

  Future<Shift> clockOutShift(String shiftId) async {
    try {
      final response = await _dio.patch('/shift/end', data: {
        'id': shiftId,
      });

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

      return Shift.fromJson(response.data);
    } catch (e) {
      String message = 'An error has occurred';

      if (e is DioException && e.response?.data != null) {
        message = e.response?.data['message'] ?? message;
      } else if (e is Exception) {
        message = e.toString().replaceFirst('Exception: ', '');
      } else {
        message = e.toString();
      }
      throw Exception('Failed to clock out shift: $message');
    }
  }
}
