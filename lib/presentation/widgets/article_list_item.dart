import 'package:flutter/material.dart';
import '../../domain/entities/article.dart';

class ArticleListItem extends StatelessWidget {
  final Article article;

  const ArticleListItem({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: const Color(0xFF37474F),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: article.urlToImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  article.urlToImage!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.image_not_supported,
                    color: Colors.white38,
                    size: 40,
                  ),
                ),
              )
            : const Icon(Icons.article, color: Colors.white38, size: 40),
        title: Text(
          article.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: article.source != null
            ? Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  article.source!,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              )
            : null,
        trailing: const Icon(Icons.chevron_right, color: Colors.white38),
      ),
    );
  }
}
