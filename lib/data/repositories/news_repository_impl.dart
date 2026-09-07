import 'package:fpdart/fpdart.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/article.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_local_data_source.dart';
import '../datasources/news_remote_data_source.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  final NewsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  NewsRepositoryImpl({required this.remoteDataSource, required this.localDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, List<Article>>> getLatestNews() async {
    if (await networkInfo.isConnected) {
      try { final articles = await remoteDataSource.getLatestNews(); await localDataSource.cacheNews(articles); return Right(articles); }
      on ServerException { return _cached(); }
    }
    return _cached();
  }
  Future<Either<Failure, List<Article>>> _cached() async { try { return Right(await localDataSource.getCachedNews()); } on CacheException { return const Left(CacheFailure()); } }
}
