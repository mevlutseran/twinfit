import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/twin_button.dart';
import '../../../core/widgets/twin_input_field.dart';
import '../providers/auth_provider.dart';
import 'register_screen.dart';
import '../../onboarding/presentation/onboarding_screen.dart';
import '../../dashboard/presentation/dashboard_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authProvider.notifier).signInWithEmail(
          _emailController.text,
          _passwordController.text,
        );

    if (success && mounted) {
      final profile = ref.read(authProvider).profile;
      if (profile == null || profile.fitnessGoal.isEmpty) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      }
    }
  }

  Future<void> _handleBiometricAuth() async {
    final success = await ref.read(authProvider.notifier).authenticateWithBiometrics();
    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo & Header
                  Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.primaryGlow,
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.polyline,
                        size: 34,
                        color: Color(0xFF07090C),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'TwinFit\'e Giriş Yap',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimaryDark,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),

                  const Text(
                    'Biyolojik ikizinizi ve otonom altın rotanızı senkronize edin.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondaryDark,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Error Message
                  if (authState.errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: AppColors.error, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              authState.errorMessage!,
                              style: const TextStyle(color: AppColors.error, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Email
                  TwinInputField(
                    label: 'E-posta Adresi',
                    hintText: 'ornek@twinfit.com',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.mail_outline,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'E-posta adresi giriniz';
                      if (!val.contains('@')) return 'Geçerli bir e-posta adresi giriniz';
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),

                  // Password
                  TwinInputField(
                    label: 'Şifre',
                    hintText: '••••••••',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.textSecondaryDark,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                    validator: (val) {
                      if (val == null || val.length < 6) return 'Şifre en az 6 karakter olmalıdır';
                      return null;
                    },
                  ),
                  const SizedBox(height: 28),

                  // Submit Button
                  TwinButton(
                    text: 'Giriş Yap',
                    isLoading: authState.status == AuthStatus.loading,
                    onPressed: _handleLogin,
                    trailingIcon: Icons.arrow_forward,
                  ),

                  // Biometrics option if available
                  if (authState.isBiometricAvailable) ...[
                    const SizedBox(height: 14),
                    TwinButton(
                      text: 'FaceID / Parmak İzi ile Giriş',
                      variant: TwinButtonVariant.secondary,
                      leadingIcon: Icons.fingerprint,
                      onPressed: _handleBiometricAuth,
                    ),
                  ],

                  const SizedBox(height: 14),
                  TwinButton(
                    text: 'Hızlı Test Modu ile Keşfet (Demo)',
                    variant: TwinButtonVariant.secondary,
                    leadingIcon: Icons.bolt,
                    onPressed: () async {
                      final success = await ref.read(authProvider.notifier).signInAsDemoUser();
                      if (success && mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const DashboardScreen()),
                          (route) => false,
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 28),

                  // Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Hesabınız yok mu?',
                        style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 14),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const RegisterScreen()),
                          );
                        },
                        child: const Text(
                          'Biyolojik İkizini Başlat',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
