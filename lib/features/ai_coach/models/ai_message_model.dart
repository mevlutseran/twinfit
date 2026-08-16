class AiMessageModel {
  final String id;
  final String role; // 'user', 'assistant', 'system'
  final String content;
  final DateTime createdAt;

  AiMessageModel({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  factory AiMessageModel.fromJson(Map<String, dynamic> json) {
    return AiMessageModel(
      id: json['id'] as String? ?? UniqueKey().toString(),
      role: json['message_role'] as String? ?? json['role'] as String? ?? 'assistant',
      content: json['content'] as String? ?? '',
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) ?? DateTime.now() : DateTime.now(),
    );
  }
}
class UniqueKey {
  @override
  String toString() => DateTime.now().millisecondsSinceEpoch.toString();
}
