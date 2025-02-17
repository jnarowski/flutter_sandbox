import 'package:flutter/cupertino.dart';

class ErrorDialog {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required Object error,
    StackTrace? stackTrace,
    String? message,
    VoidCallback? onDismiss,
  }) {
    String errorMessage = message ?? error.toString();

    // In debug mode, include the stack trace
    assert(() {
      if (stackTrace != null) {
        errorMessage += '\n\nStack Trace:\n${stackTrace.toString()}';
      }
      return true;
    }());

    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(errorMessage),
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(context);
              onDismiss?.call();
            },
          ),
        ],
      ),
    );
  }
}
