// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Unit & Widget Tests: Digital Student ID Card Screen
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sms_android_app_alpha/main.dart';
import 'package:sms_android_app_alpha/screens/dashboards/parent_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/students/digital_student_id_card_screen.dart';

void main() {
  testWidgets('Test Digital Student ID Card Hierarchy, Verification, and Strict Rules', (WidgetTester tester) async {
    await tester.pumpWidget(const OnpsErpApp());
    await tester.pumpAndSettle();

    // Navigate to /student/digital-id-sheet
    final BuildContext context = tester.element(find.byType(ParentDashboardScreen));
    context.go('/student/digital-id-sheet');
    await tester.pumpAndSettle();

    expect(find.byType(DigitalStudentIdCardScreen), findsOneWidget);

    // 1. Header Verification
    expect(find.text('Digital Student ID'), findsOneWidget);
    expect(find.text('Verified Student Identity'), findsOneWidget);
    expect(find.byIcon(Icons.share_outlined), findsOneWidget);
    expect(find.text('PDF'), findsOneWidget);

    // 2. School Identity
    expect(find.text('ONE NUMAN PUBLIC SCHOOL'), findsOneWidget);
    expect(find.text('Affiliated to CBSE • Civil Lines'), findsOneWidget);
    expect(find.text('ACADEMIC SESSION 2026–27'), findsOneWidget);

    // 3. Student Identification
    expect(find.text('DIYA SHARMA'), findsOneWidget);
    expect(find.text('DS'), findsOneWidget);
    expect(find.text('Grade 5 • Section A • Roll No. 14'), findsOneWidget);

    // 4. Structured Identity Attributes
    expect(find.text('ADMISSION NO'), findsOneWidget);
    expect(find.text('ADM-2024-0412'), findsOneWidget);
    expect(find.text('DATE OF BIRTH'), findsOneWidget);
    expect(find.text('14 Aug 2015'), findsOneWidget);
    expect(find.text('BLOOD GROUP'), findsOneWidget);
    expect(find.text('B+'), findsOneWidget);
    expect(find.text('HOUSE'), findsOneWidget);
    expect(find.text('Ruby House'), findsOneWidget);

    // 5. Validity
    expect(find.text('Card Validity'), findsOneWidget);
    expect(find.text('Valid Through 31 Mar 2027'), findsOneWidget);

    // 6. QR Verification Block
    expect(find.text('STUDENT VERIFICATION'), findsOneWidget);
    expect(find.text('Verified'), findsOneWidget);
    expect(find.text('ONPS-VERIFY-2026-ADM0412'), findsOneWidget);

    // 7. Principal Authorization
    expect(find.text('Authorized By'), findsOneWidget);
    expect(find.text('Principal'), findsOneWidget);

    // 8. Emergency Contact
    expect(find.text('EMERGENCY CONTACT (FATHER)'), findsOneWidget);
    expect(find.text('Rajesh Sharma'), findsOneWidget);
    expect(find.text('+91 98765 43210'), findsOneWidget);

    // 9. Negative assertions: Ensure technical jargon and operational manuals are completely removed
    expect(find.textContaining('Encrypted Security Token'), findsNothing);
    expect(find.textContaining('CBSE Live'), findsNothing);
    expect(find.textContaining('Campus Access Protocol'), findsNothing);
    expect(find.textContaining('Cryptographically verified'), findsNothing);
    expect(find.textContaining('Synced Today'), findsNothing);
    expect(find.textContaining('Transit Route'), findsNothing);
    expect(find.textContaining('202604125014'), findsNothing);

    // 10. Strict Zero Emojis Rule across all Text widgets
    final textWidgets = tester.widgetList<Text>(find.byType(Text));
    final emojiRegex = RegExp(
      r'[\u{1F600}-\u{1F64F}\u{1F300}-\u{1F5FF}\u{1F680}-\u{1F6FF}\u{1F1E0}-\u{1F1FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}]',
      unicode: true,
    );
    for (final text in textWidgets) {
      final data = text.data ?? text.textSpan?.toPlainText() ?? '';
      expect(
        emojiRegex.hasMatch(data),
        isFalse,
        reason: 'Text "$data" should not contain emojis',
      );
    }
  });
}
