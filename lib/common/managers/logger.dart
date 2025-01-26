import 'package:logger/logger.dart';

///Manager for [Logger].
class LoggerBase {
  static final LoggerBase _instance = LoggerBase._internal();

  factory LoggerBase() {
    return _instance;
  }

  LoggerBase._internal();

  final Logger _logger = Logger();

  Logger get logger => _logger;

  static void d<T>(T message) {
    _instance._logger.d(message is String ? message : message.toString());
  }

  static void e<T>(T message) {
    _instance._logger.e(message is String ? message : message.toString());
  }
}
