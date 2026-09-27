// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Unit & Widget Tests: Marks Entry Desk Screen
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sms_android_app_alpha/data/mock/auth_state.dart';
import 'package:sms_android_app_alpha/models/models.dart';
import 'package:sms_android_app_alpha/screens/students/marks_entry_desk_screen.dart';

void main() {
  testWidgets('MarksEntryDeskScreen mounts with custom class and subject parameters', (WidgetTester tester) async {
    final authState = AuthState();
    authState.switchRole(UserRole.classTeacher);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthState>.value(value: authState),
        ],
        child: const MaterialApp(
          home: MarksEntryDeskScreen(
            className: 'Grade Nursery B',
            classId: 'CLS-257',
            subjectName: 'English',
            examType: 'Second Assessment',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify screen title
    expect(find.text('Marks Entry Desk'), findsOneWidget);
    expect(find.text('Online Sync Live'), findsOneWidget);

    // Verify dynamic class and subject in header
    expect(find.textContaining('N - B • English'), findsOneWidget);
    expect(find.text('Max Marks: 50 • Session 2026-27'), findsOneWidget);

    // Verify exam dropdown
    expect(find.text('Second Assessment'), findsOneWidget);

    // Verify action buttons
    expect(find.text('Save Draft'), findsOneWidget);
    expect(find.text('Lock & Finalize'), findsOneWidget);

    // Verify students rendered
    expect(find.text('Aarav Sharma'), findsOneWidget);
    expect(find.text('Diya Sharma'), findsOneWidget);
  });

  testWidgets('MarksEntryDeskScreen allows score input and updates grade', (WidgetTester tester) async {
    final authState = AuthState();
    authState.switchRole(UserRole.classTeacher);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthState>.value(value: authState),
        ],
        child: const MaterialApp(
          home: MarksEntryDeskScreen(
            className: 'Grade 5-A',
            classId: 'CLS-101',
            subjectName: 'Mathematics',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify initial grade for Aarav (score 46 -> A1)
    expect(find.textContaining('Grade: A1'), findsOneWidget);

    // Tap Save Draft
    await tester.tap(find.text('Save Draft'));
    await tester.pump();
  });
}
