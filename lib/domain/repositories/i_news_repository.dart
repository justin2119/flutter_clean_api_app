// Either permet au domaine de retourner explicitement un succès ou une erreur.
import 'package:fpdart/fpdart.dart';
// Types d'erreurs indépendants de la couche réseau ou du stockage.
import '../../core/error/failures.dart';
// Modèle métier retourné en cas de succès.
import '../entities/article.dart';

// Interface du dépôt d'actualités : elle décrit le besoin du domaine.
// L'implémentation peut utiliser une API, Hive, ou une autre source sans changer ce contrat.
abstract class INewsRepository {
  // Le résultat est soit Left(Failure), soit Right(List<Article>).
  // Cette approche fonctionnelle rend l'échec visible dans le type de retour.
  Future<Either<Failure, List<Article>>> getLatestNews();
}
