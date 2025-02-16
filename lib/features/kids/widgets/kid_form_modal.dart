import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/kid.dart';

class KidFormModal extends ConsumerStatefulWidget {
  final Kid? kid;
  final Function(Kid kid) onSave;

  const KidFormModal({
    super.key,
    this.kid,
    required this.onSave,
  });

  @override
  ConsumerState<KidFormModal> createState() => _KidFormModalState();
}

class _KidFormModalState extends ConsumerState<KidFormModal> {
  final _nameController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedGender = 'Male';

  @override
  void initState() {
    super.initState();
    if (widget.kid != null) {
      _nameController.text = widget.kid!.name;
      _selectedDate = widget.kid!.dob;
      _selectedGender = widget.kid!.gender;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _save() {
    if (_nameController.text.trim().isEmpty) {
      _showError('Please enter a name');
      return;
    }

    final kid = Kid(
      id: widget.kid?.id ?? '',
      accountId: widget.kid?.accountId ?? '',
      name: _nameController.text.trim(),
      dob: _selectedDate,
      gender: _selectedGender,
      updatedAt: DateTime.now(),
    );

    widget.onSave(kid);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.kid == null ? 'Add Child' : 'Edit Child'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('Save'),
          onPressed: _save,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CupertinoFormSection.insetGrouped(
                header: const Text('Basic Information'),
                children: [
                  CupertinoFormRow(
                    prefix: const Text('Name'),
                    child: CupertinoTextField(
                      controller: _nameController,
                      placeholder: 'Enter name',
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CupertinoFormSection.insetGrouped(
                header: const Text('Date of Birth'),
                children: [
                  SizedBox(
                    height: 200,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: _selectedDate,
                      maximumDate: DateTime.now(),
                      onDateTimeChanged: (date) {
                        setState(() => _selectedDate = date);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CupertinoFormSection.insetGrouped(
                header: const Text('Gender'),
                children: [
                  CupertinoFormRow(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: CupertinoSegmentedControl<String>(
                        children: const {
                          'Male': Text('Male'),
                          'Female': Text('Female'),
                          'Other': Text('Other'),
                        },
                        groupValue: _selectedGender,
                        onValueChanged: (value) {
                          setState(() => _selectedGender = value);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              if (widget.kid != null) ...[
                const SizedBox(height: 32),
                CupertinoButton(
                  color: CupertinoColors.destructiveRed,
                  onPressed: () {
                    // TODO: Implement delete functionality
                    Navigator.pop(context);
                  },
                  child: const Text('Delete Child'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
