import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';

/// Punto único de acceso a Firestore.
/// Todas las colecciones se definen aquí como constantes.
class FirebaseService {
  FirebaseService._();

  static FirebaseFirestore get db => FirebaseFirestore.instance;

  // ── Nombres de colecciones ─────────────────────────────────────────────────
  static const String colGroups = 'groups';
  static const String colTasks = 'tasks';

  // ── Inicialización ─────────────────────────────────────────────────────────
  static Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Habilita persistencia offline: si no hay internet, la app sigue leyendo
    db.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  // ── Referencias reutilizables ──────────────────────────────────────────────

  static CollectionReference<Map<String, dynamic>> get groupsRef =>
      db.collection(colGroups);

  static CollectionReference<Map<String, dynamic>> tasksRef(String groupId) =>
      db.collection(colGroups).doc(groupId).collection(colTasks);
}