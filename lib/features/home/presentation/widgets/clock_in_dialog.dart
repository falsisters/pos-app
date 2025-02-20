import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falsisters_pos_app/features/shift/providers/shift_provider.dart';

class ClockInDialog extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const ClockInDialog({
    super.key,
    required this.onClose,
  });

  @override
  ConsumerState<ClockInDialog> createState() => _ClockInDialogState();
}

class _ClockInDialogState extends ConsumerState<ClockInDialog> {
  final _formKey = GlobalKey<FormState>();
  final _employeeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _employeeController.dispose();
    super.dispose();
  }

  Future<void> _handleClockIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref
          .read(shiftsProvider.notifier)
          .createShift(_employeeController.text);
      if (mounted) {
        widget.onClose();
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to clock in: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent dialog dismissal
      child: AlertDialog(
        title: const Text('Clock In'),
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
            onPressed: _isLoading ? null : _handleClockIn,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Clock In'),
          ),
        ],
      ),
    );
  }
}
