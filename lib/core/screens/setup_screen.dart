import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/account/account_provider.dart';
import '../../core/providers/app_provider.dart';
import '../../core/utils/error_dialog.dart';
import '../../features/account/setup_providers.dart';

class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedGender = 'Other';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedDate == null) {
        // Show date error
        return;
      }

      try {
        final createFirstKid = ref.read(createFirstKidProvider);

        await createFirstKid(
          accountId: ref.read(appProvider).account!.id,
          name: _nameController.text,
          dob: _selectedDate!,
          gender: _selectedGender,
        );
        // Navigate to home screen or show success message
      } catch (e, stackTrace) {
        // Show error message to user
        if (mounted) {
          await ErrorDialog.show(
            context: context,
            title: 'Setup Error',
            error: e,
            stackTrace: stackTrace,
            message: 'Failed to create kid profile. Please try again.',
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Welcome to Baby Tracker'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Let's set up your first baby profile",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                CupertinoTextField(
                  controller: _nameController,
                  placeholder: "Baby's Name",
                  padding: const EdgeInsets.all(12),
                ),
                const SizedBox(height: 16),
                CupertinoButton(
                  child: Text(
                    _selectedDate == null
                        ? 'Select Birth Date'
                        : 'Birth Date: ${_selectedDate.toString().split(' ')[0]}',
                  ),
                  onPressed: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext context) => SizedBox(
                        height: 250,
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: DateTime.now(),
                          maximumDate: DateTime.now(),
                          onDateTimeChanged: (DateTime newDate) {
                            setState(() {
                              _selectedDate = newDate;
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                CupertinoSegmentedControl<String>(
                  children: const {
                    'M': Text('Boy'),
                    'F': Text('Girl'),
                    'Other': Text('Other'),
                  },
                  groupValue: _selectedGender,
                  onValueChanged: (String value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
                const Spacer(),
                CupertinoButton.filled(
                  onPressed: _submitForm,
                  child: const Text('Create Profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
