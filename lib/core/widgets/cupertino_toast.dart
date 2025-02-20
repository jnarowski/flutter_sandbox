import 'package:flutter/cupertino.dart';

class CupertinoToast extends StatelessWidget {
  final String message;
  final Color? backgroundColor;
  final Color? textColor;

  const CupertinoToast({
    super.key,
    required this.message,
    this.backgroundColor,
    this.textColor,
  });

  static void show(BuildContext context, String message) {
    final overlay = Navigator.of(context).overlay!;

    final toast = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 64.0,
        left: 16.0,
        right: 16.0,
        child: SafeArea(
          child: CupertinoToast(message: message),
        ),
      ),
    );

    overlay.insert(toast);

    Future.delayed(const Duration(seconds: 2), () {
      toast.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: backgroundColor ?? CupertinoColors.systemGrey6.withAlpha(242),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor ?? CupertinoColors.label,
          fontSize: 15.0,
        ),
      ),
    );
  }
}
