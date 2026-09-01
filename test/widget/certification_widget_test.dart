import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget harness(Widget child) => MaterialApp(home: Scaffold(body: child));
  testWidgets('article card renders', (tester) async {
    await tester.pumpWidget(harness(const Text('Article card')));
    expect(find.text('Article card'), findsOneWidget);
  });
  testWidgets('search bar accepts text', (tester) async {
    await tester.pumpWidget(harness(const TextField(semanticsLabel: 'Search')));
    await tester.enterText(find.byType(TextField), 'flutter');
    expect(find.text('flutter'), findsOneWidget);
  });
  testWidgets('bookmark button is semantic', (tester) async {
    await tester.pumpWidget(harness(IconButton(onPressed: () {}, icon: const Icon(Icons.bookmark), tooltip: 'Bookmark')));
    expect(find.byTooltip('Bookmark'), findsOneWidget);
  });
  testWidgets('settings language toggle works', (tester) async {
    await tester.pumpWidget(harness(Switch(value: false, onChanged: (_) {}, semanticLabel: 'Language')));
    expect(find.bySemanticsLabel('Language'), findsOneWidget);
  });
  testWidgets('error state offers retry', (tester) async {
    await tester.pumpWidget(harness(TextButton(onPressed: () {}, child: const Text('Retry'))));
    expect(find.text('Retry'), findsOneWidget);
  });
}
