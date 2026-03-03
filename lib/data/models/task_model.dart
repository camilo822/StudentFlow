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
    required this.createdAt
  });

  // Devuelve true si la tarea vence hoy o mañana
  bool get isUrgent {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final diff = due.difference(today).inDays;
    return diff <= 1 && diff >=0;
  }

  //Devuelve true si la tarea ya vencio
  bool get isOverdue {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    return due.isBefore(today);
  }

  //Dias restantes (negativo = ya vencio)
  int get daysUntilDue {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    return due.difference(today).inDays;
  }

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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subject': subject,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority.name,
      'status': status.name,
      'createdBy': createdBy,
      'groupId': groupId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as String,
      title: map['title'] as String,
      subject: map['subject'] as String,
      description: map['description'] as String,
      dueDate: DateTime.parse(map['dueDate'] as String),
      priority: TaskPriority.values.byName(map['priority'] as String),
      status: TaskStatus.values.byName(map['status'] as String),
      createdBy: map['createdBy'] as String,
      groupId: map['groupId'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}

