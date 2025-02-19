import 'package:falsisters_pos_app/features/delivery/presentation/screens/delivery_screen.dart';
import 'package:falsisters_pos_app/features/home/presentation/widgets/quick_action_card.dart';
import 'package:falsisters_pos_app/features/sales/presentation/screens/sales_screen.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/permissions.dart';
import '../../../../core/models/cashier.dart';

class QuickActions extends StatelessWidget {
  final Cashier cashier;

  const QuickActions({
    Key? key,
    required this.cashier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: _buildQuickActionCards(context),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildQuickActionCards(BuildContext context) {
    final List<Widget> cards = [];

    cards.add(
      QuickActionCard(
        title: 'POS',
        icon: Icons.point_of_sale,
        color: Colors.green,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SalesScreen()),
          );
        },
      ),
    );

    if (cashier.permissions.contains(CashierPermissions.PRICES)) {
      cards.add(
        QuickActionCard(
          title: 'Prices',
          icon: Icons.attach_money,
          color: Colors.green,
          onTap: () {
            // TODO: Navigate to prices screen
          },
        ),
      );
    }

    if (cashier.permissions.contains(CashierPermissions.DELIVERIES)) {
      cards.add(
        QuickActionCard(
          title: 'Deliveries',
          icon: Icons.local_shipping,
          color: Colors.blue,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DeliveryScreen()),
            );
          },
        ),
      );
    }

    if (cashier.permissions.contains(CashierPermissions.STOCKS)) {
      cards.add(
        QuickActionCard(
          title: 'Stocks',
          icon: Icons.inventory,
          color: Colors.orange,
          onTap: () {
            // TODO: Navigate to stocks screen
          },
        ),
      );
    }

    if (cashier.permissions.contains(CashierPermissions.PROFITS)) {
      cards.add(
        QuickActionCard(
          title: 'Profits',
          icon: Icons.trending_up,
          color: Colors.purple,
          onTap: () {
            // TODO: Navigate to profits screen
          },
        ),
      );
    }

    if (cashier.permissions.contains(CashierPermissions.KAHON)) {
      cards.add(
        QuickActionCard(
          title: 'Kahon',
          icon: Icons.inventory_2,
          color: Colors.brown,
          onTap: () {
            // TODO: Navigate to kahon screen
          },
        ),
      );
    }

    if (cashier.permissions.contains(CashierPermissions.SALES_CHECK)) {
      cards.add(
        QuickActionCard(
          title: 'Sales Check',
          icon: Icons.receipt_long,
          color: Colors.teal,
          onTap: () {
            // TODO: Navigate to sales check screen
          },
        ),
      );
    }

    if (cashier.permissions.contains(CashierPermissions.SALES_HISTORY)) {
      cards.add(
        QuickActionCard(
          title: 'Sales History',
          icon: Icons.history,
          color: Colors.indigo,
          onTap: () {
            // TODO: Navigate to sales history screen
          },
        ),
      );
    }

    return cards;
  }
}
