# Flutter Clean API App

Application Flutter de consultation d’actualités, conçue autour d’une Clean Architecture stricte, d’un MVVM piloté par Riverpod et d’une expérience offline-first. Le projet s’appuie sur Supabase pour l’authentification, NewsAPI pour les articles, Dio pour le réseau et Hive pour la persistance locale.

## Principes directeurs

- Séparer clairement présentation, métier et infrastructure afin de limiter le couplage.
- Exposer l’état de l’application avec Riverpod plutôt qu’avec `setState`.
- Lire localement avant de dépendre du réseau : le cache est une capacité fonctionnelle, pas seulement une optimisation.
- Rester utilisable sur des connexions lentes ou instables grâce aux timeouts, aux fallbacks et à des messages d’erreur compréhensibles en français.
- Respecter sans exception la philosophie visuelle « Style Carré ».

## Architecture : Riverpod comme ViewModel dans une Clean Architecture

Le projet combine MVVM et Clean Architecture. Dans cette interprétation, les `AsyncNotifier` Riverpod constituent les ViewModels : ils exposent l’état observable à la Vue, déclenchent les use cases et centralisent les transitions de chargement, succès et erreur. La Vue ne connaît ni Dio, ni Hive, ni Supabase et ne contient pas de logique métier.

### Presentation layer — View et ViewModel

- Les écrans (`LoginScreen`, `SignUpScreen`, `HomeScreen`, `DetailScreen`) sont les Views. Ils rendent l’état et transmettent les intentions de l’utilisateur.
- `AuthNotifier` et `NewsNotifier`, consommés via `AsyncNotifierProvider`, sont les ViewModels. Ils appellent les use cases, publient `AsyncLoading`, `AsyncData` ou `AsyncError`, et permettent à l’UI de rester réactive.
- `AuthWrapper` et la configuration de navigation orchestrent l’accès aux écrans authentifiés ou publics.
- Aucun appel direct à une API, à Hive ou à Supabase ne doit être ajouté dans un widget.

### Domain layer — le cœur métier

- Les entités (`User`, `Article`) sont indépendantes de Flutter, de Supabase, de Dio et de Hive.
- Les contrats `AuthRepository` et `NewsRepository` sont définis comme abstractions que le domaine consomme.
- Les use cases (`SignInUseCase`, `SignUpUseCase`, `SignOutUseCase`, `GetLatestNews`) encapsulent les règles métier et sont invoqués par les ViewModels.
- Cette couche ne dépend que de ses propres abstractions et reste donc testable et remplaçable.

### Data layer — implémentations et adaptateurs

- Les datasources concrètes dialoguent avec Supabase et NewsAPI via leurs clients respectifs.
- `AuthRepositoryImpl` et `NewsRepositoryImpl` implémentent les contrats du domaine, convertissent les DTO/JSON en entités et coordonnent réseau et cache.
- Les détails de sérialisation, les adaptateurs Hive et la gestion des exceptions restent confinés à cette couche.

Flux nominal : View → Riverpod ViewModel (`AsyncNotifier`) → use case → repository abstrait → implémentation → datasource réseau/cache. Le flux retour remonte des entités ou des erreurs typées jusqu’au ViewModel, qui fournit un état directement exploitable par la View.

## Stratégie de cache Hive et mode offline

Les articles sont persistés dans Hive dans la box nommée `news_articles`. Le modèle Hive des articles utilise explicitement `typeId: 0`; cet identifiant doit rester stable pour préserver la compatibilité des données déjà stockées. Les adaptateurs sont générés avec `build_runner`.

La stratégie est local-first/offline-first :

1. Le repository tente d’abord de fournir les données locales disponibles, afin que l’écran puisse s’afficher même sans connexion.
2. Une récupération réseau réussie remplace ou actualise le contenu de `news_articles`, puis renvoie les articles à la présentation.
3. Une absence de réseau, un timeout ou une réponse réseau inutilisable déclenche la lecture de la box existante.
4. Si le cache contient des articles, ils sont retournés comme résultat utilisable, avec l’information permettant à l’UI d’indiquer qu’il s’agit de données hors ligne.
5. Si réseau et cache sont tous deux indisponibles, le repository renvoie une erreur explicite plutôt que des données inventées.

Les repositories utilisent le pattern `Either` de `fpdart` pour représenter le résultat : le côté gauche porte l’échec (erreur métier/data) et le côté droit porte la liste d’articles ou les données demandées. Cette convention évite de confondre une exception avec une donnée valide et rend les fallbacks déterministes : une erreur réseau peut être interceptée, le cache peut être consulté, puis le résultat local peut être renvoyé dans le côté droit si des articles existent.

