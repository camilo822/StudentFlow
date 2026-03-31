import 'package:flutter/material.dart';
import 'app.dart';
import 'data/services/firebase_service.dart';
import 'data/services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase y SharedPreferences en paralelo
  await Future.wait([
    FirebaseService.init(),
    LocalStorageService.getInstance(),
  ]);

  final storage = await LocalStorageService.getInstance();

  runApp(StudentFlowApp(storage: storage));
}