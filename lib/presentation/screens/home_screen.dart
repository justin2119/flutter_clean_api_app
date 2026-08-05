import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/usecases/get_latest_news.dart';
import '../widgets/article_list_item.dart';
import 'detail_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(newsNotifierProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF263238),
      appBar: AppBar(
        title: Text('News', style: GoogleFonts.abel()),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => ref.read(newsNotifierProvider.notifier).refresh(),
          ),
        ],
      ),
      body: newsAsync.when(
        data: (articles) => Column(
          children: [
            if (articles.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No articles available', style: TextStyle(color: Colors.white70)),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: articles.length,
                itemBuilder: (ctx, i) => GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailScreen(article: articles[i]))),
                  child: ArticleListItem(article: articles[i]),
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.white))),
      ),
    );
  }
}
