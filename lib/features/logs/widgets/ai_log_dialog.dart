import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sandbox/core/providers/app_provider.dart';
import 'package:flutter_sandbox/features/kids/kid_provider.dart';
import 'package:flutter_sandbox/features/logs/llm_logging_provider.dart';
import 'package:flutter_sandbox/core/voice/voice_provider.dart';
import 'package:flutter_sandbox/core/voice/widgets/voice_waveform.dart';
import 'package:flutter_sandbox/core/services/logger.dart';
import 'package:flutter_sandbox/core/models/log.dart';
import 'dart:async'; // Add this import
import 'package:flutter_sandbox/core/widgets/cupertino_toast.dart';

class AILogDialog extends ConsumerStatefulWidget {
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
  ConsumerState<AILogDialog> createState() => _AILogDialogState();
}

class _AILogDialogState extends ConsumerState<AILogDialog> {
  final TextEditingController _textController = TextEditingController();
  bool _isProcessing = false;
  bool _isInitializing = true;
  bool _isStopping = false;
  Log? _log;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {}); // Trigger rebuild when text changes
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSpeech();
    });
  }

  Future<void> _initializeSpeech() async {
    try {
      // Add artificial delay to ensure modal and loading state are visible
      await Future.delayed(const Duration(milliseconds: 350));

      final voiceService = ref.read(voiceServiceProvider);
      if (voiceService.isListening) {
        await voiceService.stopListening();
      }
      await voiceService.startListening(
        onTextUpdate: (text) {
          setState(() {
            _textController.text = text;
          });
        },
        onTextComplete: (text) {
          _processAIRequest();
        },
      );
    } finally {
      setState(() {
        _isInitializing = false;
      });
    }
  }

  @override
  void deactivate() {
    final voiceService = ref.read(voiceServiceProvider);
    if (voiceService.isListening) {
      print('stopping voice service...');
      voiceService.stopListening();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _textController.removeListener(() {}); // Remove listener
    _textController.dispose();
    super.dispose();
  }

  bool _isValidText() {
    final text = _textController.text.trim();
    final wordCount = text.split(' ').where((word) => word.isNotEmpty).length;
    return wordCount >= 3;
  }

  Future<void> _processAIRequest() async {
    if (_textController.text.isEmpty) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final appState = ref.read(appProvider);
      final llmService = ref.read(llmLoggingServiceProvider);
      final kidService = ref.read(kidServiceProvider);
      final kids = await kidService.getAll(appState.account!.id);
      final result = await llmService.parseLogFromText(
        text: _textController.text,
        kids: kids,
      );

      logger.info('AI Log Result: ${result.toMap()}');

      setState(() {
        _log = result;
        _isProcessing = false;
      });

      if (mounted) {
        CupertinoToast.show(context, 'Log processed successfully');
        Navigator.of(context).pop(result); // Return the log result
      }
    } catch (e, stacktrace) {
      logger.error('AI Log Error: $e');
      logger.error('AI Log Stacktrace: $stacktrace');
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5, // Changed to 50% height
      decoration: BoxDecoration(
        color: CupertinoTheme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Text('Close'),
                  onPressed: () {
                    setState(() {
                      _isStopping = true;
                    });

                    Future.delayed(const Duration(milliseconds: 50)).then((_) {
                      final voiceService = ref.read(voiceServiceProvider);
                      if (voiceService.isListening) {
                        voiceService.stopListening();
                      }
                      if (mounted) {
                        Navigator.of(context)
                            .pop(_log); // Return the log if we have one
                      }
                    });
                  },
                ),
                const Text('Add Log',
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: (_isProcessing || !_isValidText())
                      ? null
                      : _processAIRequest,
                  child: _isProcessing
                      ? const CupertinoActivityIndicator()
                      : Text('Save',
                          style: TextStyle(
                            color: _isValidText()
                                ? CupertinoTheme.of(context).primaryColor
                                : CupertinoColors.systemGrey3,
                          )),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _isInitializing
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Starting voice recognition...'),
                        ],
                      ),
                    )
                  : _isStopping
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Stopping voice recognition...'),
                            ],
                          ),
                        )
                      : Column(
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
                              controller: _textController,
                              placeholder: 'Speak or type your log here...',
                              maxLines: 1,
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Examples:',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: CupertinoColors.systemGrey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              '• "Sarah had 4 oz of formula at 2pm"\n'
                              '• "Changed wet diaper for Tommy"\n'
                              '• "James slept from 1pm to 3:30pm"',
                              style: TextStyle(
                                fontSize: 14,
                                color: CupertinoColors.systemGrey,
                              ),
                            ),
                          ],
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
