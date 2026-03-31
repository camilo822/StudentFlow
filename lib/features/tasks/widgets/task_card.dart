import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/task_color_utils.dart';
import '../../../data/models/task_model.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;
  final void Function(TaskStatus)? onStatusChanged;
  final VoidCallback? onDelete; // null = no es el creador, no puede borrar

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onStatusChanged,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = TaskColorUtils.getStatusColor(task);
    final statusLightColor = TaskColorUtils.getStatusLightColor(task);
    final isDone = task.status == TaskStatus.done;

    return Dismissible(
      key: ValueKey(task.id),
      // Swipe derecha → marcar como completada
      background: _SwipeBackground(
        color: AppColors.statusSafe,
        icon: Icons.check_circle_outline,
        label: 'Completar',
        alignment: Alignment.centerLeft,
      ),
      // Swipe izquierda → borrar (solo si es el creador)
      secondaryBackground: onDelete != null
          ? _SwipeBackground(
              color: AppColors.statusUrgent,
              icon: Icons.delete_outline,
              label: 'Borrar',
              alignment: Alignment.centerRight,
            )
          : null,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Marcar como completada sin borrar la tarjeta
          onStatusChanged?.call(TaskStatus.done);
          return false; // no elimina el widget, solo actualiza Firestore
        } else if (direction == DismissDirection.endToStart &&
            onDelete != null) {
          return await _confirmDelete(context);
        }
        return false;
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border(
              left: BorderSide(color: statusColor, width: 4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Materia + prioridad
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        task.subject,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                          letterSpacing: 0.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _PriorityChip(priority: task.priority),
                  ],
                ),
                const SizedBox(height: 6),

                // Título
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    decoration: isDone ? TextDecoration.lineThrough : null,
                    decorationColor: AppColors.textSecondary,
                  ),
                ),

                if (task.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    task.description,
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                const SizedBox(height: 12),

                // Fecha + creador + menú de estado
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusLightColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        TaskColorUtils.getDueDateLabel(task),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Avatar del creador
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: AppColors.primaryLight,
                          child: Text(
                            task.createdBy.isNotEmpty
                                ? task.createdBy[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          task.createdBy,
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    // Menú de cambio de estado (los 3 puntos)
                    if (onStatusChanged != null) ...[
                      const SizedBox(width: 8),
                      _StatusMenu(
                        currentStatus: task.status,
                        onChanged: onStatusChanged!,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('¿Borrar tarea?',
                style: TextStyle(fontWeight: FontWeight.w700)),
            content: Text(
              '¿Seguro que quieres borrar "${task.title}"? Esta acción no se puede deshacer.',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx, true);
                  onDelete?.call();
                },
                child: const Text('Borrar',
                    style: TextStyle(color: AppColors.statusUrgent)),
              ),
            ],
          ),
        ) ??
        false;
  }
}

// ── Menú de estado ────────────────────────────────────────────────────────────

class _StatusMenu extends StatelessWidget {
  final TaskStatus currentStatus;
  final void Function(TaskStatus) onChanged;

  const _StatusMenu(
      {required this.currentStatus, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<TaskStatus>(
      icon: const Icon(Icons.more_vert_rounded,
          size: 18, color: AppColors.textSecondary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (_) => [
        _menuItem(TaskStatus.pending, '⏳ Pendiente'),
        _menuItem(TaskStatus.inProgress, '🔄 En progreso'),
        _menuItem(TaskStatus.done, '✅ Completada'),
      ],
      onSelected: onChanged,
    );
  }

  PopupMenuItem<TaskStatus> _menuItem(TaskStatus status, String label) =>
      PopupMenuItem(
        value: status,
        child: Row(
          children: [
            if (currentStatus == status)
              const Icon(Icons.check, size: 16, color: AppColors.primary)
            else
              const SizedBox(width: 16),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(
                    fontWeight: currentStatus == status
                        ? FontWeight.w600
                        : FontWeight.normal)),
          ],
        ),
      );
}

// ── Fondo de swipe ────────────────────────────────────────────────────────────

class _SwipeBackground extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  final Alignment alignment;

  const _SwipeBackground(
      {required this.color,
      required this.icon,
      required this.label,
      required this.alignment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ── Chip de prioridad ─────────────────────────────────────────────────────────

class _PriorityChip extends StatelessWidget {
  final TaskPriority priority;
  const _PriorityChip({required this.priority});

  @override
  Widget build(BuildContext context) {
    final color = TaskColorUtils.getPriorityColor(priority);
    final label = TaskColorUtils.getPriorityLabel(priority);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.w700, color: color)),
    );
  }
}