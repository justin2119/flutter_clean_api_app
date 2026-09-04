import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import '../../lib/core/error/failures.dart';
import '../../lib/domain/entities/article.dart';
import '../../lib/domain/usecases/get_latest_news.dart';
import '../../lib/domain/repositories/i_news_repository.dart';
class _FakeRepository implements INewsRepository { final Either<Failure, List<Article>> response; _FakeRepository(this.response); @override Future<Either<Failure, List<Article>>> getLatestNews() async => response; }
void main() {
  test('domain entity maps API-shaped JSON', () { final article = Article.fromJson({'title': 'Title', 'url': 'https://example.com', 'source': {'name': 'Source'}, 'publishedAt': '2026-01-02T03:04:05Z'}); expect(article.source, 'Source'); expect(article.publishedAt, isNotNull); });
  test('use case preserves a data failure', () async { final result = await GetLatestNews(_FakeRepository(left(const NetworkFailure('offline'))))(); expect(result.isLeft(), isTrue); });
  test('use case returns cached/domain data', () async { final article = Article(title: 'Cached', url: 'https://example.com'); final result = await GetLatestNews(_FakeRepository(right([article])))(); expect(result.getOrElse((_) => const []).single.title, 'Cached'); });
}
