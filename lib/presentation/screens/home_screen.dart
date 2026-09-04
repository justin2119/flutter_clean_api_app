import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/news_provider.dart';
import '../widgets/article_list_item.dart';
import 'detail_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  @override Widget build(BuildContext context, WidgetRef ref) {
    final news = ref.watch(newsNotifierProvider);
    return Scaffold(backgroundColor: const Color(0xFF263238), appBar: AppBar(title: Text('News', style: GoogleFonts.abel()), actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: () => ref.invalidate(newsNotifierProvider))]), body: news.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Text('Unable to load articles', style: GoogleFonts.abel(color: Colors.white)), const SizedBox(height: 12), TextButton(onPressed: () => ref.invalidate(newsNotifierProvider), child: Text('Retry', style: GoogleFonts.abel()))])),
      data: (articles) => articles.isEmpty ? Center(child: Text('No articles available', style: GoogleFonts.abel(color: Colors.white70))) : ListView.builder(itemCount: articles.length, itemBuilder: (_, i) => InkWell(onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailScreen(article: articles[i]))), child: ArticleListItem(article: articles[i]))),
    ));
  }
}
