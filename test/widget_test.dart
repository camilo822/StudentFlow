//import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studentflow/app.dart';
import 'package:studentflow/data/services/local_storage_service.dart';

/// Helper: devuelve un LocalStorageService con valores pre-cargados
Future<LocalStorageService> _storageWith({bool onboarded = false}) async {
  SharedPreferences.setMockInitialValues(
    onboarded ? {'is_onboarded': true, 'user_name': 'Camilo', 'group_name': 'Grupo Test'} : {},
  );
  return LocalStorageService.getInstance();
}

void main() {
  setUp(() {
    // Resetea el singleton entre tests
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Usuario nuevo ve WelcomeScreen', (tester) async {
    final storage = await _storageWith(onboarded: false);
    await tester.pumpWidget(StudentFlowApp(storage: storage));
    await tester.pumpAndSettle();

    expect(find.text('StudentFlow'), findsOneWidget);
    expect(find.text('Crear nuevo grupo'), findsOneWidget);
    expect(find.text('Unirse con código'), findsOneWidget);
  });

  testWidgets('Usuario existente va directo a HomeScreen', (tester) async {
    final storage = await _storageWith(onboarded: true);
    await tester.pumpWidget(StudentFlowApp(storage: storage));
    await tester.pumpAndSettle();

    expect(find.text('¡Hola, Camilo! 👋'), findsOneWidget);
  });

  testWidgets('WelcomeScreen navega a CreateGroupScreen', (tester) async {
    final storage = await _storageWith(onboarded: false);
    await tester.pumpWidget(StudentFlowApp(storage: storage));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Crear nuevo grupo'));
    await tester.pumpAndSettle();

    expect(find.text('Nuevo grupo'), findsOneWidget);
  });

  testWidgets('WelcomeScreen navega a JoinGroupScreen', (tester) async {
    final storage = await _storageWith(onboarded: false);
    await tester.pumpWidget(StudentFlowApp(storage: storage));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Unirse con código'));
    await tester.pumpAndSettle();

    expect(find.text('Unirse al grupo'), findsOneWidget);
  });

  testWidgets('HomeScreen muestra tarjetas de resumen', (tester) async {
    final storage = await _storageWith(onboarded: true);
    await tester.pumpWidget(StudentFlowApp(storage: storage));
    await tester.pumpAndSettle();

    expect(find.text('Urgentes'), findsOneWidget);
    expect(find.text('Pendientes'), findsOneWidget);
    expect(find.text('Listas'), findsOneWidget);
  });
}