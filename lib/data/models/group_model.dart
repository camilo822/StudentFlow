class GroupModel {
  final String id;
  final String name;
  final String code; // código de 6 dígitos para unirse
  final List<String> memberIds;
  final String createdBy;
  final DateTime createdAt;

  const GroupModel({
    required this.id,
    required this.name,
    required this.code,
    required this.memberIds,
    required this.createdBy,
    required this.createdAt,
  });

  int get memberCount => memberIds.length;

  bool isMember(String userId) => memberIds.contains(userId);

  GroupModel copyWith({
    String? id,
    String? name,
    String? code,
    List<String>? memberIds,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      memberIds: memberIds ?? this.memberIds,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'memberIds': memberIds,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      id: map['id'] as String,
      name: map['name'] as String,
      code: map['code'] as String,
      memberIds: List<String>.from(map['memberIds'] as List),
      createdBy: map['createdBy'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}