import 'package:fpdart/fpdart.dart';
import '../../core/error/failures.dart';
import '../entities/article.dart';

abstract class INewsRepository {
  /// Returns either a [Failure] or a list of [Article] objects.
  Future<Either<Failure, List<Article>>> getLatestNews();
}
