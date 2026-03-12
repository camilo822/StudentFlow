import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/tasks/screens/home_screen.dart';

class StudentFlowApp extends StatelessWidget {
  const StudentFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudentFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}