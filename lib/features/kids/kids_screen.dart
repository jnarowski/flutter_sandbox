import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/kid.dart';
import 'kid_provider.dart';
import '../account/account_provider.dart';
import '../../core/providers/app_provider.dart';
import 'widgets/kid_form_modal.dart';

class KidsScreen extends ConsumerWidget {
  const KidsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appProvider);
    final kidStream = ref.watch(kidStreamProvider(appState.account!.id));

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Kids'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => _showAddKid(context, ref),
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      child: SafeArea(
        child: kidStream.when(
          data: (kids) {
            if (kids.isEmpty) {
              return const Center(
                child: Text('No kids added yet'),
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

  void _showAddKid(BuildContext context, WidgetRef ref) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => KidFormModal(
          onSave: (kid) {
            final appState = ref.read(appProvider);
            final newKid = kid.copyWith(
              accountId: appState.account!.id,
            );
            ref.read(kidsControllerProvider.notifier).addKid(newKid);
          },
        ),
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
            .updateCurrentKid(account.id, kid.id);
      },
      title: Text(kid.name),
      subtitle: Text(
        '${kid.gender} • Born ${kid.dob.toString().split(' ')[0]}',
      ),
      trailing: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => _showEditKid(context, ref),
        child: const Icon(CupertinoIcons.pencil),
      ),
    );
  }

  void _showEditKid(BuildContext context, WidgetRef ref) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => KidFormModal(
          kid: kid,
          onSave: (updatedKid) {
            ref.read(kidsControllerProvider.notifier).updateKid(updatedKid);
          },
        ),
      ),
    );
  }
}
