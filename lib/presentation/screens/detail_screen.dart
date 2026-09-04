import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/article.dart';
class DetailScreen extends StatelessWidget {
  final Article article; const DetailScreen({required this.article, super.key});
  @override Widget build(BuildContext context) => Scaffold(backgroundColor: const Color(0xFF263238), appBar: AppBar(title: Text('Article', style: GoogleFonts.abel())), body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    if (article.urlToImage != null) Image.network(article.urlToImage!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox.shrink()),
    Text(article.title, style: GoogleFonts.abel(fontSize: 24, color: Colors.white)), const SizedBox(height: 10),
    Text('${article.source ?? 'Unknown source'} • ${article.publishedAt?.toLocal().toString().split(' ').first ?? 'Unknown date'}', style: GoogleFonts.abel(color: Colors.white70)), const SizedBox(height: 14),
    if (article.description != null) Text(article.description!, style: GoogleFonts.abel(color: Colors.white70)), const SizedBox(height: 12),
    if (article.content != null) Text(article.content!, style: GoogleFonts.abel(color: Colors.white)), const SizedBox(height: 20),
    SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => launchUrl(Uri.parse(article.url), mode: LaunchMode.externalApplication), child: Text('Read full article', style: GoogleFonts.abel()))),
  ])));
}
