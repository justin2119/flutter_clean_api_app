import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/get_latest_news.dart';
import '../widgets/article_list_item.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(getLatestNewsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Latest News')),
      body: newsAsync.when(
        data: (articles) => ListView.builder(
          itemCount: articles.length,
          itemBuilder: (ctx, i) => ArticleListItem(article: articles[i]),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
