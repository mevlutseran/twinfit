import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/twin_card.dart';
import '../../../../core/widgets/twin_badge.dart';
import '../../../../core/widgets/twin_button.dart';

class GoldenPathHeroCard extends StatelessWidget {
  final Map<String, dynamic> routine;
  final List<Map<String, dynamic>> exercises;
  final VoidCallback onStartWorkout;

  const GoldenPathHeroCard({
    super.key,
    required this.routine,
    required this.exercises,
    required this.onStartWorkout,
  });

  @override
  Widget build(BuildContext context) {
    final title = routine['routine_name'] ?? 'Altın Rota Programı';
    final dayName = routine['day_name'] ?? 'Günün Antrenmanı';
    final cnsImpact = routine['total_cns_impact'] ?? 5;
    final durationMin = routine['estimated_duration_min'] ?? 55;

    return TwinCard(
      hasGlow: true,
      glowColor: AppColors.primary,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TwinBadge.sfr('elite'),
              TwinBadge.cns(cnsImpact),
            ],
          ),
          const SizedBox(height: 14),

          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimaryDark,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 4),

          Text(
            dayName,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          // Duration & Exercise Count Badge Row
          Row(
            children: [
              const Icon(Icons.timer_outlined, size: 16, color: AppColors.textSecondaryDark),
              const SizedBox(width: 6),
              Text(
                '~$durationMin Dk',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryDark, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.fitness_center_outlined, size: 16, color: AppColors.textSecondaryDark),
              const SizedBox(width: 6),
              Text(
                '${exercises.isNotEmpty ? exercises.length : 5} Elit Hareket',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryDark, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Action Button
          TwinButton(
            text: 'Günün Altın Rotasına Başla',
            leadingIcon: Icons.play_arrow,
            onPressed: onStartWorkout,
          ),
        ],
      ),
    );
  }
}
