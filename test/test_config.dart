// Test configuration and utilities

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Initialize test environment
void setupTestEnvironment() {
  TestWidgetsFlutterBinding.ensureInitialized();
}

/// Setup SharedPreferences for testing
Future<void> setupSharedPreferences([Map<String, Object>? values]) async {
  SharedPreferences.setMockInitialValues(values ?? {});
}

/// Common test timeout duration
const Duration testTimeout = Duration(seconds: 30);

/// Helper to pump widget until settled
Future<void> pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = testTimeout,
}) async {
  bool finderFound = false;
  final end = DateTime.now().add(timeout);

  while (!finderFound && DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 100));
    finderFound = finder.evaluate().isNotEmpty;
  }

  if (!finderFound) {
    throw Exception('Finder not found within timeout: $finder');
  }
}
