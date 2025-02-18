import 'package:dio/dio.dart';
import 'package:falsisters_pos_app/core/services/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioClientProvider = Provider<DioClient>((ref) => DioClient());

final dioProvider = Provider<Dio>((ref) => ref.watch(dioClientProvider).dio);
