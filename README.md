# Flutter Clean API App

## English

This repository contains a production‑grade Flutter application that follows **Clean Architecture** (Data, Domain, Presentation) with MVVM, uses **Riverpod** for state management, and includes a full authentication system (Supabase) with Dio interceptors.

### Features
- Clean Architecture (Data, Domain, Presentation) with MVVM
- Authentication via Supabase (JWT refresh tokens, Dio interceptors)
- Three UI screens interacting with a real REST API (NewsAPI example)
- Offline support using **Hive** for local caching and graceful network error handling (30 s timeout)
- Strict **Style Carré** UI aesthetic: zero border radius, background `#263238`, white text, **Abel** font, white opacity layers
- Unit tests for repositories/use‑cases (minimum three)
- State management with **Riverpod** (`AsyncNotifier`, `Provider`)

### How to run
1. Install Flutter SDK (>=3.19) and ensure `dart` is in your PATH.
2. Clone the repository:
   ```bash
   git clone https://github.com/justin2119/flutter_clean_api_app.git
   cd flutter_clean_api_app
   ```
3. Create a Supabase project and copy the `SUPABASE_URL` and `SUPABASE_ANON_KEY` into a `.env` file (or use `flutter_dotenv`).
4. Get a NewsAPI key and add it to the same `.env` file as `NEWS_API_KEY`.
5. Run `flutter pub get`.
6. Generate Hive adapters: `flutter packages pub run build_runner build`.
7. Launch the app on a device or emulator: `flutter run`.

### Tests
Run unit tests with:
```bash
flutter test
```

---

## Français

Ce dépôt contient une application Flutter **de niveau production** respectant **l’Architecture Clean** (Data, Domain, Presentation) avec le pattern MVVM, utilise **Riverpod** pour la gestion d’état, et inclut un système d’authentification complet (Supabase) avec des intercepteurs Dio.

### Fonctionnalités
- Architecture Clean (Data, Domain, Presentation) avec MVVM
- Authentification via Supabase (tokens JWT, rafraîchissement, intercepteurs Dio)
- Trois écrans UI interagissant avec une API REST réelle (exemple NewsAPI)
- Support hors‑ligne grâce à **Hive** (cache local) et gestion des erreurs réseau avec un timeout de 30 s
- Esthétique **Style Carré** stricte : aucun rayon de bordure, couleur de fond `#263238`, texte blanc, police **Abel**, calques à opacité blanche
- Tests unitaires (au moins trois) pour les dépôts ou cas d’usage
- Gestion d’état avec **Riverpod** (`AsyncNotifier`, `Provider`)

### Comment lancer l’application
1. Installez le SDK Flutter (>=3.19) et assurez‑vous que `dart` est dans votre PATH.
2. Clonez le dépôt :
   ```bash
   git clone https://github.com/justin2119/flutter_clean_api_app.git
   cd flutter_clean_api_app
   ```
3. Créez un projet Supabase et copiez `SUPABASE_URL` et `SUPABASE_ANON_KEY` dans un fichier `.env` (ou utilisez `flutter_dotenv`).
4. Obtenez une clé API NewsAPI et ajoutez‑la dans le même fichier `.env` comme `NEWS_API_KEY`.
5. Exécutez `flutter pub get`.
6. Générez les adaptateurs Hive : `flutter packages pub run build_runner build`.
7. Lancez l’application sur un appareil ou un émulateur : `flutter run`.

### Tests
Exécutez les tests unitaires avec :
```bash
flutter test
```

---

*This project follows the specifications provided in the assignment image.*