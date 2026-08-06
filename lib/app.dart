// Importe les widgets visuels de Flutter, comme MaterialApp et ThemeData.
import 'package:flutter/material.dart';
// Importe Riverpod : il permet de partager et d'observer l'état de l'application.
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Importe l'écran qui choisit l'interface selon l'état de connexion.
import 'presentation/screens/auth_wrapper.dart';

// ConsumerWidget est un widget Riverpod capable de recevoir un WidgetRef.
// Un WidgetRef donne accès aux providers ; ici il est disponible si l'app en a besoin.
class MyApp extends ConsumerWidget {
  // Le constructeur const permet à Flutter de réutiliser ce widget lorsqu'il ne change pas.
  // super.key transmet une clé optionnelle au widget parent pour aider Flutter à l'identifier.
  const MyApp({super.key});

  // build décrit l'interface à construire.
  // BuildContext indique où le widget se trouve dans l'arbre Flutter.
  // WidgetRef permettrait de lire ou d'écouter Riverpod dans cette méthode.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // MaterialApp est le conteneur principal d'une application Flutter Material.
    return MaterialApp(
      // title est le nom général de l'application, utilisé notamment par certaines plateformes.
      title: 'Flutter Clean API App',
      // ThemeData regroupe les règles visuelles communes de l'application.
      theme: ThemeData(
        // Couleur de fond Style Carré : bleu-gris très sombre #263238.
        // Cette couleur est appliquée par défaut aux Scaffold de l'application.
        scaffoldBackgroundColor: const Color(0xFF263238),
        // Le projet conserve les composants Material classiques plutôt que Material 3.
        useMaterial3: false,
      ),
      // AuthWrapper est le premier écran affiché.
      // Il peut ensuite montrer la connexion ou le contenu principal selon la session.
      home: const AuthWrapper(),
    );
  }
}
