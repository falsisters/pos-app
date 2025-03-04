import 'package:falsisters_pos_app/features/stocks/data/providers/stock_provider.dart';
import 'package:falsisters_pos_app/features/stocks/presentation/widgets/error_display.dart';
import 'package:falsisters_pos_app/features/stocks/presentation/widgets/loading_indicator.dart';
import 'package:falsisters_pos_app/features/stocks/presentation/widgets/product_stock_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falsisters_pos_app/features/sales/data/models/product_model.dart';

class StockScreen extends ConsumerWidget {
  const StockScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stocksState = ref.watch(stocksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(stocksProvider.notifier).loadStocks(),
          ),
        ],
      ),
      body: stocksState.when(
        loading: () => const LoadingIndicator(),
        error: (error, stackTrace) => ErrorDisplay(
          message: error.toString(),
          onRetry: () => ref.read(stocksProvider.notifier).loadStocks(),
        ),
        data: (products) => ProductStockList(products: products),
      ),
    );
  }
}

class ProductStockList extends StatelessWidget {
  final List<Product> products;

  const ProductStockList({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: Text('No products available.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductStockCard(product: product);
      },
    );
  }
}
