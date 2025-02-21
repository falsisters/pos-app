import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:falsisters_pos_app/features/delivery/data/providers/delivery_state_provider.dart';
import 'package:falsisters_pos_app/features/delivery/presentation/widgets/delivery_checkout_dialog.dart';
import 'package:falsisters_pos_app/features/delivery/presentation/widgets/delivery_item_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falsisters_pos_app/features/delivery/data/providers/delivery_provider.dart';
import 'package:image_picker/image_picker.dart';

class DeliveryCartSection extends ConsumerWidget {
  const DeliveryCartSection({super.key});

  Future<void> _pickImages(WidgetRef ref) async {
    final status = await Permission.photos.request();

    if (status.isGranted) {
      final imagePicker = ImagePicker();
      final images = await imagePicker.pickMultiImage();

      for (var image in images) {
        ref.read(deliveryStateProvider.notifier).addAttachment(image);
      }
    } else {
      print('Permission denied');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(deliveryCartProvider);
    final attachments = ref.watch(deliveryStateProvider).attachments;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Delivery Cart',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return DeliveryItemTile(item: item);
              },
            ),
          ),
          if (attachments.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: attachments
                    .map((attachment) => Stack(
                          children: [
                            Image.file(
                              File(attachment.path),
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => ref
                                    .read(deliveryStateProvider.notifier)
                                    .removeAttachment(attachment),
                              ),
                            ),
                          ],
                        ))
                    .toList(),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton.icon(
                  onPressed: () => _pickImages(ref),
                  icon: const Icon(Icons.attach_file),
                  label: const Text('Add Attachments'),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: cartItems.isEmpty
                      ? null
                      : () => _showDeliveryCheckoutDialog(context),
                  child: const Text('Create Delivery'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeliveryCheckoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const DeliveryCheckoutDialog(),
    );
  }
}
