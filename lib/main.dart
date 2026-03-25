import 'package:flutter/material.dart';
import 'app.dart';
import 'data/services/local_storage_service.dart';

void main() async {
  // Necesario para inicializar plugins antes de runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Carga shared_preferences una sola vez al iniciar
  final storage = await LocalStorageService.getInstance();

  runApp(StudentFlowApp(storage: storage));
}