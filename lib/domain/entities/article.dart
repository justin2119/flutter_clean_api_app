// Hive permet de sauvegarder cette entité dans une boîte locale.
import 'package:hive/hive.dart';

// Le fichier généré contient l'adaptateur Hive ; il n'est pas commenté manuellement.
part 'article.g.dart';

// typeId identifie cette classe dans Hive ; il doit rester stable, ici 0.
@HiveType(typeId: 0)
class Article extends HiveObject {
  // Chaque index identifie durablement ce champ dans les données Hive.
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

  // Les champs required doivent être fournis ; les autres peuvent être absents.
  Article({
    required this.title,
    this.description,
    required this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
    this.source,
  });

  // Factory qui transforme une carte JSON de NewsAPI en objet métier Article.
  factory Article.fromJson(Map<String, dynamic> json) => Article(
        title: json['title'] as String,
        description: json['description'] as String?,
        url: json['url'] as String,
        urlToImage: json['urlToImage'] as String?,
        // Parse la date texte seulement si l'API a fourni une valeur.
        publishedAt: json['publishedAt'] != null ? DateTime.parse(json['publishedAt'] as String) : null,
        content: json['content'] as String?,
        // source est un objet JSON imbriqué ; on extrait son nom.
        source: json['source'] != null ? (json['source'] as Map)['name'] as String? : null,
      );

  // Transforme l'objet en carte JSON, utile pour API ou stockage lisible.
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
