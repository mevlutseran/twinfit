import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/twin_card.dart';
import '../../../core/widgets/twin_badge.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text(
          'Gelişim & Analitik',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimaryDark),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total Volume Progression Chart Card
              TwinCard(
                hasGlow: true,
                glowColor: AppColors.primary,
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Haftalık Kümülatif Hacim (kg)',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimaryDark),
                            ),
                            Text(
                              '+%5.4 Progressive Overload',
                              style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        TwinBadge.sfr('elite'),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // FL Chart Line Chart
                    SizedBox(
                      height: 180,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            getDrawingHorizontalLine: (_) => const FlLine(color: AppColors.darkBorder, strokeWidth: 1),
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (val, _) {
                                  const days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
                                  final idx = val.toInt();
                                  if (idx >= 0 && idx < days.length) {
                                    return Text(days[idx], style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 10));
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          minX: 0,
                          maxX: 6,
                          minY: 10000,
                          maxY: 24000,
                          lineBarsData: [
                            LineChartBarData(
                              spots: const [
                                FlSpot(0, 12500),
                                FlSpot(1, 15200),
                                FlSpot(2, 14800),
                                FlSpot(3, 17800),
                                FlSpot(4, 19400),
                                FlSpot(5, 21800),
                                FlSpot(6, 23200),
                              ],
                              isCurved: true,
                              color: AppColors.primary,
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: const FlDotData(show: true),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primary.withValues(alpha: 0.25),
                                    AppColors.primary.withValues(alpha: 0.0),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 1RM Strength Progressions
              const Text('Tahmini 1RM Güç İlerlemesi', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimaryDark)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _build1RmCard('Incline DB Press', '42.5 kg', '+2.5 kg', AppColors.primary),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _build1RmCard('T-Bar Row', '85.0 kg', '+5.0 kg', AppColors.secondary),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _build1RmCard('Leg Curl', '65.0 kg', '+2.5 kg', AppColors.hypertrophyGold),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Achievement Badges
              const Text('Kazanılan Başarı Rozetleri', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimaryDark)),
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 2.2,
                children: [
                  _buildAchievement('Sıfır Deneme-Yanılma', 'İlk Altın Rota Tamamlandı', Icons.verified, AppColors.primary),
                  _buildAchievement('Hipertrofi Ustası', '100k kg Kümülatif Hacim', Icons.military_tech, AppColors.hypertrophyGold),
                  _buildAchievement('Biyolojik Disiplin', '7 Gün Kesintisiz Beslenme', Icons.local_fire_department, AppColors.energyOrange),
                  _buildAchievement('CNS Koruyucu', '0 Aşırı Yorgunluk Riski', Icons.shield, AppColors.secondary),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _build1RmCard(String exercise, String weight, String change, Color color) {
    return TwinCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(exercise, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondaryDark)),
          const SizedBox(height: 6),
          Text(weight, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textPrimaryDark)),
          const SizedBox(height: 2),
          Text(change, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }

  Widget _buildAchievement(String title, String desc, IconData icon, Color color) {
    return TwinCard(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimaryDark)),
                Text(desc, style: const TextStyle(fontSize: 10, color: AppColors.textSecondaryDark), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
