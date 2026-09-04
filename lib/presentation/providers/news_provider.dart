import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/article.dart';
import '../../domain/repositories/i_news_repository.dart';
import '../../data/datasources/news_api_client.dart';
import '../../data/repositories/news_repository_impl.dart';

final newsRepositoryProvider = Provider<INewsRepository>((ref) => NewsRepositoryImpl(NewsApiClient()));
final newsNotifierProvider = AsyncNotifierProvider<NewsNotifier, List<Article>>(NewsNotifier.new);
class NewsNotifier extends AsyncNotifier<List<Article>> {
  late INewsRepository _repo;
  @override Future<List<Article>> build() async { _repo = ref.watch(newsRepositoryProvider); return (await _repo.getLatestNews()).fold((failure) => throw StateError(failure.message), (articles) => articles); }
  Future<void> refresh() async { state = const AsyncLoading(); state = await AsyncValue.guard(build); }
}
