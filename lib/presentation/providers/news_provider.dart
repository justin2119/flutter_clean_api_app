import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/article.dart';
import '../../domain/repositories/news_repository.dart';
import '../../data/datasources/news_api_client.dart';

final newsRepositoryProvider = Provider<NewsRepository>((ref) => _ApiNewsRepository(NewsApiClient()));
final newsNotifierProvider = AsyncNotifierProvider<NewsNotifier, List<Article>>(NewsNotifier.new);

class _ApiNewsRepository implements NewsRepository {
  final NewsApiClient client;
  _ApiNewsRepository(this.client);
  @override
  Future<Either<Failure, List<Article>>> getLatestNews() async {
    try {
      return Right(await client.fetchTopHeadlines());
    } catch (e) {
      return Left(NetworkFailure([e.toString()]));
    }
  }
}

class NewsNotifier extends AsyncNotifier<List<Article>> {
  late NewsRepository _repo;
  int page = 0;
  bool hasMore = true;
  bool isLoadingMore = false;

  @override
  Future<List<Article>> build() async {
    _repo = ref.watch(newsRepositoryProvider);
    page = 0;
    hasMore = true;
    return _fetchPage();
  }

  Future<List<Article>> _fetchPage() async {
    final result = await _repo.getLatestNews();
    return result.fold((failure) => throw StateError(failure.toString()), (items) {
      final current = state.valueOrNull ?? <Article>[];
      final existing = current.map((article) => article.url).toSet();
      final fresh = items.where((article) => !existing.contains(article.url)).toList();
      if (fresh.isEmpty && page > 0) hasMore = false;
      page++;
      return [...current, ...fresh];
    });
  }

  Future<void> loadMore() async {
    if (isLoadingMore || !hasMore || state.isLoading) return;
    isLoadingMore = true;
    state = await AsyncValue.guard(_fetchPage);
    isLoadingMore = false;
  }

  Future<void> refresh() async {
    page = 0;
    hasMore = true;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final result = await _repo.getLatestNews();
      return result.fold((failure) => throw StateError(failure.toString()), (items) {
        page = 1;
        return items;
      });
    });
  }
}
