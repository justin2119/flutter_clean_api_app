import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/article.dart';

class DetailScreen extends StatelessWidget {
  final Article article;
  const DetailScreen({required this.article, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF263238),
      appBar: AppBar(
        title: Text(article.title, style: GoogleFonts.abel()),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null)
              Image.network(article.urlToImage!, fit: BoxFit.cover),
            const SizedBox(height: 12),
            Text(article.title, style: GoogleFonts.abel(fontSize: 22, color: Colors.white)),
            const SizedBox(height: 8),
            if (article.description != null)
              Text(article.description!, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 12),
            if (article.content != null)
              Text(article.content!, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
