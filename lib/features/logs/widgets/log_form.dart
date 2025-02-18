import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sandbox/features/logs/log_provider.dart';
import 'package:flutter_sandbox/features/logs/providers/log_form_provider.dart';
import 'package:flutter_sandbox/core/models/log.dart';
import 'package:flutter_sandbox/core/services/logger.dart';
import 'package:flutter_sandbox/features/logs/widgets/nursing_fields.dart';
import 'package:flutter_sandbox/features/logs/widgets/bottle_fields.dart';
import 'package:flutter_sandbox/features/logs/widgets/medicine_fields.dart';
import 'package:flutter_sandbox/features/logs/widgets/sleep_fields.dart';
import 'package:flutter_sandbox/features/logs/widgets/solids_fields.dart';
import 'package:flutter_sandbox/features/logs/widgets/bathroom_fields.dart';
import 'package:flutter_sandbox/features/logs/widgets/pumping_fields.dart';
import 'package:flutter_sandbox/features/logs/widgets/activity_fields.dart';
import 'package:flutter_sandbox/features/logs/widgets/growth_fields.dart';

class LogForm extends ConsumerStatefulWidget {
  final String type;
  final Log? existingLog;
  final VoidCallback? onSaved;

  const LogForm({
    super.key,
    required this.type,
    this.existingLog,
    this.onSaved,
  });

  @override
  ConsumerState<LogForm> createState() => _LogFormState();
}

class _LogFormState extends ConsumerState<LogForm> {
  // Add controllers as class fields
  late final TextEditingController _notesController;
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
    _amountController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(logFormProvider.notifier).initializeForm(
            widget.type,
            existingLog: widget.existingLog,
          );
    });
  }

  @override
  void didUpdateWidget(LogForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    final currentLog = ref.read(logFormProvider).currentLog;
    if (currentLog != null) {
      _notesController.text = currentLog.notes ?? '';
      _amountController.text = currentLog.amount?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Widget _buildTypeSelector() {
    final currentLog = ref.watch(logFormProvider).currentLog;
    if (currentLog == null) return const SizedBox.shrink();

    final types = [
      'feeding',
      'medicine',
      'sleep',
      'solids',
      'pumping',
      'bathroom',
      'activity',
      'growth',
    ];

    return CupertinoFormSection.insetGrouped(
      header: const Text('Type (Testing Only)'),
      children: [
        CupertinoFormRow(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: CupertinoSlidingSegmentedControl<String>(
            groupValue: currentLog.type,
            children: {
              for (final type in types)
                type: Text(
                  type[0].toUpperCase() + type.substring(1),
                  textAlign: TextAlign.center,
                ),
            },
            onValueChanged: (value) {
              if (value != null) {
                ref.read(logFormProvider.notifier).initializeForm(value);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    final currentLog = ref.watch(logFormProvider).currentLog;
    if (currentLog == null) return const SizedBox.shrink();

    // Return type-specific form fields
    switch (currentLog.type) {
      case 'feeding':
        return _buildFeedingFields(currentLog);
      case 'medicine':
        return MedicineFields(log: currentLog);
      case 'sleep':
        return SleepFields(log: currentLog);
      case 'solids':
        return SolidsFields(log: currentLog);
      case 'bathroom':
        return BathroomFields(log: currentLog);
      case 'pumping':
        return PumpingFields(log: currentLog);
      case 'activity':
        return ActivityFields(log: currentLog);
      case 'growth':
        return GrowthFields(log: currentLog);
      // Add other type cases
      default:
        logger.e('Unknown log type: ${currentLog.type}');
        return const Text('Unsupported log type');
    }
  }

  Widget _buildCommonFields() {
    final currentLog = ref.watch(logFormProvider).currentLog;
    if (currentLog == null) return const SizedBox.shrink();

    return Column(
      children: [
        CupertinoTextField(
          placeholder: 'Notes (optional)',
          controller: _notesController,
          onChanged: (value) {
            ref.read(logFormProvider.notifier).updateLog(
                  currentLog.copyWith(notes: value),
                );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFeedingFields(Log log) {
    return Column(
      children: [
        CupertinoSegmentedControl<String>(
          children: const {
            'nursing': Text('Nursing'),
            'bottle': Text('Bottle'),
          },
          groupValue: log.category ?? 'nursing',
          onValueChanged: (value) {
            ref.read(logFormProvider.notifier)
              ..updateLog(log.copyWith(category: value))
              ..setLastUsedCategory('feeding', value);
          },
        ),
        const SizedBox(height: 16),
        if (log.category == 'nursing')
          NursingFields(log: log)
        else if (log.category == 'bottle')
          BottleFields(log: log),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(logFormProvider);

    print('Form state: $formState');
    print('Widget existingLog: ${widget.existingLog?.id}');

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('${widget.existingLog == null ? 'New' : 'Edit'} Log'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: formState.isValid && !formState.isLoading
              ? () async {
                  try {
                    await ref.read(logFormProvider.notifier).saveLog();
                    if (mounted) {
                      widget.onSaved?.call();
                    }
                  } catch (e) {
                    if (mounted) {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                          title: const Text('Error'),
                          content: Text(e.toString()),
                          actions: [
                            CupertinoDialogAction(
                              child: const Text('OK'),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                }
              : null,
          child: formState.isLoading
              ? const CupertinoActivityIndicator()
              : const Text('Save'),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTypeSelector(),
              const SizedBox(height: 16),
              if (formState.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    formState.error!,
                    style:
                        const TextStyle(color: CupertinoColors.destructiveRed),
                  ),
                ),
              _buildFormFields(),
              const SizedBox(height: 16),
              _buildCommonFields(),
              if (widget.existingLog != null) ...[
                const SizedBox(height: 32),
                CupertinoButton(
                  color: CupertinoColors.destructiveRed,
                  onPressed: () async {
                    // Show confirmation dialog first
                    final shouldDelete = await showCupertinoDialog<bool>(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                        title: const Text('Delete Log'),
                        content: const Text(
                            'Are you sure you want to delete this log?'),
                        actions: [
                          CupertinoDialogAction(
                            isDestructiveAction: true,
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Delete'),
                          ),
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                        ],
                      ),
                    );

                    if (shouldDelete != true || !mounted) return;

                    try {
                      print('Deleting log ${widget.existingLog!.id}');

                      await ref
                          .read(logServiceProvider)
                          .delete(widget.existingLog!.id!);

                      if (mounted) {
                        widget.onSaved?.call();
                        // Pop back to previous screen after successful deletion
                        Navigator.of(context).pop();
                      }
                    } catch (e) {
                      if (mounted) {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                            title: const Text('Error'),
                            content: Text(e.toString()),
                            actions: [
                              CupertinoDialogAction(
                                child: const Text('OK'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Delete Log'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
