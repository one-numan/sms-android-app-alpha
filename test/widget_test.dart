import 'package:flutter_test/flutter_test.dart';
import 'package:sms_android_app_alpha/main.dart';

void main() {
  testWidgets('ONPS ERP App Smoke Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const OnpsErpApp());
    await tester.pumpAndSettle();

    // Verify app renders with the ONPS brand wordmark in the shared top bar
    expect(find.textContaining('ONPS'), findsWidgets);
  });
}
