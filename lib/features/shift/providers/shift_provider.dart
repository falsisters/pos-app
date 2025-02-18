// lib/features/shift/providers/shift_provider.dart
import 'package:falsisters_pos_app/core/models/cashier.dart';
import 'package:falsisters_pos_app/core/providers/dio_provider.dart';
import 'package:falsisters_pos_app/features/shift/data/repositories/shift_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';
import 'package:falsisters_pos_app/core/models/shift.dart';

final shiftRepositoryProvider = Provider((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ShiftRepository(dioClient);
});

final shiftsProvider =
    StateNotifierProvider<ShiftNotifier, AsyncValue<List<Shift>>>((ref) {
  final repository = ref.watch(shiftRepositoryProvider);
  final authState = ref.watch(authStateProvider);

  return ShiftNotifier(repository, authState);
});

final activeShiftProvider = Provider<Shift?>((ref) {
  final shiftsState = ref.watch(shiftsProvider);

  return shiftsState.when(
    data: (shifts) {
      if (shifts.isEmpty) return null;

      final now = DateTime.now();
      // Find most recent shift where clockOut is after current time
      final activeShifts = shifts.where((shift) => shift.clockOut.isAfter(now));
      if (activeShifts.isEmpty) return null;

      return activeShifts.reduce(
          (curr, next) => curr.clockOut.isAfter(next.clockOut) ? curr : next);
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

class ShiftNotifier extends StateNotifier<AsyncValue<List<Shift>>> {
  final ShiftRepository _repository;
  final AsyncValue<Cashier?> _authState;

  ShiftNotifier(this._repository, this._authState)
      : super(const AsyncValue.loading()) {
    _initialize();
  }

  Future<void> _initialize() async {
    await loadShifts();
  }

  Future<void> loadShifts() async {
    try {
      final cashier = _authState.value;
      if (cashier == null) {
        state = const AsyncValue.data([]);
        return;
      }

      state = const AsyncValue.loading();
      final shifts = await _repository.getShiftsByCashierId(cashier.id);
      // Sort shifts by clockOut time in descending order
      shifts.sort((a, b) => b.clockOut.compareTo(a.clockOut));
      state = AsyncValue.data(shifts);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> createShift(String employee) async {
    try {
      final cashier = _authState.value;
      if (cashier == null) throw Exception('No authenticated cashier');

      await _repository.createShift(cashier.id, employee);
      await loadShifts();
    } catch (e) {
      throw Exception('Failed to create shift: ${e.toString()}');
    }
  }

  bool hasActiveShift() {
    return state.when(
      data: (shifts) {
        if (shifts.isEmpty) return false;

        final now = DateTime.now();
        return shifts.any((shift) => shift.clockOut.isAfter(now));
      },
      loading: () => false,
      error: (_, __) => false,
    );
  }
}
