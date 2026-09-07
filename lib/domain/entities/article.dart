import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final String id;
  final String title;
  final String? description;
  final String url;
  final String? imageUrl;
  final DateTime? publishedAt;
  final String? source;
  final String? content;

  const Article({
    this.id = '',
    required this.title,
    this.description,
    required this.url,
    this.imageUrl,
    this.publishedAt,
    this.source,
    this.content,
  });

  String? get urlToImage => imageUrl;

  @override
  List<Object?> get props => [id, title, description, url, imageUrl, publishedAt, source, content];
}
