import 'package:dio/dio.dart';
import 'package:falsisters_pos_app/core/services/dio_client.dart';
import 'package:falsisters_pos_app/features/shift/data/models/shift.dart';

class ShiftRepository {
  final Dio _dio;

  ShiftRepository(DioClient dioClient) : _dio = dioClient.dio;

  Future<List<Shift>> getShiftsByCashierId(String cashierId) async {
    try {
      final response = await _dio.get('/shift/cashier/$cashierId');
      return (response.data as List)
          .map((shift) => Shift.fromJson(shift))
          .toList();
    } catch (e) {
      throw Exception('Failed to get shifts: ${e.toString()}');
    }
  }

  Future<Shift> createShift(String cashierId, String employee) async {
    try {
      final response = await _dio.post('/shift', data: {
        'cashierId': cashierId,
        'employee': employee,
      });
      return Shift.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create shift: ${e.toString()}');
    }
  }

  Future<Shift> clockOutShift(String shiftId) async {
    try {
      final response = await _dio.patch('/shift/end', data: {
        'id': shiftId,
      });
      return Shift.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to clock out shift: ${e.toString()}');
    }
  }
}
