import 'package:falsisters_pos_app/core/providers/dio_provider.dart';
import 'package:falsisters_pos_app/features/kahon/data/models/kahon_model.dart';
import 'package:falsisters_pos_app/features/kahon/data/models/kahon_request.dart';
import 'package:falsisters_pos_app/features/kahon/data/repositories/kahon_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final kahonRepositoryProvider = Provider((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return KahonRepository(dioClient);
});

final kahonProvider =
    StateNotifierProvider<KahonNotifier, AsyncValue<List<Kahon>>>((ref) {
  return KahonNotifier(ref.watch(kahonRepositoryProvider));
});

class KahonNotifier extends StateNotifier<AsyncValue<List<Kahon>>> {
  final KahonRepository _repository;

  KahonNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadKahon();
  }

  Future<void> loadKahon() async {
    try {
      state = const AsyncValue.loading();
      final kahon = await _repository.getAllKahon();
      state = AsyncValue.data(kahon);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> createKahon() async {
    try {
      await _repository.createKahon();
      loadKahon();
    } catch (e) {
      // Handle error but do not update state to prevent UI from being cleared
      rethrow;
    }
  }

  Future<Kahon> getKahonById(String kahonId) async {
    try {
      final kahon = await _repository.getKahonById(kahonId);
      return kahon;
    } catch (e) {
      // Handle error but do not update state to prevent UI from being cleared
      rethrow;
    }
  }

  Future<void> updateKahon(UpdateKahonRequest request) async {
    try {
      await _repository.updateKahon(request);
      loadKahon();
    } catch (e) {
      // Handle error but do not update state to prevent UI from being cleared
      rethrow;
    }
  }
}