## Gestion des erreurs et contraintes réseau

La conception est locale d’abord, avec un comportement prévisible sur les réseaux lents :

- Toutes les requêtes réseau appliquent un timeout de 30 secondes (`connectTimeout`, `receiveTimeout` et `sendTimeout` lorsque le client le permet).
- Les `SocketException` signalent les pertes de connectivité et les `DioException` couvrent les erreurs HTTP, de transport et de timeout Dio.
- Ces exceptions sont capturées au niveau datasource/repository, converties vers le modèle d’erreur du projet et ne sont pas laissées remonter comme des crashes Flutter.
- Pour les actualités, l’application privilégie le cache Hive après un échec réseau. L’utilisateur conserve donc ses dernières données connues.
- Quand aucune donnée locale n’est disponible, l’échec est présenté via une snackbar en français, avec un message court et actionnable plutôt qu’une stack trace technique.
- Les ViewModels transforment ensuite ces résultats en états Riverpod cohérents pour que la Vue distingue chargement, données fraîches, données hors ligne et erreur.

## Philosophie visuelle sacrée : « Style Carré »

Le Style Carré est un contrat produit et non une préférence facultative :

- Rayon de bordure absolument nul partout : `BorderRadius.circular(0.0)` ou `BorderRadius.zero`; la valeur de référence est `0.0`.
- Arrière-plan principal : `#263238`.
- Texte primaire : `#FFFFFF`.
- Typographie exclusivement basée sur `GoogleFonts.abel`. Aucun autre style de police ne doit être introduit pour l’interface.
- La profondeur est créée avec des opacités et des superpositions, jamais avec des ombres : `white70` pour les éléments secondaires lisibles, `white24` pour les séparations/surfaces discrètes et `white10` pour les fonds ou couches de profondeur.
- Les cartes, champs, boutons, dialogues et conteneurs doivent conserver des angles parfaitement droits. Ne pas ajouter de `boxShadow` ou de rayon décoratif pour simuler une élévation.

Cette discipline doit être respectée dans tout nouvel écran et toute modification de composant existant.

## CI/CD

Le workflow `.github/workflows/flutter.yml` s’exécute sur chaque `push` vers `main` et chaque pull request ciblant `main`. Il utilise `ubuntu-latest` et les étapes suivantes :

1. Checkout du dépôt avec `actions/checkout@v4`.
2. Installation de Flutter `3.22.0` via `subosito/flutter-action@v2`, sur le channel `stable`.
3. Installation des dépendances avec `flutter pub get`.
4. Analyse statique avec `flutter analyze`.
5. Exécution de la suite de tests avec `flutter test`.

Une contribution n’est donc acceptable que si elle reste compatible avec Flutter 3.22.0 stable, passe l’analyse et ne casse pas les tests. Le workflow constitue la porte de validation continue du projet ; les secrets et variables de production doivent être fournis par la configuration sécurisée du pipeline, jamais committés.

## Fonctionnalités et stack

- Authentification, inscription et session persistante via Supabase.
- Récupération et affichage d’actualités via NewsAPI et Dio.
- État asynchrone avec Riverpod (`AsyncNotifier`).
- Domaine découplé avec use cases et repositories abstraits.
- Cache persistant Hive (`news_articles`, `typeId: 0`).
- Sérialisation avec `json_serializable`/Freezed et génération via `build_runner`.
- Configuration par variables `SUPABASE_URL` et `SUPABASE_ANON_KEY` injectées avec `--dart-define` ou `--dart-define-from-file`.

| Domaine | Technologie |
|---|---|
| Framework | Flutter / Dart |
| Architecture | Clean Architecture + MVVM |
| ViewModels / état | Riverpod, `AsyncNotifier` |
| Backend/authentification | Supabase |
| HTTP | Dio |
| Résultats | `fpdart`, pattern `Either` |
| Cache local | Hive, box `news_articles`, `typeId: 0` |
| Typographie | `GoogleFonts.abel` |
| Style | `#263238`, `#FFFFFF`, rayon `0.0`, opacités `white70`/`white24`/`white10` |

## Installation et exécution

```bash
git clone https://github.com/justin2119/flutter_clean_api_app.git
cd flutter_clean_api_app
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
```

Lancer avec les variables d’environnement :

```bash
flutter run \\
  --dart-define=SUPABASE_URL=... \\
  --dart-define=SUPABASE_ANON_KEY=...
```

Ou utiliser un fichier de définitions :

```bash
flutter run --dart-define-from-file=dart_defines.txt
```

Avant de soumettre une modification, reproduire localement les contrôles CI :

```bash
flutter analyze
flutter test
```

## Licence

Ce projet est publié sous licence MIT.
