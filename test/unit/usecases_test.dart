import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import '../../lib/core/error/failures.dart';
import '../../lib/domain/entities/article.dart';
import '../../lib/domain/repositories/i_news_repository.dart';
import '../../lib/domain/usecases/get_latest_news.dart';

class _Repo implements INewsRepository {
  final Either<Failure, List<Article>> value;
  _Repo(this.value);
  @override Future<Either<Failure, List<Article>>> getLatestNews() async => value;
}
void main() {
  test('GetLatestNews returns repository articles unchanged', () async {
    final article = Article(title: 'headline', url: 'https://example.com');
    final result = await GetLatestNews(_Repo(right([article])))();
    expect(result.getOrElse((_) => const []), [article]);
  });
  test('GetLatestNews propagates failures', () async {
    final failure = const NetworkFailure('offline');
    final result = await GetLatestNews(_Repo(left(failure)))();
    expect(result.match((value) => value.message, (_) => ''), 'offline');
  });
}
