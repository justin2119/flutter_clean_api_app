import 'package:dio/dio.dart';
import '../../domain/entities/article.dart';
import '../../core/config/env_config.dart';

class NewsApiClient {
  final Dio _dio;
  static const _defaultBaseUrl = 'https://newsapi.org/v2';
  final String _baseUrl;
  final String _apiKey;

  NewsApiClient()
      : _dio = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        )),
        _baseUrl = EnvConfig.newsApiUrl.isNotEmpty ? EnvConfig.newsApiUrl : _defaultBaseUrl,
        _apiKey = EnvConfig.newsApiKey.isNotEmpty ? EnvConfig.newsApiKey : '';

  Future<List<Article>> fetchTopHeadlines({String country = 'us'}) async {
    final response = await _dio.get('$_baseUrl/top-headlines', queryParameters: {
      'country': country,
      'apiKey': _apiKey,
    });
    final List articlesJson = response.data['articles'] as List;
    return articlesJson.map((e) => Article.fromJson(e as Map<String, dynamic>)).toList();
  }
}
