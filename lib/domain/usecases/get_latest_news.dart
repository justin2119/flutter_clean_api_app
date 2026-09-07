import 'package:fpdart/fpdart.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/article.dart';
import '../repositories/news_repository.dart';

class GetLatestNews implements UseCase<List<Article>, NoParams> {
  final NewsRepository repository;
  GetLatestNews(this.repository);
  @override
  Future<Either<Failure, List<Article>>> call(NoParams params) => repository.getLatestNews();
}
