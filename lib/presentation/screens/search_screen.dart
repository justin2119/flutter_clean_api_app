import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/news_provider.dart';
import '../providers/bookmarks_provider.dart';
import '../widgets/article_list_item.dart';
import 'detail_screen.dart';

class SearchScreen extends ConsumerStatefulWidget { const SearchScreen({super.key}); @override ConsumerState<SearchScreen> createState() => _SearchScreenState(); }
class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _query = TextEditingController(); Timer? _debounce; String text = ''; String category = 'All';
  final categories = const ['All', 'Technology', 'Business', 'Science', 'Health', 'Sports'];
  @override void dispose() { _debounce?.cancel(); _query.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) { final source = ref.watch(newsNotifierProvider).valueOrNull ?? []; final results = source.where((a) { final hay = '${a.title} ${a.description ?? ''} ${a.content ?? ''}'.toLowerCase(); final matchesText = text.isEmpty || hay.contains(text.toLowerCase()); final matchesCategory = category == 'All' || hay.contains(category.toLowerCase()); return matchesText && matchesCategory; }).toList(); return Scaffold(backgroundColor: const Color(0xFF263238), appBar: AppBar(title: Text('Search', style: GoogleFonts.abel())), body: Column(children: [Padding(padding: const EdgeInsets.all(12), child: TextField(controller: _query, onChanged: (value) { _debounce?.cancel(); _debounce = Timer(const Duration(milliseconds: 300), () => setState(() => text = value.trim())); }, style: GoogleFonts.abel(color: Colors.white), decoration: const InputDecoration(labelText: 'Search articles', border: OutlineInputBorder(borderRadius: BorderRadius.zero)))), SizedBox(height: 52, child: ListView.separated(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 12), itemCount: categories.length, separatorBuilder: (_, __) => const SizedBox(width: 8), itemBuilder: (_, i) => ChoiceChip(label: Text(categories[i]), selected: category == categories[i], onSelected: (_) => setState(() => category = categories[i]), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)))), Expanded(child: results.isEmpty ? Center(child: Text('No matching articles', style: GoogleFonts.abel(color: Colors.white70))) : ListView.builder(itemCount: results.length, itemBuilder: (_, i) { final article = results[i]; return Row(children: [Expanded(child: InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(article: article))), child: ArticleListItem(article: article))), IconButton(icon: const Icon(Icons.bookmark_border, color: Color(0xFF4CAF50)), onPressed: () => ref.read(bookmarksNotifierProvider.notifier).toggleBookmark(article))]); }))])); }
}
