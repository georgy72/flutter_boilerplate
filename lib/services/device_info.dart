import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_udid/flutter_udid.dart';

class DeviceInfo {
  Future<String> getDeviceId() async {
//    TODO: implement web device_id
    if (kIsWeb) return '${new DateTime.now().millisecondsSinceEpoch}';
    return FlutterUdid.consistentUdid;
  }

  String get platform => getPlatformName().toLowerCase();

  String getPlatformName() {
    if (kIsWeb) return 'Web';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    return Platform.operatingSystem;
  }
}
