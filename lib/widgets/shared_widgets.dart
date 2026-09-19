// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Shared UI Widgets: Inset Cards, Pill Badges, List Rows, Profile Capsules
// Design System: Espresso Heritage Academic
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Fully rounded pill badge for statuses, counts, and tags
class PillBadge extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final double fontSize;

  const PillBadge({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
    this.fontSize = 10.5,
  });

  factory PillBadge.success(String text, {IconData? icon}) {
    return PillBadge(
      text: text,
      backgroundColor: AcademicColors.successContainer,
      textColor: AcademicColors.success,
      icon: icon,
    );
  }

  factory PillBadge.warning(String text, {IconData? icon}) {
    return PillBadge(
      text: text,
      backgroundColor: AcademicColors.warningContainer,
      textColor: AcademicColors.warning,
      icon: icon,
    );
  }

  factory PillBadge.danger(String text, {IconData? icon}) {
    return PillBadge(
      text: text,
      backgroundColor: AcademicColors.dangerContainer,
      textColor: AcademicColors.danger,
      icon: icon,
    );
  }

  factory PillBadge.info(String text, {IconData? icon}) {
    return PillBadge(
      text: text,
      backgroundColor: AcademicColors.infoContainer,
      textColor: AcademicColors.info,
      icon: icon,
    );
  }

  factory PillBadge.neutral(String text, {IconData? icon}) {
    return PillBadge(
      text: text,
      backgroundColor: const Color(0xFFF0EBE7),
      textColor: AcademicColors.textSecondary,
      icon: icon,
    );
  }

  factory PillBadge.secondary(String text, {IconData? icon}) {
    return PillBadge(
      text: text,
      backgroundColor: const Color(0xFFF0EBE7),
      textColor: AcademicColors.textSecondary,
      icon: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize + 1, color: textColor),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              text,
              style: GoogleFonts.manrope(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: textColor,
                letterSpacing: 0.2,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Inset Grouped Card (16px radius, border, soft shadow)
class InsetCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const InsetCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.only(bottom: 12),
    this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidget = Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? AcademicColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AcademicColors.border, width: 1),
        boxShadow: AcademicColors.cardShadow,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: child,
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: cardWidget,
      );
    }
    return cardWidget;
  }
}

/// Inset Grouped List Row
class ListRowItem extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;

  const ListRowItem({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.manrope(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: AcademicColors.textPrimary,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: GoogleFonts.manrope(
                            fontSize: 11.5,
                            color: AcademicColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 8),
                  trailing!,
                ] else if (onTap != null) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right, size: 18, color: AcademicColors.textSecondary),
                ],
              ],
            ),
          ),
        ),
        if (showDivider)
          const Divider(height: 1, color: AcademicColors.border),
      ],
    );
  }
}

/// Student Capsule Card
class StudentCapsuleCard extends StatelessWidget {
  final String? name;
  final String? gradeSection;
  final int? rollNumber;
  final dynamic student;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const StudentCapsuleCard({
    super.key,
    this.name,
    this.gradeSection,
    this.rollNumber,
    this.student,
    this.subtitle,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final String sName = (student != null)
        ? (student.name ?? 'Student')
        : (name ?? 'Student');
    final String sSub = subtitle ??
        '${gradeSection ?? "Grade 5-A"} • Roll ${rollNumber ?? (student?.rollNumber ?? 1)}';

    return InsetCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AcademicColors.primaryDark,
            child: Text(
              sName.isNotEmpty ? sName[0].toUpperCase() : 'S',
              style: GoogleFonts.newsreader(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sName,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AcademicColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sSub,
                  style: GoogleFonts.manrope(
                    fontSize: 11.5,
                    color: AcademicColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null)
            trailing!
          else
            const Icon(Icons.chevron_right, size: 18, color: AcademicColors.textSecondary),
        ],
      ),
    );
  }
}

/// Staff / Faculty Capsule Card (Name + Subject/Designation only — NO fake IDs, NO degrees)
class StaffCapsuleCard extends StatelessWidget {
  final String name;
  final String designationOrSubject;
  final VoidCallback? onTap;
  final Widget? trailing;

  const StaffCapsuleCard({
    super.key,
    required this.name,
    required this.designationOrSubject,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InsetCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AcademicColors.secondary,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'T',
              style: GoogleFonts.newsreader(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AcademicColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  designationOrSubject,
                  style: GoogleFonts.manrope(
                    fontSize: 11.5,
                    color: AcademicColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null)
            trailing!
          else
            const Icon(Icons.chevron_right, size: 18, color: AcademicColors.textSecondary),
        ],
      ),
    );
  }
}
