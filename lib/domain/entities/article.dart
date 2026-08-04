import 'package:hive/hive.dart';

part 'article.g.dart';

@HiveType(typeId: 0)
class Article extends HiveObject {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String? description;
  @HiveField(2)
  final String url;
  @HiveField(3)
  final String? urlToImage;
  @HiveField(4)
  final DateTime? publishedAt;
  @HiveField(5)
  final String? content;
  @HiveField(6)
  final String? source;

  Article({
    required this.title,
    this.description,
    required this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
    this.source,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        title: json['title'] as String,
        description: json['description'] as String?,
        url: json['url'] as String,
        urlToImage: json['urlToImage'] as String?,
        publishedAt: json['publishedAt'] != null ? DateTime.parse(json['publishedAt'] as String) : null,
        content: json['content'] as String?,
        source: json['source'] != null ? (json['source'] as Map)['name'] as String? : null,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'url': url,
        'urlToImage': urlToImage,
        'publishedAt': publishedAt?.toIso8601String(),
        'content': content,
        'source': source,
      };
}
