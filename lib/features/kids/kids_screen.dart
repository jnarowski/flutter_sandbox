import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/kid.dart';
import 'kid_provider.dart';
import '../account/account_provider.dart';
import '../../core/providers/app_provider.dart';

class KidsScreen extends ConsumerWidget {
  const KidsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appProvider);
    final kidStream = ref.watch(kidStreamProvider(appState.account!.id));

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Kids'),
        trailing: AddKidButton(),
      ),
      child: SafeArea(
        child: kidStream.when(
          data: (kids) {
            if (kids.isEmpty) {
              return const Center(
                child: Text('No kidss added yet'),
              );
            }

            return ListView.builder(
              itemCount: kids.length,
              itemBuilder: (context, index) {
                final kid = kids[index];
                return KidListTile(kid: kid);
              },
            );
          },
          loading: () => const Center(
            child: CupertinoActivityIndicator(),
          ),
          error: (error, stack) => Center(
            child: Text('Error: $error'),
          ),
        ),
      ),
    );
  }
}

class AddKidButton extends ConsumerWidget {
  const AddKidButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _showAddKidDialog(context, ref),
      child: const Icon(CupertinoIcons.add),
    );
  }

  void _showAddKidDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    String selectedGender = 'Male';

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Add New Kid'),
        content: Column(
          children: [
            CupertinoTextField(
              controller: nameController,
              placeholder: 'Name',
            ),
            const SizedBox(height: 16),
            CupertinoButton(
              child: Text(
                'Date of Birth: ${selectedDate.toString().split(' ')[0]}',
              ),
              onPressed: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) => Container(
                    height: 216,
                    color: CupertinoColors.systemBackground,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: selectedDate,
                      maximumDate: DateTime.now(),
                      onDateTimeChanged: (date) {
                        selectedDate = date;
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            CupertinoSlidingSegmentedControl<String>(
              children: const {
                'Male': Text('Male'),
                'Female': Text('Female'),
              },
              groupValue: selectedGender,
              onValueChanged: (value) {
                if (value != null) {
                  selectedGender = value;
                }
              },
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            child: const Text('Add'),
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                final appState = ref.watch(appProvider);

                final kid = Kid(
                  name: name,
                  dob: selectedDate,
                  gender: selectedGender,
                  accountId: appState.account!.id,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );
                ref.read(kidsControllerProvider.notifier).addKid(kid);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}

class KidListTile extends ConsumerWidget {
  final Kid kid;

  const KidListTile({super.key, required this.kid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appProvider);

    return CupertinoListTile(
      onTap: () async {
        final account = appState.account;
        if (account == null) return;

        await ref
            .read(accountServiceProvider)
            .updateCurrentKid(account.id, kid.id!);
      },
      title: Text(kid.name),
      subtitle: Text(
        '${kid.gender} • Born ${kid.dob.toString().split(' ')[0]}',
      ),
      trailing: GestureDetector(
        onTap: () => _showEditKidDialog(context, ref),
        child: const Icon(CupertinoIcons.pencil),
      ),
    );
  }

  void _showEditKidDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController(text: kid.name);
    DateTime selectedDate = kid.dob;
    String selectedGender = kid.gender;

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Edit Kid'),
        content: Column(
          children: [
            CupertinoTextField(
              controller: nameController,
              placeholder: 'Name',
            ),
            const SizedBox(height: 16),
            CupertinoButton(
              child: Text(
                'Date of Birth: ${selectedDate.toString().split(' ')[0]}',
              ),
              onPressed: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) => Container(
                    height: 216,
                    color: CupertinoColors.systemBackground,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: selectedDate,
                      maximumDate: DateTime.now(),
                      onDateTimeChanged: (date) {
                        selectedDate = date;
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            CupertinoSlidingSegmentedControl<String>(
              children: const {
                'Male': Text('Male'),
                'Female': Text('Female'),
              },
              groupValue: selectedGender,
              onValueChanged: (value) {
                if (value != null) {
                  selectedGender = value;
                }
              },
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Delete'),
            onPressed: () {
              ref.read(kidsControllerProvider.notifier).deleteKid(kid.id!);
              Navigator.pop(context);
            },
          ),
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            child: const Text('Save'),
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                final updatedKid = kid.copyWith(
                  name: name,
                  dob: selectedDate,
                  gender: selectedGender,
                );
                ref.read(kidsControllerProvider.notifier).updateKid(updatedKid);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
