# Flutter Clean API App – Documentation Technique (FR)

## Introduction

**Flutter Clean API App** est une application mobile full‑stack développée avec **Flutter** qui suit scrupuleusement les principes de **Clean Architecture** et du **Modèle‑Vue‑Vue‑Modèle (MVVM)**. Elle offre une authentification sécurisée via **Supabase**, une consommation d’API de nouvelles (NewsAPI) et un cache local **Hive** afin d’assurer une stratégie **offline‑first**. L’ensemble du projet a été pensé pour résister aux réseaux à haute latence, notamment ceux du Togo, grâce à des time‑outs de 30 s sur toutes les requêtes réseau.

---

## Architecture détaillée

### 1️⃣ Data Layer
* **Datasources** – Implémentations concrètes qui interagissent avec les services externes :
  * `SupabaseAuthDataSource` : gère les appels d’authentification Supabase avec des `Dio`/`SupabaseClient` configurés avec `connectTimeout`, `receiveTimeout` et `sendTimeout` à 30 s.
  * `NewsApiClient` : utilise **Dio** (30 s timeout) pour récupérer les dernières actualités via **NewsAPI**.
* **Repositories (Implémentations)** – `AuthRepositoryImpl` et `NewsRepositoryImpl` traduisent les réponses du datasource en **Domain Models**. Elles mettent également à jour le cache local Hive (`articles_box`). En cas d’échec (exception `DioException` ou perte de connexion), les méthodes retournent les données provenant du cache, garantissant la continuité de l’expérience utilisateur.
* **Mapping** – Chaque datasource transforme les objets Supabase ou les JSON de NewsAPI en entités du domaine (`User`, `Article`).

### 2️⃣ Domain Layer
* **Entités** – `User` (identifiant, email, téléphone, date de création, métadonnées) et `Article` (titre, description, URL, image, date de publication, contenu, source). Aucun import du SDK Supabase ou d’une bibliothèque de réseau.
* **Repositories (Interfaces)** – Contrats abstraits (`AuthRepository`, `NewsRepository`) définissant les opérations nécessaires.
* **Use Cases** – Logique métier encapsulée :
  * `SignInUseCase`, `SignUpUseCase`, `SignOutUseCase`
  * `GetLatestNews`
  Ces cas d’usage sont invoqués depuis les `AsyncNotifier` du **Presentation Layer**.

### 3️⃣ Presentation Layer
* **État** – Gestion du state via **Riverpod** : `AsyncNotifierProvider`/`AsyncNotifier` (`AuthNotifier`, `NewsNotifier`). Aucun `setState` n’est utilisé ; toute la logique repose sur des notifiers asynchrones.
* **UI** – Écrans (`LoginScreen`, `SignUpScreen`, `HomeScreen`, `DetailScreen`) conformes au **Style Carré** :
  * Fond `#263238`
  * Texte blanc `#FFFFFF`
  * Police **Abel** via `GoogleFonts.abel`
  * Bordure nulle (`BorderRadius.zero`) sur tous les conteneurs, champs de texte et boutons.
* **Navigation** – `AuthWrapper` route automatiquement l’utilisateur authentifié vers `HomeScreen` ou vers `LoginScreen` sinon.

---

## Fonctionnalités principales
* **Authentification Supabase** : inscription, connexion, déconnexion, persistance de session.
* **Intégration NewsAPI** : récupération des gros titres, affichage en liste, rafraîchissement manuel.
* **Cache Hive offline‑first** : stockage persistant des articles, récupération en cas d’absence de réseau.
* **Configuration d’environnement** : variables `SUPABASE_URL` et `SUPABASE_ANON_KEY` injectées via `--dart-define` ou `--dart-define-from-file`.
* **Gestion des time‑outs** : toutes les requêtes réseau (Supabase, Dio) sont limitées à **30 s** pour compenser les latences élevées observées au Togo.

---

## Stack technique
| Domaine | Technologie |
|--------|--------------|
| UI & Framework | **Flutter** (Dart) |
| Gestion d’état | **Riverpod** (AsyncNotifier) |
| Authentification | **Supabase SDK** |
| Appels HTTP | **Dio** (timeout 30 s) |
| Cache local | **Hive** (Box `articles_box`) |
| Styling | **GoogleFonts.abel**, couleur `#263238`, texte `#FFFFFF`, bordure zéro |

---

## Guide d’installation & d’exécution
1. **Cloner le dépôt**
   ```bash
   git clone https://github.com/justin2119/flutter_clean_api_app.git
   cd flutter_clean_api_app
   ```
2. **Créer le fichier d’environnement**
   Copiez le modèle fourni et remplissez vos valeurs :
   ```bash
   cp .env.example .env
   # éditez .env avec votre URL Supabase et votre clé Anon
   ```
3. **Installer les dépendances**
   ```bash
   flutter pub get
   ```
4. **Générer les adaptateurs Hive**
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```
5. **Lancer l’application** (en injectant les variables) :
   ```bash
   flutter run \
     --dart-define=SUPABASE_URL=$(grep SUPABASE_URL .env | cut -d'=' -f2) \
     --dart-define=SUPABASE_ANON_KEY=$(grep SUPABASE_ANON_KEY .env | cut -d'=' -f2)
   ```
   Vous pouvez également créer un fichier `dart_defines.txt` et lancer :
   ```bash
   flutter run --dart-define-from-file=dart_defines.txt
   ```
6. **Construire une version release**
   ```bash
   flutter build apk \
     --dart-define=SUPABASE_URL=... \
     --dart-define=SUPABASE_ANON_KEY=...
   ```

---

## Gestion des contraintes réseau du Togo
Le Togo possède des connexions Internet parfois lentes et instables. Le projet répond à ces contraintes :
* **Timeout personnalisés** : chaque appel `Dio` et chaque opération Supabase sont configurés avec un `connectTimeout`, `receiveTimeout` et `sendTimeout` de **30 seconds**.
* **Stratégie offline‑first** : les articles sont stockés dans Hive dès la première récupération réussie. Si la connexion : est absente ou que le serveur ne répond pas dans les 30 s, l’application lit directement le cache local, garantissant ainsi une expérience fluide même en cas de perte de réseau.
* **Graceful fallback** : les exceptions (`DioException`, `SocketException`) sont interceptées, loggées et entraînent le retour des données en cache sans interruption de l’UI.

---

## Licence
Ce projet est publié sous la licence MIT. Vous êtes libre de l’utiliser, le modifier et le redistribuer.

---

*Bonne programmation !*