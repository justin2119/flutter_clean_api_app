import 'package:flutter/material.dart';
import '../../domain/entities/article.dart';

class DetailScreen extends StatelessWidget {
  final Article article;
  const DetailScreen({required this.article, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(article.content ?? 'No content'),
      ),
    );
  }
}
