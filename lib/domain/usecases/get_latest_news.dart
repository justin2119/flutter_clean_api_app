import '../../data/repositories/news_repository_impl.dart';
import '../../domain/entities/article.dart';
import '../../domain/repositories/news_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart';
import '../../data/datasources/news_api_client.dart';

final getLatestNewsProvider = AsyncNotifierProvider<GetLatestNewsNotifier, List<Article>>(() => GetLatestNewsNotifier());

class GetLatestNewsNotifier extends AsyncNotifier<List<Article>> {
  late final NewsRepository repository;

  @override
  Future<List<Article>> build() async {
    // Initialize dependencies lazily
    final dio = Dio();
    final client = NewsApiClient(dio);
    final box = await Hive.openBox<Article>('articles');
    repository = NewsRepositoryImpl(apiClient: client, cacheBox: box);
    return await repository.getLatestNews();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repository.getLatestNews());
  }
}
