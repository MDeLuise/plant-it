import 'package:talker_flutter/talker_flutter.dart';

abstract class Logger {
  void debug(
    dynamic msg, [
    Object? exception,
    StackTrace? stackTrace,
  ]);

  void error(
    dynamic msg, [
    Object? exception,
    StackTrace? stackTrace,
  ]);

  void info(
    dynamic msg, [
    Object? exception,
    StackTrace? stackTrace,
  ]);

  void warning(
    dynamic msg, [
    Object? exception,
    StackTrace? stackTrace,
  ]);
}

class TalkerLogger implements Logger {
  final Talker _innerLogger;

  TalkerLogger() : _innerLogger = TalkerFlutter.init();

  Talker get talker => _innerLogger;

  @override
  void debug(msg, [Object? exception, StackTrace? stackTrace]) {
    _innerLogger.debug(msg, [exception, stackTrace]);
  }

  @override
  void error(msg, [Object? exception, StackTrace? stackTrace]) {
    _innerLogger.error(msg, [exception, stackTrace]);
  }

  @override
  void info(msg, [Object? exception, StackTrace? stackTrace]) {
    _innerLogger.info(msg, [exception, stackTrace]);
  }

  @override
  void warning(msg, [Object? exception, StackTrace? stackTrace]) {
    _innerLogger.warning(msg, [exception, stackTrace]);
  }
}
