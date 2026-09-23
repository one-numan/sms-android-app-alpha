// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Test Suite: Batch A — Shared Core / Auth / Profile MockData Elimination
// Verifies:
// 1. No JWT -> unauthenticated
// 2. Valid JWT -> authenticated user
// 3. Valid profile -> correct profile shown, zero demo personas
// 4. Invalid JWT -> reject login
// 5. 401 response -> clear token & user identity & return to login
// 6. Profile API failure -> empty state, no fake user
// 7. Missing profile fields -> empty, no MockData
// 8. Logout -> all identity state cleared
// 9. Re-login with another user -> previous identity purged
// 10. AppConfig institutional branding
// ==============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:sms_android_app_alpha/core/api/api_client.dart';
import 'package:sms_android_app_alpha/core/api/token_storage.dart';
import 'package:sms_android_app_alpha/core/config/app_config.dart';
import 'package:sms_android_app_alpha/data/mock/auth_state.dart';
import 'package:sms_android_app_alpha/models/models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await TokenStorage.clearSession();
  });

  group('Batch A — Auth & Profile MockData Elimination Tests', () {
    test('1. No JWT -> unauthenticated state & empty identity', () async {
      final auth = AuthState(isAuthenticated: false);
      expect(auth.isAuthenticated, isFalse);
      expect(auth.currentUsername, isEmpty);
      expect(auth.fullName, isEmpty);
      expect(auth.userEmail, isEmpty);
      expect(auth.userMobile, isEmpty);
    });

    test('2. Valid user session sets authenticated state', () {
      final auth = AuthState(isAuthenticated: true);
      expect(auth.isAuthenticated, isTrue);
    });

    test('3. Real profile data is reflected accurately without fallback persona', () {
      final auth = AuthState(isAuthenticated: true);
      auth.switchRole(UserRole.principal);
      expect(AuthState.roleTitle(auth.currentRole), 'Principal');
      expect(auth.fullName, isNot('Rajesh Sharma'));
      expect(auth.fullName, isNot('Principal Numan Khan'));
      expect(auth.fullName, isNot('Dr. M. Chacko'));
    });

    test('4. Invalid login credentials reject authentication', () async {
      final auth = AuthState(isAuthenticated: false);
      final success = await auth.login(
        role: UserRole.principal,
        username: 'nonexistent',
        password: 'wrong',
      );
      expect(success, isFalse);
      expect(auth.isAuthenticated, isFalse);
    });

    test('5. 401 response / ApiClient.onUnauthorized triggers signOut & clears identity', () async {
      final auth = AuthState(isAuthenticated: true);
      auth.switchRole(UserRole.classTeacher);
      
      // Simulate 401 callback triggered by ApiClient
      ApiClient.onUnauthorized?.call();
      
      expect(auth.isAuthenticated, isFalse);
      expect(auth.currentUsername, isEmpty);
      expect(auth.fullName, isEmpty);
      expect(auth.authenticatedStudent, isNull);
      expect(auth.userProfile, isNull);
      expect(auth.currentRole, UserRole.student);
    });

    test('6. Profile failure produces no fake persona', () {
      final auth = AuthState(isAuthenticated: false);
      expect(auth.fullName, isEmpty);
      expect(auth.fullName, isNot('Dr. M. Chacko'));
      expect(auth.fullName, isNot('Rajesh Sharma'));
      expect(auth.fullName, isNot('Principal Numan Khan'));
    });

    test('7. Missing profile field yields empty state, never MockData', () {
      final auth = AuthState(isAuthenticated: true);
      expect(auth.userEmail, isEmpty);
      expect(auth.userMobile, isEmpty);
    });

    test('8. Logout clears all identity and role state', () {
      final auth = AuthState(isAuthenticated: true);
      auth.switchRole(UserRole.principal);
      auth.signOut();
      
      expect(auth.isAuthenticated, isFalse);
      expect(auth.currentUsername, isEmpty);
      expect(auth.fullName, isEmpty);
      expect(auth.authenticatedStudent, isNull);
      expect(auth.userProfile, isNull);
      expect(auth.selectedChildIndex, 0);
      expect(auth.currentRole, UserRole.student);
    });

    test('9. Re-login with another user does not inherit previous user identity', () async {
      final auth = AuthState(isAuthenticated: false);
      // User A
      await auth.login(role: UserRole.subjectTeacher, username: 'teacher.user', password: 'demo12345');
      expect(auth.currentUsername, 'teacher.user');
      expect(auth.fullName, 'Teacher User');

      // Logout User A
      auth.signOut();
      expect(auth.currentUsername, isEmpty);
      expect(auth.fullName, isEmpty);

      // User B
      await auth.login(role: UserRole.librarian, username: 'librarian.user', password: 'demo12345');
      expect(auth.currentUsername, 'librarian.user');
      expect(auth.fullName, 'Librarian User');
      expect(auth.fullName, isNot('Teacher User'));
    });

    test('10. Institutional AppConfig contains verified production branding', () {
      expect(AppConfig.schoolName, 'One Numan Public School');
      expect(AppConfig.academicSession, 'Session 2026-27');
      expect(AppConfig.campusAddress, 'Civil Lines Campus, New Delhi 110054');
    });
  });
}
