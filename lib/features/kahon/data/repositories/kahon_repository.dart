import 'package:dio/dio.dart';
import 'package:falsisters_pos_app/core/services/dio_client.dart';
import 'package:falsisters_pos_app/features/kahon/data/models/kahon_model.dart';
import 'package:falsisters_pos_app/features/kahon/data/models/kahon_request.dart';

class KahonRepository {
  final Dio _dio;

  KahonRepository(DioClient dioClient) : _dio = dioClient.dio;

  Future<List<Kahon>> getAllKahon() async {
    try {
      final response = await _dio.get('/kahon');

      return (response.data as List)
          .map((json) => Kahon.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get kahon: ${e.toString()}');
    }
  }

  Future<Kahon> getKahonById(String kahonId) async {
    try {
      final response = await _dio.get('/kahon/$kahonId');

      return Kahon.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get kahon: ${e.toString()}');
    }
  }

  Future<Kahon> createKahon() async {
    try {
      final data = {
        'name': DateTime.now().toIso8601String(),
      };

      final response = await _dio.post('/kahon/create', data: data);

      return Kahon.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create kahon: ${e.toString()}');
    }
  }

  Future<Kahon> updateKahon(UpdateKahonRequest request) async {
    try {
      final response =
          await _dio.put('/kahon/${request.id}', data: request.toJson());

      return Kahon.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create kahon: ${e.toString()}');
    }
  }
}
