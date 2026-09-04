import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ecommerce_project/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app starts with five-screen navigation', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });

  testWidgets('navigation reaches settings screen', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    expect(find.text('Paramètres'), findsOneWidget);
  });
}
