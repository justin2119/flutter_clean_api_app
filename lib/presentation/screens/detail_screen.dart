import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/article.dart';

// Écran de présentation immuable : l'entité Article arrive depuis la route précédente.
class DetailScreen extends StatelessWidget {
  // Passer une entité du domaine évite de refaire un appel réseau sur cet écran.
  final Article article;
  const DetailScreen({required this.article, super.key});

  @override
  Widget build(BuildContext context) {
    // Le fond #263238 et l'absence de décoration arrondie expriment le Style Carré.
    return Scaffold(
      backgroundColor: const Color(0xFF263238),
      appBar: AppBar(
        // Toutes les chaînes visibles utilisent Abel pour une hiérarchie typographique cohérente.
        title: Text(article.title, style: GoogleFonts.abel()),
        // Transparent évite une surface concurrente au fond sombre de la marque.
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // L'image reste conditionnelle car urlToImage est nullable dans l'entité.
            if (article.urlToImage != null)
              Image.network(article.urlToImage!, fit: BoxFit.cover),
            const SizedBox(height: 12),
            Text(article.title, style: GoogleFonts.abel(fontSize: 22, color: Colors.white)),
            const SizedBox(height: 8),
            // Le blanc à forte opacité maximise le contraste sur #263238.
            if (article.description != null)
              Text(article.description!, style: GoogleFonts.abel(color: Colors.white70)),
            const SizedBox(height: 12),
            if (article.content != null)
              Text(article.content!, style: GoogleFonts.abel(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
