import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/twin_card.dart';
import '../../../core/widgets/twin_badge.dart';
import '../../../core/widgets/twin_button.dart';
import '../providers/workout_provider.dart';
import 'exercise_guide_modal.dart';

class WorkoutSessionScreen extends ConsumerStatefulWidget {
  const WorkoutSessionScreen({super.key});

  @override
  ConsumerState<WorkoutSessionScreen> createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends ConsumerState<WorkoutSessionScreen> {
  String _formatDuration(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  void _showExerciseGuide(WorkoutExerciseState exercise) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ExerciseGuideModal(
        exerciseName: exercise.name,
        targetMuscle: exercise.targetMuscle,
        cnsLoadScore: exercise.cnsLoadScore,
        sfrRating: exercise.sfrRating,
        executionCues: exercise.executionCues,
      ),
    );
  }

  void _showFinishConfirmation() {
    final workout = ref.read(workoutProvider);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Antrenmanı Tamamla',
          style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.textPrimaryDark),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bugünkü otonom altın rotayı başarıyla bitirdiniz.',
              style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TwinCard(
              backgroundColor: AppColors.darkSurfaceElevated,
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Süre:', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12)),
                      Text(_formatDuration(workout.durationSeconds), style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Toplam Hacim (Volume):', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12)),
                      Text('${workout.totalVolumeKg.round()} kg', style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.secondary)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Devam Et', style: TextStyle(color: AppColors.textSecondaryDark)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await ref.read(workoutProvider.notifier).finishWorkout();
              if (mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🎉 Antrenman ve set logları başarıyla kaydedildi!'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              }
            },
            child: const Text('Kaydet ve Bitir', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final workout = ref.watch(workoutProvider);

    if (!workout.isActive || workout.exercises.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.darkBackground,
        appBar: AppBar(title: const Text('Canlı Antrenman')),
        body: const Center(child: Text('Aktif antrenman bulunamadı.', style: TextStyle(color: AppColors.textSecondaryDark))),
      );
    }

    final currentExercise = workout.exercises[workout.currentExerciseIndex];

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showFinishConfirmation(),
        ),
        title: Column(
          children: [
            Text(
              workout.sessionTitle,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimaryDark),
            ),
            Text(
              _formatDuration(workout.durationSeconds),
              style: AppTypography.metricDisplay(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: AppColors.primary),
            onPressed: _showFinishConfirmation,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Exercise Selector Tabs
            SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: workout.exercises.length,
                itemBuilder: (context, idx) {
                  final ex = workout.exercises[idx];
                  final isSelected = workout.currentExerciseIndex == idx;
                  final isAllSetsDone = ex.sets.every((s) => s.isCompleted);

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: isSelected,
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isAllSetsDone) ...[
                            const Icon(Icons.check, size: 12, color: AppColors.primary),
                            const SizedBox(width: 4),
                          ],
                          Text(ex.name),
                        ],
                      ),
                      onSelected: (_) => ref.read(workoutProvider.notifier).setCurrentExercise(idx),
                      backgroundColor: AppColors.darkSurface,
                      selectedColor: AppColors.primary.withValues(alpha: 0.15),
                      checkmarkColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.primary : AppColors.textSecondaryDark,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 12,
                      ),
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : AppColors.darkBorder,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Active Rest Timer Bar if running
            if (workout.isRestTimerRunning) ...[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(color: AppColors.primaryGlow, blurRadius: 16, offset: Offset(0, 4)),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.timer, color: Color(0xFF07090C), size: 22),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Dinlenme Sayacı (Rest Timer)',
                              style: TextStyle(color: Color(0xFF07090C), fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '${workout.restTimerRemainingSeconds} saniye kaldı',
                              style: const TextStyle(color: Color(0xFF07090C), fontSize: 16, fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      ],
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF07090C).withValues(alpha: 0.15),
                        foregroundColor: const Color(0xFF07090C),
                      ),
                      onPressed: () => ref.read(workoutProvider.notifier).stopRestTimer(),
                      child: const Text('Geç', style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
              ),
            ],

            // Active Exercise Card Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TwinCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              TwinBadge.sfr(currentExercise.sfrRating),
                              const SizedBox(width: 8),
                              TwinBadge.cns(currentExercise.cnsLoadScore),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currentExercise.name,
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimaryDark),
                          ),
                          Text(
                            'Hedef: ${currentExercise.targetMuscle}',
                            style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.info_outline, color: AppColors.secondary),
                      onPressed: () => _showExerciseGuide(currentExercise),
                    ),
                  ],
                ),
              ),
            ),

            // Sets List View
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: currentExercise.sets.length,
                itemBuilder: (context, setIdx) {
                  final s = currentExercise.sets[setIdx];
                  final isDone = s.isCompleted;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isDone ? AppColors.primary.withValues(alpha: 0.08) : AppColors.darkSurface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDone ? AppColors.primary.withValues(alpha: 0.4) : AppColors.darkBorder,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Set Number Badge
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDone ? AppColors.primary : AppColors.darkSurfaceElevated,
                          ),
                          child: Center(
                            child: Text(
                              '${s.setNumber}',
                              style: TextStyle(
                                color: isDone ? Colors.black : AppColors.textPrimaryDark,
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Weight Input
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Kilo (kg)', style: TextStyle(fontSize: 10, color: AppColors.textSecondaryDark)),
                              const SizedBox(height: 2),
                              Text(
                                '${s.loggedWeightKg} kg',
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimaryDark),
                              ),
                            ],
                          ),
                        ),

                        // Reps Input
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Tekrar', style: TextStyle(fontSize: 10, color: AppColors.textSecondaryDark)),
                              const SizedBox(height: 2),
                              Text(
                                '${s.loggedReps} rep',
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimaryDark),
                              ),
                            ],
                          ),
                        ),

                        // Complete Action Button
                        IconButton(
                          icon: Icon(
                            isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                            color: isDone ? AppColors.primary : AppColors.textSecondaryDark,
                            size: 28,
                          ),
                          onPressed: () {
                            ref.read(workoutProvider.notifier).logSetCompleted(
                                  exerciseIndex: workout.currentExerciseIndex,
                                  setIndex: setIdx,
                                  weightKg: s.loggedWeightKg,
                                  reps: s.loggedReps,
                                  rpe: s.loggedRpe,
                                );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Volume Footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                color: AppColors.darkSurface,
                border: Border(top: BorderSide(color: AppColors.darkBorder)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Kümülatif Hacim', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryDark)),
                      Text(
                        '${workout.totalVolumeKg.round()} kg',
                        style: AppTypography.metricDisplay(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary),
                      ),
                    ],
                  ),
                  TwinButton(
                    text: 'Antrenmanı Bitir',
                    isFullWidth: false,
                    onPressed: _showFinishConfirmation,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
