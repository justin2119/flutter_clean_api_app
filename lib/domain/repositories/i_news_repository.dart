import 'package:fpdart/fpdart.dart';
import '../../core/error/failures.dart';
import '../entities/article.dart';
import 'news_repository.dart';

abstract class INewsRepository implements NewsRepository {
  @override
  Future<Either<Failure, List<Article>>> getLatestNews();
}
