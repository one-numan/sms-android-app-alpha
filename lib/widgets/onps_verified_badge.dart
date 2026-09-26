// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Component: ONPS Verified Identity Badges
// Architecture: Role-Based Tiered Verification System
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

enum VerifiedTier {
  principal,
  classTeacher,
  teacher,
  student,
  staff,
}

class VerifiedBadgeInfo {
  final String roleName;
  final String colorName;
  final String category;
  final String assetPath;
  final Color accentColor;
  final String description;

  const VerifiedBadgeInfo({
    required this.roleName,
    required this.colorName,
    required this.category,
    required this.assetPath,
    required this.accentColor,
    required this.description,
  });
}

class OnpsVerifiedConfig {
  static const principal = VerifiedBadgeInfo(
    roleName: 'Principal',
    colorName: 'GOLD',
    category: 'Institutional',
    assetPath: 'assets/badges/verified_principal.png',
    accentColor: Color(0xFFC59B27),
    description: 'Highest institutional authority & executive verification',
  );

  static const classTeacher = VerifiedBadgeInfo(
    roleName: 'Class Teacher',
    colorName: 'PURPLE',
    category: 'Class responsibility',
    assetPath: 'assets/badges/verified_class_teacher.png',
    accentColor: Color(0xFF7C3AED),
    description: 'Classroom stewardship & pastoral leadership verification',
  );

  static const teacher = VerifiedBadgeInfo(
    roleName: 'Teacher',
    colorName: 'GREEN',
    category: 'Faculty',
    assetPath: 'assets/badges/verified_teacher.png',
    accentColor: Color(0xFF059669),
    description: 'Certified academic faculty & subject authority',
  );

  static const student = VerifiedBadgeInfo(
    roleName: 'Student',
    colorName: 'BLUE',
    category: 'Student',
    assetPath: 'assets/badges/verified_student.png',
    accentColor: Color(0xFF0284C7),
    description: 'Authoritative enrolled student identity verification',
  );

  static const staff = VerifiedBadgeInfo(
    roleName: 'Staff',
    colorName: 'PLATINUM',
    category: 'Staff',
    assetPath: 'assets/badges/verified_staff.png',
    accentColor: Color(0xFF64748B),
    description: 'Institutional administration & operations staff verification',
  );

  static VerifiedBadgeInfo resolve({
    UserRole? role,
    String? designation,
    String? username,
    String? email,
  }) {
    final dLower = (designation ?? '').toLowerCase().trim();
    final uLower = (username ?? '').toLowerCase().trim();
    final eLower = (email ?? '').toLowerCase().trim();

    // Check Principal
    if (dLower.contains('principal') ||
        uLower.contains('principal') ||
        eLower.contains('principal') ||
        role == UserRole.principal ||
        role == UserRole.superAdmin) {
      return principal;
    }

    // Check Class Teacher
    if (dLower.contains('class teacher') || role == UserRole.classTeacher) {
      return classTeacher;
    }

    // Check Subject Teacher / Faculty
    if (dLower.contains('teacher') ||
        dLower.contains('faculty') ||
        role == UserRole.subjectTeacher) {
      return teacher;
    }

    // Check Student & Parent
    if (role == UserRole.student || role == UserRole.parent || dLower.contains('student')) {
      return student;
    }

    // Check Staff / Admin / Operational
    return staff;
  }
}

/// Official ONPS Verified Badge Widget.
class OnpsVerifiedBadge extends StatelessWidget {
  final UserRole? role;
  final String? designation;
  final String? username;
  final String? email;
  final double size;
  final bool showLabel;
  final bool showCategory;
  final bool interactive;

  const OnpsVerifiedBadge({
    super.key,
    this.role,
    this.designation,
    this.username,
    this.email,
    this.size = 18.0,
    this.showLabel = false,
    this.showCategory = false,
    this.interactive = true,
  });

  /// Factory specifically for Principal / Executive.
  factory OnpsVerifiedBadge.principal({double size = 18.0, bool showLabel = false, bool showCategory = false}) {
    return OnpsVerifiedBadge(
      role: UserRole.principal,
      designation: 'Principal',
      size: size,
      showLabel: showLabel,
      showCategory: showCategory,
    );
  }

  /// Factory specifically for Class Teacher.
  factory OnpsVerifiedBadge.classTeacher({double size = 18.0, bool showLabel = false, bool showCategory = false}) {
    return OnpsVerifiedBadge(
      role: UserRole.classTeacher,
      designation: 'Class Teacher',
      size: size,
      showLabel: showLabel,
      showCategory: showCategory,
    );
  }

  /// Factory specifically for Teacher / Faculty.
  factory OnpsVerifiedBadge.teacher({double size = 18.0, bool showLabel = false, bool showCategory = false}) {
    return OnpsVerifiedBadge(
      role: UserRole.subjectTeacher,
      designation: 'Teacher',
      size: size,
      showLabel: showLabel,
      showCategory: showCategory,
    );
  }

  /// Factory specifically for Student.
  factory OnpsVerifiedBadge.student({double size = 18.0, bool showLabel = false, bool showCategory = false}) {
    return OnpsVerifiedBadge(
      role: UserRole.student,
      designation: 'Student',
      size: size,
      showLabel: showLabel,
      showCategory: showCategory,
    );
  }

  /// Factory specifically for Staff.
  factory OnpsVerifiedBadge.staff({double size = 18.0, bool showLabel = false, bool showCategory = false}) {
    return OnpsVerifiedBadge(
      role: UserRole.accountant,
      designation: 'Staff',
      size: size,
      showLabel: showLabel,
      showCategory: showCategory,
    );
  }

  void _showExplanation(BuildContext context, VerifiedBadgeInfo info) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
          decoration: const BoxDecoration(
            color: AcademicColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AcademicColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 18),
            Image.asset(
              info.assetPath,
              width: 64,
              height: 64,
              errorBuilder: (_, __, ___) => Icon(Icons.verified, size: 64, color: info.accentColor),
            ),
            const SizedBox(height: 12),
            Text(
              'ONPS VERIFIED',
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
                color: AcademicColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${info.roleName} • ${info.colorName}',
              style: GoogleFonts.newsreader(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AcademicColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: info.accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: info.accentColor.withValues(alpha: 0.3)),
              ),
              child: Text(
                'Tier: ${info.category}',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: info.accentColor,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              info.description,
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 13,
                color: AcademicColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 14),
            Text(
              'Authentic institutional record cryptographically linked to the official CBSE campus database ledger.',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 11,
                color: AcademicColors.textSecondary.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    ),
  ),
);
  }

  @override
  Widget build(BuildContext context) {
    final info = OnpsVerifiedConfig.resolve(
      role: role,
      designation: designation,
      username: username,
      email: email,
    );

    Widget badgeIcon = Image.asset(
      info.assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (ctx, err, stack) => Icon(
        Icons.verified,
        size: size,
        color: info.accentColor,
      ),
    );

    Widget content;
    if (!showLabel && !showCategory) {
      content = badgeIcon;
    } else {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          badgeIcon,
          const SizedBox(width: 5),
          Text(
            showCategory ? info.category : 'Verified',
            style: GoogleFonts.manrope(
              fontSize: (size * 0.65).clamp(11.0, 14.0),
              fontWeight: FontWeight.bold,
              color: info.accentColor,
            ),
          ),
        ],
      );
    }

    if (!interactive) return content;

    return Semantics(
      label: 'ONPS Verified ${info.roleName} - ${info.category}',
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _showExplanation(context, info),
        child: content,
      ),
    );
  }
}
