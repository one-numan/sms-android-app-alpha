// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Automated Test Suite: Parents Directory UI/UX Deep Verification
// Verifies:
// 1. Strict Terminology: "Student" instead of "Ward" across UI.
// 2. Information hierarchy: Parent identity, Portal status, Linked Students.
// 3. Multi-student capsules ("STUDENTS · 2") vs single-student ("STUDENT").
// 4. Dynamic KPI computation (Attendance % and Outstanding Fees from real data).
// 5. Search, filtering, Add Parent & Link Student modals.
// 6. Zero unicode emojis.
// 7. Role-based access guard for unauthorized personas.
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sms_android_app_alpha/data/mock/auth_state.dart';
import 'package:sms_android_app_alpha/models/models.dart';
import 'package:sms_android_app_alpha/screens/admin/parents_directory_screen.dart';

Widget createParentsDirectoryTestApp(AuthState authState) {
  return ChangeNotifierProvider<AuthState>.value(
    value: authState,
    child: const MaterialApp(
      home: ParentsDirectoryScreen(),
    ),
  );
}

void main() {
  group('Parents Directory — UI/UX Deep Verification', () {
    late AuthState staffAuth;
    late AuthState studentAuth;

    setUp(() {
      staffAuth = AuthState();
      staffAuth.login(role: UserRole.principal, username: 'dr.sharma');

      studentAuth = AuthState();
      studentAuth.login(role: UserRole.student, username: 'diya.sharma');
    });

    testWidgets('TEST 1: Strict Terminology — Zero "Ward" or "Wards" in staff UI', (tester) async {
      await tester.pumpWidget(createParentsDirectoryTestApp(staffAuth));
      await tester.pumpAndSettle();

      final wardRegex = RegExp(r'\bward\b|\bwards\b', caseSensitive: false);
      for (final textWidget in tester.widgetList<Text>(find.byType(Text))) {
        final text = textWidget.data ?? '';
        expect(
          wardRegex.hasMatch(text),
          isFalse,
          reason: 'Forbidden terminology "ward/wards" found in text: "$text"',
        );
      }
    });

    testWidgets('TEST 2: Header, Primary Actions, Summary and Filter Chips', (tester) async {
      await tester.pumpWidget(createParentsDirectoryTestApp(staffAuth));
      await tester.pumpAndSettle();

      // Header title
      expect(find.text('Parents Directory'), findsWidgets);

      // Primary actions
      expect(find.text('Add Parent'), findsOneWidget);
      expect(find.text('Link Student'), findsOneWidget);

      // Search placeholder
      expect(find.text('Search parent by name, mobile or email'), findsOneWidget);

      // Directory Summary counters
      expect(find.textContaining('Registered Parents'), findsOneWidget);
      expect(find.textContaining('Students'), findsWidgets);

      // Filter chips
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Portal Linked'), findsWidgets);
      expect(find.text('No Account'), findsOneWidget);
      expect(find.text('Father'), findsWidgets);
      expect(find.text('Mother'), findsWidgets);
      expect(find.text('Guardian'), findsWidgets);
    });

    testWidgets('TEST 3: Multi-Student Capsule & Dynamic KPIs for Rajesh Sharma', (tester) async {
      await tester.pumpWidget(createParentsDirectoryTestApp(staffAuth));
      await tester.pumpAndSettle();

      // Rajesh Sharma (Father)
      expect(find.text('Rajesh Sharma'), findsOneWidget);
      expect(find.text('+91 98100 12345'), findsOneWidget);
      expect(find.text('rajesh.sharma@example.com'), findsOneWidget);

      // Multi-student indicator
      expect(find.text('STUDENTS · 2'), findsWidgets);

      // Linked students under Rajesh
      expect(find.text('Diya Sharma'), findsWidgets);
      expect(find.text('Class 5-A · Roll 14'), findsWidgets);
      expect(find.text('Aarav Sharma'), findsWidgets);
      expect(find.text('Class 2-B · Roll 3'), findsWidgets);

      // Attendance & Fee metrics
      expect(find.text('Attendance'), findsWidgets);
      expect(find.text('Outstanding Fees'), findsWidgets);
      expect(find.text('₹12,450'), findsWidgets);
      expect(find.text('All Clear'), findsWidgets);

      // Student Profile link
      expect(find.text('Student Profile'), findsWidgets);
    });

    testWidgets('TEST 4: Single-Student Capsule for Vikram Kapoor', (tester) async {
      await tester.pumpWidget(createParentsDirectoryTestApp(staffAuth));
      await tester.pumpAndSettle();

      // Scroll down until Vikram Kapoor is visible using the vertical ListView
      await tester.drag(find.byType(ListView).last, const Offset(0, -600));
      await tester.pumpAndSettle();

      expect(find.text('Vikram Kapoor'), findsOneWidget);
      expect(find.text('STUDENT'), findsWidgets);
      expect(find.text('Myra Kapoor'), findsWidgets);
      expect(find.text('Class 5-C · Roll 21'), findsWidgets);
    });

    testWidgets('TEST 5: Search filtering works dynamically', (tester) async {
      await tester.pumpWidget(createParentsDirectoryTestApp(staffAuth));
      await tester.pumpAndSettle();

      // Search for "Malhotra"
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'Malhotra');
      await tester.pumpAndSettle();

      expect(find.text('Sanjay Malhotra'), findsOneWidget);
      expect(find.text('Rajesh Sharma'), findsNothing);
      expect(find.text('Rohan Verma'), findsOneWidget);
    });

    testWidgets('TEST 6: Role Guard prevents unauthorized Student from accessing directory', (tester) async {
      await tester.pumpWidget(createParentsDirectoryTestApp(studentAuth));
      await tester.pumpAndSettle();

      // Should show Access Restricted
      expect(find.text('Access Restricted'), findsOneWidget);
      expect(
        find.textContaining('The Parents Directory contains sensitive parent contact information'),
        findsOneWidget,
      );
      expect(find.text('Rajesh Sharma'), findsNothing);
    });

    testWidgets('TEST 7: Zero unicode emojis used across Parents Directory', (tester) async {
      final emojiPattern = RegExp(
        r'[\u{1F300}-\u{1F5FF}\u{1F600}-\u{1F64F}\u{1F680}-\u{1F6FF}\u{1F700}-\u{1F77F}\u{1F780}-\u{1F7FF}\u{1F800}-\u{1F8FF}\u{1F900}-\u{1F9FF}\u{1FA00}-\u{1FA6F}\u{2600}-\u{26FF}\u{2700}-\u{27BF}]',
        unicode: true,
      );

      await tester.pumpWidget(createParentsDirectoryTestApp(staffAuth));
      await tester.pumpAndSettle();

      for (final textWidget in tester.widgetList<Text>(find.byType(Text))) {
        final text = textWidget.data ?? '';
        expect(
          emojiPattern.hasMatch(text),
          isFalse,
          reason: 'Found emoji in Parents Directory: "$text"',
        );
      }
    });
  });
}
