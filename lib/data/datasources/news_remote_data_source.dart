import 'package:dio/dio.dart';
import '../../core/error/exceptions.dart';
import '../models/article_model.dart';

abstract class NewsRemoteDataSource { Future<List<ArticleModel>> getLatestNews(); }
class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final Dio client;
  NewsRemoteDataSourceImpl(this.client);
  @override
  Future<List<ArticleModel>> getLatestNews() async { try { final response = await client.get('/top-headlines'); final data = response.data; final values = data is Map ? data['articles'] : data; return (values as List).map((e) => ArticleModel.fromJson(Map<String, dynamic>.from(e as Map))).toList(); } on DioException catch (e) { throw ServerException(e.message); } }
}
