// Contrat abstrait décrivant les opérations de stockage sécurisé.
// Une interface sépare ce que le service sait faire de la technologie utilisée.
abstract class ISecureStorageService {
  // Écrit une valeur texte associée à une clé.
  // Future<void> signifie que l'opération se termine plus tard sans résultat.
  Future<void> write({required String key, required String value});
  // Lit la valeur d'une clé ; null signifie qu'elle n'existe pas.
  Future<String?> read({required String key});
  // Supprime la valeur liée à une clé.
  Future<void> delete({required String key});
}
