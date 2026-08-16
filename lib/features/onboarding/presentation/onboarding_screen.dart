import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/twin_button.dart';
import '../../../core/widgets/twin_card.dart';
import '../../../core/widgets/twin_badge.dart';
import '../providers/onboarding_provider.dart';
import '../../dashboard/presentation/dashboard_screen.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    final state = ref.read(onboardingProvider);
    if (state.currentStep < 3) {
      ref.read(onboardingProvider.notifier).setStep(state.currentStep + 1);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _prevPage() {
    final state = ref.read(onboardingProvider);
    if (state.currentStep > 0) {
      ref.read(onboardingProvider.notifier).setStep(state.currentStep - 1);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        leading: state.currentStep > 0 && !state.isSynthesizing
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                onPressed: _prevPage,
              )
            : null,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TwinBadge.ai(label: 'COLD START PROTOKOLÜ'),
            const SizedBox(width: 8),
            Text(
              'Adım ${state.currentStep + 1}/4',
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondaryDark),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Linear Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (state.currentStep + 1) / 4,
                  backgroundColor: AppColors.darkSurfaceElevated,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 4,
                ),
              ),
            ),

            // Wizard Pages
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStep1Metrics(state),
                  _buildStep2Biomechanics(state),
                  _buildStep3Goals(state),
                  _buildStep4Synthesis(state),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- ADIM 1: FİZİKSEL METRİKLER ---
  Widget _buildStep1Metrics(OnboardingState state) {
    final notifier = ref.read(onboardingProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fiziksel Parametreler',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimaryDark),
          ),
          const SizedBox(height: 6),
          const Text(
            'Biyolojik ikizinizi modellemek için temel vücut metriklerinizi girin.',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondaryDark),
          ),
          const SizedBox(height: 24),

          // Cinsiyet Seçimi
          const Text('Biyolojik Cinsiyet', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimaryDark)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildSelectCard(
                  title: 'Erkek',
                  icon: Icons.male,
                  isSelected: state.gender == 'male',
                  onTap: () => notifier.setGender('male'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSelectCard(
                  title: 'Kadın',
                  icon: Icons.female,
                  isSelected: state.gender == 'female',
                  onTap: () => notifier.setGender('female'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Yaş Slider
          _buildSliderSection(
            title: 'Yaş',
            valueText: '${state.age} yaş',
            value: state.age.toDouble(),
            min: 14,
            max: 80,
            onChanged: (v) => notifier.setAge(v.round()),
          ),
          const SizedBox(height: 16),

          // Boy Slider
          _buildSliderSection(
            title: 'Boy',
            valueText: '${state.heightCm.round()} cm',
            value: state.heightCm,
            min: 140,
            max: 220,
            onChanged: (v) => notifier.setHeight(v),
          ),
          const SizedBox(height: 16),

          // Kilo Slider
          _buildSliderSection(
            title: 'Vücut Ağırlığı',
            valueText: '${state.weightKg.toStringAsFixed(1)} kg',
            value: state.weightKg,
            min: 40,
            max: 160,
            onChanged: (v) => notifier.setWeight(v),
          ),
          const SizedBox(height: 16),

          // Yağ Oranı
          _buildSliderSection(
            title: 'Tahmini Yağ Oranı',
            valueText: '%${state.bodyFatPct.round()}',
            value: state.bodyFatPct,
            min: 5,
            max: 45,
            onChanged: (v) => notifier.setBodyFat(v),
          ),
          const SizedBox(height: 28),

          TwinButton(
            text: 'Biyomekanik Analize Geç',
            onPressed: _nextPage,
            trailingIcon: Icons.arrow_forward,
          ),
        ],
      ),
    );
  }

  // --- ADIM 2: BİYOMEKANİK & MORFOLOJİ ---
  Widget _buildStep2Biomechanics(OnboardingState state) {
    final notifier = ref.read(onboardingProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Morfoloji & Biyomekanik',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimaryDark),
          ),
          const SizedBox(height: 6),
          const Text(
            'Uzuv boyları ve eklem açıları, size özel en yüksek SFR\'lı hareketleri belirler.',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondaryDark),
          ),
          const SizedBox(height: 24),

          // Torso / Femur Oranı
          const Text('Femur / Torso Oranı (Uyluk Kemiği Boyu)', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimaryDark)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildSelectCard(
                  title: 'Kısa Femur',
                  subtitle: 'Squat Dostu',
                  isSelected: state.torsoFemurRatio == 'short_femur',
                  onTap: () => notifier.setTorsoFemurRatio('short_femur'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSelectCard(
                  title: 'Ortalama',
                  subtitle: 'Dengeli',
                  isSelected: state.torsoFemurRatio == 'average',
                  onTap: () => notifier.setTorsoFemurRatio('average'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSelectCard(
                  title: 'Uzun Femur',
                  subtitle: 'Hinge Baskın',
                  isSelected: state.torsoFemurRatio == 'long_femur',
                  onTap: () => notifier.setTorsoFemurRatio('long_femur'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Kol Açıklığı
          const Text('Kol Boyu Orantısı', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimaryDark)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildSelectCard(
                  title: 'Kısa Kollar',
                  subtitle: 'Pres Avantajı',
                  isSelected: state.armLengthType == 'short',
                  onTap: () => notifier.setArmLengthType('short'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSelectCard(
                  title: 'Orantılı',
                  subtitle: 'Standart',
                  isSelected: state.armLengthType == 'average',
                  onTap: () => notifier.setArmLengthType('average'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSelectCard(
                  title: 'Uzun Kollar',
                  subtitle: 'Çekiş Avantajı',
                  isSelected: state.armLengthType == 'long',
                  onTap: () => notifier.setArmLengthType('long'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Eklem Hassasiyetleri & Sakatlık Geçmişi
          const Text('Eklem Hassasiyeti / Geçmiş Sakatlıklar (Varsa Seçin)', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimaryDark)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildJointChip('Omuz (Shoulder)', 'shoulder', state.jointSensitivities, notifier),
              _buildJointChip('Bel (Lower Back)', 'lower_back', state.jointSensitivities, notifier),
              _buildJointChip('Diz (Knee)', 'knee', state.jointSensitivities, notifier),
              _buildJointChip('Dirsek (Elbow)', 'elbow', state.jointSensitivities, notifier),
              _buildJointChip('Bilek (Wrist)', 'wrist', state.jointSensitivities, notifier),
            ],
          ),
          const SizedBox(height: 32),

          TwinButton(
            text: 'Hedef ve Kapasiteye Geç',
            onPressed: _nextPage,
            trailingIcon: Icons.arrow_forward,
          ),
        ],
      ),
    );
  }

  // --- ADIM 3: HEDEF VE KAPASİTE ---
  Widget _buildStep3Goals(OnboardingState state) {
    final notifier = ref.read(onboardingProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hedef & Frekans',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimaryDark),
          ),
          const SizedBox(height: 6),
          const Text(
            'Sistem, seçtiğiniz amaca göre set/tekrar ve RPE optimizasyonu yapacaktır.',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondaryDark),
          ),
          const SizedBox(height: 24),

          // Hedef Seçimi
          const Text('Öncelikli Fitness Hedefi', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimaryDark)),
          const SizedBox(height: 10),
          _buildSelectTile(
            title: 'Maksimum Hipertrofi (Kas Kazanımı)',
            subtitle: 'Elit SFR hareketleri ile minimum yorgunluk, maksimum kas büyümesi',
            icon: Icons.fitness_center,
            isSelected: state.fitnessGoal == 'hypertrophy',
            onTap: () => notifier.setFitnessGoal('hypertrophy'),
          ),
          const SizedBox(height: 10),
          _buildSelectTile(
            title: 'Saf Güç & Nöral Adaptasyon',
            subtitle: 'Mekanik gerilim ve 1RM artışına odaklı periodizasyon',
            icon: Icons.bolt,
            isSelected: state.fitnessGoal == 'strength',
            onTap: () => notifier.setFitnessGoal('strength'),
          ),
          const SizedBox(height: 10),
          _buildSelectTile(
            title: 'Vücut Rekompozisyonu (Yağ Yakımı & Sıkılaşma)',
            subtitle: 'Kalori açığında kas kütlesini koruyup metabolik verimi artırma',
            icon: Icons.track_changes,
            isSelected: state.fitnessGoal == 'recomp',
            onTap: () => notifier.setFitnessGoal('recomp'),
          ),
          const SizedBox(height: 24),

          // Haftalık Gün Sayısı
          const Text('Haftalık Antrenman Frekansı', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimaryDark)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [3, 4, 5, 6].map((days) {
              final isSelected = state.daysPerWeek == days;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: TwinCard(
                    onTap: () => notifier.setDaysPerWeek(days),
                    backgroundColor: isSelected ? AppColors.primary.withValues(alpha: 0.15) : AppColors.darkSurface,
                    borderColor: isSelected ? AppColors.primary : AppColors.darkBorder,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Center(
                      child: Text(
                        '$days Gün',
                        style: TextStyle(
                          color: isSelected ? AppColors.primary : AppColors.textPrimaryDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),

          TwinButton(
            text: 'Biyolojik İkizi Sentezle',
            onPressed: () {
              _nextPage();
              notifier.synthesizeDigitalTwin();
            },
            trailingIcon: Icons.auto_awesome,
          ),
        ],
      ),
    );
  }

  // --- ADIM 4: SENTEZ & COLD START GENERATOR ---
  Widget _buildStep4Synthesis(OnboardingState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Glowing Core
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.aiBadgeGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondary.withValues(alpha: 0.5),
                    blurRadius: 40,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: const Center(
                child: Icon(Icons.hub, size: 54, color: Colors.white),
              ),
            ),
            const SizedBox(height: 32),

            Text(
              state.isSynthesizing ? 'Biyolojik İkiz İndeksleniyor' : 'Altın Rota Hazır!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimaryDark,
              ),
            ),
            const SizedBox(height: 12),

            Text(
              state.synthesisMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 40),

            if (state.isSynthesizing) ...[
              const SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ] else ...[
              TwinButton(
                text: 'Kokpite Giriş Yap',
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const DashboardScreen()),
                    (route) => false,
                  );
                },
                trailingIcon: Icons.arrow_forward,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSelectCard({
    required String title,
    String? subtitle,
    IconData? icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return TwinCard(
      onTap: onTap,
      backgroundColor: isSelected ? AppColors.primary.withValues(alpha: 0.12) : AppColors.darkSurface,
      borderColor: isSelected ? AppColors.primary : AppColors.darkBorder,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      child: Column(
        children: [
          if (icon != null) ...[
            Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondaryDark, size: 24),
            const SizedBox(height: 6),
          ],
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? AppColors.primary : AppColors.textPrimaryDark,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSelectTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return TwinCard(
      onTap: onTap,
      backgroundColor: isSelected ? AppColors.primary.withValues(alpha: 0.12) : AppColors.darkSurface,
      borderColor: isSelected ? AppColors.primary : AppColors.darkBorder,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withValues(alpha: 0.2) : AppColors.darkSurfaceElevated,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondaryDark, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? AppColors.primary : AppColors.textPrimaryDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderSection({
    required String title,
    required String valueText,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return TwinCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimaryDark, fontSize: 14)),
              Text(valueText, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 6),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.darkSurfaceElevated,
              thumbColor: AppColors.primary,
              trackHeight: 4,
            ),
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJointChip(String label, String key, List<String> selected, OnboardingNotifier notifier) {
    final isSelected = selected.contains(key);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => notifier.toggleJointSensitivity(key),
      backgroundColor: AppColors.darkSurface,
      selectedColor: AppColors.heartRed.withValues(alpha: 0.2),
      checkmarkColor: AppColors.heartRed,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.heartRed : AppColors.textSecondaryDark,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        fontSize: 12,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.heartRed.withValues(alpha: 0.5) : AppColors.darkBorder,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
