// AsyncNotifier et AsyncNotifierProvider représentent un état asynchrone Riverpod.
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Hive fournit le cache local des articles.
import 'package:hive/hive.dart';
// Entité métier affichée par l'application.
import '../../domain/entities/article.dart';
// Contrat du dépôt utilisé par ce cas d'utilisation.
import '../../domain/repositories/news_repository.dart';
// Source de données distante.
import '../../data/datasources/news_api_client.dart';
// Implémentation concrète du dépôt.
import '../../data/repositories/news_repository_impl.dart';
// Import conservé tel quel pour la gestion des appels réseau dans ce fichier.
import 'package:dio/dio.dart';

// Provider global : Riverpod crée et suit un NewsNotifier quand l'interface le demande.
// Il expose une liste accompagnée d'états loading, data ou error.
final newsNotifierProvider = AsyncNotifierProvider<NewsNotifier, List<Article>>(() => NewsNotifier());

// Orchestrateur de l'état des actualités dans l'interface Flutter.
class NewsNotifier extends AsyncNotifier<List<Article>> {
  // late signifie que le dépôt sera initialisé avant sa première utilisation.
  late final NewsRepository _repo;

  // build est appelé par Riverpod pour initialiser la valeur du provider.
  @override
  Future<List<Article>> build() async {
    // Prépare le client de l'API distante.
    final apiClient = NewsApiClient();
    // Ouvre la boîte locale utilisée ici comme cache.
    final box = await Hive.openBox<Article>('articles_box');
    // Assemble les dépendances avant de demander les données au dépôt.
    _repo = NewsRepositoryImpl(apiClient, box);
    return await _repo.getLatestNews();
  }

  // Recharge les informations et actualise l'état observé par les widgets.
  Future<void> refresh() async {
    // Informe l'interface qu'une nouvelle opération est en cours.
    state = const AsyncLoading();
    try {
      // Demande les dernières données au dépôt.
      final fresh = await _repo.getLatestNews();
      // AsyncData contient une valeur prête à afficher.
      state = AsyncData(fresh);
    } catch (e, st) {
      // AsyncError conserve l'erreur et sa stack trace pour le diagnostic.
      state = AsyncError(e, st);
    }
  }
}
