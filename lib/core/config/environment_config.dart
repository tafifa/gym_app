import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppEnvironment {
  production,
  staging,
  test,
  testLocal,
}

extension AppEnvironmentExtension on AppEnvironment {
  String get name {
    switch (this) {
      case AppEnvironment.production:
        return 'Production';
      case AppEnvironment.staging:
        return 'Staging';
      case AppEnvironment.test:
        return 'Test';
      case AppEnvironment.testLocal:
        return 'Test Local';
    }
  }

  String get baseUrl {
    switch (this) {
      case AppEnvironment.production:
        return 'https://api.gym-app.com/v1/';
      case AppEnvironment.staging:
        return 'https://staging-api.gym-app.com/v1/';
      case AppEnvironment.test:
        return 'https://test-api.gym-app.com/v1/';
      case AppEnvironment.testLocal:
        return 'http://10.0.2.2:8080/v1/'; // Localhost for Android emulator
    }
  }
}

class EnvironmentNotifier extends Notifier<AppEnvironment> {
  @override
  AppEnvironment build() {
    return AppEnvironment.production;
  }

  void updateEnvironment(AppEnvironment newEnvironment) {
    state = newEnvironment;
  }
}

final environmentProvider = NotifierProvider<EnvironmentNotifier, AppEnvironment>(() {
  return EnvironmentNotifier();
});
