import 'package:falsisters_pos_app/features/sales/presentation/widgets/cart_section.dart';
import 'package:falsisters_pos_app/features/sales/presentation/widgets/products_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SalesScreen extends ConsumerWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        // Products section (left 60%)
        Expanded(
          flex: 60,
          child: ProductsSection(),
        ),
        // Cart section (right 40%)
        Expanded(
          flex: 40,
          child: CartSection(),
        ),
      ],
    );
  }
}
