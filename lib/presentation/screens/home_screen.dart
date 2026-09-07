import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/news_provider.dart';
import '../providers/bookmarks_provider.dart';
import '../widgets/article_list_item.dart';
import 'detail_screen.dart';

class HomeScreen extends ConsumerStatefulWidget { const HomeScreen({super.key}); @override ConsumerState<HomeScreen> createState() => _HomeScreenState(); }
class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scroll = ScrollController();
  @override void initState() { super.initState(); _scroll.addListener(() { if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 300) ref.read(newsNotifierProvider.notifier).loadMore(); }); }
  @override void dispose() { _scroll.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) {
    final news = ref.watch(newsNotifierProvider);
    return Scaffold(backgroundColor: const Color(0xFF263238), appBar: AppBar(title: Text('News', style: GoogleFonts.abel()), actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: () => ref.read(newsNotifierProvider.notifier).refresh())]), body: news.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Unable to load articles', style: GoogleFonts.abel(color: Colors.white))),
      data: (articles) => RefreshIndicator(onRefresh: () => ref.read(newsNotifierProvider.notifier).refresh(), child: ListView.builder(controller: _scroll, itemCount: articles.length + 1, itemBuilder: (_, i) { if (i == articles.length) return ref.read(newsNotifierProvider.notifier).isLoadingMore ? const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator())) : const SizedBox(height: 24); final article = articles[i]; return Row(children: [Expanded(child: InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(article: article))), child: ArticleListItem(article: article))), Consumer(builder: (_, ref, __) { final saved = ref.watch(bookmarksNotifierProvider).valueOrNull?.any((item) => item.url == article.url) ?? false; return IconButton(icon: Icon(saved ? Icons.bookmark : Icons.bookmark_border, color: const Color(0xFF4CAF50)), onPressed: () => ref.read(bookmarksNotifierProvider.notifier).toggleBookmark(article)); })]); })),
    ));
  }
}
