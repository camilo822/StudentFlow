import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../data/models/task_model.dart';
import '../../../data/repositories/task_repository.dart';
import '../../../data/services/local_storage_service.dart';
import '../widgets/task_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TaskStatus? _activeFilter;
  String _userName = '';
  String _groupName = '';
  String _groupId = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final storage = await LocalStorageService.getInstance();
    setState(() {
      _userName = storage.userName ?? 'Estudiante';
      _groupName = storage.groupName ?? '';
      _groupId = storage.groupId ?? '';
    });
  }

  List<TaskModel> _applyFilter(List<TaskModel> tasks) {
    if (_activeFilter == null) return tasks;
    return tasks.where((t) => t.status == _activeFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Si todavía no cargó el groupId, muestra un loader
    if (_groupId.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        // ── StreamBuilder: escucha Firestore en tiempo real ─────────────────
        child: StreamBuilder<List<TaskModel>>(
          stream: TaskRepository.instance.watchTasks(_groupId),
          builder: (context, snapshot) {
            // ── Estados del stream ─────────────────────────────────────────
            if (snapshot.hasError) {
              return _ErrorState(message: snapshot.error.toString());
            }

            final allTasks = snapshot.data ?? [];
            final tasks = _applyFilter(allTasks);

            final urgentCount = allTasks
                .where((t) =>
                    (t.isUrgent || t.isOverdue) &&
                    t.status != TaskStatus.done)
                .length;
            final pendingCount = allTasks
                .where((t) => t.status == TaskStatus.pending)
                .length;
            final doneCount =
                allTasks.where((t) => t.status == TaskStatus.done).length;

            return CustomScrollView(
              slivers: [
                // ── Header ──────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '¡Hola, $_userName! 👋',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(fontSize: 22),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Text(
                                      _groupName,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary),
                                    ),
                                    // Indicador de conexión en tiempo real
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) ...[
                                      const SizedBox(width: 6),
                                      const SizedBox(
                                        width: 8,
                                        height: 8,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 1.5,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ] else ...[
                                      const SizedBox(width: 6),
                                      Container(
                                        width: 7,
                                        height: 7,
                                        decoration: const BoxDecoration(
                                          color: AppColors.statusSafe,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Center(
                                child: Text(
                                  _userName.isNotEmpty
                                      ? _userName[0].toUpperCase()
                                      : 'E',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // ── Tarjetas resumen ─────────────────────────────
                        Row(
                          children: [
                            _SummaryCard(
                              label: 'Urgentes',
                              count: urgentCount,
                              color: AppColors.statusUrgent,
                              lightColor: AppColors.statusUrgentLight,
                              icon: Icons.warning_amber_rounded,
                            ),
                            const SizedBox(width: 10),
                            _SummaryCard(
                              label: 'Pendientes',
                              count: pendingCount,
                              color: AppColors.primary,
                              lightColor: AppColors.primaryLight,
                              icon: Icons.assignment_outlined,
                            ),
                            const SizedBox(width: 10),
                            _SummaryCard(
                              label: 'Listas',
                              count: doneCount,
                              color: AppColors.statusSafe,
                              lightColor: AppColors.statusSafeLight,
                              icon: Icons.check_circle_outline,
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // ── Chips de filtro ──────────────────────────────
                        Text('Mis Tareas',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _FilterChip(
                                label: 'Todas',
                                isActive: _activeFilter == null,
                                onTap: () =>
                                    setState(() => _activeFilter = null),
                              ),
                              const SizedBox(width: 8),
                              _FilterChip(
                                label: 'Pendientes',
                                isActive:
                                    _activeFilter == TaskStatus.pending,
                                onTap: () => setState(
                                    () => _activeFilter = TaskStatus.pending),
                              ),
                              const SizedBox(width: 8),
                              _FilterChip(
                                label: 'En progreso',
                                isActive:
                                    _activeFilter == TaskStatus.inProgress,
                                onTap: () => setState(() =>
                                    _activeFilter = TaskStatus.inProgress),
                              ),
                              const SizedBox(width: 8),
                              _FilterChip(
                                label: 'Completadas',
                                isActive: _activeFilter == TaskStatus.done,
                                onTap: () => setState(
                                    () => _activeFilter = TaskStatus.done),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),

                // ── Lista de tareas ──────────────────────────────────────
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  sliver: tasks.isEmpty
                      ? const SliverToBoxAdapter(child: _EmptyState())
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => TaskCard(
                              task: tasks[index],
                              onStatusChanged: (newStatus) async {
                                await TaskRepository.instance.updateStatus(
                                  _groupId,
                                  tasks[index].id,
                                  newStatus,
                                );
                              },
                              onDelete: tasks[index].createdBy == _userName
                                  ? () async {
                                      await TaskRepository.instance
                                          .deleteTask(
                                              _groupId, tasks[index].id);
                                    }
                                  : null,
                            ),
                            childCount: tasks.length,
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRouter.taskForm),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nueva tarea',
            style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

// ── Widgets auxiliares ────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final Color lightColor;
  final IconData icon;
  const _SummaryCard(
      {required this.label,
      required this.count,
      required this.color,
      required this.lightColor,
      required this.icon});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: lightColor, borderRadius: BorderRadius.circular(16)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(count.toString(),
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.w700, color: color)),
            Text(label,
                style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500)),
          ]),
        ),
      );
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _FilterChip(
      {required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isActive
                  ? AppColors.primary
                  : AppColors.textSecondary.withOpacity(0.3),
            ),
          ),
          child: Text(label,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : AppColors.textSecondary)),
        ),
      );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(children: [
          Icon(Icons.assignment_turned_in_outlined,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.4)),
          const SizedBox(height: 16),
          const Text('¡Todo al día! 🎉',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          const Text('No hay tareas en esta categoría.',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
        ]),
      );
}

class _ErrorState extends StatelessWidget {
  final String message;
  const _ErrorState({required this.message});
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.cloud_off_rounded,
                size: 56, color: AppColors.statusUrgent),
            const SizedBox(height: 16),
            const Text('Sin conexión',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary)),
          ]),
        ),
      );
}