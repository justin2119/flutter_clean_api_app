import 'package:fpdart/fpdart.dart';
import '../../core/error/failures.dart';
import '../entities/article.dart';
import '../repositories/i_news_repository.dart';

/// Domain operation for retrieving the latest articles.
/// It depends only on the repository contract and is safe to unit test without Flutter.
class GetLatestNews {
  final INewsRepository _repository;
  const GetLatestNews(this._repository);
  Future<Either<Failure, List<Article>>> call() => _repository.getLatestNews();
}
