import 'dart:io';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/article.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_api_client.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsApiClient _client;
  final Box<Article> _box;

  NewsRepositoryImpl(this._client, this._box);

  @override
  Future<List<Article>> getLatestNews() async {
    try {
      final remote = await _client.fetchTopHeadlines();
      await _box.clear();
      for (var article in remote) {
        await _box.add(article);
      }
      return remote;
    } on DioException catch (_) {
      // Network error – fall back to cache
      return _box.values.toList();
    } on SocketException catch (_) {
      // Offline – fall back to cache
      return _box.values.toList();
    }
  }
}
