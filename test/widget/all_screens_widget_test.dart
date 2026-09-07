import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../lib/core/error/failures.dart';
import '../../lib/domain/entities/article.dart';
import '../../lib/domain/entities/user.dart';
import '../../lib/domain/repositories/i_news_repository.dart';
import '../../lib/domain/repositories/auth_repository.dart';
import '../../lib/presentation/providers/news_provider.dart';
import '../../lib/presentation/providers/bookmarks_provider.dart';
import '../../lib/presentation/providers/auth_provider.dart';
import '../../lib/presentation/providers/locale_provider.dart';
import '../../lib/presentation/providers/theme_provider.dart';
import '../../lib/presentation/screens/detail_screen.dart';
import '../../lib/presentation/screens/search_screen.dart';
import '../../lib/presentation/screens/bookmarks_screen.dart';
import '../../lib/presentation/screens/settings_screen.dart';
import '../../lib/presentation/screens/login_screen.dart';
import '../../lib/presentation/screens/signup_screen.dart';

final article = Article(title: 'Flutter testing', url: 'https://example.com', source: 'Example', description: 'Testing description', content: 'Full content', publishedAt: DateTime(2026, 1, 2));

class FakeNews implements INewsRepository {
  @override Future<Either<Failure, List<Article>>> getLatestNews() async => right([article]);
}
class FakeAuth implements AuthRepository {
  @override Future<Either<Failure, User?>> getCurrentUser() async => right(null);
  @override Future<Either<Failure, User>> signIn({required String email, required String password}) async => right(User(id: '1', email: email));
  @override Future<Either<Failure, User>> signUp({required String email, required String password}) async => right(User(id: '1', email: email));
  @override Future<Either<Failure, Unit>> signOut() async => right(unit);
}

Widget shell(Widget child) => ProviderScope(
  overrides: [
    newsRepositoryProvider.overrideWithValue(FakeNews()),
    authRepositoryProvider.overrideWithValue(FakeAuth()),
    bookmarksNotifierProvider.overrideWith((ref) async => [article]),
  ],
  child: MaterialApp(home: child),
);

void main() {
  testWidgets('DetailScreen renders metadata, content and actions', (tester) async {
    await tester.pumpWidget(shell(DetailScreen(article: article)));
    await tester.pumpAndSettle();
    expect(find.text('Flutter testing'), findsOneWidget);
    expect(find.textContaining('Example'), findsOneWidget);
    expect(find.text('Testing description'), findsOneWidget);
    expect(find.text('Full content'), findsOneWidget);
    expect(find.text('Read full article'), findsOneWidget);
    expect(find.byIcon(Icons.bookmark), findsOneWidget);
  });

  testWidgets('SearchScreen renders input, category chips and filtered result', (tester) async {
    await tester.pumpWidget(shell(const SearchScreen()));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Technology'), findsOneWidget);
    expect(find.text('Flutter testing'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'no match');
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('No matching articles'), findsOneWidget);
  });

  testWidgets('BookmarksScreen renders saved article and delete control', (tester) async {
    await tester.pumpWidget(shell(const BookmarksScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Flutter testing'), findsOneWidget);
    expect(find.byIcon(Icons.delete), findsOneWidget);
  });

  testWidgets('BookmarksScreen renders empty state', (tester) async {
    await tester.pumpWidget(ProviderScope(overrides: [bookmarksNotifierProvider.overrideWith((ref) async => const [])], child: const MaterialApp(home: BookmarksScreen())));
    await tester.pumpAndSettle();
    expect(find.text('No saved articles'), findsOneWidget);
  });

  testWidgets('SettingsScreen exposes locale and theme controls', (tester) async {
    await tester.pumpWidget(ProviderScope(child: const MaterialApp(home: SettingsScreen())));
    await tester.pumpAndSettle();
    expect(find.byType(SwitchListTile), findsNWidgets(2));
    expect(find.byIcon(Icons.language), findsOneWidget);
    expect(find.byIcon(Icons.brightness_6), findsOneWidget);
    await tester.tap(find.byType(SwitchListTile).last);
    await tester.pump();
    expect(find.byType(SwitchListTile), findsNWidgets(2));
  });

  testWidgets('LoginScreen renders fields, submit and guest controls', (tester) async {
    await tester.pumpWidget(ProviderScope(overrides: [authRepositoryProvider.overrideWithValue(FakeAuth())], child: const MaterialApp(home: LoginScreen())));
    expect(find.text('Login'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Continue as guest'), findsOneWidget);
  });

  testWidgets('SignUpScreen renders its form', (tester) async {
    await tester.pumpWidget(ProviderScope(overrides: [authRepositoryProvider.overrideWithValue(FakeAuth())], child: const MaterialApp(home: SignUpScreen())));
    expect(find.byType(TextField), findsNWidgets(3));
    expect(find.text('Sign Up'), findsOneWidget);
  });

  test('theme and locale notifiers expose deterministic toggles', () {
    final locale = LocaleNotifier();
    expect(locale.state.languageCode, 'fr');
    locale.toggle();
    expect(locale.state.languageCode, 'en');
    final theme = ThemeModeNotifier();
    expect(theme.state, ThemeMode.light);
    theme.toggle();
    expect(theme.state, ThemeMode.dark);
  });
}
