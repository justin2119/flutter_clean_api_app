// Riverpod fournit AsyncNotifier et AsyncNotifierProvider pour gérer un état asynchrone.
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Article est le modèle métier contenu dans l'état réactif de l'écran.
import '../../domain/entities/article.dart';
// INewsRepository est le contrat abstrait consommé par ce cas d'utilisation.
import '../../domain/repositories/i_news_repository.dart';
// NewsApiClient est la dépendance réseau injectée dans l'implémentation du dépôt.
import '../../data/datasources/news_api_client.dart';
// NewsRepositoryImpl relie l'API et le cache Hive tout en respectant le contrat.
import '../../data/repositories/news_repository_impl.dart';
// Either, Left et Right permettent de traiter explicitement succès et échec.
import 'package:fpdart/fpdart.dart';

// Riverpod crée ce notifier à la demande et le rend observable par les widgets.
// Le second paramètre List<Article> signifie que la donnée finale exposée est une liste.
// AsyncNotifier ajoute automatiquement les états AsyncLoading, AsyncData et AsyncError.
final newsNotifierProvider = AsyncNotifierProvider<NewsNotifier, List<Article>>(() => NewsNotifier());

// Orchestrateur de l'état des actualités dans l'interface Flutter.
// Les widgets peuvent écouter ce notifier et se reconstruire lorsque state change.
class NewsNotifier extends AsyncNotifier<List<Article>> {
  // Le type d'interface protège le domaine contre un choix technique particulier.
  // NewsRepositoryImpl sera injecté dans build, mais utilisé à travers INewsRepository.
  late final INewsRepository _repo;

  // Riverpod appelle build pour préparer la valeur initiale du provider.
  @override
  Future<List<Article>> build() async {
    // Construit la source réseau ; ses timeouts de 30 secondes sont définis dans NewsApiClient.
    // Ce fichier ne les remplace pas et ne les affaiblit donc pas.
    final apiClient = NewsApiClient();
    // L'injection transmet uniquement le client au repository.
    // Le repository retrouve lui-même sa boîte Hive interne : aucune boîte n'est dupliquée ici.
    _repo = NewsRepositoryImpl(apiClient);
    // Le dépôt renvoie Either<Failure, List<Article>>, pas directement une liste.
    // fold reçoit d'abord la fonction Left, puis la fonction Right.
    return await _repo.getLatestNews().fold(
      // Left contient l'erreur métier ; on la transforme en exception pour AsyncNotifier.
      // L'exception sera capturée par Riverpod et convertie en état AsyncError.
      (failure) => throw Exception(failure.message),
      // Right contient la liste valide que build doit exposer comme List<Article>.
      (articles) => articles,
    );
  }

  // Recharge les actualités et met à jour l'état réactif observé par les widgets.
  Future<void> refresh() async {
    // AsyncLoading indique visuellement qu'une nouvelle requête est en cours.
    state = const AsyncLoading();
    try {
      // Même traitement Either : fold sépare proprement Left et Right.
      final fresh = await _repo.getLatestNews().fold(
        // Une Failure devient une exception capturée par le catch ci-dessous.
        (failure) => throw Exception(failure.message),
        // En cas de Right, la liste devient la nouvelle donnée de l'interface.
        (articles) => articles,
      );
      // AsyncData publie la liste réussie aux widgets abonnés.
      state = AsyncData(fresh);
    } catch (e, st) {
      // Toute exception issue d'un Left ou toute autre erreur devient AsyncError.
      state = AsyncError(e, st);
    }
  }
}
