import 'package:flutter_test/flutter_test.dart';
import 'package:eye_care_app/main.dart';

void main() {
  testWidgets('Eye Care app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const EyeCareApp());

    // Verify that the app title is displayed
    expect(find.text('Eye Care'), findsOneWidget);
  });
}
