import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sms_android_app_alpha/data/mock/auth_state.dart';
import 'package:sms_android_app_alpha/models/models.dart';
import 'package:sms_android_app_alpha/screens/dashboards/class_teacher_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/dashboards/parent_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/dashboards/principal_dashboard_screen.dart';
import 'package:sms_android_app_alpha/screens/dashboards/student_hub_screen.dart';
import 'package:sms_android_app_alpha/screens/dashboards/subject_teacher_dashboard_screen.dart';

Widget _buildWrapper(Widget child, [UserRole role = UserRole.parent]) {
  final authState = AuthState();
  authState.switchRole(role);
  return ChangeNotifierProvider<AuthState>.value(
    value: authState,
    child: MaterialApp(
      home: child,
    ),
  );
}

void main() {
  testWidgets('Parent dashboard greeting card tap opens AccountProfileSheet', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_buildWrapper(const ParentDashboardScreen(), UserRole.parent));
    await tester.pumpAndSettle();

    expect(find.text('Good Morning, Rajesh Sharma'), findsOneWidget);

    final card = find.byWidgetPredicate((w) => w is Semantics && w.properties.label == 'View account profile');
    expect(card, findsOneWidget);

    await tester.tap(card);
    await tester.pumpAndSettle();

    expect(find.text('User Account Profile'), findsOneWidget);
    expect(find.text('Rajesh Sharma'), findsAtLeastNWidgets(1));
    handle.dispose();
  });

  testWidgets('Principal dashboard greeting card tap opens AccountProfileSheet', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_buildWrapper(const PrincipalDashboardScreen(), UserRole.principal));
    await tester.pumpAndSettle();

    expect(find.text('Principal Numan Khan'), findsOneWidget);

    final card = find.byWidgetPredicate((w) => w is Semantics && w.properties.label == 'View account profile');
    expect(card, findsOneWidget);

    await tester.tap(card);
    await tester.pumpAndSettle();

    expect(find.text('User Account Profile'), findsOneWidget);
    expect(find.text('Principal Numan Khan'), findsAtLeastNWidgets(1));
    handle.dispose();
  });

  testWidgets('Class Teacher dashboard greeting card tap opens AccountProfileSheet', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_buildWrapper(const ClassTeacherDashboardScreen(), UserRole.classTeacher));
    await tester.pumpAndSettle();

    final card = find.byWidgetPredicate((w) => w is Semantics && w.properties.label == 'View account profile');
    expect(card, findsOneWidget);

    await tester.tap(card);
    await tester.pumpAndSettle();

    expect(find.text('User Account Profile'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('Subject Teacher dashboard greeting card tap opens AccountProfileSheet', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_buildWrapper(const SubjectTeacherDashboardScreen(), UserRole.subjectTeacher));
    await tester.pumpAndSettle();

    final card = find.byWidgetPredicate((w) => w is Semantics && w.properties.label == 'View account profile');
    expect(card, findsOneWidget);

    await tester.tap(card);
    await tester.pumpAndSettle();

    expect(find.text('User Account Profile'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('Student Hub identity card tap opens AccountProfileSheet', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_buildWrapper(const StudentHubScreen(), UserRole.student));
    await tester.pumpAndSettle();

    final card = find.byWidgetPredicate((w) => w is Semantics && w.properties.label == 'View account profile');
    expect(card, findsOneWidget);

    await tester.tap(card);
    await tester.pumpAndSettle();

    expect(find.text('User Account Profile'), findsOneWidget);
    handle.dispose();
  });
}
