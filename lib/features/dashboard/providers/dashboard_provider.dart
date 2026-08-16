import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/supabase_service.dart';
import '../../../core/network/redis_service.dart';
import '../../auth/providers/auth_provider.dart';

class MuscleRecoveryStatus {
  final String muscleName;
  final double recoveryPercentage; // 0 to 100
  final int hoursUntilFullyRecovered;

  const MuscleRecoveryStatus({
    required this.muscleName,
    required this.recoveryPercentage,
    required this.hoursUntilFullyRecovered,
  });
}

class DashboardState {
  final bool isLoading;
  final int cnsFatigueIndex; // 0 to 100
  final List<MuscleRecoveryStatus> muscleRecoveryList;
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
  final Map<String, dynamic>? activeRoutine;
  final List<Map<String, dynamic>> routineExercises;
  final List<Map<String, dynamic>> recentActivities;

  const DashboardState({
    this.isLoading = true,
    this.cnsFatigueIndex = 25,
    this.muscleRecoveryList = const [],
    this.caloriesConsumed = 1850,
    this.caloriesTarget = 2500,
    this.proteinG = 140,
    this.proteinTargetG = 160,
    this.carbG = 210,
    this.carbTargetG = 280,
    this.fatG = 55,
    this.fatTargetG = 75,
    this.waterMl = 2250,
    this.waterTargetMl = 3000,
    this.activeRoutine,
    this.routineExercises = const [],
    this.recentActivities = const [],
  });

  DashboardState copyWith({
    bool? isLoading,
    int? cnsFatigueIndex,
    List<MuscleRecoveryStatus>? muscleRecoveryList,
    int? caloriesConsumed,
    int? caloriesTarget,
    double? proteinG,
    double? proteinTargetG,
    double? carbG,
    double? carbTargetG,
    double? fatG,
    double? fatTargetG,
    int? waterMl,
    int? waterTargetMl,
    Map<String, dynamic>? activeRoutine,
    List<Map<String, dynamic>>? routineExercises,
    List<Map<String, dynamic>>? recentActivities,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      cnsFatigueIndex: cnsFatigueIndex ?? this.cnsFatigueIndex,
      muscleRecoveryList: muscleRecoveryList ?? this.muscleRecoveryList,
      caloriesConsumed: caloriesConsumed ?? this.caloriesConsumed,
      caloriesTarget: caloriesTarget ?? this.caloriesTarget,
      proteinG: proteinG ?? this.proteinG,
      proteinTargetG: proteinTargetG ?? this.proteinTargetG,
      carbG: carbG ?? this.carbG,
      carbTargetG: carbTargetG ?? this.carbTargetG,
      fatG: fatG ?? this.fatG,
      fatTargetG: fatTargetG ?? this.fatTargetG,
      waterMl: waterMl ?? this.waterMl,
      waterTargetMl: waterTargetMl ?? this.waterTargetMl,
      activeRoutine: activeRoutine ?? this.activeRoutine,
      routineExercises: routineExercises ?? this.routineExercises,
      recentActivities: recentActivities ?? this.recentActivities,
    );
  }
}

final dashboardProvider = StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  return DashboardNotifier(ref);
});

class DashboardNotifier extends StateNotifier<DashboardState> {
  final Ref _ref;

  DashboardNotifier(this._ref) : super(const DashboardState()) {
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    state = state.copyWith(isLoading: true);
    try {
      final user = SupabaseService.currentUser;
      final profile = _ref.read(authProvider).profile;

      // 1. Muscle Recovery simulation based on biology
      final muscles = [
        const MuscleRecoveryStatus(muscleName: 'Göğüs (Üst/Orta)', recoveryPercentage: 94, hoursUntilFullyRecovered: 4),
        const MuscleRecoveryStatus(muscleName: 'Sırt & Lats', recoveryPercentage: 88, hoursUntilFullyRecovered: 8),
        const MuscleRecoveryStatus(muscleName: 'Yan Omuz', recoveryPercentage: 98, hoursUntilFullyRecovered: 0),
        const MuscleRecoveryStatus(muscleName: 'Quadriceps', recoveryPercentage: 65, hoursUntilFullyRecovered: 22),
        const MuscleRecoveryStatus(muscleName: 'Hamstrings & Glute', recoveryPercentage: 72, hoursUntilFullyRecovered: 18),
        const MuscleRecoveryStatus(muscleName: 'Kollar (Biceps/Triceps)', recoveryPercentage: 92, hoursUntilFullyRecovered: 5),
      ];

      // 2. Fetch Active Golden Path Routine
      Map<String, dynamic>? routine;
      List<Map<String, dynamic>> exercises = [];

      if (user != null) {
        final routinesData = await SupabaseService.client
            .from('golden_path_routines')
            .select()
            .eq('user_id', user.id)
            .eq('is_active', true)
            .limit(1);

        if (routinesData.isNotEmpty) {
          routine = routinesData.first;
          final exercisesData = await SupabaseService.client
              .from('golden_path_exercises')
              .select('*, exercises(*)')
              .eq('routine_id', routine['id'])
              .order('order_index');
          exercises = List<Map<String, dynamic>>.from(exercisesData);
        }
      }

      // 3. Fallback mock routine if user is guest or just joined
      routine ??= {
        'id': 'mock-routine-1',
        'routine_name': 'Altın Rota: Üst Vücut (SFR Zirvesi)',
        'day_name': 'Pazartesi: Üst Göğüs, Sırt & Yan Omuz',
        'focus_muscles': ['Göğüs', 'Sırt', 'Yan Omuz'],
        'total_cns_impact': 6,
        'estimated_duration_min': 55,
      };

      // Cache snapshot to Redis
      if (user != null) {
        RedisService.instance.set('user_cns_${user.id}', {'cns': 28, 'updated': DateTime.now().toIso8601String()});
      }

      state = state.copyWith(
        isLoading: false,
        cnsFatigueIndex: 28,
        muscleRecoveryList: muscles,
        caloriesTarget: profile?.dailyCalorieTarget ?? 2500,
        proteinTargetG: (profile?.dailyProteinTargetG ?? 160).toDouble(),
        carbTargetG: (profile?.dailyCarbTargetG ?? 280).toDouble(),
        fatTargetG: (profile?.dailyFatTargetG ?? 75).toDouble(),
        waterTargetMl: profile?.dailyWaterTargetMl ?? 3000,
        activeRoutine: routine,
        routineExercises: exercises,
      );
    } catch (e) {
      debugPrint('Error loading dashboard data: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  void addWater(int amountMl) {
    state = state.copyWith(waterMl: state.waterMl + amountMl);
  }

  void addNutrition({required int calories, required double protein, required double carbs, required double fat}) {
    state = state.copyWith(
      caloriesConsumed: state.caloriesConsumed + calories,
      proteinG: state.proteinG + protein,
      carbG: state.carbG + carbs,
      fatG: state.fatG + fat,
    );
  }
}
