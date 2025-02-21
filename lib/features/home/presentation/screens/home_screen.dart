// lib/features/home/presentation/screens/home_screen.dart
import 'package:falsisters_pos_app/features/auth/presentation/screens/login_screen.dart';
import 'package:falsisters_pos_app/features/home/presentation/widgets/profile_section.dart';
import 'package:falsisters_pos_app/features/sales/presentation/screen/sales_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falsisters_pos_app/core/constants/permissions.dart';
import 'package:falsisters_pos_app/features/auth/providers/auth_provider.dart';
import 'package:falsisters_pos_app/features/shift/providers/shift_provider.dart';
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
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 90, // Fixed width for navigation drawer
                      child: NavigationDrawer(
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
                              'POS',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (cashier.permissions
                              .contains(CashierPermissions.SALES_CHECK))
                            const NavigationDrawerDestination(
                              icon: Padding(
                                padding: EdgeInsets.only(left: 3.5),
                                child: Icon(Icons.point_of_sale),
                              ),
                              label: Text(''),
                            ),
                          const Text(
                            'Sales',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          if (cashier.permissions
                              .contains(CashierPermissions.DELIVERIES))
                            const NavigationDrawerDestination(
                              icon: Padding(
                                padding: EdgeInsets.only(left: 3.5),
                                child: Icon(Icons.local_shipping),
                              ),
                              label: Text(''),
                            ),
                          const Text(
                            'Deliveries',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          if (cashier.permissions
                              .contains(CashierPermissions.STOCKS))
                            const NavigationDrawerDestination(
                              icon: Padding(
                                padding: EdgeInsets.only(left: 3.5),
                                child: Icon(Icons.inventory),
                              ),
                              label: Text(''),
                            ),
                          const Text(
                            'Stocks',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          if (cashier.permissions
                              .contains(CashierPermissions.PROFITS))
                            const NavigationDrawerDestination(
                              icon: Padding(
                                padding: EdgeInsets.only(left: 3.5),
                                child: Icon(Icons.attach_money),
                              ),
                              label: Text(''),
                            ),
                          const Text(
                            'Profits',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          if (cashier.permissions
                              .contains(CashierPermissions.KAHON))
                            const NavigationDrawerDestination(
                              icon: Padding(
                                padding: EdgeInsets.only(left: 3.5),
                                child: Icon(Icons.rice_bowl),
                              ),
                              label: Text(''),
                            ),
                          const Text(
                            'Kahon',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          if (cashier.permissions
                              .contains(CashierPermissions.SALES_CHECK))
                            const NavigationDrawerDestination(
                              icon: Padding(
                                padding: EdgeInsets.only(left: 3.5),
                                child: Icon(Icons.checklist),
                              ),
                              label: Text(''),
                            ),
                          const Text(
                            'Sales Check',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          if (cashier.permissions
                              .contains(CashierPermissions.SALES_HISTORY))
                            const NavigationDrawerDestination(
                              icon: Padding(
                                padding: EdgeInsets.only(left: 3.5),
                                child: Icon(Icons.history),
                              ),
                              label: Text(''),
                            ),
                          const Text(
                            'Sales History',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          if (true)
                            const NavigationDrawerDestination(
                              icon: Padding(
                                padding: EdgeInsets.only(left: 3.5),
                                child: Icon(Icons.account_box),
                              ),
                              label: Text(''),
                            ),
                          const Text(
                            'Profile',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          const Spacer(),
                        ],
                      ),
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
        return const SalesScreen();
      case 1:
        return const Center(child: Text('Deliveries Screen'));
      case 2:
        return const Center(child: Text('Stock Screen'));
      case 3:
        return const Center(child: Text('Profits Screen'));
      case 4:
        return const Center(child: Text('Kahon Screen'));
      case 5:
        return const Center(child: Text('Sales Check Screen'));
      case 6:
        return const Center(child: Text('Sales History Screen'));
      case 7:
        return const ProfileSection();
      default:
        return const Center(child: Text('Select a menu item'));
    }
  }
}
