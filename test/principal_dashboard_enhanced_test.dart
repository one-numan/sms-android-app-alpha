import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sms_android_app_alpha/data/mock/auth_state.dart';
import 'package:sms_android_app_alpha/models/models.dart';
import 'package:sms_android_app_alpha/screens/dashboards/principal_dashboard_screen.dart';

Widget _buildTestApp(Widget child) {
  final auth = AuthState();
  auth.login(role: UserRole.principal, username: 'numan_khan');

  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, __) => child),
      GoRoute(path: '/faculty/allocation', builder: (_, __) => const Scaffold(body: Text('Faculty Allocation Screen'))),
      GoRoute(path: '/attendance/matrix', builder: (_, __) => const Scaffold(body: Text('Attendance Matrix Screen'))),
      GoRoute(path: '/admissions/applications', builder: (_, __) => const Scaffold(body: Text('Applications Screen'))),
      GoRoute(path: '/attendance/faculty-leave', builder: (_, __) => const Scaffold(body: Text('Faculty Leave Screen'))),
      GoRoute(path: '/principal/announcements/approval', builder: (_, __) => const Scaffold(body: Text('Announcement Approval Screen'))),
      GoRoute(path: '/accounts/dashboard', builder: (_, __) => const Scaffold(body: Text('Accounts Dashboard Screen'))),
      GoRoute(path: '/calendar/academic', builder: (_, __) => const Scaffold(body: Text('Academic Calendar Screen'))),
      GoRoute(path: '/students/all-students', builder: (_, __) => const Scaffold(body: Text('All Students Screen'))),
      GoRoute(path: '/students/marks-entry', builder: (_, __) => const Scaffold(body: Text('Marks Entry Screen'))),
      GoRoute(path: '/faculty/timetable/class', builder: (_, __) => const Scaffold(body: Text('Class Timetable Screen'))),
      GoRoute(path: '/faculty/directory', builder: (_, __) => const Scaffold(body: Text('Staff Directory Screen'))),
      GoRoute(path: '/transit/bus', builder: (_, __) => const Scaffold(body: Text('Bus Transit Screen'))),
      GoRoute(path: '/notices', builder: (_, __) => const Scaffold(body: Text('Notices Screen'))),
    ],
  );

  return ChangeNotifierProvider<AuthState>.value(
    value: auth,
    child: MaterialApp.router(
      routerConfig: router,
    ),
  );
}

void main() {
  testWidgets('Enhanced Principal Dashboard UI/UX Test Suite', (WidgetTester tester) async {
    await tester.pumpWidget(_buildTestApp(const PrincipalDashboardScreen()));
    await tester.pumpAndSettle();

    // 1. Verify Principal Identity Header
    expect(find.textContaining('Principal'), findsAtLeastNWidgets(1));
    expect(find.text('Principal • Head of Institution'), findsOneWidget);
    expect(find.text('2026–27'), findsOneWidget);

    // 2. Verify Today's Overview KPIs
    expect(find.text("TODAY'S OVERVIEW"), findsOneWidget);
    expect(find.text('10000'), findsAtLeastNWidgets(1));
    expect(find.text('255'), findsAtLeastNWidgets(1));
    expect(find.text('85.5%'), findsAtLeastNWidgets(1));

    // 3. Verify Unified Attendance Today Section
    expect(find.text('Attendance Today'), findsOneWidget);
    expect(find.text('Student Attendance'), findsOneWidget);
    expect(find.text('Staff Attendance'), findsOneWidget);
    expect(find.text('8551'), findsOneWidget); // Present students
    expect(find.text('Open Attendance →'), findsOneWidget);

    // 4. Verify Class & Section Progress Section (Replaces Academic Progress)
    expect(find.text('Class & Section Progress'), findsOneWidget);
    expect(find.text('Academic Completion'), findsOneWidget);
    expect(find.text('Class 5-A'), findsOneWidget);
    expect(find.text('Class 5-B'), findsOneWidget);
    expect(find.text('Class 8-A'), findsOneWidget);
    expect(find.text('Class 10-B'), findsOneWidget);
    expect(find.text('92%'), findsOneWidget);
    expect(find.text('86%'), findsOneWidget);
    expect(find.text('78%'), findsOneWidget);
    expect(find.text('95%'), findsOneWidget);
    expect(find.text('32 Active Class Sections'), findsOneWidget);

    // 5. Verify Needs Attention Items
    expect(find.text('Needs Attention'), findsOneWidget);
    expect(find.text('12 Admission Applications Pending'), findsOneWidget);
    expect(find.text('4 Faculty Leave Requests Awaiting Action'), findsOneWidget);
    expect(find.text('3 Circular Announcements Pending Approval'), findsOneWidget);

    // 6. Verify Fee Collection Summary
    expect(find.text('Fee Collection (Term 2)'), findsOneWidget);
    expect(find.text('₹16,92,800'), findsOneWidget);
    expect(find.text('₹1,47,200'), findsOneWidget);

    // 7. Verify Upcoming Events (empty state when no real holiday data is loaded)
    expect(find.text('Upcoming Events'), findsOneWidget);
    expect(find.text('No upcoming holidays or events scheduled.'), findsOneWidget);

    // 8. Verify Quick Access Shortcuts
    expect(find.text('QUICK ACCESS'), findsOneWidget);
    expect(find.text('Students'), findsAtLeastNWidgets(1));
    expect(find.text('Teachers'), findsAtLeastNWidgets(1));
    expect(find.text('Classes'), findsAtLeastNWidgets(1));
    expect(find.text('Exams'), findsOneWidget);
    expect(find.text('Fees'), findsOneWidget);
    expect(find.text('Attendance'), findsAtLeastNWidgets(1));
    expect(find.text('Transport'), findsOneWidget);
    expect(find.text('Circulars'), findsOneWidget);

    // 9. Test Navigation from Class & Section Progress "View All"
    final viewAllBtn = find.text('View All →').first;
    await tester.ensureVisible(viewAllBtn);
    await tester.tap(viewAllBtn);
    await tester.pumpAndSettle();
    expect(find.text('Faculty Allocation Screen'), findsOneWidget);
  });
}
