import 'package:falsisters_pos_app/features/shift/data/models/shift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falsisters_pos_app/features/auth/providers/auth_provider.dart';
import 'package:falsisters_pos_app/features/shift/providers/shift_provider.dart';

class ProfileSection extends ConsumerWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final activeShift = ref.watch(activeShiftProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 30,
            child: Icon(Icons.person, size: 40),
          ),
          const SizedBox(height: 8),
          Text(
            authState.value?.name ?? '',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (activeShift != null) ...[
            const SizedBox(height: 4),
            Text(
              'Active Shift: ${activeShift.employee}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            _buildClockOutButton(context, activeShift),
          ],
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(authStateProvider.notifier).logout();
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

Widget _buildClockOutButton(BuildContext context, Shift activeShift) {
  return Consumer(
    builder: (context, ref, _) {
      return ElevatedButton.icon(
        onPressed: () async {
          try {
            await ref
                .read(shiftsProvider.notifier)
                .clockOutShift(activeShift.id);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Successfully clocked out')),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(e.toString())),
              );
            }
          }
        },
        icon: const Icon(Icons.timer_off),
        label: const Text('Clock Out'),
      );
    },
  );
}
