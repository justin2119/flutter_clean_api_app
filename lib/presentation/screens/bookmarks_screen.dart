import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/bookmarks_provider.dart';
import '../widgets/article_list_item.dart';
import 'detail_screen.dart';

class BookmarksScreen extends ConsumerWidget { const BookmarksScreen({super.key}); @override Widget build(BuildContext context, WidgetRef ref) { final saved = ref.watch(bookmarksNotifierProvider); return Scaffold(backgroundColor: const Color(0xFF263238), appBar: AppBar(title: Text('Bookmarks', style: GoogleFonts.abel())), body: saved.when(loading: () => const Center(child: CircularProgressIndicator()), error: (_, __) => const Center(child: Text('Unable to load bookmarks')), data: (articles) => articles.isEmpty ? Center(child: Text('No saved articles', style: GoogleFonts.abel(color: Colors.white70))) : ListView.builder(itemCount: articles.length, itemBuilder: (_, i) { final article = articles[i]; return Dismissible(key: ValueKey(article.url), onDismissed: (_) => ref.read(bookmarksNotifierProvider.notifier).remove(article), child: ListTile(title: Text(article.title, style: GoogleFonts.abel(color: Colors.white)), trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent), onPressed: () => ref.read(bookmarksNotifierProvider.notifier).remove(article)), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(article: article)))) ; })); } }
