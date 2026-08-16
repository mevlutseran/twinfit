class ExerciseModel {
  final String id;
  final String name;
  final String turkishName;
  final String targetMuscle;
  final List<String> synergistMuscles;
  final int cnsLoadScore;
  final String sfrRating; // 'low', 'medium', 'high', 'elite'
  final Map<String, dynamic> jointStressIndex;
  final String? biomechanicalNotes;
  final List<String> executionCues;
  final String? videoUrl;
  final String? thumbnailUrl;
  final String equipment;

  ExerciseModel({
    required this.id,
    required this.name,
    required this.turkishName,
    required this.targetMuscle,
    this.synergistMuscles = const [],
    this.cnsLoadScore = 4,
    this.sfrRating = 'high',
    this.jointStressIndex = const {},
    this.biomechanicalNotes,
    this.executionCues = const [],
    this.videoUrl,
    this.thumbnailUrl,
    this.equipment = 'Dumbbell',
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      turkishName: json['turkish_name'] as String? ?? json['name'] as String? ?? '',
      targetMuscle: json['target_muscle'] as String? ?? '',
      synergistMuscles: (json['synergist_muscles'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      cnsLoadScore: json['cns_load_score'] as int? ?? 4,
      sfrRating: json['sfr_rating'] as String? ?? 'high',
      jointStressIndex: json['joint_stress_index'] is Map ? Map<String, dynamic>.from(json['joint_stress_index']) : {},
      biomechanicalNotes: json['biomechanical_notes'] as String?,
      executionCues: (json['execution_cues'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      videoUrl: json['video_url'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      equipment: json['equipment'] as String? ?? 'Dumbbell',
    );
  }
}
