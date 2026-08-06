// Fournit le coffre-fort natif de la plateforme (Keychain, Keystore, etc.).
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// Importe le contrat que cette classe doit implémenter.
import 'i_secure_storage_service.dart';

// Adaptateur concret entre notre contrat et FlutterSecureStorage.
class SecureStorageService implements ISecureStorageService {
  // Instance privée du coffre-fort sécurisé.
  final FlutterSecureStorage _storage;

  // Initialise le coffre avec sa configuration constante par défaut.
  SecureStorageService() : _storage = const FlutterSecureStorage();

  // Écrit une donnée protégée ; await attend la fin de l'opération native.
  @override
  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  // Lit une donnée ; String? autorise null si la clé est absente.
  @override
  Future<String?> read({required String key}) async {
    return await _storage.read(key: key);
  }

  // Supprime une donnée du stockage sécurisé.
  @override
  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }
}
