import 'package:flutter_test/flutter_test.dart';
import 'package:twinfit/core/utils/biomechanics_calculator.dart';
import 'package:twinfit/features/exercise_catalog/models/exercise_model.dart';

void main() {
  group('BiomechanicsCalculator Tests', () {
    test('1RM Epley Formula Calculation', () {
      // 100 kg for 10 reps -> 100 * (1 + 10/30) = 133.33 kg
      final oneRm = BiomechanicsCalculator.calculate1RM(100, 10);
      expect(oneRm, closeTo(133.33, 0.05));

      // 1 rep of 100 kg is 100 kg
      expect(BiomechanicsCalculator.calculate1RM(100, 1), equals(100.0));
      expect(BiomechanicsCalculator.calculate1RM(0, 5), equals(0.0));
    });

    test('CNS Strain Scoring', () {
      // Barbell Squat (CNS: 9) at RPE 9.0 -> 9 * 0.9 = 8.1
      final strain = BiomechanicsCalculator.calculateSetCnsStrain(
        exerciseCnsScore: 9,
        rpe: 9.0,
        weightKg: 100,
      );
      expect(strain, closeTo(8.1, 0.01));
    });

    test('Daily Nutrition Target Generator', () {
      final targets = BiomechanicsCalculator.calculateNutritionTargets(
        weightKg: 80,
        heightCm: 180,
        age: 25,
        gender: 'male',
        goal: 'hypertrophy',
      );

      expect(targets['calories'], greaterThan(2400));
      expect(targets['protein_g'], equals(160)); // 2.0 g/kg * 80kg
      expect(targets['water_ml'], equals(2800));   // 35ml/kg * 80kg
    });

    test('Biomechanical Compatibility & Joint Sensitivity Filter', () {
      // User with long femur should not have Barbell Squat as default
      final squatCompat = BiomechanicsCalculator.isExerciseBiomechanicallyCompatible(
        exerciseName: 'Barbell Squat',
        torsoFemurRatio: 'long_femur',
        jointSensitivities: [],
      );
      expect(squatCompat, isFalse);

      // User with lower back sensitivity should avoid Deadlifts
      final dlCompat = BiomechanicsCalculator.isExerciseBiomechanicallyCompatible(
        exerciseName: 'Conventional Deadlift',
        torsoFemurRatio: 'average',
        jointSensitivities: ['lower_back'],
      );
      expect(dlCompat, isFalse);
    });
  });

  group('ExerciseModel JSON Serialization', () {
    test('Correctly maps JSON to ExerciseModel', () {
      final json = {
        'id': 'ex-123',
        'name': 'Cable Lateral Raise',
        'turkish_name': 'Kablo Yan Omuz Açış',
        'target_muscle': 'Yan Omuz',
        'synergist_muscles': ['Trapez'],
        'cns_load_score': 2,
        'sfr_rating': 'elite',
        'joint_stress_index': {'shoulder': 1, 'lower_back': 0},
        'equipment': 'Cable',
      };

      final model = ExerciseModel.fromJson(json);
      expect(model.id, 'ex-123');
      expect(model.turkishName, 'Kablo Yan Omuz Açış');
      expect(model.sfrRating, 'elite');
      expect(model.cnsLoadScore, 2);
      expect(model.jointStressIndex['shoulder'], 1);
    });
  });
}
