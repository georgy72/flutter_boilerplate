import 'package:flutter/foundation.dart';

class App {
  static bool get isDebug {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }
}

class Constants {
  static Urls urls = Urls();
}

class Urls {
  String? base;
  String? api;

  String? auth;
  String? profile;

  Urls() {
    base = 'https://example.com';
    if (kIsWeb) {
      if (App.isDebug) base = 'http://localhost';
    } else {
      if (App.isDebug) base = 'https://example.com/test';
    }
    api = '$base/api/v1';

    auth = '$api/auth';
    profile = '$api/profile';
  }
}
