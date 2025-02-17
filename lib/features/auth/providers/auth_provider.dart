import 'package:falsisters_pos_app/core/models/cashier.dart';
import 'package:falsisters_pos_app/core/services/dio_client.dart';
import 'package:falsisters_pos_app/core/services/secure_storage.dart';
import 'package:falsisters_pos_app/features/auth/data/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider((ref) => DioClient().dio);

final authRepositoryProvider =
    Provider((ref) => AuthRepository(ref.watch(dioProvider)));

final authStateProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<Cashier?>>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AsyncValue<Cashier?>> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AsyncValue.data(null)) {
    checkAuth();
  }

  Future<void> checkAuth() async {
    try {
      final token = await SecureStorage.getToken();
      if (token == null) {
        state = const AsyncValue.data(null);
        return;
      }

      state = const AsyncValue.loading();
      final cashier = await _repository.getCashierInfo();
      state = AsyncValue.data(cashier);
    } catch (e) {
      await SecureStorage.deleteToken();
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> login(String username, String password) async {
    try {
      state = const AsyncValue.loading();
      final token = await _repository.login(username, password);
      await SecureStorage.saveToken(token);
      await checkAuth();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> logout() async {
    await SecureStorage.deleteToken();
    state = const AsyncValue.data(null);
  }
}
