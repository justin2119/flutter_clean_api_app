import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../lib/domain/entities/article.dart';
import '../../lib/core/error/failures.dart';
import '../../lib/domain/repositories/i_news_repository.dart';
import '../../lib/presentation/providers/news_provider.dart';
import '../../lib/presentation/screens/home_screen.dart';
import 'package:fpdart/fpdart.dart';
class _FakeNews implements INewsRepository { final Either<Failure, List<Article>> response; _FakeNews(this.response); @override Future<Either<Failure, List<Article>>> getLatestNews() async => response; }
void main() {
  testWidgets('HomeScreen renders data using a ProviderScope override', (tester) async { await tester.pumpWidget(ProviderScope(overrides: [newsRepositoryProvider.overrideWithValue(_FakeNews(right([Article(title: 'Test article', url: 'https://example.com')])) )], child: const MaterialApp(home: HomeScreen()))); await tester.pumpAndSettle(); expect(find.text('Test article'), findsOneWidget); });
  testWidgets('HomeScreen renders retry on failure', (tester) async { await tester.pumpWidget(ProviderScope(overrides: [newsRepositoryProvider.overrideWithValue(_FakeNews(left(const NetworkFailure('offline'))))], child: const MaterialApp(home: HomeScreen()))); await tester.pumpAndSettle(); expect(find.text('Retry'), findsOneWidget); });
}
