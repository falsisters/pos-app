import 'package:falsisters_pos_app/features/auth/presentation/screens/login_screen.dart';
import 'package:falsisters_pos_app/features/auth/providers/auth_provider.dart';
import 'package:falsisters_pos_app/features/shift/presentation/widgets/create_shift_dialog.dart';
import 'package:falsisters_pos_app/features/shift/providers/shift_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/quick_actions.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final shiftsState = ref.watch(shiftsProvider);

    return authState.when(
      data: (cashier) {
        if (cashier == null) return const LoginScreen();

        return shiftsState.when(
          data: (_) {
            final hasActiveShift =
                ref.watch(shiftsProvider.notifier).hasActiveShift();
            final activeShift = ref.watch(activeShiftProvider);

            if (!hasActiveShift) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const CreateShiftDialog(),
                );
              });
            }

            return Scaffold(
              appBar: AppBar(
                title: const Text('Home'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      ref.read(authStateProvider.notifier).logout();
                    },
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome Section
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'FALSISTERS POS DEVICE:',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Colors.grey,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                cashier.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Quick Actions Section
                      QuickActions(cashier: cashier),

                      const SizedBox(height: 16),

                      // Current Shift Card (if active)
                      if (hasActiveShift) ...[
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Current Shift',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 16),
                                Text('Employee: ${activeShift?.employee}'),
                                const SizedBox(height: 8),
                                Text(
                                    'Started: ${activeShift?.clockIn.toLocal()}'),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: activeShift != null
                                      ? () => ref
                                          .read(shiftsProvider.notifier)
                                          .clockOutShift(activeShift.id)
                                      : null,
                                  child: const Text('End Shift'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stackTrace) => Scaffold(
            body: Center(
              child: Text('Error: ${error.toString()}'),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(child: Text('Error: ${error.toString()}')),
      ),
    );
  }
}
