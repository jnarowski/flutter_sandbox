import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:intelligence/intelligence.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/auth_gate_screen.dart';
import 'firebase_options.dart';
import 'screens/app_init_gate.dart';
import 'screens/app_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  runApp(const ProviderScope(child: MyApp()));
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
    return CupertinoApp(
      theme: const CupertinoThemeData(brightness: Brightness.light),
      home: AuthGate(
        child: AppInitGate(child: AppScreen()),
      ),
    );
  }
}
