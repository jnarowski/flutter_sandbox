import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sandbox/core/voice/widgets/voice_waveform.dart';

import 'package:flutter_sandbox/core/models/log.dart';
import 'dart:async'; // Add this import

import 'package:flutter_sandbox/features/logs/widgets/ai_log_controller.dart';

class AILogDialog extends ConsumerWidget {
  const AILogDialog({super.key});

  static Future<Log?> show(BuildContext context) {
    return showCupertinoModalPopup<Log?>(
      context: context,
      barrierColor:
          CupertinoColors.black.withAlpha(127), // 50% opacity using withAlpha
      builder: (context) => const AILogDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(aiLogControllerProvider);

    // Initialize speech recognition on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.isInitializing) {
        controller.initializeSpeech();
      }
    });

    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        color: CupertinoTheme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        children: [
          _buildHeader(context, controller),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildContent(controller),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AILogController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Text('Close'),
            onPressed: () async {
              await controller.stopListening();
              Navigator.of(context).pop(controller.log);
            },
          ),
          const Text('Add Voice Log',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: (controller.isProcessing || !controller.isValidText)
                ? null
                : controller.processAIRequest,
            child: controller.isProcessing
                ? const CupertinoActivityIndicator()
                : Text('Save',
                    style: TextStyle(
                      color: controller.isValidText
                          ? CupertinoTheme.of(context).primaryColor
                          : CupertinoColors.systemGrey3,
                    )),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(AILogController controller) {
    if (controller.isInitializing) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Starting voice recognition...')],
        ),
      );
    }

    if (controller.isStopping) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Stopping voice recognition...')],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: CupertinoColors.systemGrey4,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.all(8.0),
          child: const VoiceWaveform(),
        ),
        const SizedBox(height: 16),
        CupertinoTextField(
          controller: controller.textController,
          placeholder: 'Speak or type your log here...',
          maxLines: 1,
        ),
        const SizedBox(height: 24),
        _buildExamples(),
      ],
    );
  }

  Widget _buildExamples() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Examples:',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: CupertinoColors.systemGrey,
          ),
        ),
        SizedBox(height: 8),
        Text(
          '• "Sarah had 4 oz of formula at 2pm"\n'
          '• "Changed wet diaper for Tommy"\n'
          '• "James slept from 1pm to 3:30pm"',
          style: TextStyle(
            fontSize: 14,
            color: CupertinoColors.systemGrey,
          ),
        ),
      ],
    );
  }
}
