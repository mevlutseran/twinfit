import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/twin_button.dart';
import '../../../core/widgets/twin_input_field.dart';
import '../providers/auth_provider.dart';
import '../../onboarding/presentation/onboarding_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authProvider.notifier).signUpWithEmail(
          _emailController.text,
          _passwordController.text,
          fullName: _nameController.text.trim(),
        );

    if (success && mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Biyolojik İkizini Yarat',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimaryDark,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sıfır deneme-yanılma ile bilimin öngördüğü en verimli rotaya adım atın.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondaryDark,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 32),

                  if (authState.errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        authState.errorMessage!,
                        style: const TextStyle(color: AppColors.error, fontSize: 13),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  TwinInputField(
                    label: 'Ad Soyad',
                    hintText: 'Mevlüt Şeran',
                    controller: _nameController,
                    prefixIcon: Icons.person_outline,
                    validator: (val) => val == null || val.trim().isEmpty ? 'Adınızı giriniz' : null,
                  ),
                  const SizedBox(height: 16),

                  TwinInputField(
                    label: 'E-posta Adresi',
                    hintText: 'ornek@twinfit.com',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.mail_outline,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'E-posta giriniz';
                      if (!val.contains('@')) return 'Geçerli e-posta giriniz';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TwinInputField(
                    label: 'Şifre Belirleyin',
                    hintText: 'En az 6 karakter',
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
                    validator: (val) => val == null || val.length < 6 ? 'En az 6 karakter giriniz' : null,
                  ),
                  const SizedBox(height: 28),

                  TwinButton(
                    text: 'Hesap Oluştur ve Başla',
                    isLoading: authState.status == AuthStatus.loading,
                    onPressed: _handleRegister,
                    trailingIcon: Icons.arrow_forward,
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Zaten hesabınız var mı?', style: TextStyle(color: AppColors.textSecondaryDark)),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Giriş Yap',
                          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
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
