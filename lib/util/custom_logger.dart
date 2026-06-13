import 'dart:developer' as dev;

class CustomLogger {
  // Use 'log' from dart:developer for better formatted output in IDEs
  static void info(String message) {
    dev.log('🔵 [INFO] $message', name: 'LocaLink');
  }

  static void warning(String message) {
    dev.log('🟠 [WARN] $message', name: 'LocaLink');
  }

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    dev.log(
        '🔴 [ERROR] $message',
        name: 'LocaLink',
        error: error,
        stackTrace: stackTrace
    );
  }

  static void debug(String message) {
    dev.log('🟢 [DEBUG] $message', name: 'LocaLink');
  }
}