import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/storage/local_storage_service.dart';
import 'core/network/supabase_service.dart';
import 'features/auth/presentation/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Local Storage & Supabase
  await LocalStorageService.initialize();
  await SupabaseService.initialize();

  runApp(
    const ProviderScope(
      child: TwinFitApp(),
    ),
  );
}

class TwinFitApp extends StatelessWidget {
  const TwinFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TwinFit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const SplashScreen(),
    );
  }
}
