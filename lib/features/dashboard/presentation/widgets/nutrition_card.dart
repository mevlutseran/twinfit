import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/twin_card.dart';

class NutritionCard extends StatelessWidget {
  final int caloriesConsumed;
  final int caloriesTarget;
  final double proteinG;
  final double proteinTargetG;
  final double carbG;
  final double carbTargetG;
  final double fatG;
  final double fatTargetG;
  final int waterMl;
  final int waterTargetMl;
  final VoidCallback onAddWater;

  const NutritionCard({
    super.key,
    required this.caloriesConsumed,
    required this.caloriesTarget,
    required this.proteinG,
    required this.proteinTargetG,
    required this.carbG,
    required this.carbTargetG,
    required this.fatG,
    required this.fatTargetG,
    required this.waterMl,
    required this.waterTargetMl,
    required this.onAddWater,
  });

  @override
  Widget build(BuildContext context) {
    return TwinCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.local_fire_department, color: AppColors.energyOrange, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Biyolojik Yakıt & Makrolar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
                ],
              ),
              Text(
                '$caloriesConsumed / $caloriesTarget kcal',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.energyOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Kalori Barı
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (caloriesConsumed / caloriesTarget).clamp(0.0, 1.0),
              backgroundColor: AppColors.darkSurfaceElevated,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.energyOrange),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 16),

          // 3 Makro Barı (Protein, Karb, Yağ)
          Row(
            children: [
              Expanded(
                child: _buildMacroItem(
                  label: 'Protein',
                  current: proteinG,
                  target: proteinTargetG,
                  color: AppColors.primary,
                  unit: 'g',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMacroItem(
                  label: 'Karb',
                  current: carbG,
                  target: carbTargetG,
                  color: AppColors.secondary,
                  unit: 'g',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMacroItem(
                  label: 'Yağ',
                  current: fatG,
                  target: fatTargetG,
                  color: AppColors.hypertrophyGold,
                  unit: 'g',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Su Takibi
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.darkSurfaceElevated,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.water_drop, color: AppColors.recoveryBlue, size: 20),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hidrasyon Seviyesi',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimaryDark),
                        ),
                        Text(
                          '$waterMl / $waterTargetMl ml',
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryDark),
                        ),
                      ],
                    ),
                  ],
                ),
                InkWell(
                  onTap: onAddWater,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.recoveryBlue.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.recoveryBlue.withValues(alpha: 0.3)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, color: AppColors.recoveryBlue, size: 14),
                        SizedBox(width: 4),
                        Text(
                          '+250 ml',
                          style: TextStyle(color: AppColors.recoveryBlue, fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroItem({
    required String label,
    required double current,
    required double target,
    required Color color,
    required String unit,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.darkSurfaceElevated,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondaryDark)),
          const SizedBox(height: 4),
          Text(
            '${current.round()}/$target$unit',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: color),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: (current / target).clamp(0.0, 1.0),
              backgroundColor: Colors.black26,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 3,
            ),
          ),
        ],
      ),
    );
  }
}
