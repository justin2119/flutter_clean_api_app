import '../entities/article.dart';
import 'news_repository.dart';

abstract class INewsRepository implements NewsRepository {
  @override
  Future<NewsResult> getLatestNews();
}
