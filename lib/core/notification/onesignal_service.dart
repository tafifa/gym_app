import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalService {
  static const String appId = "YOUR-ONESIGNAL-APP-ID-HERE"; // Replace with real ID

  static Future<void> init() async {
    // Only initialize OneSignal on mobile platforms (Android/iOS)
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
      debugPrint("OneSignal: Push notifications are only initialized on mobile platforms (Android/iOS).");
      return;
    }

    try {
      // Set debug logging for development
      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

      // Initialize OneSignal
      OneSignal.initialize(appId);

      // Request notification permission if not yet granted
      await OneSignal.Notifications.requestPermission(true);
    } catch (e) {
      debugPrint("OneSignal Initialization Error: $e");
    }
  }
}
