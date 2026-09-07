import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import '../../lib/core/error/failures.dart';
import '../../lib/domain/entities/article.dart';
import '../../lib/domain/repositories/i_news_repository.dart';

class _FakeNewsRepository implements INewsRepository {
  _FakeNewsRepository(this.result);
  final Either<Failure, List<Article>> result;
  @override
  Future<Either<Failure, List<Article>>> getLatestNews() async => result;
}

void main() {
  group('repository and datasource boundaries', () {
    test('fake remote success preserves all article fields', () async {
      final original = Article(title: 'Title', url: 'https://example.com', source: 'Source', description: 'Description', content: 'Content', publishedAt: DateTime(2026, 2, 3));
      final result = await _FakeNewsRepository(right([original])).getLatestNews();
      expect(result.isRight(), isTrue);
      expect(result.getOrElse((_) => const []).single, same(original));
    });

    test('repository boundary preserves network failures for cache fallback', () async {
      final result = await _FakeNewsRepository(left(const NetworkFailure('offline'))).getLatestNews();
      expect(result.isLeft(), isTrue);
      expect(result.match((failure) => failure.message, (_) => ''), 'offline');
    });

    test('Article deserializes nullable fields and malformed dates safely', () {
      final article = Article.fromJson({'title': 'Nullable', 'url': 'https://example.com', 'source': null, 'description': null, 'content': null, 'publishedAt': 'not-a-date'});
      expect(article.title, 'Nullable');
      expect(article.url, 'https://example.com');
      expect(article.source, isNull);
      expect(article.description, isNull);
      expect(article.content, isNull);
      expect(article.publishedAt, isNull);
    });

    test('Article round trips its JSON boundary', () {
      final original = Article(title: 'Round trip', url: 'https://example.com', source: 'Source', publishedAt: DateTime.utc(2026, 1, 1));
      final restored = Article.fromJson(original.toJson());
      expect(restored.title, original.title);
      expect(restored.url, original.url);
      expect(restored.source, original.source);
      expect(restored.publishedAt, original.publishedAt);
    });
  });
}
