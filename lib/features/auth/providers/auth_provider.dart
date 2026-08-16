import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/network/supabase_service.dart';
import '../../../core/storage/local_storage_service.dart';
import '../models/user_profile.dart';

enum AuthStatus { initial, unauthenticated, authenticated, loading, error }

class AuthState {
  final AuthStatus status;
  final User? user;
  final UserProfile? profile;
  final String? errorMessage;
  final bool isBiometricAvailable;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.profile,
    this.errorMessage,
    this.isBiometricAvailable = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    UserProfile? profile,
    String? errorMessage,
    bool? isBiometricAvailable,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      profile: profile ?? this.profile,
      errorMessage: errorMessage,
      isBiometricAvailable: isBiometricAvailable ?? this.isBiometricAvailable,
    );
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AuthState> {
  final LocalAuthentication _localAuth = LocalAuthentication();

  AuthNotifier() : super(const AuthState()) {
    checkInitialSession();
  }

  Future<void> checkInitialSession() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      bool canCheckBiometrics = false;
      try {
        canCheckBiometrics = await _localAuth.canCheckBiometrics || await _localAuth.isDeviceSupported();
      } catch (_) {}

      final currentUser = SupabaseService.currentUser;
      if (currentUser != null) {
        final profile = await fetchProfile(currentUser.id);
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: currentUser,
          profile: profile,
          isBiometricAvailable: canCheckBiometrics,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          isBiometricAvailable: canCheckBiometrics,
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString(),
      );
    }
  }

  Future<UserProfile?> fetchProfile(String userId) async {
    try {
      final data = await SupabaseService.client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (data != null) {
        final profile = UserProfile.fromJson(data);
        await LocalStorageService.saveJson('twinfit_cached_profile', data);
        return profile;
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching profile: $e');
      final cached = LocalStorageService.getJson('twinfit_cached_profile');
      if (cached != null) {
        return UserProfile.fromJson(cached);
      }
      return null;
    }
  }

  Future<bool> signInWithEmail(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final response = await SupabaseService.client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      if (response.user != null) {
        final profile = await fetchProfile(response.user!.id);
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: response.user,
          profile: profile,
        );
        return true;
      }
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'Giriş yapılamadı. Lütfen bilgilerinizi kontrol edin.',
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString().replaceAll('AuthException: ', ''),
      );
      return false;
    }
  }

  Future<bool> signUpWithEmail(String email, String password, {String? fullName}) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final response = await SupabaseService.client.auth.signUp(
        email: email.trim(),
        password: password,
        data: fullName != null ? {'full_name': fullName} : null,
      );

      if (response.user != null) {
        final newProfile = UserProfile(
          id: response.user!.id,
          email: response.user!.email ?? email,
          fullName: fullName,
        );
        await SupabaseService.client.from('profiles').upsert(newProfile.toJson());

        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: response.user,
          profile: newProfile,
        );
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString().replaceAll('AuthException: ', ''),
      );
      return false;
    }
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'TwinFit Biyolojik İkiz Kokpitine girmek için kimliğinizi doğrulayın',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      return authenticated;
    } catch (e) {
      debugPrint('Biometric auth failed: $e');
      return false;
    }
  }

  Future<void> updateProfile(UserProfile profile) async {
    try {
      await SupabaseService.client.from('profiles').upsert(profile.toJson());
      state = state.copyWith(profile: profile);
      await LocalStorageService.saveJson('twinfit_cached_profile', profile.toJson());
    } catch (e) {
      debugPrint('Error updating profile: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await SupabaseService.client.auth.signOut();
    } catch (_) {}
    await LocalStorageService.remove('twinfit_cached_profile');
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}
