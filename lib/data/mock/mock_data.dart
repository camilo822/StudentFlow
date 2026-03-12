import '../models/task_model.dart';
import '../models/group_model.dart';

/// Datos de mentira para la Semana 1
/// En la Semana 3 esto se reemplazará con Firebase
class MockData {
  MockData._();

  static final GroupModel mockGroup = GroupModel(
    id: 'group_001',
    name: 'Ingeniería de Sistemas - 2025',
    code: 'SF4821',
    memberIds: ['user_001', 'user_002', 'user_003'],
    createdBy: 'user_001',
    createdAt: DateTime.now().subtract(const Duration(days: 7)),
  );

  static final List<TaskModel> mockTasks = [
    // 🔴 Vence hoy
    TaskModel(
      id: 'task_001',
      title: 'Parcial de Cálculo Diferencial',
      subject: 'Cálculo Diferencial',
      description: 'Temas: límites, derivadas, regla de la cadena.',
      dueDate: DateTime.now(),
      priority: TaskPriority.high,
      status: TaskStatus.pending,
      createdBy: 'Camilo',
      groupId: 'group_001',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),

    // 🔴 Vence mañana
    TaskModel(
      id: 'task_002',
      title: 'Entrega Lab Física',
      subject: 'Física I',
      description: 'Informe del laboratorio de movimiento parabólico.',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      priority: TaskPriority.high,
      status: TaskStatus.inProgress,
      createdBy: 'Valentina',
      groupId: 'group_001',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),

    // ⚠️ Vence en 3 días
    TaskModel(
      id: 'task_003',
      title: 'Proyecto de Programación',
      subject: 'Fundamentos de Programación',
      description: 'Aplicación de consola en Java: gestor de notas.',
      dueDate: DateTime.now().add(const Duration(days: 3)),
      priority: TaskPriority.medium,
      status: TaskStatus.inProgress,
      createdBy: 'Andrés',
      groupId: 'group_001',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),

    // ✅ Vence en 7 días
    TaskModel(
      id: 'task_004',
      title: 'Ensayo Ética Profesional',
      subject: 'Ética y Sociedad',
      description: 'Ensayo 3 páginas sobre dilemas éticos en IA.',
      dueDate: DateTime.now().add(const Duration(days: 7)),
      priority: TaskPriority.low,
      status: TaskStatus.pending,
      createdBy: 'Camilo',
      groupId: 'group_001',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),

    // ✅ Completada
    TaskModel(
      id: 'task_005',
      title: 'Quiz Álgebra Lineal',
      subject: 'Álgebra Lineal',
      description: 'Quiz sobre matrices y determinantes.',
      dueDate: DateTime.now().subtract(const Duration(days: 2)),
      priority: TaskPriority.medium,
      status: TaskStatus.done,
      createdBy: 'Valentina',
      groupId: 'group_001',
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
    ),

    // 🔴 Venció (overdue)
    TaskModel(
      id: 'task_006',
      title: 'Taller de Estadística',
      subject: 'Estadística',
      description: 'Taller 2: distribuciones de probabilidad.',
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
      priority: TaskPriority.high,
      status: TaskStatus.pending,
      createdBy: 'Andrés',
      groupId: 'group_001',
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
    ),

    // ✅ Vence en 14 días
    TaskModel(
      id: 'task_007',
      title: 'Exposición Bases de Datos',
      subject: 'Bases de Datos I',
      description: 'Presentación sobre modelo relacional, 15 min.',
      dueDate: DateTime.now().add(const Duration(days: 14)),
      priority: TaskPriority.low,
      status: TaskStatus.pending,
      createdBy: 'Camilo',
      groupId: 'group_001',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
}