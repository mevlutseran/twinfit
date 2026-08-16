import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/supabase_service.dart';
import '../../../core/utils/biomechanics_calculator.dart';
import '../../auth/models/user_profile.dart';
import '../../auth/providers/auth_provider.dart';

class OnboardingState {
  final int currentStep;
  final String gender;
  final int age;
  final double heightCm;
  final double weightKg;
  final double bodyFatPct;
  final String torsoFemurRatio;
  final String armLengthType;
  final List<String> jointSensitivities;
  final String fitnessGoal;
  final String experienceLevel;
  final int daysPerWeek;
  final bool isSynthesizing;
  final String synthesisMessage;

  const OnboardingState({
    this.currentStep = 0,
    this.gender = 'male',
    this.age = 25,
    this.heightCm = 178,
    this.weightKg = 76,
    this.bodyFatPct = 16.0,
    this.torsoFemurRatio = 'average',
    this.armLengthType = 'average',
    this.jointSensitivities = const [],
    this.fitnessGoal = 'hypertrophy',
    this.experienceLevel = 'intermediate',
    this.daysPerWeek = 4,
    this.isSynthesizing = false,
    this.synthesisMessage = '',
  });

  OnboardingState copyWith({
    int? currentStep,
    String? gender,
    int? age,
    double? heightCm,
    double? weightKg,
    double? bodyFatPct,
    String? torsoFemurRatio,
    String? armLengthType,
    List<String>? jointSensitivities,
    String? fitnessGoal,
    String? experienceLevel,
    int? daysPerWeek,
    bool? isSynthesizing,
    String? synthesisMessage,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      bodyFatPct: bodyFatPct ?? this.bodyFatPct,
      torsoFemurRatio: torsoFemurRatio ?? this.torsoFemurRatio,
      armLengthType: armLengthType ?? this.armLengthType,
      jointSensitivities: jointSensitivities ?? this.jointSensitivities,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
      isSynthesizing: isSynthesizing ?? this.isSynthesizing,
      synthesisMessage: synthesisMessage ?? this.synthesisMessage,
    );
  }
}

final onboardingProvider = StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier(ref);
});

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final Ref _ref;

  OnboardingNotifier(this._ref) : super(const OnboardingState());

  void setStep(int step) => state = state.copyWith(currentStep: step);
  void setGender(String g) => state = state.copyWith(gender: g);
  void setAge(int a) => state = state.copyWith(age: a);
  void setHeight(double h) => state = state.copyWith(heightCm: h);
  void setWeight(double w) => state = state.copyWith(weightKg: w);
  void setBodyFat(double bf) => state = state.copyWith(bodyFatPct: bf);
  void setTorsoFemurRatio(String r) => state = state.copyWith(torsoFemurRatio: r);
  void setArmLengthType(String l) => state = state.copyWith(armLengthType: l);
  
  void toggleJointSensitivity(String joint) {
    final list = List<String>.from(state.jointSensitivities);
    if (list.contains(joint)) {
      list.remove(joint);
    } else {
      list.add(joint);
    }
    state = state.copyWith(jointSensitivities: list);
  }

  void setFitnessGoal(String g) => state = state.copyWith(fitnessGoal: g);
  void setExperienceLevel(String e) => state = state.copyWith(experienceLevel: e);
  void setDaysPerWeek(int d) => state = state.copyWith(daysPerWeek: d);

  /// Synthesize Synthetic Digital Twin & Generate Autonomous Golden Path Routine
  Future<bool> synthesizeDigitalTwin() async {
    state = state.copyWith(isSynthesizing: true, synthesisMessage: 'NSCA Biyomekanik Veri Havuzu Taranıyor...');
    
    try {
      final user = SupabaseService.currentUser;
      if (user == null) throw Exception('Kullanıcı oturumu bulunamadı');

      await Future.delayed(const Duration(milliseconds: 700));
      state = state.copyWith(synthesisMessage: 'Morfoloji & Uzuv Oranları Modelleniyor...');
      
      // Calculate optimal nutrition
      final nutrition = BiomechanicsCalculator.calculateNutritionTargets(
        weightKg: state.weightKg,
        heightCm: state.heightCm,
        age: state.age,
        gender: state.gender,
        goal: state.fitnessGoal,
      );

      await Future.delayed(const Duration(milliseconds: 700));
      state = state.copyWith(synthesisMessage: 'Otonom Altın Rota Programı İnşa Ediliyor...');

      final profile = UserProfile(
        id: user.id,
        email: user.email ?? '',
        fullName: _ref.read(authProvider).profile?.fullName ?? 'Sporcu',
        gender: state.gender,
        heightCm: state.heightCm,
        weightKg: state.weightKg,
        bodyFatPercentage: state.bodyFatPct,
        torsoFemurRatio: state.torsoFemurRatio,
        armLengthType: state.armLengthType,
        jointSensitivities: state.jointSensitivities,
        fitnessGoal: state.fitnessGoal,
        experienceLevel: state.experienceLevel,
        cnsFatigueCapacity: 100,
        dailyCalorieTarget: nutrition['calories'] as int,
        dailyProteinTargetG: nutrition['protein_g'] as int,
        dailyCarbTargetG: nutrition['carb_g'] as int,
        dailyFatTargetG: nutrition['fat_g'] as int,
        dailyWaterTargetMl: nutrition['water_ml'] as int,
      );

      // Save profile to Supabase
      await _ref.read(authProvider.notifier).updateProfile(profile);

      // Generate Golden Path Routine in Supabase
      await _generateInitialRoutines(user.id);

      await Future.delayed(const Duration(milliseconds: 600));
      state = state.copyWith(isSynthesizing: false, synthesisMessage: 'Biyolojik İkiz Başarıyla Oluşturuldu!');
      return true;
    } catch (e) {
      debugPrint('Error synthesizing digital twin: $e');
      state = state.copyWith(isSynthesizing: false, synthesisMessage: 'Hata: $e');
      return false;
    }
  }

  Future<void> _generateInitialRoutines(String userId) async {
    try {
      // Fetch available exercises from Supabase
      final exercisesData = await SupabaseService.client.from('exercises').select();
      final List<dynamic> exercises = exercisesData;

      if (exercises.isEmpty) return;

      // Routine 1: Üst Vücut (Elit SFR İtiş & Çekiş)
      final routineRes = await SupabaseService.client.from('golden_path_routines').insert({
        'user_id': userId,
        'routine_name': 'Altın Rota: Üst Vücut SFR Zirvesi',
        'day_name': 'Gün 1: Üst Göğüs, Sırt & Yan Omuz',
        'day_of_week': 1,
        'focus_muscles': ['Göğüs', 'Sırt', 'Yan Omuz', 'Triceps'],
        'total_cns_impact': 6,
        'estimated_duration_min': 55,
        'is_active': true,
      }).select().single();

      final routineId = routineRes['id'];

      // Attach 4-5 exercises to this routine
      int order = 1;
      for (final ex in exercises.take(5)) {
        await SupabaseService.client.from('golden_path_exercises').insert({
          'routine_id': routineId,
          'exercise_id': ex['id'],
          'order_index': order++,
          'target_sets': 3,
          'target_reps_min': 8,
          'target_reps_max': 12,
          'target_rpe': 8.5,
          'target_weight_kg': 40.0,
          'rest_seconds': 90,
        });
      }
    } catch (e) {
      debugPrint('Error generating initial routine: $e');
    }
  }
}
