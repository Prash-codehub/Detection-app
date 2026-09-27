import 'package:flutter_test/flutter_test.dart';
import 'package:snack_spotter/main.dart';

void main() {
  testWidgets('App launches without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const SnackSpotterApp());
    // Verify splash screen elements
    expect(find.text('SnackSpotter'), findsOneWidget);
    expect(find.text('AI-Powered Snack Detection'), findsOneWidget);
  });
}
