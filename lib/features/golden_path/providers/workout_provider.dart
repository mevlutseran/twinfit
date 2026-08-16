import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/supabase_service.dart';
import '../../../core/storage/offline_sync_service.dart';

class WorkoutSet {
  final int setNumber;
  final double targetWeightKg;
  final int targetRepsMin;
  final int targetRepsMax;
  final double targetRpe;
  double loggedWeightKg;
  int loggedReps;
  double loggedRpe;
  bool isCompleted;
  bool isWarmup;

  WorkoutSet({
    required this.setNumber,
    required this.targetWeightKg,
    required this.targetRepsMin,
    required this.targetRepsMax,
    this.targetRpe = 8.0,
    double? loggedWeightKg,
    int? loggedReps,
    double? loggedRpe,
    this.isCompleted = false,
    this.isWarmup = false,
  })  : loggedWeightKg = loggedWeightKg ?? targetWeightKg,
        loggedReps = loggedReps ?? targetRepsMin,
        loggedRpe = loggedRpe ?? targetRpe;
}

class WorkoutExerciseState {
  final String id;
  final String exerciseId;
  final String name;
  final String targetMuscle;
  final int cnsLoadScore;
  final String sfrRating;
  final List<String> executionCues;
  final int restSeconds;
  final List<WorkoutSet> sets;

  const WorkoutExerciseState({
    required this.id,
    required this.exerciseId,
    required this.name,
    required this.targetMuscle,
    required this.cnsLoadScore,
    required this.sfrRating,
    required this.executionCues,
    required this.restSeconds,
    required this.sets,
  });
}

class WorkoutState {
  final bool isActive;
  final String sessionTitle;
  final String? sessionId;
  final DateTime? startTime;
  final int durationSeconds;
  final int currentExerciseIndex;
  final List<WorkoutExerciseState> exercises;
  final bool isRestTimerRunning;
  final int restTimerRemainingSeconds;
  final int restTimerTotalSeconds;
  final double totalVolumeKg;

  const WorkoutState({
    this.isActive = false,
    this.sessionTitle = 'Altın Rota Antrenmanı',
    this.sessionId,
    this.startTime,
    this.durationSeconds = 0,
    this.currentExerciseIndex = 0,
    this.exercises = const [],
    this.isRestTimerRunning = false,
    this.restTimerRemainingSeconds = 0,
    this.restTimerTotalSeconds = 90,
    this.totalVolumeKg = 0,
  });

  WorkoutState copyWith({
    bool? isActive,
    String? sessionTitle,
    String? sessionId,
    DateTime? startTime,
    int? durationSeconds,
    int? currentExerciseIndex,
    List<WorkoutExerciseState>? exercises,
    bool? isRestTimerRunning,
    int? restTimerRemainingSeconds,
    int? restTimerTotalSeconds,
    double? totalVolumeKg,
  }) {
    return WorkoutState(
      isActive: isActive ?? this.isActive,
      sessionTitle: sessionTitle ?? this.sessionTitle,
      sessionId: sessionId ?? this.sessionId,
      startTime: startTime ?? this.startTime,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      currentExerciseIndex: currentExerciseIndex ?? this.currentExerciseIndex,
      exercises: exercises ?? this.exercises,
      isRestTimerRunning: isRestTimerRunning ?? this.isRestTimerRunning,
      restTimerRemainingSeconds: restTimerRemainingSeconds ?? this.restTimerRemainingSeconds,
      restTimerTotalSeconds: restTimerTotalSeconds ?? this.restTimerTotalSeconds,
      totalVolumeKg: totalVolumeKg ?? this.totalVolumeKg,
    );
  }
}

final workoutProvider = StateNotifierProvider<WorkoutNotifier, WorkoutState>((ref) {
  return WorkoutNotifier();
});

class WorkoutNotifier extends StateNotifier<WorkoutState> {
  Timer? _sessionTimer;
  Timer? _restTimer;

  WorkoutNotifier() : super(const WorkoutState());

