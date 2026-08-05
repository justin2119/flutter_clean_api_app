import '../entities/article.dart';

abstract class NewsRepository {
  Future<List<Article>> getLatestNews();
}
