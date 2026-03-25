import 'package:flutter/material.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/services/local_storage_service.dart';

class StudentFlowApp extends StatelessWidget {
  final LocalStorageService storage;

  const StudentFlowApp({super.key, required this.storage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudentFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      initialRoute: AppRouter.initialRoute(storage),
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}