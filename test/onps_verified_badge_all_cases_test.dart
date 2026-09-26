// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Deep Regression Test: ONPS Verified Badges Across All 5 Cases & Form Factors
// Scope: Principal (Gold), Class Teacher (Purple), Teacher (Green), Student (Blue), Staff (Platinum)
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sms_android_app_alpha/data/mock/auth_state.dart';
import 'package:sms_android_app_alpha/models/models.dart';
import 'package:sms_android_app_alpha/theme/app_theme.dart';
import 'package:sms_android_app_alpha/widgets/account_profile_sheet.dart';
import 'package:sms_android_app_alpha/widgets/onps_verified_badge.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ONPS Verified Badge — Configuration & Resolution Matrix (All 5 Cases)', () {
    test('Case 1: Principal resolves to GOLD & Institutional', () {
      final fromRole = OnpsVerifiedConfig.resolve(role: UserRole.principal);
      expect(fromRole.colorName, 'GOLD');
      expect(fromRole.category, 'Institutional');
      expect(fromRole.assetPath, 'assets/badges/verified_principal.png');

      final fromDesignation = OnpsVerifiedConfig.resolve(designation: 'Principal');
      expect(fromDesignation.colorName, 'GOLD');
      expect(fromDesignation.category, 'Institutional');

      final fromUsername = OnpsVerifiedConfig.resolve(username: 'principal.numan');
      expect(fromUsername.colorName, 'GOLD');
      expect(fromUsername.category, 'Institutional');

      final fromEmail = OnpsVerifiedConfig.resolve(email: 'principal.numan@school.example');
      expect(fromEmail.colorName, 'GOLD');
      expect(fromEmail.category, 'Institutional');
    });

    test('Case 2: Class Teacher resolves to PURPLE & Class responsibility', () {
      final fromRole = OnpsVerifiedConfig.resolve(role: UserRole.classTeacher);
      expect(fromRole.colorName, 'PURPLE');
      expect(fromRole.category, 'Class responsibility');
      expect(fromRole.assetPath, 'assets/badges/verified_class_teacher.png');

      final fromDesignation = OnpsVerifiedConfig.resolve(designation: 'Class Teacher');
      expect(fromDesignation.colorName, 'PURPLE');
      expect(fromDesignation.category, 'Class responsibility');
    });

    test('Case 3: Teacher / Faculty resolves to GREEN & Faculty', () {
      final fromRole = OnpsVerifiedConfig.resolve(role: UserRole.subjectTeacher);
      expect(fromRole.colorName, 'GREEN');
      expect(fromRole.category, 'Faculty');
      expect(fromRole.assetPath, 'assets/badges/verified_teacher.png');

      final fromDesignation = OnpsVerifiedConfig.resolve(designation: 'Senior Faculty');
      expect(fromDesignation.colorName, 'GREEN');
      expect(fromDesignation.category, 'Faculty');

      final fromSubjectTeacher = OnpsVerifiedConfig.resolve(designation: 'Mathematics Teacher');
      expect(fromSubjectTeacher.colorName, 'GREEN');
      expect(fromSubjectTeacher.category, 'Faculty');
    });

    test('Case 4: Student & Parent resolves to BLUE & Student', () {
      final fromStudent = OnpsVerifiedConfig.resolve(role: UserRole.student);
      expect(fromStudent.colorName, 'BLUE');
      expect(fromStudent.category, 'Student');
      expect(fromStudent.assetPath, 'assets/badges/verified_student.png');

      final fromParent = OnpsVerifiedConfig.resolve(role: UserRole.parent);
      expect(fromParent.colorName, 'BLUE');
      expect(fromParent.category, 'Student');

      final fromDesignation = OnpsVerifiedConfig.resolve(designation: 'Class 5 Student');
      expect(fromDesignation.colorName, 'BLUE');
      expect(fromDesignation.category, 'Student');
    });

    test('Case 5: Staff resolves to PLATINUM & Staff', () {
      final fromRole = OnpsVerifiedConfig.resolve(role: UserRole.accountant);
      expect(fromRole.colorName, 'PLATINUM');
      expect(fromRole.category, 'Staff');
      expect(fromRole.assetPath, 'assets/badges/verified_staff.png');

      final fromLibrarian = OnpsVerifiedConfig.resolve(role: UserRole.librarian);
      expect(fromLibrarian.colorName, 'PLATINUM');
      expect(fromLibrarian.category, 'Staff');

      final fromReceptionist = OnpsVerifiedConfig.resolve(role: UserRole.receptionist);
      expect(fromReceptionist.colorName, 'PLATINUM');
      expect(fromReceptionist.category, 'Staff');
    });
  });

  group('ONPS Verified Badge — UI Widget Rendering & Sizing Across All 5 Cases', () {
    testWidgets('Renders all 5 badges simultaneously without layout errors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AcademicTheme.themeData,
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  OnpsVerifiedBadge.principal(size: 20, showLabel: true),
                  OnpsVerifiedBadge.classTeacher(size: 20, showLabel: true),
                  OnpsVerifiedBadge.teacher(size: 20, showLabel: true),
                  OnpsVerifiedBadge.student(size: 20, showLabel: true),
                  OnpsVerifiedBadge.staff(size: 20, showLabel: true),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(OnpsVerifiedBadge), findsNWidgets(5));
      expect(find.text('Verified'), findsNWidgets(5));
      expect(tester.takeException(), isNull);
    });

    testWidgets('Renders badges with category titles across all 5 cases', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AcademicTheme.themeData,
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  OnpsVerifiedBadge.principal(size: 24, showCategory: true),
                  OnpsVerifiedBadge.classTeacher(size: 24, showCategory: true),
                  OnpsVerifiedBadge.teacher(size: 24, showCategory: true),
                  OnpsVerifiedBadge.student(size: 24, showCategory: true),
                  OnpsVerifiedBadge.staff(size: 24, showCategory: true),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Institutional'), findsOneWidget);
      expect(find.text('Class responsibility'), findsOneWidget);
      expect(find.text('Faculty'), findsOneWidget);
      expect(find.text('Student'), findsOneWidget);
      expect(find.text('Staff'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Tapping verified badge opens official explanation modal with details', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AcademicTheme.themeData,
          home: Scaffold(
            body: Center(
              child: OnpsVerifiedBadge.principal(size: 24),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap badge
      await tester.tap(find.byType(OnpsVerifiedBadge));
      await tester.pumpAndSettle();

      // Check modal content
      expect(find.text('ONPS VERIFIED'), findsOneWidget);
      expect(find.text('Principal • GOLD'), findsOneWidget);
      expect(find.text('Tier: Institutional'), findsOneWidget);
      expect(find.textContaining('institutional authority'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Zero overflow in narrow 320px viewport with long names', (tester) async {
      tester.view.physicalSize = const Size(320, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          theme: AcademicTheme.themeData,
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Prof. Dr. Mohammad Numan Al-Hussaini Senior Executive',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  OnpsVerifiedBadge.principal(size: 20, showLabel: true),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Verified'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('AccountProfileSheet displays correct verified badge for Principal Mohd Numan', (tester) async {
      final auth = AuthState();
      await auth.login(
        role: UserRole.principal,
        username: 'principal.numan',
        password: 'principal12345',
      );

      await tester.pumpWidget(
        ChangeNotifierProvider<AuthState>.value(
          value: auth,
          child: MaterialApp(
            theme: AcademicTheme.themeData,
            home: const Scaffold(
              body: AccountProfileSheet(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(OnpsVerifiedBadge), findsOneWidget);
      expect(find.text('Principal'), findsWidgets);
      expect(find.text('Executive Tier 0'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('AccountProfileSheet displays PURPLE Class Teacher badge when role is Class Teacher', (tester) async {
      final auth = AuthState();
      auth.switchRole(UserRole.classTeacher);

      await tester.pumpWidget(
        ChangeNotifierProvider<AuthState>.value(
          value: auth,
          child: MaterialApp(
            theme: AcademicTheme.themeData,
            home: const Scaffold(
              body: AccountProfileSheet(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(OnpsVerifiedBadge), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('AccountProfileSheet displays GREEN Faculty badge when role is Subject Teacher', (tester) async {
      final auth = AuthState();
      auth.switchRole(UserRole.subjectTeacher);

      await tester.pumpWidget(
        ChangeNotifierProvider<AuthState>.value(
          value: auth,
          child: MaterialApp(
            theme: AcademicTheme.themeData,
            home: const Scaffold(
              body: AccountProfileSheet(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(OnpsVerifiedBadge), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('AccountProfileSheet displays BLUE Student badge when role is Student', (tester) async {
      final auth = AuthState();
      auth.switchRole(UserRole.student);

      await tester.pumpWidget(
        ChangeNotifierProvider<AuthState>.value(
          value: auth,
          child: MaterialApp(
            theme: AcademicTheme.themeData,
            home: const Scaffold(
              body: AccountProfileSheet(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(OnpsVerifiedBadge), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('AccountProfileSheet displays PLATINUM Staff badge when role is Staff/Accountant', (tester) async {
      final auth = AuthState();
      auth.switchRole(UserRole.accountant);

      await tester.pumpWidget(
        ChangeNotifierProvider<AuthState>.value(
          value: auth,
          child: MaterialApp(
            theme: AcademicTheme.themeData,
            home: const Scaffold(
              body: AccountProfileSheet(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(OnpsVerifiedBadge), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Renders all extreme sizes without distortion or crash (10px to 128px)', (tester) async {
      final sizes = [10.0, 14.0, 16.0, 18.0, 20.0, 24.0, 32.0, 48.0, 64.0, 128.0];

      await tester.pumpWidget(
        MaterialApp(
          theme: AcademicTheme.themeData,
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: sizes.map((s) => OnpsVerifiedBadge.principal(size: s)).toList(),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(OnpsVerifiedBadge), findsNWidgets(sizes.length));
      expect(tester.takeException(), isNull);
    });

    testWidgets('Edge case resolution fallback handles nulls and non-standard strings safely', (tester) async {
      // Empty inputs fallback gracefully to staff
      final emptyFallback = OnpsVerifiedConfig.resolve();
      expect(emptyFallback.colorName, 'PLATINUM');
      expect(emptyFallback.category, 'Staff');

      // SuperAdmin resolves to Institutional Gold
      final superAdmin = OnpsVerifiedConfig.resolve(role: UserRole.superAdmin);
      expect(superAdmin.colorName, 'GOLD');
      expect(superAdmin.category, 'Institutional');

      // Arbitrary faculty strings
      final chemistryLecturer = OnpsVerifiedConfig.resolve(designation: 'HOD Chemistry Faculty');
      expect(chemistryLecturer.colorName, 'GREEN');
      expect(chemistryLecturer.category, 'Faculty');

      // Class Teacher in uppercase
      final classTeacherUpper = OnpsVerifiedConfig.resolve(designation: 'CLASS TEACHER GRADE 10');
      expect(classTeacherUpper.colorName, 'PURPLE');
      expect(classTeacherUpper.category, 'Class responsibility');
    });
  });
}
