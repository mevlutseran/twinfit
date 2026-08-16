import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/twin_card.dart';
import '../../../core/widgets/twin_badge.dart';
import '../models/exercise_model.dart';
import '../providers/exercise_catalog_provider.dart';

class ExerciseDetailScreen extends ConsumerWidget {
  final ExerciseModel exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final substitutes = ref.read(exerciseCatalogProvider.notifier).findSubstitutes(exercise);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: Text(
          exercise.turkishName.isNotEmpty ? exercise.turkishName : exercise.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
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
                        TwinBadge.sfr(exercise.sfrRating),
                        TwinBadge.cns(exercise.cnsLoadScore),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      exercise.turkishName,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textPrimaryDark),
                    ),
                    Text(
                      exercise.name,
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondaryDark, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Hedef Kas Grubu: ${exercise.targetMuscle} • Ekipman: ${exercise.equipment}',
                      style: const TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Biyomekanik Analiz Notu
              if (exercise.biomechanicalNotes != null) ...[
                const Text('Biyomekanik Verimlilik Analizi', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimaryDark)),
                const SizedBox(height: 8),
                TwinCard(
                  backgroundColor: AppColors.darkSurfaceElevated,
                  child: Text(
                    exercise.biomechanicalNotes!,
                    style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 13, height: 1.4),
                  ),
                ),
                const SizedBox(height: 18),
              ],

              // Eklem Stres İndeksi
              const Text('Eklem Stres Katsayıları (0 - 10)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimaryDark)),
              const SizedBox(height: 8),
              TwinCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildJointBar('Omuz (Shoulder)', exercise.jointStressIndex['shoulder'] as num? ?? 0),
                    const SizedBox(height: 10),
                    _buildJointBar('Bel (Lumbar Spine)', exercise.jointStressIndex['lower_back'] as num? ?? 0),
                    const SizedBox(height: 10),
                    _buildJointBar('Diz (Knee)', exercise.jointStressIndex['knee'] as num? ?? 0),
                    const SizedBox(height: 10),
                    _buildJointBar('Dirsek (Elbow)', exercise.jointStressIndex['elbow'] as num? ?? 0),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // İcra Püf Noktaları
              const Text('Kusursuz İcra Cues', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimaryDark)),
              const SizedBox(height: 8),
              TwinCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: exercise.executionCues.isNotEmpty
                      ? exercise.executionCues
                          .map((cue) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.check_circle, color: AppColors.primary, size: 16),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(cue, style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 13)),
                                    ),
                                  ],
                                ),
                              ))
                          .toList()
                      : [
                          const Text(
                            'Negatif fazı yavaşlatarak kas gerilimini maksimize edin.',
                            style: TextStyle(color: AppColors.textPrimaryDark, fontSize: 13),
                          ),
                        ],
                ),
              ),
              const SizedBox(height: 20),

              // Akıllı Alternatif Hareketler
              if (substitutes.isNotEmpty) ...[
                const Text('Eşdeğer SFR Alternatif Hareketler', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimaryDark)),
                const SizedBox(height: 8),
                ...substitutes.map((sub) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: TwinCard(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => ExerciseDetailScreen(exercise: sub)),
                          );
                        },
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            const Icon(Icons.swap_horiz, color: AppColors.secondary, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                sub.turkishName,
                                style: const TextStyle(color: AppColors.textPrimaryDark, fontWeight: FontWeight.w700, fontSize: 13),
                              ),
                            ),
                            TwinBadge.sfr(sub.sfrRating),
                          ],
                        ),
                      ),
                    )),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJointBar(String label, num score) {
    final double val = (score.toDouble() / 10.0).clamp(0.0, 1.0);
    Color color = AppColors.primary;
    if (score >= 6) {
      color = AppColors.heartRed;
    } else if (score >= 3) {
      color = AppColors.energyOrange;
    }

    return Row(
      children: [
        SizedBox(
          width: 130,
          child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryDark)),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: val,
              backgroundColor: AppColors.darkSurfaceElevated,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text('$score/10', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }
}
