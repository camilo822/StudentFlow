import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/group_model.dart';
import '../services/firebase_service.dart';

class GroupRepository {
  GroupRepository._();
  static final GroupRepository instance = GroupRepository._();

  // ── Crear grupo ────────────────────────────────────────────────────────────

  /// Crea el grupo en Firestore y devuelve el modelo con el ID asignado
  Future<GroupModel> createGroup({
    required String name,
    required String code,
    required String createdBy,
  }) async {
    final group = GroupModel(
      id: '',
      name: name,
      code: code.toUpperCase(),
      memberIds: [createdBy],
      createdBy: createdBy,
      createdAt: DateTime.now(),
    );

    final ref =
        await FirebaseService.groupsRef.add(group.toFirestore());

    return group.copyWith(id: ref.id);
  }

  // ── Buscar por código ──────────────────────────────────────────────────────

  /// Busca un grupo por su código de invitación.
  /// Devuelve null si no existe.
  Future<GroupModel?> findByCode(String code) async {
    final snapshot = await FirebaseService.groupsRef
        .where('code', isEqualTo: code.toUpperCase())
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    final doc = snapshot.docs.first;
    return GroupModel.fromFirestore(
        doc as DocumentSnapshot<Map<String, dynamic>>);
  }

  // ── Unirse a un grupo ──────────────────────────────────────────────────────

  /// Agrega el userId al array memberIds del grupo
  Future<void> joinGroup({
    required String groupId,
    required String userId,
  }) async {
    await FirebaseService.groupsRef.doc(groupId).update({
      'memberIds': FieldValue.arrayUnion([userId]),
    });
  }

  // ── Leer grupo ─────────────────────────────────────────────────────────────

  Future<GroupModel?> fetchGroup(String groupId) async {
    final doc = await FirebaseService.groupsRef.doc(groupId).get();
    if (!doc.exists) return null;
    return GroupModel.fromFirestore(doc);
  }
}