import 'package:falsisters_pos_app/features/kahon/presentation/screens/kahon_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falsisters_pos_app/features/kahon/data/models/kahon_model.dart';
import 'package:falsisters_pos_app/features/kahon/data/providers/kahon_provider.dart';

class KahonListScreen extends ConsumerStatefulWidget {
  const KahonListScreen({Key? key}) : super(key: key);

  @override
  _KahonListScreenState createState() => _KahonListScreenState();
}

class _KahonListScreenState extends ConsumerState<KahonListScreen> {
  Kahon? _selectedKahon;

  @override
  void initState() {
    super.initState();
    // Trigger loading of Kahons
    ref.read(kahonProvider.notifier).loadKahon();
  }

  void _createNewKahon() async {
    try {
      await ref.read(kahonProvider.notifier).createKahon();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating Kahon: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final kahonState = ref.watch(kahonProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kahon Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _createNewKahon,
            tooltip: 'Create New Kahon',
          ),
        ],
      ),
      body: kahonState.when(
        data: (kahons) => kahons.isEmpty
            ? const Center(child: Text('No Kahons available'))
            : _selectedKahon == null
                ? _buildKahonList(kahons)
                : KahonDetailView(
                    kahon: _selectedKahon!,
                    onBack: () => setState(() {
                      _selectedKahon = null;
                    }),
                  ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading Kahons: $error'),
        ),
      ),
    );
  }

  Widget _buildKahonList(List<Kahon> kahons) {
    return ListView.builder(
      itemCount: kahons.length,
      itemBuilder: (context, index) {
        final kahon = kahons[index];
        return ListTile(
          title: Text('Kahon: ${kahon.name}'),
          subtitle: Text(
            'Created: ${kahon.createdAt.toLocal()}',
            style: const TextStyle(fontSize: 12),
          ),
          trailing: Text(
            'Items: ${kahon.kahonItem.length + kahon.kahonTransferredItem.length}',
          ),
          onTap: () {
            setState(() {
              _selectedKahon = kahon;
            });
          },
        );
      },
    );
  }
}
