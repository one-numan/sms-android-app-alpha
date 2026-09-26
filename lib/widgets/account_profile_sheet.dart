// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Component: Account Profile Sheet (User Identity & Role Dossier)
// Design System: Espresso Heritage Academic
// Aligned to Backend: apps.accounts.views.profile_view
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/config/app_config.dart';
import '../data/mock/auth_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'account_settings_sheet.dart';
import 'onps_verified_badge.dart';
import 'role_switcher_sheet.dart';
import 'shared_widgets.dart';

class AccountProfileSheet extends StatelessWidget {
  const AccountProfileSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const AccountProfileSheet(),
    );
  }

  static String _getRoleTier(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
      case UserRole.principal:
        return 'Institutional Head (Level 0)';
      case UserRole.vicePrincipal:
        return 'Administrative Tier 1';
      case UserRole.classTeacher:
      case UserRole.subjectTeacher:
        return 'Faculty Tier 2';
      case UserRole.accountant:
      case UserRole.librarian:
      case UserRole.receptionist:
        return 'Operational Tier 3';
      case UserRole.parent:
      case UserRole.student:
        return 'Community Tier 4';
    }
  }

  static UserProfileInfo getProfileForRole(UserRole role) {
    final title = AuthState.roleTitle(role);
    return UserProfileInfo(
      fullName: title,
      initials: title.isNotEmpty ? title[0] : 'U',
      designation: title,
      roleTitle: title,
      email: 'Not available',
      phone: 'Not available',
      tier: _getRoleTier(role),
      idBadge: 'N/A',
      joiningYear: AppConfig.sessionYear,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final userProfile = auth.userProfile;
    final roleTitle = AuthState.roleTitle(auth.currentRole);

    final fullName = (userProfile?['full_name'] as String?)?.trim().isNotEmpty == true
        ? (userProfile!['full_name'] as String).trim()
        : (auth.fullName.isNotEmpty ? auth.fullName : (auth.currentUsername.isNotEmpty ? auth.currentUsername : 'Not available'));
    final email = (userProfile?['email'] as String?)?.trim().isNotEmpty == true
        ? (userProfile!['email'] as String).trim()
        : (auth.userEmail.isNotEmpty ? auth.userEmail : 'Not available');
    final phone = (userProfile?['mobile_number'] as String?)?.trim().isNotEmpty == true
        ? (userProfile!['mobile_number'] as String).trim()
        : (auth.userMobile.isNotEmpty ? auth.userMobile : 'Not available');
    final designation = (userProfile?['designation'] as String?)?.trim().isNotEmpty == true
        ? (userProfile!['designation'] as String).trim()
        : ((auth.currentUsername.toLowerCase().contains('principal') ||
                userProfile?['email']?.toString().toLowerCase().contains('principal') == true ||
                auth.currentRole == UserRole.principal)
            ? 'Principal'
            : roleTitle);
    final isPrincipal = designation.toLowerCase().contains('principal') ||
        auth.currentRole == UserRole.principal ||
        auth.currentUsername.toLowerCase().contains('principal');
    final tier = isPrincipal ? 'Executive Tier 0' : _getRoleTier(auth.currentRole);
    final idBadge = (userProfile?['id'] != null)
        ? 'ID #${userProfile!['id']}'
        : (auth.currentUsername.isNotEmpty ? auth.currentUsername.toUpperCase() : 'N/A');
    final initials = fullName != 'Not available' && fullName.isNotEmpty
        ? fullName.split(RegExp(r'\s+')).where((e) => e.isNotEmpty).map((e) => e[0].toUpperCase()).take(2).join()
        : (auth.currentUsername.isNotEmpty ? auth.currentUsername[0].toUpperCase() : 'U');

    final profile = UserProfileInfo(
      fullName: fullName,
      initials: initials,
      designation: designation,
      roleTitle: roleTitle,
      email: email,
      phone: phone,
      tier: tier,
      idBadge: idBadge,
      joiningYear: AppConfig.sessionYear,
    );

    return Container(
      decoration: const BoxDecoration(
        color: AcademicColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AcademicColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'User Account Profile',
                    style: GoogleFonts.newsreader(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AcademicColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20, color: AcademicColors.textSecondary),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Hero Identity Card
              InsetCard(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: const BoxDecoration(
                        color: AcademicColors.primaryDark,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          profile.initials,
                          style: GoogleFonts.newsreader(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AcademicColors.accent,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  profile.fullName,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.newsreader(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AcademicColors.textPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              OnpsVerifiedBadge(
                                role: auth.currentRole,
                                designation: profile.designation,
                                username: auth.currentUsername,
                                email: profile.email,
                                size: 22,
                                showLabel: true,
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            profile.designation,
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              color: AcademicColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              PillBadge.neutral(profile.tier),
                              PillBadge.neutral(profile.idBadge),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Account Details List
              InsetCard(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: [
                    _buildDetailRow(Icons.alternate_email, 'Official Email', profile.email),
                    const Divider(height: 16, color: AcademicColors.border),
                    _buildDetailRow(Icons.phone_outlined, 'Registered Mobile', profile.phone),
                    const Divider(height: 16, color: AcademicColors.border),
                    _buildDetailRow(Icons.school_outlined, 'Affiliation', AppConfig.schoolName),
                    const Divider(height: 16, color: AcademicColors.border),
                    _buildDetailRow(Icons.calendar_today_outlined, 'Active Session', AppConfig.academicSession),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: AcademicColors.primaryDark),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        RoleSwitcherSheet.show(context);
                      },
                      icon: const Icon(Icons.swap_horiz, size: 18, color: AcademicColors.primaryDark),
                      label: Text(
                        'Switch Role',
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.primaryDark,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AcademicColors.primaryDark,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        AccountSettingsSheet.show(context);
                      },
                      icon: const Icon(Icons.settings_outlined, size: 18),
                      label: Text(
                        'Settings',
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AcademicColors.primaryDark),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.manrope(fontSize: 10.5, color: AcademicColors.textSecondary),
            ),
            Text(
              value,
              style: GoogleFonts.manrope(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AcademicColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class UserProfileInfo {
  final String fullName;
  final String initials;
  final String designation;
  final String roleTitle;
  final String email;
  final String phone;
  final String tier;
  final String idBadge;
  final String joiningYear;

  const UserProfileInfo({
    required this.fullName,
    required this.initials,
    required this.designation,
    required this.roleTitle,
    required this.email,
    required this.phone,
    required this.tier,
    required this.idBadge,
    required this.joiningYear,
  });
}
