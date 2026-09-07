import '../../domain/entities/article.dart';

class ArticleModel extends Article {
  const ArticleModel({required super.id, required super.title, required super.description, required super.url, super.imageUrl, super.publishedAt});
  factory ArticleModel.fromJson(Map<String, dynamic> json) => ArticleModel(id: '${json['id'] ?? json['url'] ?? ''}', title: '${json['title'] ?? ''}', description: '${json['description'] ?? ''}', url: '${json['url'] ?? ''}', imageUrl: json['urlToImage'] as String?, publishedAt: json['publishedAt'] == null ? null : DateTime.tryParse('${json['publishedAt']}'));
  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'description': description, 'url': url, 'urlToImage': imageUrl, 'publishedAt': publishedAt?.toIso8601String()};
  Article toEntity() => this;
  factory ArticleModel.fromEntity(Article entity) => ArticleModel(id: entity.id, title: entity.title, description: entity.description, url: entity.url, imageUrl: entity.imageUrl, publishedAt: entity.publishedAt);
}
