import 'package:dio/dio.dart';
import '../../domain/entities/article.dart';

class NewsApiClient {
  final Dio _dio;
  static const _baseUrl = 'https://newsapi.org/v2';
  static const _apiKey = '551b4fd5d6fb4afb9982c66c99061533';

  NewsApiClient()
      : _dio = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ));

  Future<List<Article>> fetchTopHeadlines({String country = 'us'}) async {
    final response = await _dio.get('$_baseUrl/top-headlines', queryParameters: {
      'country': country,
      'apiKey': _apiKey,
    });
    final List articlesJson = response.data['articles'] as List;
    return articlesJson.map((e) => Article.fromJson(e as Map<String, dynamic>)).toList();
  }
}
