import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../lib/presentation/providers/connectivity_provider.dart';

void main() {
  test('connectivity provider is constructible without platform/network setup', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    expect(container.read(connectivityProvider), isNotNull);
  });
}
