import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/database/objectbox_service.dart';
import 'core/notification/onesignal_service.dart';
import 'core/providers/core_providers.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/views/login_screen.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local ObjectBox database store
  final objectBoxService = await ObjectBoxService.create();

  // Initialize push notification settings (with platform safety)
  await OneSignalService.init();

  runApp(
    ProviderScope(
      overrides: [
        // Inject the initialized ObjectBox service instance
        objectBoxProvider.overrideWithValue(objectBoxService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitTrack Gym App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const LoginScreen(),
    );
  }
}
