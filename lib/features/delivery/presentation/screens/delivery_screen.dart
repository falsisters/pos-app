import 'package:falsisters_pos_app/features/delivery/presentation/widgets/delivery_cart_section.dart';
import 'package:falsisters_pos_app/features/delivery/presentation/widgets/products_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeliveryScreen extends ConsumerWidget {
  const DeliveryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        // Products section (left 60%)
        const Expanded(
          flex: 60,
          child: ProductsSection(),
        ),
        // Delivery Cart section (right 40%)
        const Expanded(
          flex: 40,
          child: DeliveryCartSection(),
        ),
      ],
    );
  }
}
