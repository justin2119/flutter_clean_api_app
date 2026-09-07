import 'package:fpdart/fpdart.dart';
import '../../core/error/failures.dart';
import '../entities/article.dart';

abstract class NewsRepository {
  Future<Either<Failure, List<Article>>> getLatestNews();
}
