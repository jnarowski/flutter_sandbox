import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:intelligence/intelligence.dart';

void main() {
  runApp(const CupertinoApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _intelligencePlugin = Intelligence();
  final _messages = <String>[];

  @override
  void initState() {
    super.initState();
    unawaited(init());
  }

  Future<void> init() async {
    try {
      _intelligencePlugin.selectionsStream().listen(_handleVoiceInput);
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handleVoiceInput(String message) {
    print('Voice message received: $message');
    setState(() {
      _messages.add(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          const CupertinoSliverNavigationBar(
            leading: Icon(CupertinoIcons.captions_bubble_fill),
            largeTitle: Text('Voice Messages'),
          ),
          SliverList.builder(
            itemBuilder: (_, index) => Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _messages[index],
                style: const TextStyle(fontSize: 16),
              ),
            ),
            itemCount: _messages.length,
          ),
        ],
      ),
    );
  }
}
