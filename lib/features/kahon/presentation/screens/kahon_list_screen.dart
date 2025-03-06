import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falsisters_pos_app/features/kahon/data/providers/kahon_provider.dart';
import 'package:falsisters_pos_app/features/kahon/presentation/screens/kahon_detail_screen.dart';

class KahonListScreen extends ConsumerWidget {
  const KahonListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kahonsAsyncValue = ref.watch(kahonProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kahon Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              try {
                await ref.read(kahonProvider.notifier).createKahon();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('New Kahon created')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error creating Kahon: $e')),
                );
              }
            },
          ),
        ],
      ),
      drawer: const Drawer(
          // Keep the drawer here as requested
          ),
      body: kahonsAsyncValue.when(
        data: (kahons) {
          if (kahons.isEmpty) {
            return const Center(
              child: Text(
                  'No Kahons available. Create one by clicking the + button.'),
            );
          }

          return ListView.builder(
            itemCount: kahons.length,
            itemBuilder: (context, index) {
              final kahon = kahons[index];
              final itemCount =
                  kahon.kahonItem.length + kahon.kahonTransferredItem.length;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(kahon.name),
                  subtitle: Text(
                      '$itemCount items • Created: ${_formatDate(kahon.createdAt)}'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            KahonDetailScreen(kahonId: kahon.id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading Kahons: $error'),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
