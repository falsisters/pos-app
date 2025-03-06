import 'package:falsisters_pos_app/features/kahon/presentation/widgets/kahon_item.dart';
import 'package:falsisters_pos_app/features/kahon/presentation/widgets/kahon_total.dart';
import 'package:falsisters_pos_app/features/kahon/presentation/widgets/kahon_transferred_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falsisters_pos_app/features/kahon/data/models/kahon_model.dart';
import 'package:falsisters_pos_app/features/kahon/data/models/kahon_item.dart';
import 'package:falsisters_pos_app/features/kahon/data/models/kahon_request.dart';
import 'package:falsisters_pos_app/features/kahon/data/models/kahon_transferred_item_model.dart';
import 'package:falsisters_pos_app/features/kahon/data/providers/kahon_provider.dart';
import 'package:falsisters_pos_app/features/kahon/presentation/widgets/add_kahon_item_dialog.dart';
import 'package:uuid/uuid.dart';

class KahonDetailScreen extends ConsumerStatefulWidget {
  final String kahonId;

  const KahonDetailScreen({Key? key, required this.kahonId}) : super(key: key);

  @override
  ConsumerState<KahonDetailScreen> createState() => _KahonDetailScreenState();
}

class _KahonDetailScreenState extends ConsumerState<KahonDetailScreen> {
  late Kahon kahon;
  bool isLoading = true;
  bool hasChanges = false;
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadKahon();
  }

  Future<void> _loadKahon() async {
    try {
      final loadedKahon =
          await ref.read(kahonProvider.notifier).getKahonById(widget.kahonId);
      setState(() {
        kahon = loadedKahon;
        nameController.text = loadedKahon.name;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load Kahon: $e')),
        );
      }
    }
  }

  void _markAsChanged() {
    setState(() {
      hasChanges = true;
    });
  }

  Future<void> _saveKahon() async {
    try {
      final request = UpdateKahonRequest(
        id: kahon.id,
        name: nameController.text,
        kahonItem: kahon.kahonItem,
        kahonTransferredItem: kahon.kahonTransferredItem,
        kahonTotalModifier: kahon.kahonTotalModifier,
      );

      await ref.read(kahonProvider.notifier).updateKahon(request);
      setState(() {
        hasChanges = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kahon updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update Kahon: $e')),
      );
    }
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (context) => AddKahonItemDialog(
        onItemAdded: (String name, int qty, double value) {
          setState(() {
            final newItem = KahonItem(
              id: const Uuid().v4(),
              qty: qty,
              name: name,
              value: value,
              kahonId: kahon.id,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );

            kahon = kahon.copyWith(
              kahonItem: [...kahon.kahonItem, newItem],
            );
            hasChanges = true;
          });
        },
      ),
    );
  }

  void _addTotalModifier(OperationType operation, double value) {
    setState(() {
      final newModifier = KahonTotalModifier(
        id: const Uuid().v4(),
        index: kahon.kahonTotalModifier.length,
        operation: operation,
        value: value,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        kahonId: kahon.id,
      );

      kahon = kahon.copyWith(
        kahonTotalModifier: [...kahon.kahonTotalModifier, newModifier],
      );
      hasChanges = true;
    });
  }

  Future<bool> _onWillPop() async {
    if (!hasChanges) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text(
            'You have unsaved changes. Do you want to save them before leaving?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Discard'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _saveKahon();
              if (mounted) Navigator.of(context).pop(true);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Calculate total items and their values
    double totalValue = 0;
    int totalItemCount = 0;
    int totalTransferredItemCount = 0;

    for (var item in kahon.kahonItem) {
      totalValue += _calculateItemValue(item);
      totalItemCount += item.qty;
    }

    for (var item in kahon.kahonTransferredItem) {
      // Skip PER_KILO items for quantity counting
      if (item.price != null &&
          item.price!.type.toString().contains('PER_KILO')) {
        continue;
      }
      totalValue += _calculateTransferredItemValue(item);
      totalTransferredItemCount += item.qty;
    }

    // Apply total modifiers
    double grandTotal = totalValue;
    for (var modifier in kahon.kahonTotalModifier) {
      grandTotal =
          _applyOperation(grandTotal, modifier.operation, modifier.value);
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: nameController,
            style: const TextStyle(fontSize: 18, color: Colors.white),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Kahon Name',
              hintStyle: TextStyle(color: Colors.white70),
            ),
            onChanged: (_) => _markAsChanged(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _showAddItemDialog,
              tooltip: 'Add Item',
            ),
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveKahon,
              tooltip: 'Save Changes',
            ),
          ],
        ),
        drawer: const Drawer(),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Transferred Items Section (BOLD)
                  if (kahon.kahonTransferredItem.isNotEmpty) ...[
                    const Text(
                      'Transferred Items',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...kahon.kahonTransferredItem.map(
                      (item) => KahonTransferredItemWidget(
                        item: item,
                        onModifierAdded: (itemId, operation, value) {
                          _addTransferredItemModifier(itemId, operation, value);
                        },
                        onModifierRemoved: (itemId, modifierId) {
                          _removeTransferredItemModifier(itemId, modifierId);
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Regular Items Section
                  if (kahon.kahonItem.isNotEmpty) ...[
                    const Text(
                      'Items',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    ...kahon.kahonItem.map(
                      (item) => KahonItemWidget(
                        item: item,
                        onModifierAdded: (itemId, operation, value) {
                          _addItemModifier(itemId, operation, value);
                        },
                        onModifierRemoved: (itemId, modifierId) {
                          _removeItemModifier(itemId, modifierId);
                        },
                        onItemDeleted: (itemId) {
                          _deleteItem(itemId);
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Total Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: KahonTotalWidget(
                itemCount: totalItemCount + totalTransferredItemCount,
                subTotal: totalValue,
                totalModifiers: kahon.kahonTotalModifier,
                grandTotal: grandTotal,
                onTotalModifierAdded: (operation, value) {
                  _addTotalModifier(operation, value);
                },
                onTotalModifierRemoved: (modifierId) {
                  _removeTotalModifier(modifierId);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateItemValue(KahonItem item) {
    double value = item.value * item.qty;

    // Apply modifiers
    for (var modifier in item.kahonItemModifier) {
      value = _applyOperation(value, modifier.operation, modifier.value);
    }

    return value;
  }

  double _calculateTransferredItemValue(KahonTransferredItem item) {
    double value = item.value;
    if (item.price != null) {
      value = item.price!.price * item.qty;
    }

    // Apply modifiers
    for (var modifier in item.kahonTransferredItemModifier) {
      value = _applyOperation(value, modifier.operation, modifier.value);
    }

    return value;
  }

  double _applyOperation(
      double value, OperationType operation, double modifierValue) {
    switch (operation) {
      case OperationType.ADDITION:
        return value + modifierValue;
      case OperationType.SUBTRACTION:
        return value - modifierValue;
      case OperationType.MULTIPLICATION:
        return value * modifierValue;
      case OperationType.DIVISION:
        return modifierValue != 0 ? value / modifierValue : value;
      case OperationType.TOTAL:
        return modifierValue; // Replace with the specified value
      default:
        return value;
    }
  }

  void _addItemModifier(String itemId, OperationType operation, double value) {
    setState(() {
      final itemIndex = kahon.kahonItem.indexWhere((item) => item.id == itemId);
      if (itemIndex != -1) {
        final item = kahon.kahonItem[itemIndex];
        final newModifier = KahonItemModifier(
          id: const Uuid().v4(),
          index: item.kahonItemModifier.length,
          operation: operation,
          value: value,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          kahonItemId: itemId,
        );

        final updatedItem = KahonItem(
          id: item.id,
          qty: item.qty,
          name: item.name,
          value: item.value,
          kahonId: item.kahonId,
          createdAt: item.createdAt,
          updatedAt: DateTime.now(),
          kahonItemModifier: [...item.kahonItemModifier, newModifier],
        );

        final updatedItems = [...kahon.kahonItem];
        updatedItems[itemIndex] = updatedItem;

        kahon = kahon.copyWith(kahonItem: updatedItems);
        hasChanges = true;
      }
    });
  }

  void _removeItemModifier(String itemId, String modifierId) {
    setState(() {
      final itemIndex = kahon.kahonItem.indexWhere((item) => item.id == itemId);
      if (itemIndex != -1) {
        final item = kahon.kahonItem[itemIndex];

        final updatedModifiers = item.kahonItemModifier
            .where((mod) => mod.id != modifierId)
            .toList();

        // Reindex remaining modifiers
        for (int i = 0; i < updatedModifiers.length; i++) {
          updatedModifiers[i] = KahonItemModifier(
            id: updatedModifiers[i].id,
            index: i,
            operation: updatedModifiers[i].operation,
            value: updatedModifiers[i].value,
            createdAt: updatedModifiers[i].createdAt,
            updatedAt: DateTime.now(),
            kahonItemId: updatedModifiers[i].kahonItemId,
          );
        }

        final updatedItem = KahonItem(
          id: item.id,
          qty: item.qty,
          name: item.name,
          value: item.value,
          kahonId: item.kahonId,
          createdAt: item.createdAt,
          updatedAt: DateTime.now(),
          kahonItemModifier: updatedModifiers,
        );

        final updatedItems = [...kahon.kahonItem];
        updatedItems[itemIndex] = updatedItem;

        kahon = kahon.copyWith(kahonItem: updatedItems);
        hasChanges = true;
      }
    });
  }

  void _addTransferredItemModifier(
      String itemId, OperationType operation, double value) {
    setState(() {
      final itemIndex =
          kahon.kahonTransferredItem.indexWhere((item) => item.id == itemId);
      if (itemIndex != -1) {
        final item = kahon.kahonTransferredItem[itemIndex];
        final newModifier = KahonTransferredItemModifier(
          id: const Uuid().v4(),
          index: item.kahonTransferredItemModifier.length,
          operation: operation,
          value: value,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          kahonTransferredItemId: itemId,
        );

        final updatedModifiers = [
          ...item.kahonTransferredItemModifier,
          newModifier
        ];

        final updatedItem = KahonTransferredItem(
          id: item.id,
          qty: item.qty,
          name: item.name,
          price: item.price,
          priceId: item.priceId,
          value: item.value,
          kahonId: item.kahonId,
          createdAt: item.createdAt,
          updatedAt: DateTime.now(),
          kahonTransferredItemModifier: updatedModifiers,
        );

        final updatedItems = [...kahon.kahonTransferredItem];
        updatedItems[itemIndex] = updatedItem;

        kahon = kahon.copyWith(kahonTransferredItem: updatedItems);
        hasChanges = true;
      }
    });
  }

  void _removeTransferredItemModifier(String itemId, String modifierId) {
    setState(() {
      final itemIndex =
          kahon.kahonTransferredItem.indexWhere((item) => item.id == itemId);
      if (itemIndex != -1) {
        final item = kahon.kahonTransferredItem[itemIndex];

        final updatedModifiers = item.kahonTransferredItemModifier
            .where((mod) => mod.id != modifierId)
            .toList();

        // Reindex remaining modifiers
        for (int i = 0; i < updatedModifiers.length; i++) {
          updatedModifiers[i] = KahonTransferredItemModifier(
            id: updatedModifiers[i].id,
            index: i,
            operation: updatedModifiers[i].operation,
            value: updatedModifiers[i].value,
            createdAt: updatedModifiers[i].createdAt,
            updatedAt: DateTime.now(),
            kahonTransferredItemId: updatedModifiers[i].kahonTransferredItemId,
          );
        }

        final updatedItem = KahonTransferredItem(
          id: item.id,
          qty: item.qty,
          name: item.name,
          price: item.price,
          priceId: item.priceId,
          value: item.value,
          kahonId: item.kahonId,
          createdAt: item.createdAt,
          updatedAt: DateTime.now(),
          kahonTransferredItemModifier: updatedModifiers,
        );

        final updatedItems = [...kahon.kahonTransferredItem];
        updatedItems[itemIndex] = updatedItem;

        kahon = kahon.copyWith(kahonTransferredItem: updatedItems);
        hasChanges = true;
      }
    });
  }

  void _removeTotalModifier(String modifierId) {
    setState(() {
      final updatedModifiers = kahon.kahonTotalModifier
          .where((mod) => mod.id != modifierId)
          .toList();

      // Reindex remaining modifiers
      for (int i = 0; i < updatedModifiers.length; i++) {
        updatedModifiers[i] = KahonTotalModifier(
          id: updatedModifiers[i].id,
          index: i,
          operation: updatedModifiers[i].operation,
          value: updatedModifiers[i].value,
          createdAt: updatedModifiers[i].createdAt,
          updatedAt: DateTime.now(),
          kahonId: updatedModifiers[i].kahonId,
        );
      }

      kahon = kahon.copyWith(kahonTotalModifier: updatedModifiers);
      hasChanges = true;
    });
  }

  void _deleteItem(String itemId) {
    setState(() {
      final updatedItems =
          kahon.kahonItem.where((item) => item.id != itemId).toList();
      kahon = kahon.copyWith(kahonItem: updatedItems);
      hasChanges = true;
    });
  }
}
