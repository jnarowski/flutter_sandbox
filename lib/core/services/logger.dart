enum LogLevel {
  debug,
  info,
  warning,
  error,
}

class Logger {
  static final Logger _instance = Logger._internal();
  factory Logger() => _instance;
  Logger._internal();

  void log(String message, {LogLevel level = LogLevel.info}) {
    final timestamp = DateTime.now().toIso8601String();
    final prefix = level.toString().split('.').last.toUpperCase();

    // In production, you might want to send this to a logging service
    // ignore: avoid_print
    print('[$timestamp] $prefix: $message');
  }

  void d(String message) => log(message, level: LogLevel.debug);
  void i(String message) => log(message, level: LogLevel.info);
  void w(String message) => log(message, level: LogLevel.warning);
  void e(String message) => log(message, level: LogLevel.error);
}

// Global instance
final logger = Logger();
