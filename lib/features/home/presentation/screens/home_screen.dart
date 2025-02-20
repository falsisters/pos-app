// lib/features/home/presentation/screens/home_screen.dart
import 'package:falsisters_pos_app/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falsisters_pos_app/core/constants/permissions.dart';
import 'package:falsisters_pos_app/features/auth/providers/auth_provider.dart';
import 'package:falsisters_pos_app/features/shift/providers/shift_provider.dart';
import 'package:falsisters_pos_app/features/home/presentation/widgets/profile_section.dart';
import 'package:falsisters_pos_app/features/home/presentation/widgets/clock_in_dialog.dart';

final selectedNavigationIndexProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _showingDialog = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final shiftsState = ref.watch(shiftsProvider);
    final activeShift = ref.watch(activeShiftProvider);
    final selectedIndex = ref.watch(selectedNavigationIndexProvider);

    return authState.when(
      data: (cashier) {
        if (cashier == null) {
          return const LoginScreen();
        }

        return shiftsState.when(
          data: (_) {
            if (activeShift == null && !_showingDialog) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() => _showingDialog = true);
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => ClockInDialog(
                    onClose: () => setState(() => _showingDialog = false),
                  ),
                );
              });
            }

            return Scaffold(
              body: SafeArea(
                child: Row(
                  children: [
                    NavigationDrawer(
                      selectedIndex: selectedIndex,
                      onDestinationSelected: (index) {
                        ref
                            .read(selectedNavigationIndexProvider.notifier)
                            .state = index;
                      },
                      children: [
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Falsisters POS',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (cashier.permissions
                            .contains(CashierPermissions.SALES_CHECK))
                          const NavigationDrawerDestination(
                            icon: Icon(Icons.point_of_sale),
                            label: Text('Sales'),
                          ),
                        if (cashier.permissions
                            .contains(CashierPermissions.DELIVERIES))
                          const NavigationDrawerDestination(
                            icon: Icon(Icons.local_shipping),
                            label: Text('Deliveries'),
                          ),
                        if (cashier.permissions
                            .contains(CashierPermissions.STOCKS))
                          const NavigationDrawerDestination(
                            icon: Icon(Icons.inventory),
                            label: Text('Stock'),
                          ),
                        if (cashier.permissions
                            .contains(CashierPermissions.SALES_HISTORY))
                          const NavigationDrawerDestination(
                            icon: Icon(Icons.history),
                            label: Text('History'),
                          ),
                        const Spacer(),
                        const Divider(),
                        const ProfileSection(),
                      ],
                    ),
                    Expanded(
                      child: activeShift == null
                          ? const Center(
                              child: Text('Please clock in to continue'),
                            )
                          : _buildScreen(selectedIndex),
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return const Center(child: Text('Sales Screen'));
      case 1:
        return const Center(child: Text('Deliveries Screen'));
      case 2:
        return const Center(child: Text('Stock Screen'));
      case 3:
        return const Center(child: Text('History Screen'));
      default:
        return const Center(child: Text('Select a menu item'));
    }
  }
}
