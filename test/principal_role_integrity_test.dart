import 'package:flutter_test/flutter_test.dart';
import 'package:sms_android_app_alpha/data/mock/auth_state.dart';
import 'package:sms_android_app_alpha/models/models.dart';
import 'package:sms_android_app_alpha/widgets/onps_verified_badge.dart';

void main() {
  group('Principal Role Integrity Regression Tests', () {
    test('AuthState resolves UserRole.principal from backend profile', () {
      final profile = {
        'id': 38290,
        'username': 'principal.numan',
        'role': 'principal',
        'designation': 'Principal',
        'full_name': 'Mohd Numan',
      };

      final role = AuthState.resolveRoleFromProfile(profile);
      expect(role, equals(UserRole.principal));
    });

    test('AuthState resolves UserRole.principal from backend profile with role: staff and username: principal.numan', () {
      final profile = {
        'id': 38290,
        'username': 'principal.numan',
        'role': 'staff',
        'email': 'principal@onenuman.com',
      };

      final role = AuthState.resolveRoleFromProfile(profile);
      expect(role, equals(UserRole.principal));
    });

    test('AuthState profile resolution strictly differentiates principal from teacher', () {
      final profile = {
        'id': 38290,
        'username': 'principal.numan',
        'role': 'principal',
        'designation': 'Principal',
        'full_name': 'Mohd Numan',
      };

      final resolved = AuthState.resolveRoleFromProfile(profile);
      expect(resolved, equals(UserRole.principal));
      expect(resolved, isNot(equals(UserRole.classTeacher)));
      expect(resolved, isNot(equals(UserRole.subjectTeacher)));
    });

    test('OnpsVerifiedConfig resolves GOLD badge for Principal and NOT Class Teacher', () {
      final badge = OnpsVerifiedConfig.resolve(
        role: UserRole.principal,
        designation: 'Principal',
        username: 'principal.numan',
      );

      expect(badge.roleName, equals('Principal'));
      expect(badge.colorName, equals('GOLD'));
      expect(badge.roleName, isNot(equals('Class Teacher')));
      expect(badge.colorName, isNot(equals('PURPLE')));
      expect(badge.colorName, isNot(equals('GREEN')));
    });

    test('Real Class Teacher resolves PURPLE/GREEN badge', () {
      final ctBadge = OnpsVerifiedConfig.resolve(
        role: UserRole.classTeacher,
        designation: 'Class Teacher',
        username: 'washingtonsundar',
      );

      expect(ctBadge.roleName, equals('Class Teacher'));
      expect(ctBadge.colorName, equals('PURPLE'));

      final stBadge = OnpsVerifiedConfig.resolve(
        role: UserRole.subjectTeacher,
        designation: 'Faculty',
        username: 'ajinkyarahane',
      );

      expect(stBadge.colorName, equals('GREEN'));
    });
  });
}
