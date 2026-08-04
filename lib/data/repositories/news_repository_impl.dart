import '../../domain/entities/article.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_api_client.dart';
import 'package:hive/hive.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsApiClient apiClient;
  final Box<Article> cacheBox;

  NewsRepositoryImpl({required this.apiClient, required this.cacheBox});

  @override
  Future<List<Article>> getLatestNews() async {
    try {
      final remote = await apiClient.fetchLatestNews();
      // Save to cache
      await cacheBox.clear();
      for (var article in remote) {
        await cacheBox.add(article);
      }
      return remote;
    } catch (_) {
      // On error, return cached data if available
      return cacheBox.values.toList();
    }
  }
}
