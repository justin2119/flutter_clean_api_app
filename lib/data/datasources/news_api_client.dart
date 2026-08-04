import 'package:dio/dio.dart';
import '../../domain/entities/article.dart';

class NewsApiClient {
  final Dio _dio;
  NewsApiClient(this._dio);

  /// Fetch latest news from NewsAPI (replace with your API key).
  Future<List<Article>> fetchLatestNews() async {
    const url = 'https://newsapi.org/v2/top-headlines?country=us';
    final response = await _dio.get(url, queryParameters: {
      'apiKey': const String.fromEnvironment('NEWS_API_KEY'),
    }).timeout(const Duration(seconds: 30));
    final List articlesJson = response.data['articles'] as List;
    return articlesJson.map((json) => Article.fromJson(json)).toList();
  }
}
