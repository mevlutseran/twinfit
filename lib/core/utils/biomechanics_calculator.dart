class BiomechanicsCalculator {
  /// Calculate estimated 1RM using Epley Formula: 1RM = weight * (1 + reps / 30)
  static double calculate1RM(double weightKg, int reps) {
    if (reps <= 0 || weightKg <= 0) return 0;
    if (reps == 1) return weightKg;
    return weightKg * (1 + (reps / 30.0));
  }

  /// Calculate CNS Strain points for a set: CNS_Load * (RPE / 10) * (WeightFactor)
  static double calculateSetCnsStrain({
    required int exerciseCnsScore, // 1 to 10
    required double rpe,           // 6.0 to 10.0
    required double weightKg,
  }) {
    final intensityMultiplier = (rpe / 10.0);
    return exerciseCnsScore * intensityMultiplier;
  }

  /// Calculate Daily Calorie & Macro Target based on body metrics
  static Map<String, dynamic> calculateNutritionTargets({
    required double weightKg,
    required double heightCm,
    required int age,
    required String gender,
    required String goal, // 'hypertrophy', 'strength', 'recomp'
  }) {
    // Mifflin-St Jeor BMR
    double bmr;
    if (gender == 'female') {
      bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161;
    } else {
      bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5;
    }

    // TDEE with moderate activity factor (1.45)
    double tdee = bmr * 1.45;

    // Adjust for goal
    int calorieTarget;
    if (goal == 'hypertrophy') {
      calorieTarget = (tdee + 300).round(); // Surplus
    } else if (goal == 'recomp') {
      calorieTarget = (tdee - 200).round(); // Slight deficit
    } else {
      calorieTarget = (tdee + 150).round(); // Maintenance / Strength
    }

    // Macros: 2.0g/kg protein, 1.0g/kg fat, rest carbs
    final proteinG = (weightKg * 2.0).round();
    final fatG = (weightKg * 0.9).round();
    final remainingCalories = calorieTarget - (proteinG * 4 + fatG * 9);
    final carbG = (remainingCalories / 4).round().clamp(100, 600);
    final waterMl = (weightKg * 35).round();

    return {
      'calories': calorieTarget,
      'protein_g': proteinG,
      'carb_g': carbG,
      'fat_g': fatG,
      'water_ml': waterMl,
    };
  }

  /// Evaluate if an exercise is optimal for user's morphology
  static bool isExerciseBiomechanicallyCompatible({
    required String exerciseName,
    required String torsoFemurRatio, // 'short_femur', 'average', 'long_femur'
    required List<String> jointSensitivities, // e.g. ['lower_back', 'knee', 'shoulder']
  }) {
    final lower = exerciseName.toLowerCase();

    // If user has lower back pain/sensitivity, avoid high spinal compression
    if (jointSensitivities.contains('lower_back')) {
      if (lower.contains('deadlift') && !lower.contains('chest')) return false;
      if (lower.contains('bent over row')) return false;
    }

    // If user has long femurs, barbell back squats create huge forward lean -> substitute with Bulgarian Split Squat or Leg Press
    if (torsoFemurRatio == 'long_femur' && lower.contains('barbell squat')) {
      return false;
    }

    // If user has shoulder impingement/sensitivity, prefer cable/dumbbell over straight barbell bench
    if (jointSensitivities.contains('shoulder') && lower.contains('barbell bench')) {
      return false;
    }

    return true;
  }
}
