class AppConstants {
  // App Info
  static const String appName = 'TwinFit';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Biyolojik İkiz & Otonom Altın Rota';

  // Supabase Configuration
  static const String supabaseUrl = 'https://lhjmemrwbswiqphsvlbp.supabase.co';
  static const String supabaseAnonKey = 'sb_publishable_R7W9KJA-9wDqle7iurzp8w_XAicHo80';

  // Upstash Redis REST Configuration
  static const String upstashRedisRestUrl = 'https://wondrous-viper-149203.upstash.io';
  static const String upstashRedisRestToken = 'gQAAAAAAAkbTAAIgcDI5NjIzYWQ1NWQ3YzU0ZGJkODE2YTNkNjE5ZTJlYzdhYQ';

  // Storage Keys
  static const String keyAuthToken = 'twinfit_auth_token';
  static const String keyUserId = 'twinfit_user_id';
  static const String keyBiometricEnabled = 'twinfit_biometric_enabled';
  static const String keyThemeMode = 'twinfit_theme_mode';
  static const String keyOfflineQueue = 'twinfit_offline_sync_queue';
  static const String keyProfileCache = 'twinfit_cached_profile';
  static const String keyRoutinesCache = 'twinfit_cached_routines';
  static const String keyExercisesCache = 'twinfit_cached_exercises';

  // Animation Durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 250);
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
}