  void startWorkout({
    required String title,
    required List<Map<String, dynamic>> rawExercises,
  }) {
    final List<WorkoutExerciseState> list = [];

    for (int i = 0; i < rawExercises.length; i++) {
      final item = rawExercises[i];
      final exData = item['exercises'] ?? item;

      final setsCount = item['target_sets'] ?? 3;
      final targetWeight = (item['target_weight_kg'] as num?)?.toDouble() ?? 40.0;
      final repsMin = item['target_reps_min'] ?? 8;
      final repsMax = item['target_reps_max'] ?? 12;
      final rpe = (item['target_rpe'] as num?)?.toDouble() ?? 8.5;
      final restSec = item['rest_seconds'] ?? 90;

      final sets = List.generate(
        setsCount,
        (sIdx) => WorkoutSet(
          setNumber: sIdx + 1,
          targetWeightKg: targetWeight,
          targetRepsMin: repsMin,
          targetRepsMax: repsMax,
          targetRpe: rpe,
        ),
      );

      list.add(
        WorkoutExerciseState(
          id: item['id'] ?? 'ex-$i',
          exerciseId: exData['id'] ?? 'ex-id-$i',
          name: exData['name'] ?? 'Egzersiz',
          targetMuscle: exData['target_muscle'] ?? 'Tüm Vücut',
          cnsLoadScore: exData['cns_load_score'] ?? 4,
          sfrRating: exData['sfr_rating'] ?? 'high',
          executionCues: (exData['execution_cues'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
          restSeconds: restSec,
          sets: sets,
        ),
      );
    }

    state = WorkoutState(
      isActive: true,
      sessionTitle: title,
      startTime: DateTime.now(),
      exercises: list,
    );

    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(durationSeconds: state.durationSeconds + 1);
    });
  }

  void logSetCompleted({
    required int exerciseIndex,
    required int setIndex,
    required double weightKg,
    required int reps,
    required double rpe,
  }) {
    final updatedExercises = List<WorkoutExerciseState>.from(state.exercises);
    final ex = updatedExercises[exerciseIndex];
    final targetSet = ex.sets[setIndex];

    targetSet.loggedWeightKg = weightKg;
    targetSet.loggedReps = reps;
    targetSet.loggedRpe = rpe;
    targetSet.isCompleted = true;

    // Recalculate Volume
    double volume = 0;
    for (final e in updatedExercises) {
      for (final s in e.sets) {
        if (s.isCompleted) {
          volume += s.loggedWeightKg * s.loggedReps;
        }
      }
    }

    state = state.copyWith(
      exercises: updatedExercises,
      totalVolumeKg: volume,
    );

    // Auto Start Rest Timer
    startRestTimer(ex.restSeconds);

    // Save offline queue immediately
    OfflineSyncService.instance.enqueueWorkoutLog({
      'sync_table': 'workout_set_logs',
      'exercise_id': ex.exerciseId,
      'set_number': targetSet.setNumber,
      'weight_kg': weightKg,
      'reps_completed': reps,
      'rpe_achieved': rpe,
      'is_completed': true,
    });
  }

  void startRestTimer(int seconds) {
    _restTimer?.cancel();
    state = state.copyWith(
      isRestTimerRunning: true,
      restTimerTotalSeconds: seconds,
      restTimerRemainingSeconds: seconds,
    );

    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.restTimerRemainingSeconds <= 1) {
        timer.cancel();
        state = state.copyWith(isRestTimerRunning: false, restTimerRemainingSeconds: 0);
      } else {
        state = state.copyWith(restTimerRemainingSeconds: state.restTimerRemainingSeconds - 1);
      }
    });
  }

  void stopRestTimer() {
    _restTimer?.cancel();
    state = state.copyWith(isRestTimerRunning: false, restTimerRemainingSeconds: 0);
  }

  void setCurrentExercise(int index) {
    state = state.copyWith(currentExerciseIndex: index);
  }

  Future<void> finishWorkout() async {
    _sessionTimer?.cancel();
    _restTimer?.cancel();

    try {
      final user = SupabaseService.currentUser;
      if (user != null) {
        // Save to Supabase
        await SupabaseService.client.from('workout_sessions').insert({
          'user_id': user.id,
          'session_title': state.sessionTitle,
          'started_at': state.startTime?.toIso8601String(),
          'completed_at': DateTime.now().toIso8601String(),
          'duration_seconds': state.durationSeconds,
          'total_volume_kg': state.totalVolumeKg,
          'cns_strain_score': 6,
          'status': 'completed',
        });

        // Trigger sync of queued logs
        await OfflineSyncService.instance.syncAllPending();
      }
    } catch (e) {
      debugPrint('Error finishing workout session: $e');
    }

    state = const WorkoutState();
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _restTimer?.cancel();
    super.dispose();
  }
}
