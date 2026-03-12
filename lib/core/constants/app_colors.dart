import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Colores base
  static const Color primary = Color(0xFF6C63FF);       // Morado principal
  static const Color primaryLight = Color(0xFFEEEDFF);
  static const Color secondary = Color(0xFF43C6AC);     // Verde agua

  // Fondo
  static const Color background = Color(0xFFF5F6FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E2E);
  static const Color backgroundDark = Color(0xFF13131F);

  // Texto
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textPrimaryDark = Color(0xFFF1F1F5);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);

  // ── Colores de estado de tarea ──────────────────────────────────────────────

  /// Verde: tarea con más de 3 días de plazo
  static const Color statusSafe = Color(0xFF22C55E);
  static const Color statusSafeLight = Color(0xFFDCFCE7);

  /// Amarillo: 2-3 días restantes
  static const Color statusWarning = Color(0xFFF59E0B);
  static const Color statusWarningLight = Color(0xFFFEF3C7);

  /// Rojo: vence hoy o mañana (URGENTE)
  static const Color statusUrgent = Color(0xFFEF4444);
  static const Color statusUrgentLight = Color(0xFFFEE2E2);

  /// Gris: tarea vencida
  static const Color statusOverdue = Color(0xFF6B7280);
  static const Color statusOverdueLight = Color(0xFFF3F4F6);

  /// Azul: tarea completada
  static const Color statusDone = Color(0xFF3B82F6);
  static const Color statusDoneLight = Color(0xFFDBEAFE);

  // Prioridades
  static const Color priorityLow = Color(0xFF22C55E);
  static const Color priorityMedium = Color(0xFFF59E0B);
  static const Color priorityHigh = Color(0xFFEF4444);
}