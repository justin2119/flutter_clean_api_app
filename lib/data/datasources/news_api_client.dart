// Dio est un client HTTP : il envoie des requêtes vers une API distante.
import 'package:dio/dio.dart';
// Article est l'objet métier dans lequel nous transformons les données JSON.
import '../../domain/entities/article.dart';
// Centralise les URL et clés fournies par l'environnement.
import '../../core/config/env_config.dart';
// Ajoute automatiquement le jeton d'authentification aux requêtes si nécessaire.
import '../../core/network/auth_interceptor.dart';

// Cette classe appartient à la couche data : elle parle directement à NewsAPI.
class NewsApiClient {
  // Client Dio configuré pour effectuer les appels réseau.
  final Dio _dio;
  // Adresse de secours utilisée si aucune URL personnalisée n'est configurée.
  static const _defaultBaseUrl = 'https://newsapi.org/v2';
  // Adresse réellement utilisée par les requêtes.
  final String _baseUrl;
  // Clé d'accès à NewsAPI.
  final String _apiKey;

  // Le constructeur configure Dio et ses options avant tout appel.
  NewsApiClient()
      : _dio = Dio(BaseOptions(
          // Chaque opération réseau peut attendre au maximum 30 secondes.
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        // L'intercepteur peut ajouter le JWT avant l'envoi de chaque requête.
        ))..interceptors.add(AuthInterceptor()),
        // Utilise la configuration personnalisée ou l'adresse publique de secours.
        _baseUrl = EnvConfig.newsApiUrl.isNotEmpty ? EnvConfig.newsApiUrl : _defaultBaseUrl,
        // Une clé absente devient une chaîne vide, sans modifier le comportement existant.
        _apiKey = EnvConfig.newsApiKey.isNotEmpty ? EnvConfig.newsApiKey : '';

  // Récupère les principales actualités ; le pays américain est la valeur par défaut.
  Future<List<Article>> fetchTopHeadlines({String country = 'us'}) async {
    // get construit une requête GET vers le chemin top-headlines.
    // queryParameters transforme ces valeurs en paramètres de l'URL.
    final response = await _dio.get('$_baseUrl/top-headlines', queryParameters: {
      'country': country,
      'apiKey': _apiKey,
    });
    // La réponse JSON contient une liste sous la clé articles.
    final List articlesJson = response.data['articles'] as List;
    // Chaque élément JSON devient un Article grâce à la factory fromJson.
    return articlesJson.map((e) => Article.fromJson(e as Map<String, dynamic>)).toList();
  }
}
