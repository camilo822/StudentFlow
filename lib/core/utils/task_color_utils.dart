import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../../data/models/task_model.dart';

class TaskColorUtils {
  TaskColorUtils._();

  /// Color principal del indicador según estado de fecha
  static Color getStatusColor(TaskModel task) {
    if (task.status == TaskStatus.done) return AppColors.statusDone;
    if (task.isOverdue) return AppColors.statusOverdue;
    if (task.isUrgent) return AppColors.statusUrgent;

    final days = task.daysUntilDue;
    if (days <= 3) return AppColors.statusWarning;
    return AppColors.statusSafe;
  }

  /// Color de fondo claro para la tarjeta
  static Color getStatusLightColor(TaskModel task) {
    if (task.status == TaskStatus.done) return AppColors.statusDoneLight;
    if (task.isOverdue) return AppColors.statusOverdueLight;
    if (task.isUrgent) return AppColors.statusUrgentLight;

    final days = task.daysUntilDue;
    if (days <= 3) return AppColors.statusWarningLight;
    return AppColors.statusSafeLight;
  }

  /// Texto descriptivo del tiempo restante
  static String getDueDateLabel(TaskModel task) {
    if (task.status == TaskStatus.done) return '✓ Completada';
    if (task.isOverdue) {
      final days = task.daysUntilDue.abs();
      return days == 1 ? 'Venció ayer' : 'Venció hace $days días';
    }
    final days = task.daysUntilDue;
    if (days == 0) return '🔴 Vence hoy';
    if (days == 1) return '🔴 Vence mañana';
    if (days <= 3) return '⚠️ Vence en $days días';
    return '✅ Vence en $days días';
  }

  /// Color de la etiqueta de prioridad
  static Color getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return AppColors.priorityLow;
      case TaskPriority.medium:
        return AppColors.priorityMedium;
      case TaskPriority.high:
        return AppColors.priorityHigh;
    }
  }

  static String getPriorityLabel(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'Baja';
      case TaskPriority.medium:
        return 'Media';
      case TaskPriority.high:
        return 'Alta';
    }
  }

  static String getStatusLabel(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'Pendiente';
      case TaskStatus.inProgress:
        return 'En progreso';
      case TaskStatus.done:
        return 'Completada';
    }
  }
}