//import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studentflow/app.dart';

void main() {
  testWidgets('HomeScreen muestra el saludo', (WidgetTester tester) async {
    await tester.pumpWidget(const StudentFlowApp());

    // Verifica que la pantalla principal carga correctamente
    expect(find.textContaining('Hola'), findsOneWidget);
  });

  testWidgets('HomeScreen muestra tarjetas de resumen', (WidgetTester tester) async {
    await tester.pumpWidget(const StudentFlowApp());

    // Las 3 tarjetas de resumen deben estar visibles
    expect(find.text('Urgentes'), findsOneWidget);
    expect(find.text('Pendientes'), findsOneWidget);
    expect(find.text('Listas'), findsOneWidget);
  });

  testWidgets('HomeScreen muestra lista de tareas', (WidgetTester tester) async {
    await tester.pumpWidget(const StudentFlowApp());

    // El FAB de nueva tarea debe estar presente
    expect(find.text('Nueva tarea'), findsOneWidget);
  });
}