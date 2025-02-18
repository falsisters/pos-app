import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/shift_provider.dart';

class CreateShiftDialog extends ConsumerStatefulWidget {
  const CreateShiftDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateShiftDialog> createState() => _CreateShiftDialogState();
}

class _CreateShiftDialogState extends ConsumerState<CreateShiftDialog> {
  final _formKey = GlobalKey<FormState>();
  final _employeeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _employeeController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateShift() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref
          .read(shiftsProvider.notifier)
          .createShift(_employeeController.text);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Start New Shift'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _employeeController,
              decoration: const InputDecoration(
                labelText: 'Employee Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter employee name';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleCreateShift,
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Clock In'),
        ),
      ],
    );
  }
}
