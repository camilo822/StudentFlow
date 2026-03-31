import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';
import '../services/firebase_service.dart';

/// Toda la lógica de tareas con Firestore.
/// El HomeScreen NUNCA habla con Firestore directamente, siempre usa este repo.
class TaskRepository {
  TaskRepository._();
  static final TaskRepository instance = TaskRepository._();

  // ── Stream en tiempo real ──────────────────────────────────────────────────

  /// Escucha TODOS los cambios del grupo en tiempo real.
  /// Cada vez que alguien agrega, edita o borra una tarea → el stream emite
  /// la lista actualizada automáticamente.
  /// Orden: primero las más próximas a vencer.
  Stream<List<TaskModel>> watchTasks(String groupId) {
    return FirebaseService.tasksRef(groupId)
        .orderBy('dueDate', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TaskModel.fromFirestore(
                  doc as DocumentSnapshot<Map<String, dynamic>>))
              .toList(),
        );
  }

  // ── Escritura ──────────────────────────────────────────────────────────────

  /// Agrega una tarea nueva. Firestore genera el ID automáticamente.
  Future<String> addTask(TaskModel task) async {
    final ref = await FirebaseService.tasksRef(task.groupId)
        .add(task.toFirestore());
    return ref.id;
  }

  /// Actualiza solo los campos que cambian (no reescribe todo el documento)
  Future<void> updateTask(TaskModel task) async {
    await FirebaseService.tasksRef(task.groupId)
        .doc(task.id)
        .update(task.toFirestore());
  }

  /// Actualiza solo el estado de una tarea (pending / inProgress / done)
  Future<void> updateStatus(
    String groupId,
    String taskId,
    TaskStatus newStatus,
  ) async {
    await FirebaseService.tasksRef(groupId)
        .doc(taskId)
        .update({'status': newStatus.name});
  }

  /// Borra una tarea (solo si el creador es el usuario actual — validar en UI)
  Future<void> deleteTask(String groupId, String taskId) async {
    await FirebaseService.tasksRef(groupId).doc(taskId).delete();
  }

  // ── Lectura puntual (sin stream) ───────────────────────────────────────────

  Future<List<TaskModel>> fetchTasks(String groupId) async {
    final snapshot = await FirebaseService.tasksRef(groupId)
        .orderBy('dueDate')
        .get();
    return snapshot.docs
        .map((doc) => TaskModel.fromFirestore(
            doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();
  }
}