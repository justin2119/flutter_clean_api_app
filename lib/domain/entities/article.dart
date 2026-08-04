import 'package:hive/hive.dart';

part 'article.g.dart';

@HiveType(typeId: 0)
class Article {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String? description;
  @HiveField(2)
  final String? content;
  @HiveField(3)
  final String url;
  @HiveField(4)
  final String? urlToImage;

  Article({required this.title, this.description, this.content, required this.url, this.urlToImage});

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        title: json['title'] as String,
        description: json['description'] as String?,
        content: json['content'] as String?,
        url: json['url'] as String,
        urlToImage: json['urlToImage'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'content': content,
        'url': url,
        'urlToImage': urlToImage,
      };
}
