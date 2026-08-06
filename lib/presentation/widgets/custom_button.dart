import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Composant partagé : centraliser le bouton garantit une même expression du Style Carré.
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // La largeur complète crée une action clairement identifiable et réutilisable.
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          // Le vert conserve un contraste net avec le fond #263238.
          backgroundColor: const Color(0xFF4CAF50),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          // Une élévation nulle et des angles droits forment le bouton minimaliste.
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        // Abel aligne le bouton sur toute la hiérarchie typographique de l'application.
        child: Text(label, style: GoogleFonts.abel(fontSize: 16, color: Colors.white)),
      ),
    );
  }
}
