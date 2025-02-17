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
  late DateTime _selectedDate;
  String _selectedGender = 'Male';

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.kid?.dob ?? DateTime.now();

    if (widget.kid != null) {
      _nameController.text = widget.kid!.name;
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

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  String _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    final difference = now.difference(birthDate);
    final days = difference.inDays;
    final months = (days / 30.44).floor(); // Average days in a month
    final years = (days / 365.25).floor(); // Account for leap years

    if (years < 1) {
      final remainingDays = days - (months * 30.44).floor();
      return '$months ${months == 1 ? 'month' : 'months'}, '
          '${remainingDays.floor()} ${remainingDays.floor() == 1 ? 'day' : 'days'}';
    } else {
      final remainingMonths = months - (years * 12);
      return '$years ${years == 1 ? 'year' : 'years'}, '
          '$remainingMonths ${remainingMonths == 1 ? 'month' : 'months'}';
    }
  }

  void _showDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground.resolveFrom(context),
              border: Border(
                top: BorderSide(
                  color: CupertinoColors.separator.resolveFrom(context),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoButton(
                  child: const Text('Done'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Container(
            height: 216,
            padding: const EdgeInsets.only(top: 6.0),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            color: CupertinoColors.systemBackground.resolveFrom(context),
            child: SafeArea(
              top: false,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: _selectedDate,
                maximumDate: DateTime.now(),
                onDateTimeChanged: (DateTime newDate) {
                  setState(() => _selectedDate = newDate);
                },
              ),
            ),
          ),
        ],
      ),
    );
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
          onPressed: _save,
          child: const Text('Save'),
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
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: _showDatePicker,
                    child: CupertinoFormRow(
                      prefix: const Text('Birthday'),
                      child: Text(
                        _formatDate(_selectedDate),
                        style:
                            const TextStyle(color: CupertinoColors.systemBlue),
                      ),
                    ),
                  ),
                  CupertinoFormRow(
                    prefix: const Text('Age'),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        _calculateAge(_selectedDate),
                        style:
                            const TextStyle(color: CupertinoColors.systemGrey),
                      ),
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
