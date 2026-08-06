// Importe l'interface LocalStorage attendue par Supabase.
import 'package:supabase_flutter/supabase_flutter.dart';
// Importe le service qui utilise le stockage sécurisé de la plateforme.
import 'secure_storage_service.dart';

// Adaptateur : traduit les opérations LocalStorage en opérations sécurisées.
class SecureSupabaseLocalStorage implements LocalStorage {
  // Service délégué ; cette classe ne manipule pas directement le coffre natif.
  final SecureStorageService _service;

  // Reçoit le service par injection de dépendance.
  SecureSupabaseLocalStorage(this._service);

  // Supabase appelle removeItem pour effacer une session.
  // La flèche => renvoie directement le Future produit par delete.
  @override
  Future<void> removeItem(String key) async => await _service.delete(key: key);

  // Supabase appelle getItem pour relire une session sauvegardée.
  @override
  Future<String?> getItem(String key) async => await _service.read(key: key);

  // Supabase appelle setItem pour enregistrer une nouvelle session.
  @override
  Future<void> setItem(String key, String value) async => await _service.write(key: key, value: value);
}
