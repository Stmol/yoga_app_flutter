import 'package:logger/logger.dart';

class Log {
  static Logger _instance;

  static void init() {
    _instance = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        colors: true,
        lineLength: 80,
        printTime: true,
      ),
    );
  }

  static void debug(dynamic message, [dynamic error, StackTrace stackTrace]) {
    _instance.d(message, error, stackTrace);
  }

  static void info(dynamic message, [dynamic error, StackTrace stackTrace]) {
    _instance.i(message, error, stackTrace);
  }

  static void error(dynamic message, [dynamic error, StackTrace stackTrace]) {
    _instance.e(message, error, stackTrace);
  }

  static void warn(dynamic message, [dynamic error, StackTrace stackTrace]) {
    _instance.w(message, error, stackTrace);
  }
}
