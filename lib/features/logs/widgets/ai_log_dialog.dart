import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sandbox/core/providers/app_provider.dart';
import 'package:flutter_sandbox/features/kids/kid_provider.dart';
import 'package:flutter_sandbox/features/logs/llm_logging_provider.dart';
import 'dart:convert';
import 'package:flutter_sandbox/core/voice/voice_provider.dart';
import 'package:flutter_sandbox/core/voice/widgets/voice_waveform.dart';

class AILogDialog extends ConsumerStatefulWidget {
  const AILogDialog({super.key});

  @override
  ConsumerState<AILogDialog> createState() => _AILogDialogState();
}

class _AILogDialogState extends ConsumerState<AILogDialog> {
  final TextEditingController _textController = TextEditingController();
  String? _result;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startListening();
    });
  }

  Future<void> _startListening() async {
    final voiceService = ref.read(voiceServiceProvider);
    await voiceService.startListening(
      onTextUpdate: (text) {
        setState(() {
          _textController.text = text;
        });
        // Auto-process after speech pause
        _processAIRequest();
      },
    );
  }

  @override
  void deactivate() {
    final voiceService = ref.read(voiceServiceProvider);
    if (voiceService.isListening) {
      voiceService.stopListening();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _processAIRequest() async {
    if (_textController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _result = null;
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

      setState(() {
        _result = const JsonEncoder.withIndent('  ').convert(result.toMap());
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('AI Log Test'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('Close'),
          onPressed: () {
            if (mounted) {
              final voiceService = ref.read(voiceServiceProvider);
              if (voiceService.isListening) {
                voiceService.stopListening();
              }
            }
            Navigator.of(context).pop();
          },
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const VoiceWaveform(),
              const SizedBox(height: 16),
              CupertinoTextField(
                controller: _textController,
                placeholder: 'Speak or type your log here...',
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              CupertinoButton.filled(
                onPressed: _isLoading ? null : _processAIRequest,
                child: _isLoading
                    ? const CupertinoActivityIndicator()
                    : const Text('Process'),
              ),
              const SizedBox(height: 16),
              if (_result != null)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey6,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SingleChildScrollView(
                      child: Text(_result!),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
