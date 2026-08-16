import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/twin_card.dart';
import '../../../../core/widgets/twin_badge.dart';
import '../../providers/dashboard_provider.dart';

class DigitalTwinCard extends StatelessWidget {
  final int cnsFatigueIndex;
  final List<MuscleRecoveryStatus> muscleRecoveryList;

  const DigitalTwinCard({
    super.key,
    required this.cnsFatigueIndex,
    required this.muscleRecoveryList,
  });

  @override
  Widget build(BuildContext context) {
    return TwinCard(
      hasGlow: true,
      glowColor: AppColors.secondary,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.accessibility_new, color: AppColors.secondary, size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Biyolojik İkiz Durumu',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimaryDark,
                        ),
                      ),
                      Text(
                        'Gerçek Zamanlı Toparlanma & CNS',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondaryDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              TwinBadge.ai(label: 'CANLI İKİZ'),
            ],
          ),
          const SizedBox(height: 20),

          // CNS Yorgunluk Barı
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.darkSurfaceElevated,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.bolt, color: AppColors.energyOrange, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'CNS (Merkezi Sinir Sistemi) Yorgunluğu',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimaryDark),
                        ),
                      ],
                    ),
                    Text(
                      '%$cnsFatigueIndex (Düşük - Hazır)',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: cnsFatigueIndex / 100,
                    backgroundColor: Colors.black26,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Kas Grubu Toparlanma Listesi
          const Text(
            'Bölgesel Kas Toparlanma Seviyeleri',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondaryDark),
          ),
          const SizedBox(height: 10),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: muscleRecoveryList.map((m) {
              final isReady = m.recoveryPercentage >= 85;
              final color = isReady ? AppColors.primary : AppColors.energyOrange;

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.darkSurfaceElevated,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: color.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                        boxShadow: [
                          BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 4),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      m.muscleName,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimaryDark),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '%${m.recoveryPercentage.round()}',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: color),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
