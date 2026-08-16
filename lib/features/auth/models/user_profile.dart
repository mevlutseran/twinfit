class UserProfile {
  final String id;
  final String email;
  final String? fullName;
  final String gender;
  final DateTime? birthDate;
  final double heightCm;
  final double weightKg;
  final double? bodyFatPercentage;
  final String torsoFemurRatio; // 'short_femur', 'average', 'long_femur'
  final String armLengthType;   // 'short', 'average', 'long'
  final List<String> jointSensitivities;
  final String fitnessGoal;     // 'hypertrophy', 'strength', 'recomp'
  final String experienceLevel; // 'beginner', 'intermediate', 'advanced'
  final int cnsFatigueCapacity;
  final int dailyCalorieTarget;
  final int dailyProteinTargetG;
  final int dailyCarbTargetG;
  final int dailyFatTargetG;
  final int dailyWaterTargetMl;
  final String? avatarUrl;

  UserProfile({
    required this.id,
    required this.email,
    this.fullName,
    this.gender = 'male',
    this.birthDate,
    this.heightCm = 178,
    this.weightKg = 75,
    this.bodyFatPercentage,
    this.torsoFemurRatio = 'average',
    this.armLengthType = 'average',
    this.jointSensitivities = const [],
    this.fitnessGoal = 'hypertrophy',
    this.experienceLevel = 'intermediate',
    this.cnsFatigueCapacity = 100,
    this.dailyCalorieTarget = 2400,
    this.dailyProteinTargetG = 160,
    this.dailyCarbTargetG = 260,
    this.dailyFatTargetG = 70,
    this.dailyWaterTargetMl = 3000,
    this.avatarUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String? ?? '',
      fullName: json['full_name'] as String?,
      gender: json['gender'] as String? ?? 'male',
      birthDate: json['birth_date'] != null ? DateTime.tryParse(json['birth_date']) : null,
      heightCm: (json['height_cm'] as num?)?.toDouble() ?? 178.0,
      weightKg: (json['weight_kg'] as num?)?.toDouble() ?? 75.0,
      bodyFatPercentage: (json['body_fat_percentage'] as num?)?.toDouble(),
      torsoFemurRatio: json['torso_femur_ratio'] as String? ?? 'average',
      armLengthType: json['arm_length_type'] as String? ?? 'average',
      jointSensitivities: (json['joint_sensitivities'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      fitnessGoal: json['fitness_goal'] as String? ?? 'hypertrophy',
      experienceLevel: json['experience_level'] as String? ?? 'intermediate',
      cnsFatigueCapacity: json['cns_fatigue_capacity'] as int? ?? 100,
      dailyCalorieTarget: json['daily_calorie_target'] as int? ?? 2400,
      dailyProteinTargetG: json['daily_protein_target_g'] as int? ?? 160,
      dailyCarbTargetG: json['daily_carb_target_g'] as int? ?? 260,
      dailyFatTargetG: json['daily_fat_target_g'] as int? ?? 70,
      dailyWaterTargetMl: json['daily_water_target_ml'] as int? ?? 3000,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'gender': gender,
      'birth_date': birthDate?.toIso8601String().split('T').first,
      'height_cm': heightCm,
      'weight_kg': weightKg,
      'body_fat_percentage': bodyFatPercentage,
      'torso_femur_ratio': torsoFemurRatio,
      'arm_length_type': armLengthType,
      'joint_sensitivities': jointSensitivities,
      'fitness_goal': fitnessGoal,
      'experience_level': experienceLevel,
      'cns_fatigue_capacity': cnsFatigueCapacity,
      'daily_calorie_target': dailyCalorieTarget,
      'daily_protein_target_g': dailyProteinTargetG,
      'daily_carb_target_g': dailyCarbTargetG,
      'daily_fat_target_g': dailyFatTargetG,
      'daily_water_target_ml': dailyWaterTargetMl,
      'avatar_url': avatarUrl,
    };
  }

  UserProfile copyWith({
    String? fullName,
    String? gender,
    DateTime? birthDate,
    double? heightCm,
    double? weightKg,
    double? bodyFatPercentage,
    String? torsoFemurRatio,
    String? armLengthType,
    List<String>? jointSensitivities,
    String? fitnessGoal,
    String? experienceLevel,
    int? cnsFatigueCapacity,
    int? dailyCalorieTarget,
    int? dailyProteinTargetG,
    int? dailyCarbTargetG,
    int? dailyFatTargetG,
    int? dailyWaterTargetMl,
    String? avatarUrl,
  }) {
    return UserProfile(
      id: id,
      email: email,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      bodyFatPercentage: bodyFatPercentage ?? this.bodyFatPercentage,
      torsoFemurRatio: torsoFemurRatio ?? this.torsoFemurRatio,
      armLengthType: armLengthType ?? this.armLengthType,
      jointSensitivities: jointSensitivities ?? this.jointSensitivities,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      cnsFatigueCapacity: cnsFatigueCapacity ?? this.cnsFatigueCapacity,
      dailyCalorieTarget: dailyCalorieTarget ?? this.dailyCalorieTarget,
      dailyProteinTargetG: dailyProteinTargetG ?? this.dailyProteinTargetG,
      dailyCarbTargetG: dailyCarbTargetG ?? this.dailyCarbTargetG,
      dailyFatTargetG: dailyFatTargetG ?? this.dailyFatTargetG,
      dailyWaterTargetMl: dailyWaterTargetMl ?? this.dailyWaterTargetMl,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
