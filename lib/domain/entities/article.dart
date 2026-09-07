import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final String id;
  final String title;
  final String description;
  final String url;
  final String? imageUrl;
  final DateTime? publishedAt;
  const Article({required this.id, required this.title, required this.description, required this.url, this.imageUrl, this.publishedAt});
  @override
  List<Object?> get props => [id, title, description, url, imageUrl, publishedAt];
}
