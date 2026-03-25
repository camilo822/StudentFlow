import 'package:flutter/material.dart';
import 'package:studentflow/data/services/local_storage_service.dart';
import 'package:studentflow/features/onboarding/screens/welcome_screen.dart';
import 'package:studentflow/features/onboarding/screens/create_group_screen.dart';
import 'package:studentflow/features/onboarding/screens/join_group_screen.dart';
import 'package:studentflow/features/tasks/screens/home_screen.dart';
import 'package:studentflow/features/tasks/screens/task_form_screen.dart';

class AppRouter {
  AppRouter._();

  static const String welcome = '/';
  static const String createGroup = '/create-group';
  static const String joinGroup = '/join-group';
  static const String home = '/home';
  static const String taskForm = '/task-form';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcome:
        return _fade(const WelcomeScreen());
      case createGroup:
        return _slide(const CreateGroupScreen());
      case joinGroup:
        return _slide(const JoinGroupScreen());
      case home:
        return _fade(const HomeScreen());
      case taskForm:
        return _slideUp(const TaskFormScreen());
      default:
        return _fade(const WelcomeScreen());
    }
  }

  /// Decide la ruta inicial según si el usuario ya hizo onboarding
  static String initialRoute(LocalStorageService storage) {
    return storage.isOnboarded ? home : welcome;
  }

  // ── Transiciones ──────────────────────────────────────────────────────────

  static PageRouteBuilder _fade(Widget page) => PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 300),
      );

  static PageRouteBuilder _slide(Widget page) => PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 350),
      );

  static PageRouteBuilder _slideUp(Widget page) => PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 400),
      );
}