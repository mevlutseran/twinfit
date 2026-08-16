import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/twin_badge.dart';
import '../../../core/widgets/twin_card.dart';

class ExerciseGuideModal extends StatelessWidget {
  final String exerciseName;
  final String targetMuscle;
  final int cnsLoadScore;
  final String sfrRating;
  final List<String> executionCues;
  final String? biomechanicalNotes;

  const ExerciseGuideModal({
    super.key,
    required this.exerciseName,
    required this.targetMuscle,
    required this.cnsLoadScore,
    required this.sfrRating,
    required this.executionCues,
    this.biomechanicalNotes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.darkBorderHighlight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Title & Badges
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exerciseName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimaryDark,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Hedef: $targetMuscle',
                      style: const TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              TwinBadge.sfr(sfrRating),
            ],
          ),
          const SizedBox(height: 20),

          // Aspect-Ratio Preserved Media / Anatomical Diagram Area
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.darkSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.darkBorder),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.1),
                          AppColors.secondary.withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withValues(alpha: 0.2),
                        ),
                        child: const Icon(Icons.fitness_center, color: AppColors.primary, size: 32),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Biyomekanik Form ve Açı Rehberi',
                        style: TextStyle(color: AppColors.textPrimaryDark, fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'CNS Yükü: $cnsLoadScore/10 • Dikey Video Oranı: 9:16',
                        style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Biyomekanik İpuçları (Execution Cues)
          const Text(
            'Kusursuz İcra Püf Noktaları',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimaryDark),
          ),
          const SizedBox(height: 10),

          if (executionCues.isNotEmpty) ...[
            ...executionCues.map((cue) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle, color: AppColors.primary, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          cue,
                          style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 13, height: 1.3),
                        ),
                      ),
                    ],
                  ),
                )),
          ] else ...[
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle, color: AppColors.primary, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Negatif fazı (bırakış) 3 saniye kontrollü yapın ve alt noktada kası gerdirin.',
                    style: TextStyle(color: AppColors.textPrimaryDark, fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),

          // Eklem Güvenlik Notu
          TwinCard(
            backgroundColor: AppColors.darkSurfaceElevated,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.shield_outlined, color: AppColors.secondary, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    biomechanicalNotes ?? 'Bu hareket omurga ve eklem stresini minimumda tutarak hipertrofiyi hedefler.',
                    style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 12, height: 1.3),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
