import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_clean_api_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('application starts and exposes the settings navigation', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(find.text('Paramètres'), findsOneWidget);
  });
}
