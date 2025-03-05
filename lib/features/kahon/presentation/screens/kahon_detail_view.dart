import 'package:falsisters_pos_app/features/kahon/data/models/kahon_model.dart';
import 'package:falsisters_pos_app/features/kahon/data/models/kahon_request.dart';
import 'package:falsisters_pos_app/features/kahon/data/providers/kahon_provider.dart';
import 'package:falsisters_pos_app/features/kahon/presentation/widgets/kahon_item_list.dart';
import 'package:falsisters_pos_app/features/kahon/presentation/widgets/kahon_transferred_items_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KahonDetailView extends StatefulWidget {
  final Kahon kahon;
  final VoidCallback onBack;

  const KahonDetailView({
    Key? key,
    required this.kahon,
    required this.onBack,
  }) : super(key: key);

  @override
  _KahonDetailViewState createState() => _KahonDetailViewState();
}

class _KahonDetailViewState extends State<KahonDetailView> {
  bool _isEditing = false;
  late Kahon _currentKahon;

  @override
  void initState() {
    super.initState();
    _currentKahon = widget.kahon;
  }

  void _saveKahon(WidgetRef ref) {
    final request = UpdateKahonRequest(
      id: _currentKahon.id,
      name: _currentKahon.name,
      kahonItem: _currentKahon.kahonItem,
      kahonTransferredItem: _currentKahon.kahonTransferredItem,
      kahonTotalModifier: _currentKahon.kahonTotalModifier,
    );

    ref.read(kahonProvider.notifier).updateKahon(request);
    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: widget.onBack,
            ),
            title: Text('Kahon: ${_currentKahon.name}'),
            actions: [
              IconButton(
                icon: Icon(_isEditing ? Icons.save : Icons.edit),
                onPressed: () {
                  if (_isEditing) {
                    _saveKahon(ref);
                  } else {
                    setState(() {
                      _isEditing = true;
                    });
                  }
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
                  const Text(
                    'Transferred Items',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  KahonTransferredItemsList(
                    items: _currentKahon.kahonTransferredItem,
                    isEditing: _isEditing,
                    onItemsChanged: (items) {
                      setState(() {
                        _currentKahon = _currentKahon.copyWith(
                          kahonTransferredItem: items,
                          updatedAt: DateTime.now(),
                        );
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Kahon Items',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  KahonItemsList(
                    items: _currentKahon.kahonItem,
                    isEditing: _isEditing,
                    onItemsChanged: (items) {
                      setState(() {
                        _currentKahon = _currentKahon.copyWith(
                          kahonItem: items,
                          updatedAt: DateTime.now(),
                        );
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
