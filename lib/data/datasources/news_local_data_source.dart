import 'dart:convert';
import 'package:hive/hive.dart';
import '../../core/error/exceptions.dart';
import '../models/article_model.dart';

abstract class NewsLocalDataSource { Future<List<ArticleModel>> getCachedNews(); Future<void> cacheNews(List<ArticleModel> articles); }
class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  final Box<String> box;
  NewsLocalDataSourceImpl(this.box);
  @override
  Future<List<ArticleModel>> getCachedNews() async { final raw = box.get('latest'); if (raw == null) throw const CacheException(); try { return (jsonDecode(raw) as List).map((e) => ArticleModel.fromJson(Map<String, dynamic>.from(e))).toList(); } catch (_) { throw const CacheException(); } }
  @override
  Future<void> cacheNews(List<ArticleModel> articles) async => box.put('latest', jsonEncode(articles.map((e) => e.toJson()).toList()));
}
