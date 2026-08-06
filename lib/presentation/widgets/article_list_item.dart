import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/article.dart';

// Widget de présentation réutilisable : il reçoit l'entité Article déjà préparée par le domaine.
class ArticleListItem extends StatelessWidget {
  final Article article;

  const ArticleListItem({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    // Le Style Carré impose une surface plate et des angles strictement droits.
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: const Color(0xFF37474F),
      // BorderRadius.zero interdit tout arrondi implicite sur la carte.
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        // Les attributs optionnels du domaine sont affichés conditionnellement.
        // L'image est volontairement brute : aucune découpe arrondie ne rompt le langage visuel.
        leading: article.urlToImage != null
            ? Image.network(
                article.urlToImage!,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.image_not_supported,
                  color: Colors.white38,
                  size: 40,
                ),
              )
            : const Icon(Icons.article, color: Colors.white38, size: 40),
        // Le titre est l'information principale : blanc opaque et taille supérieure.
        title: Text(
          article.title,
          style: GoogleFonts.abel(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        // La source est secondaire : blanc moins opaque pour établir une hiérarchie lisible.
        subtitle: article.source != null
            ? Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  article.source!,
                  style: GoogleFonts.abel(color: Colors.white54, fontSize: 12),
                ),
              )
            : null,
        trailing: const Icon(Icons.chevron_right, color: Colors.white38),
      ),
    );
  }
}
