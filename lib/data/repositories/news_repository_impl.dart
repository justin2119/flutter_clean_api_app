// Hive fournit une base locale légère pour conserver les articles hors connexion.
import 'package:hive/hive.dart';
// DioException représente les erreurs liées aux appels HTTP.
import 'package:dio/dio.dart';
// fpdart fournit Either, Left et Right pour représenter succès ou échec.
import 'package:fpdart/fpdart.dart';

// Types d'erreurs communs de l'application.
import '../../core/error/failures.dart';
// Modèle métier manipulé par le repository.
import '../../domain/entities/article.dart';
// Source distante qui interroge NewsAPI.
import '../../data/datasources/news_api_client.dart';
// Contrat que cette implémentation doit respecter.
import '../../domain/repositories/i_news_repository.dart';

// Relie la source réseau, le cache Hive et le domaine de l'application.
class NewsRepositoryImpl implements INewsRepository {
  // Client injecté : le repository ne construit pas lui-même le réseau.
  final NewsApiClient _client;
  // Boîte Hive contenant les articles sauvegardés localement.
  final Box<Article> _box;

  // Récupère la boîte déjà ouverte pendant l'initialisation de l'application.
  NewsRepositoryImpl(this._client) : _box = Hive.box<Article>('news_articles');

  // Retourne soit une erreur, soit une liste d'articles.
  @override
  Future<Either<Failure, List<Article>>> getLatestNews() async {
    try {
      // Demande d'abord des données fraîches à l'API distante.
      final List<Article> articles = await _client.fetchTopHeadlines();

      // Remplace le cache par les données fraîchement reçues.
      await _box.clear();
      await _box.addAll(articles);
      // Right signifie que l'opération a réussi et contient des articles.
      return Right(articles);
    } on DioException catch (e) {
      // Une erreur réseau peut être un timeout, une connexion impossible ou une réponse HTTP.
      if (_box.isNotEmpty) {
        // Right reste un succès pour l'écran : les articles viennent simplement du cache.
        return Right(_box.values.toList());
      }
      // Left transporte l'échec lorsqu'aucune donnée locale n'est disponible.
      return Left(NetworkFailure(e.message ?? 'Erreur réseau'));
    } catch (e) {
      // Capture les erreurs inattendues qui ne sont pas des DioException.
      return Left(UnknownFailure(e.toString()));
    }
  }
}
