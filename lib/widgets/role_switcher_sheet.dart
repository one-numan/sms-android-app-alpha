// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Institutional Role Switcher Sheet
// Supports testing all 9 institutional personas from any screen
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/mock/auth_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'shared_widgets.dart';

class RoleSwitcherSheet extends StatelessWidget {
  const RoleSwitcherSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const RoleSwitcherSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthState>();

    return Container(
      decoration: const BoxDecoration(
        color: AcademicColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Switch Role Workspace',
                      style: GoogleFonts.newsreader(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Select an institutional role to test its specific portal',
                      style: GoogleFonts.manrope(fontSize: 12, color: AcademicColors.textSecondary),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                _buildRoleItem(context, authState, UserRole.parent, 'Parent Portal', 'Diya & Aarav Sharma • Grades 5-A & 2-B', Icons.family_restroom),
                _buildRoleItem(context, authState, UserRole.student, 'Student Hub', 'Diya Sharma • Grade 5-A', Icons.school),
                _buildRoleItem(context, authState, UserRole.classTeacher, 'Class Teacher Workspace', '${(authState.fullName.isNotEmpty && authState.fullName != 'User' && authState.fullName != 'Rajesh Sharma') ? authState.fullName : 'Shubman Gill'} • Class Teacher', Icons.assignment_ind),
                _buildRoleItem(context, authState, UserRole.subjectTeacher, 'Subject Teacher Desk', 'Robert Chen • Science Faculty', Icons.science),
                _buildRoleItem(context, authState, UserRole.principal, 'Principal Executive Command', 'Numan Khan • Head of School', Icons.account_balance),
                _buildRoleItem(context, authState, UserRole.vicePrincipal, 'Vice Principal Hub', 'Priya Nair • Academic Head', Icons.shield),
                _buildRoleItem(context, authState, UserRole.accountant, 'Accounts & Fees Desk', 'Rajesh Verma • Head Accountant', Icons.receipt_long),
                _buildRoleItem(context, authState, UserRole.librarian, 'Library Circulation Desk', 'Sunita Mehra • Head Librarian', Icons.local_library),
                _buildRoleItem(context, authState, UserRole.receptionist, 'Admissions & Front Desk', 'Kavita Joshi • Admissions Officer', Icons.desk),
                _buildRoleItem(context, authState, UserRole.superAdmin, 'Super Admin Directory', 'System Governance & All Modules', Icons.admin_panel_settings),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AcademicColors.danger),
                foregroundColor: AcademicColors.danger,
              ),
              onPressed: () {
                final router = GoRouter.of(context);
                Navigator.pop(context);
                authState.signOut();
                router.go('/login');
              },
              icon: const Icon(Icons.logout, size: 16),
              label: const Text('Sign Out to Login Gateway'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleItem(
    BuildContext context,
    AuthState authState,
    UserRole role,
    String title,
    String subtitle,
    IconData icon,
  ) {
    final isSelected = authState.currentRole == role;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InsetCard(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        backgroundColor: isSelected ? AcademicColors.warningContainer : AcademicColors.surface,
        onTap: () {
          final router = GoRouter.of(context);
          Navigator.pop(context);
          authState.switchRole(role);
          switch (role) {
            case UserRole.parent:
              router.go('/parent/dashboard');
              break;
            case UserRole.student:
              router.go('/student/hub');
              break;
            case UserRole.classTeacher:
              router.go('/teacher/class-dashboard');
              break;
            case UserRole.subjectTeacher:
              router.go('/teacher/subject-dashboard');
              break;
            case UserRole.principal:
            case UserRole.vicePrincipal:
              router.go('/principal/command');
              break;
            case UserRole.accountant:
              router.go('/accounts/dashboard');
              break;
            case UserRole.librarian:
              router.go('/library/desk');
              break;
            case UserRole.receptionist:
              router.go('/admissions/enquiries');
              break;
            case UserRole.superAdmin:
              router.go('/admin/modules');
              break;
          }
        },
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected ? AcademicColors.primary : AcademicColors.canvas,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: isSelected ? Colors.white : AcademicColors.primary, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: AcademicColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.manrope(fontSize: 11, color: AcademicColors.textSecondary),
                  ),
                ],
              ),
            ),
            if (isSelected)
              PillBadge.success('ACTIVE')
            else
              const Icon(Icons.chevron_right, size: 18, color: AcademicColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
