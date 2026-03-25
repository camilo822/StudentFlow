import 'package:shared_preferences/shared_preferences.dart';

/// Servicio que abstrae shared_preferences.
/// En el resto de la app NUNCA se llama SharedPreferences directamente,
/// siempre se usa esta clase.
class LocalStorageService {
  LocalStorageService._();
  static LocalStorageService? _instance;
  static late SharedPreferences _prefs;

  static Future<LocalStorageService> getInstance() async {
    if (_instance == null) {
      _prefs = await SharedPreferences.getInstance();
      _instance = LocalStorageService._();
    }
    return _instance!;
  }

  // ── Claves ────────────────────────────────────────────────────────────────
  static const _keyUserName = 'user_name';
  static const _keyGroupId = 'group_id';
  static const _keyGroupName = 'group_name';
  static const _keyGroupCode = 'group_code';
  static const _keyIsOnboarded = 'is_onboarded';

  // ── Usuario ───────────────────────────────────────────────────────────────
  String? get userName => _prefs.getString(_keyUserName);
  Future<void> setUserName(String name) => _prefs.setString(_keyUserName, name);

  // ── Grupo ─────────────────────────────────────────────────────────────────
  String? get groupId => _prefs.getString(_keyGroupId);
  String? get groupName => _prefs.getString(_keyGroupName);
  String? get groupCode => _prefs.getString(_keyGroupCode);

  Future<void> saveGroup({
    required String id,
    required String name,
    required String code,
  }) async {
    await _prefs.setString(_keyGroupId, id);
    await _prefs.setString(_keyGroupName, name);
    await _prefs.setString(_keyGroupCode, code);
  }

  // ── Onboarding ────────────────────────────────────────────────────────────
  bool get isOnboarded => _prefs.getBool(_keyIsOnboarded) ?? false;
  Future<void> completeOnboarding() => _prefs.setBool(_keyIsOnboarded, true);

  /// Limpia todo (útil para cerrar sesión)
  Future<void> clearAll() => _prefs.clear();
}