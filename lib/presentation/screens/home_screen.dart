import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/usecases/get_latest_news.dart';
import '../widgets/article_list_item.dart';
import 'detail_screen.dart';

// ConsumerWidget reçoit un WidgetRef et délègue l'état réseau à Riverpod.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch s'abonne au provider : chaque nouvelle AsyncValue reconstruit cette vue.
    // Aucune variable setState n'est nécessaire pour charger, réussir ou échouer.
    final newsAsync = ref.watch(newsNotifierProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF263238),
      appBar: AppBar(
        title: Text('News', style: GoogleFonts.abel()),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            // ref.read déclenche l'action sans créer un abonnement supplémentaire.
            // Le notifier republie ensuite loading puis data/error aux widgets abonnés.
            onPressed: () => ref.read(newsNotifierProvider.notifier).refresh(),
          ),
        ],
      ),
      // when rend lisibles les trois états asynchrones issus du provider.
      body: newsAsync.when(
        data: (articles) => Column(
          children: [
            if (articles.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('No articles available', style: GoogleFonts.abel(color: Colors.white70)),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: articles.length,
                itemBuilder: (ctx, i) => GestureDetector(
                  // L'entité Article est passée à l'écran détail via le constructeur de route.
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailScreen(article: articles[i]))),
                  child: ArticleListItem(article: articles[i]),
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e', style: GoogleFonts.abel(color: Colors.white))),
      ),
    );
  }
}
