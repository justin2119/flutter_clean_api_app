import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/article.dart';

final bookmarksNotifierProvider = AsyncNotifierProvider<BookmarksNotifier, List<Article>>(BookmarksNotifier.new);

class BookmarksNotifier extends AsyncNotifier<List<Article>> {
  static const boxName = 'bookmarked_articles';
  Box<Article>? _box;

  @override
  Future<List<Article>> build() async {
    _box = Hive.isBoxOpen(boxName) ? Hive.box<Article>(boxName) : await Hive.openBox<Article>(boxName);
    return _box!.values.toList(growable: false);
  }

  bool isBookmarked(Article article) => (_box?.values ?? const <Article>[]).any((item) => item.url == article.url);

  Future<void> toggleBookmark(Article article) async {
    final box = _box ?? (Hive.isBoxOpen(boxName) ? Hive.box<Article>(boxName) : await Hive.openBox<Article>(boxName));
    _box = box;
    final match = box.keys.where((key) => box.get(key)?.url == article.url).toList();
    if (match.isEmpty) {
      await box.add(article);
    } else {
      await box.delete(match.first);
    }
    state = AsyncData(box.values.toList(growable: false));
  }

  Future<void> remove(Article article) => toggleBookmark(article);
}
