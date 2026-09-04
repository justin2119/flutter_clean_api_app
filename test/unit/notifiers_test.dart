import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../lib/core/error/failures.dart';
import '../../lib/domain/entities/article.dart';
import '../../lib/domain/entities/user.dart';
import '../../lib/domain/repositories/i_news_repository.dart';
import '../../lib/domain/repositories/auth_repository.dart';
import '../../lib/presentation/providers/news_provider.dart';
import '../../lib/presentation/providers/auth_provider.dart';
import '../../lib/presentation/providers/locale_provider.dart';

class FakeNews implements INewsRepository { final Either<Failure, List<Article>> result; FakeNews(this.result); @override Future<Either<Failure, List<Article>>> getLatestNews() async => result; }
class FakeAuth implements AuthRepository { @override Future<Either<Failure, User?>> getCurrentUser() async => right(null); @override Future<Either<Failure, User>> signIn({required String email, required String password}) async => right(User(id: '1', email: email)); @override Future<Either<Failure, User>> signUp({required String email, required String password}) async => right(User(id: '2', email: email)); @override Future<Either<Failure, Unit>> signOut() async => right(unit); }
void main() {
  test('LocaleNotifier toggles supported locales', () { final notifier = LocaleNotifier(); expect(notifier.state.languageCode, 'fr'); notifier.toggle(); expect(notifier.state.languageCode, 'en'); notifier.setLocale(const Locale('de')); expect(notifier.state.languageCode, 'en'); });
  test('NewsNotifier exposes repository data through ProviderScope override', () async { final article = Article(title: 'A', url: 'https://example.com'); final container = ProviderContainer(overrides: [newsRepositoryProvider.overrideWithValue(FakeNews(right([article])))]); addTearDown(container.dispose); expect(await container.read(newsNotifierProvider.future), [article]); });
  test('AuthNotifier signs in and preserves domain failure as AsyncError', () async { final container = ProviderContainer(overrides: [authRepositoryProvider.overrideWithValue(FakeAuth())]); addTearDown(container.dispose); await container.read(authProvider.future); await container.read(authProvider.notifier).signIn(' user@example.com ', 'pw'); expect(container.read(authProvider).value!.email, ' user@example.com '); });
}
