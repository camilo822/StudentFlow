import 'package:cloud_firestore/cloud_firestore.dart';

enum TaskPriority { low, medium, high }

enum TaskStatus { pending, inProgress, done }

class TaskModel {
  final String id;
  final String title;
  final String subject;
  final String description;
  final DateTime dueDate;
  final TaskPriority priority;
  final TaskStatus status;
  final String createdBy;
  final String groupId;
  final DateTime createdAt;

  const TaskModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.status,
    required this.createdBy,
    required this.groupId,
    required this.createdAt,
  });

  bool get isUrgent {
    final today = _today();
    final due = _dateOnly(dueDate);
    final diff = due.difference(today).inDays;
    return diff <= 1 && diff >= 0;
  }

  bool get isOverdue {
    final today = _today();
    final due = _dateOnly(dueDate);
    return due.isBefore(today);
  }

  int get daysUntilDue {
    final today = _today();
    final due = _dateOnly(dueDate);
    return due.difference(today).inDays;
  }

  DateTime _today() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  // ── Firestore ──────────────────────────────────────────────────────────────

  /// Serializa para guardar en Firestore
  /// Usa Timestamp para las fechas (no String) → permite queries por fecha
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'subject': subject,
      'description': description,
      'dueDate': Timestamp.fromDate(dueDate),
      'priority': priority.name,
      'status': status.name,
      'createdBy': createdBy,
      'groupId': groupId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Construye un TaskModel desde un DocumentSnapshot de Firestore
  factory TaskModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return TaskModel(
      id: doc.id,
      title: data['title'] as String,
      subject: data['subject'] as String,
      description: data['description'] as String? ?? '',
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      priority: TaskPriority.values.byName(data['priority'] as String),
      status: TaskStatus.values.byName(data['status'] as String),
      createdBy: data['createdBy'] as String,
      groupId: data['groupId'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // ── Utilidades ─────────────────────────────────────────────────────────────

  TaskModel copyWith({
    String? id,
    String? title,
    String? subject,
    String? description,
    DateTime? dueDate,
    TaskPriority? priority,
    TaskStatus? status,
    String? createdBy,
    String? groupId,
    DateTime? createdAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      groupId: groupId ?? this.groupId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}