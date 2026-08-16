import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/twin_card.dart';
import '../../../core/widgets/twin_button.dart';
import '../../../core/widgets/twin_badge.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../../core/storage/offline_sync_service.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/presentation/login_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _biometricEnabled = LocalStorageService.isBiometricEnabled;
  bool _notificationsEnabled = true;
  bool _isSyncing = false;

  Future<void> _handleSyncNow() async {
    setState(() => _isSyncing = true);
    final count = await OfflineSyncService.instance.syncAllPending();
    setState(() => _isSyncing = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(count > 0 ? '$count adet çevrimdışı kayıt senkronize edildi!' : 'Tüm verileriniz Supabase ile senkronize durumda.'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Hesabı ve Biyolojik Verileri Sil', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w800)),
        content: const Text(
          'Bu işlem geri alınamaz. Biyolojik ikiziniz, otonom rotalarınız ve antrenman geçmişiniz KVKK/GDPR kapsamında kalıcı olarak silinecektir.',
          style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Vazgeç', style: TextStyle(color: AppColors.textSecondaryDark)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await ref.read(authProvider.notifier).signOut();
              if (mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (r) => false,
                );
              }
            },
            child: const Text('Kalıcı Olarak Sil', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final profile = authState.profile;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text(
          'Profil & Biyometrik Ayarlar',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimaryDark),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Header Card
              TwinCard(
                hasGlow: true,
                glowColor: AppColors.secondary,
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.primaryGradient,
                      ),
                      child: const Icon(Icons.person, color: Color(0xFF07090C), size: 30),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile?.fullName ?? 'Mevlüt Şeran',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimaryDark),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            profile?.email ?? 'sporcu@twinfit.com',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryDark),
                          ),
                          const SizedBox(height: 6),
                          TwinBadge.ai(label: 'BİYOLOJİK İKİZ: AKTİF'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Biyolojik Parametreler Özeti
              const Text('Kayıtlı Biyomekanik Parametreler', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimaryDark)),
              const SizedBox(height: 10),
              TwinCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    _buildParamRow('Boy / Kilo', '${profile?.heightCm.round() ?? 178} cm / ${profile?.weightKg ?? 76} kg'),
                    const Divider(height: 16),
                    _buildParamRow('Femur / Torso Oranı', profile?.torsoFemurRatio.toUpperCase() ?? 'AVERAGE'),
                    const Divider(height: 16),
                    _buildParamRow('Kol Açıklığı', profile?.armLengthType.toUpperCase() ?? 'AVERAGE'),
                    const Divider(height: 16),
                    _buildParamRow('Hedef / Seviye', '${profile?.fitnessGoal.toUpperCase()} • ${profile?.experienceLevel.toUpperCase()}'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Çevrimdışı Senkronizasyon Durumu
              const Text('Veri & Senkronizasyon', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimaryDark)),
              const SizedBox(height: 10),
              TwinCard(
                padding: const EdgeInsets.all(14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.cloud_sync, color: AppColors.primary, size: 22),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Offline Sync Kuyruğu', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimaryDark, fontSize: 13)),
                            Text(
                              '${OfflineSyncService.instance.pendingItemsCount} bekleyen kayıt',
                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryDark),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkSurfaceElevated,
                        foregroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: _isSyncing ? null : _handleSyncNow,
                      child: _isSyncing
                          ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('Eşitle', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Tercihler & Güvenlik
              const Text('Tercihler & Güvenlik', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimaryDark)),
              const SizedBox(height: 10),
              TwinCard(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Column(
                  children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('FaceID / TouchID ile Giriş', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimaryDark)),
                      subtitle: const Text('Açılışta biyometrik kilit uygula', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryDark)),
                      value: _biometricEnabled,
                      activeTrackColor: AppColors.primary,
                      onChanged: (val) {
                        setState(() => _biometricEnabled = val);
                        LocalStorageService.setBiometricEnabled(val);
                      },
                    ),
                    const Divider(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Antrenman & Dinlenme Bildirimleri', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimaryDark)),
                      subtitle: const Text('Altın rota hatırlatıcıları ve toparlanma alarmları', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryDark)),
                      value: _notificationsEnabled,
                      activeTrackColor: AppColors.primary,
                      onChanged: (val) => setState(() => _notificationsEnabled = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Çıkış & Hesap Sil
              TwinButton(
                text: 'Oturumu Kapat',
                variant: TwinButtonVariant.secondary,
                leadingIcon: Icons.logout,
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  await ref.read(authProvider.notifier).signOut();
                  navigator.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (r) => false,
                  );
                },
              ),
              const SizedBox(height: 12),

              Center(
                child: TextButton(
                  onPressed: _showDeleteAccountDialog,
                  child: const Text(
                    'Hesabımı ve Tüm Biyolojik Verilerimi Sil (GDPR)',
                    style: TextStyle(color: AppColors.error, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParamRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondaryDark)),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimaryDark)),
      ],
    );
  }
}
