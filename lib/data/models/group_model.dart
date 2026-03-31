import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String id;
  final String name;
  final String code;
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

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'code': code,
      'memberIds': memberIds,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory GroupModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return GroupModel(
      id: doc.id,
      name: data['name'] as String,
      code: data['code'] as String,
      memberIds: List<String>.from(data['memberIds'] as List),
      createdBy: data['createdBy'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

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
}