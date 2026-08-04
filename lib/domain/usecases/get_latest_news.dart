import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/article.dart';
import '../../domain/repositories/news_repository.dart';
import '../../data/datasources/news_api_client.dart';
import '../../data/repositories/news_repository_impl.dart';
import 'package:dio/dio.dart';

/// Riverpod AsyncNotifier that provides the latest list of articles.
final newsNotifierProvider = AsyncNotifierProvider<NewsNotifier, List<Article>>(() => NewsNotifier());

class NewsNotifier extends AsyncNotifier<List<Article>> {
  late final NewsRepository _repo;

  @override
  Future<List<Article>> build() async {
    final apiClient = NewsApiClient();
    final box = await Hive.openBox<Article>('articles_box');
    _repo = NewsRepositoryImpl(apiClient, box);
    return await _repo.getLatestNews();
  }

  /// Refresh the news from the remote API and update the cache.
  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      final fresh = await _repo.getLatestNews();
      state = AsyncData(fresh);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
