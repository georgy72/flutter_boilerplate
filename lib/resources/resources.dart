import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AllFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) => App.isDebug;
}

class App {
  static bool get isDebug {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }

  static final logger = Logger(
    printer: PrettyPrinter(methodCount: 0, printTime: false, errorMethodCount: 0),
    filter: AllFilter(),
  );

  static info(dynamic message) => logger.i(message);

  static debug(dynamic message) => logger.d(message);

  static verbose(dynamic message) => logger.v(message);

  static warning(dynamic message) => logger.w(message);
}

class Constants {
  static Urls urls = Urls();
}

class Urls {
  String get base {
    if (kIsWeb) {
      if (App.isDebug) return 'http://localhost';
    } else {
      if (App.isDebug) return 'https://example.com/test';
    }
    return 'https://example.com';
  }

  String get api => '$base/api/v1';

  String get auth => '$api/auth';

  String get profile => '$api/profile';
}
