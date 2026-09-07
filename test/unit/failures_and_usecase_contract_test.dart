import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import '../../lib/core/error/failures.dart';
import '../../lib/domain/entities/article.dart';
import '../../lib/domain/repositories/i_news_repository.dart';
import '../../lib/domain/usecases/get_latest_news.dart';

class _Repository implements INewsRepository {
  _Repository(this.response);
  final Either<Failure, List<Article>> response;

  @override
  Future<Either<Failure, List<Article>>> getLatestNews() async => response;
}

void main() {
  group('GetLatestNews Either contract', () {
    final article = Article(title: 'Headline', url: 'https://example.com');

    test('returns a non-empty success without transforming the entity', () async {
      final result = await GetLatestNews(_Repository(right([article])))();

      expect(result.isRight(), isTrue);
      expect(result.getOrElse((_) => const []).single, same(article));
    });

    test('preserves ServerFailure', () async {
      final failure = const ServerFailure('server unavailable');
      final result = await GetLatestNews(_Repository(left(failure)))();

      expect(result, left(failure));
    });

    test('preserves CacheFailure', () async {
      final failure = const CacheFailure('cache unavailable');
      final result = await GetLatestNews(_Repository(left(failure)))();

      expect(result, left(failure));
    });

    test('preserves NetworkFailure', () async {
      final failure = const NetworkFailure('offline');
      final result = await GetLatestNews(_Repository(left(failure)))();

      expect(result, left(failure));
    });

    test('returns an empty successful collection unchanged', () async {
      final result = await GetLatestNews(_Repository(right(const [])))();

      expect(result.isRight(), isTrue);
      expect(result.getOrElse((_) => [article]), isEmpty);
    });
  });

  group('Article JSON boundary', () {
    test('reads optional API fields without requiring them', () {
      final article = Article.fromJson({
        'title': 'Minimal',
        'url': 'https://example.com/minimal',
      });

      expect(article.title, 'Minimal');
      expect(article.url, 'https://example.com/minimal');
      expect(article.source, isNull);
      expect(article.publishedAt, isNull);
    });

    test('reads nested source and published timestamp', () {
      final article = Article.fromJson({
        'title': 'Full',
        'url': 'https://example.com/full',
        'source': {'name': 'Example News'},
        'publishedAt': '2026-01-02T03:04:05Z',
      });

      expect(article.source, 'Example News');
      expect(article.publishedAt, isNotNull);
    });
  });
}
