// Importe l'entité métier utilisée par le contrat.
import '../entities/article.dart';

// Contrat abstrait simple pour récupérer des actualités.
// Il appartient au domaine et ne connaît pas l'origine réelle des données.
abstract class NewsRepository {
  // Future signifie que la liste sera disponible après une opération asynchrone.
  // Ici, le contrat expose directement une liste et non Either.
  Future<List<Article>> getLatestNews();
}
