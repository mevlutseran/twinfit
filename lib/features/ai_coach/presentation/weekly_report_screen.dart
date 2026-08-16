import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/twin_card.dart';
import '../../../core/widgets/twin_badge.dart';
import '../providers/ai_coach_provider.dart';

class WeeklyReportScreen extends ConsumerWidget {
  const WeeklyReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(aiCoachProvider);
    final report = state.latestReport;

    if (report == null) {
      return Scaffold(
        backgroundColor: AppColors.darkBackground,
        appBar: AppBar(title: const Text('Haftalık İkiz Raporu')),
        body: const Center(child: Text('Henüz haftalık rapor oluşturulmadı.', style: TextStyle(color: AppColors.textSecondaryDark))),
      );
    }

    final hypertrophyScore = report['hypertrophy_score'] ?? 88.0;
    final recoveryScore = report['recovery_efficiency_score'] ?? 92.0;
    final volumeProg = report['volume_progression_pct'] ?? 5.4;
    final summary = report['ai_summary'] ?? '';
    final recommendations = report['actionable_recommendations'] as List<dynamic>? ?? [];

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Haftalık Sentetik İkiz Raporu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Score Card
              TwinCard(
                hasGlow: true,
                glowColor: AppColors.secondary,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TwinBadge.ai(label: 'SENTETİK İKİZ SENTEZİ'),
                        const Text('Son 7 Gün', style: TextStyle(fontSize: 12, color: AppColors.textSecondaryDark, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 18),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildScoreRing('Hipertrofi Skoru', '$hypertrophyScore', AppColors.primary),
                        _buildScoreRing('Toparlanma Verimi', '$recoveryScore', AppColors.secondary),
                        _buildScoreRing('Hacim Artışı', '+%$volumeProg', AppColors.hypertrophyGold),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // AI Summary
              const Text('Yapay Zeka Biyolojik Özeti', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimaryDark)),
              const SizedBox(height: 8),
              TwinCard(
                backgroundColor: AppColors.darkSurfaceElevated,
                child: Text(
                  summary,
                  style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 13, height: 1.4),
                ),
              ),
              const SizedBox(height: 20),

              // Actionable Items
              const Text('Gelecek Hafta İçin Aksiyon Planı', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimaryDark)),
              const SizedBox(height: 8),
              ...recommendations.map((rec) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TwinCard(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.auto_awesome, color: AppColors.secondary, size: 16),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              rec.toString(),
                              style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 13, height: 1.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreRing(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.12),
            border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: color),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondaryDark),
        ),
      ],
    );
  }
}
