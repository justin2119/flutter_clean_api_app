import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../lib/core/error/failures.dart';
import '../../lib/domain/entities/article.dart';
import '../../lib/domain/repositories/i_news_repository.dart';
import '../../lib/presentation/providers/news_provider.dart';
import '../../lib/presentation/screens/home_screen.dart';

class _EmptyRepository implements INewsRepository {
  @override
  Future<Either<Failure, List<Article>>> getLatestNews() async => right(const []);
}

void main() {
  testWidgets('HomeScreen handles an empty successful response', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [newsRepositoryProvider.overrideWithValue(_EmptyRepository())],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Retry'), findsNothing);
  });
}
