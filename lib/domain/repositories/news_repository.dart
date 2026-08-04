import 'article.dart';

abstract class NewsRepository {
  Future<List<Article>> getLatestNews();
}
