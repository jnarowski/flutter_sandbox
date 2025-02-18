import 'package:flutter/cupertino.dart';

class ErrorScreen extends StatelessWidget {
  final Object error;
  final StackTrace stackTrace;

  const ErrorScreen({super.key, required this.error, required this.stackTrace});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${error.toString()}'),
            Text('Stacktrace: ${stackTrace.toString()}'),
          ],
        ),
      ),
    );
  }
}
