import 'package:hive/hive.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/article.dart';
import '../../data/datasources/news_api_client.dart';
import '../../domain/repositories/i_news_repository.dart';

/// Concrete implementation of [INewsRepository] that retrieves news from the
/// remote NewsAPI and caches the result in a Hive box named `news_articles`.
///
/// * On success, fresh articles are stored in the Hive box for offline use.
/// * On any network error (including time‑outs), the repository falls back to
///   the cached articles if they exist.
/// * All results are wrapped in an `Either<Failure, List<Article>>` using the
///   fpdart functional style.
class NewsRepositoryImpl implements INewsRepository {
  final NewsApiClient _client;
  final Box<Article> _box;

  NewsRepositoryImpl(this._client) : _box = Hive.box<Article>('news_articles');

  @override
  Future<Either<Failure, List<Article>>> getLatestNews() async {
    try {
      // Attempt to fetch fresh news from the remote API.
      final List<Article> articles = await _client.fetchTopHeadlines();

      // Cache the fresh articles for offline access.
      await _box.clear();
      await _box.addAll(articles);
      return Right(articles);
    } on DioException catch (e) {
      // Network‑related error – try to serve cached data.
      if (_box.isNotEmpty) {
        return Right(_box.values.toList());
      }
      return Left(NetworkFailure(e.message ?? 'Erreur réseau'));
    } catch (e) {
      // Any other unexpected error.
      return Left(UnknownFailure(e.toString()));
    }
  }
}
