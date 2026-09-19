// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Component: Account Profile Sheet (User Identity & Role Dossier)
// Design System: Espresso Heritage Academic
// Aligned to Backend: apps.accounts.views.profile_view
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/mock/auth_state.dart';
import '../data/mock/mock_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'account_settings_sheet.dart';
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

  static UserProfileInfo getProfileForRole(UserRole role) {
    switch (role) {
      case UserRole.principal:
        return const UserProfileInfo(
          fullName: 'Principal Numan Khan',
          initials: 'NK',
          designation: 'Head of Institution • Executive Leadership',
          roleTitle: 'Principal',
          email: 'principal@onps.edu.in',
          phone: '+91 98000 11223',
          tier: 'Admin Tier 0',
          idBadge: 'PRIN-2015-01',
          joiningYear: 'Jan 2015',
        );
      case UserRole.vicePrincipal:
        return const UserProfileInfo(
          fullName: 'Priya Nair',
          initials: 'PN',
          designation: 'Vice Principal • Academic Dean',
          roleTitle: 'Vice Principal',
          email: 'vp@onps.edu.in',
          phone: '+91 98000 22334',
          tier: 'Admin Tier 1',
          idBadge: 'VP-2017-08',
          joiningYear: 'Jul 2017',
        );
      case UserRole.classTeacher:
        return const UserProfileInfo(
          fullName: 'Anita Desai',
          initials: 'AD',
          designation: 'Class Teacher • Grade 5-A Lead',
          roleTitle: 'Class Teacher',
          email: 'anita.desai@onps.edu.in',
          phone: '+91 98222 33445',
          tier: 'Faculty Tier 2',
          idBadge: 'FAC-T1',
          joiningYear: 'Jun 2018',
        );
      case UserRole.subjectTeacher:
        return const UserProfileInfo(
          fullName: 'Vikram Malhotra',
          initials: 'VM',
          designation: 'Subject Faculty • Mathematics Department',
          roleTitle: 'Subject Teacher',
          email: 'vikram.m@onps.edu.in',
          phone: '+91 98111 22334',
          tier: 'Faculty Tier 2',
          idBadge: 'FAC-T4',
          joiningYear: 'Jul 2019',
        );
      case UserRole.parent:
        return const UserProfileInfo(
          fullName: 'Rajesh Sharma',
          initials: 'RS',
          designation: 'Guardian • Children: Diya (5-A), Aarav (2-B)',
          roleTitle: 'Parent',
          email: 'rajesh.sharma@example.com',
          phone: '+91 98765 43210',
          tier: 'Guardian Tier 3',
          idBadge: 'GRD-8821',
          joiningYear: 'Apr 2024',
        );
      case UserRole.student:
        return const UserProfileInfo(
          fullName: 'Diya Sharma',
          initials: 'DS',
          designation: 'Enrolled Student • Grade 5-A, Roll #14',
          roleTitle: 'Student',
          email: 'diya.sharma@example.com',
          phone: '+91 98765 43210',
          tier: 'Student Tier 4',
          idBadge: 'ADM-2024-0412',
          joiningYear: 'Apr 2024',
        );
      case UserRole.accountant:
        return const UserProfileInfo(
          fullName: 'Rajesh Verma',
          initials: 'RV',
          designation: 'Bursar & Accounts Officer',
          roleTitle: 'Accountant',
          email: 'accounts@onps.edu.in',
          phone: '+91 98000 33445',
          tier: 'Finance Tier 1',
          idBadge: 'ACC-03',
          joiningYear: 'Apr 2019',
        );
      case UserRole.librarian:
        return const UserProfileInfo(
          fullName: 'Sunita Rao',
          initials: 'SR',
          designation: 'Head Librarian • Resource Center',
          roleTitle: 'Librarian',
          email: 'library@onps.edu.in',
          phone: '+91 98000 44556',
          tier: 'Operations Tier 2',
          idBadge: 'LIB-02',
          joiningYear: 'Sep 2020',
        );
      case UserRole.receptionist:
        return const UserProfileInfo(
          fullName: 'Meena Joshi',
          initials: 'MJ',
          designation: 'Admissions & Information Desk Officer',
          roleTitle: 'Receptionist',
          email: 'admissions@onps.edu.in',
          phone: '+91 98000 55667',
          tier: 'Intake Tier 2',
          idBadge: 'REC-05',
          joiningYear: 'Feb 2021',
        );
      case UserRole.superAdmin:
        return const UserProfileInfo(
          fullName: 'System Administrator',
          initials: 'SA',
          designation: 'Enterprise Infrastructure & IT Governance',
          roleTitle: 'Super Admin',
          email: 'admin@onps.edu.in',
          phone: '+91 98000 00000',
          tier: 'Root Tier 0',
          idBadge: 'ROOT-00',
          joiningYear: 'Aug 2014',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final profile = getProfileForRole(auth.currentRole);

    return Container(
      decoration: const BoxDecoration(
        color: AcademicColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
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
                              const SizedBox(width: 6),
                              PillBadge.success('Verified'),
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
                    _buildDetailRow(Icons.school_outlined, 'Affiliation', MockData.schoolName),
                    const Divider(height: 16, color: AcademicColors.border),
                    _buildDetailRow(Icons.calendar_today_outlined, 'Active Session', '${MockData.session} (Since ${profile.joiningYear})'),
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
