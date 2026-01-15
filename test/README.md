# Testing Guide

## Overview

This directory contains all tests for the Eye Care App. We follow a comprehensive testing strategy including unit tests, widget tests, and integration tests.

## Test Structure

```
test/
├── unit/                    # Unit tests for business logic
│   ├── models/              # Model tests
│   ├── providers/           # Provider/state management tests
│   ├── services/            # Service layer tests
│   └── utils/               # Utility function tests
├── widget/                  # Widget tests for UI components
├── integration/             # Integration and e2e tests
├── test_config.dart         # Shared test utilities
└── widget_test.dart         # Basic smoke test
```

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test File
```bash
flutter test test/unit/models/settings_model_test.dart
```

### Run Tests with Coverage
```bash
flutter test --coverage
```

### View Coverage Report
```bash
# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Open in browser
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
start coverage/html/index.html  # Windows
```

### Run Tests in Watch Mode
```bash
flutter test --watch
```

## Test Categories

### Unit Tests

Unit tests verify individual functions, methods, and classes in isolation.

**Location**: `test/unit/`

**Example**:
```dart
test('creates default settings correctly', () {
  const settings = EyeCareSettings();
  expect(settings.backgroundModeEnabled, true);
  expect(settings.blinkIntervalSeconds, 15);
});
```

**Coverage Goal**: >80%

### Widget Tests

Widget tests verify UI components and their interactions.

**Location**: `test/widget/`

**Example**:
```dart
testWidgets('displays blink reminder overlay', (tester) async {
  await tester.pumpWidget(MyApp());
  expect(find.text('Blink Your Eyes'), findsOneWidget);
});
```

**Coverage Goal**: >70%

### Integration Tests

Integration tests verify complete user flows and interactions between components.

**Location**: `test/integration/`

**Example**:
```dart
testWidgets('complete eye care flow', (tester) async {
  // Start app
  // Enable protection
  // Verify overlay appears
  // Change settings
  // Verify settings persist
});
```

**Coverage Goal**: >60%

## Writing Good Tests

### Best Practices

1. **Arrange-Act-Assert Pattern**
   ```dart
   test('description', () {
     // Arrange: Set up test data
     const settings = EyeCareSettings();

     // Act: Perform the action
     final updated = settings.copyWith(blinkIntervalSeconds: 20);

     // Assert: Verify the result
     expect(updated.blinkIntervalSeconds, 20);
   });
   ```

2. **Descriptive Test Names**
   ```dart
   // ✅ Good
   test('copyWith creates new instance with updated values', () {});

   // ❌ Bad
   test('test copyWith', () {});
   ```

3. **One Assertion Per Test** (when possible)
   ```dart
   // ✅ Good
   test('blinkIntervalSeconds updates correctly', () {
     final updated = settings.copyWith(blinkIntervalSeconds: 20);
     expect(updated.blinkIntervalSeconds, 20);
   });

   test('other properties remain unchanged', () {
     final updated = settings.copyWith(blinkIntervalSeconds: 20);
     expect(updated.ttsEnabled, original.ttsEnabled);
   });
   ```

4. **Test Edge Cases**
   ```dart
   test('fromJson handles missing values with defaults', () {
     final json = <String, dynamic>{};
     final settings = EyeCareSettings.fromJson(json);
     expect(settings.blinkIntervalSeconds, 15);
   });
   ```

5. **Use Test Fixtures**
   ```dart
   EyeCareSettings createTestSettings() {
     return const EyeCareSettings(blinkIntervalSeconds: 15);
   }
   ```

### Test Organization

Use `group()` to organize related tests:

```dart
group('EyeCareSettings', () {
  group('creation', () {
    test('creates default settings', () {});
    test('creates with custom values', () {});
  });

  group('serialization', () {
    test('toJson works correctly', () {});
    test('fromJson works correctly', () {});
  });
});
```

### Mocking

For tests requiring external dependencies:

```dart
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([SharedPreferences, NotificationService])
void main() {
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
  });

  test('saves settings to storage', () async {
    when(mockPrefs.setString(any, any))
        .thenAnswer((_) async => true);

    // Test code using mockPrefs
  });
}
```

Generate mocks:
```bash
flutter pub run build_runner build
```

## Test Coverage Goals

| Category | Target Coverage |
|----------|----------------|
| Models | >90% |
| Providers | >80% |
| Services | >75% |
| Widgets | >70% |
| Utils | >85% |
| Overall | >75% |

## Continuous Integration

Tests run automatically on:
- Every push to `main` or `develop`
- Every pull request
- Pre-release builds

See `.github/workflows/test.yml` for CI configuration.

## Common Testing Patterns

### Testing Providers

```dart
test('provider notifies listeners on change', () {
  final provider = SettingsProvider();
  var notified = false;

  provider.addListener(() {
    notified = true;
  });

  provider.updateBlinkInterval(30);

  expect(notified, true);
  expect(provider.settings.blinkIntervalSeconds, 30);
});
```

### Testing Widgets

```dart
testWidgets('button tap triggers action', (tester) async {
  var pressed = false;

  await tester.pumpWidget(
    MaterialApp(
      home: ElevatedButton(
        onPressed: () => pressed = true,
        child: const Text('Press Me'),
      ),
    ),
  );

  await tester.tap(find.text('Press Me'));
  await tester.pump();

  expect(pressed, true);
});
```

### Testing Async Operations

```dart
test('async operation completes successfully', () async {
  final result = await fetchData();
  expect(result, isNotNull);
});

test('async operation with timeout', () async {
  await expectLater(
    longRunningOperation(),
    completes,
  ).timeout(const Duration(seconds: 5));
});
```

### Testing Streams

```dart
test('stream emits expected values', () async {
  final stream = countStream(3);

  await expectLater(
    stream,
    emitsInOrder([0, 1, 2, emitsDone]),
  );
});
```

## Troubleshooting

### Tests Fail Locally But Pass in CI
- Ensure Flutter SDK version matches CI
- Check for platform-specific dependencies
- Verify timezone/locale settings

### Flaky Tests
- Add `await tester.pumpAndSettle()` in widget tests
- Use explicit waits instead of fixed delays
- Mock time-dependent operations

### Coverage Not Generating
```bash
# Clean and regenerate
flutter clean
flutter pub get
flutter test --coverage
```

### Mock Generation Fails
```bash
# Clean build cache
flutter packages pub run build_runner clean
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Effective Dart: Testing](https://dart.dev/guides/language/effective-dart/testing)
- [Package: test](https://pub.dev/packages/test)
- [Package: mockito](https://pub.dev/packages/mockito)
- [Package: integration_test](https://docs.flutter.dev/testing/integration-tests)

## Contributing

When adding new features:
1. Write tests first (TDD approach recommended)
2. Ensure tests pass locally
3. Maintain or improve coverage
4. Update this guide if adding new testing patterns

---

**Remember**: Good tests are fast, isolated, repeatable, and self-validating!
