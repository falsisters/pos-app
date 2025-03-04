import 'package:falsisters_pos_app/features/stocks/data/models/transfer_kahon_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falsisters_pos_app/core/providers/dio_provider.dart';
import 'package:falsisters_pos_app/features/sales/data/models/product_model.dart';
import 'package:falsisters_pos_app/features/stocks/data/models/stock_model.dart';
import 'package:falsisters_pos_app/features/stocks/data/models/transfer_stock_model.dart';
import 'package:falsisters_pos_app/features/stocks/data/repositories/stock_repository.dart';
import 'package:image_picker/image_picker.dart';

// Re-exporting the provider from your core file
final stockRepositoryProvider = Provider((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return StockRepository(dioClient);
});

final stocksProvider =
    StateNotifierProvider<StocksNotifier, AsyncValue<List<Product>>>((ref) {
  return StocksNotifier(ref.watch(stockRepositoryProvider));
});

class StocksNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  final StockRepository _repository;

  StocksNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadStocks();
  }

  Future<void> loadStocks() async {
    try {
      state = const AsyncValue.loading();
      final stocks = await _repository.getAllStocks();
      state = AsyncValue.data(stocks);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> editStock(String productId, EditStockRequest request) async {
    try {
      await _repository.editStock(productId, request);
      loadStocks();
    } catch (e) {
      // Handle error but do not update state to prevent UI from being cleared
      rethrow;
    }
  }

  Future<Map<String, dynamic>> transferToKahon(
      String productId, TransferKahonRequest request) async {
    try {
      final response = await _repository.transferToKahon(productId, request);
      loadStocks();
      return response;
    } catch (e) {
      // Handle error but do not update state to prevent UI from being cleared
      rethrow;
    }
  }

  Future<Map<String, dynamic>> transferStock(
      TransferStockRequest request, List<XFile> attachments) async {
    try {
      final response = await _repository.transferStock(request, attachments);
      loadStocks();
      return response;
    } catch (e) {
      // Handle error but do not update state to prevent UI from being cleared
      rethrow;
    }
  }
}
