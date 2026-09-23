// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Shared Top Bar: Used by every screen in the app (single implementation)
// Design System: Espresso Heritage Academic
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/mock/auth_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'account_profile_sheet.dart';
import 'account_settings_sheet.dart';
import 'onps_logo.dart';
import 'role_switcher_sheet.dart';

/// Single shared app bar for the entire app.
///
/// Shows screen title or ONPS crest on the left, and standard institutional
/// actions on the right: [Search], [Notifications], and [3-Dots Menu].
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  /// Screen title, rendered Newsreader headline-sm / Text Cocoa.
  /// Required unless [showBrand] is true.
  final String? title;

  /// Renders the school crest + "ONPS" wordmark instead of [title].
  /// Reserved for the 7 role dashboard screens.
  final bool showBrand;

  /// Shows a leading back-arrow button. Defaults to whether the current
  /// route can be popped.
  final bool? showBackButton;

  /// Optional override for the back button's action. Defaults to popping.
  final VoidCallback? onBackPressed;

  /// Extra one-off actions (e.g. a filter control), rendered to
  /// the left of Search, Notifications, and 3-dots.
  final List<Widget> actions;

  const AppTopBar({
    super.key,
    this.title,
    this.showBrand = false,
    this.showBackButton,
    this.onBackPressed,
    this.actions = const [],
  }) : assert(
          showBrand || title != null,
          'AppTopBar requires either a title or showBrand: true',
        );

  static const double barHeight = 56;
  static const double _iconTapTarget = 38;
  static const double _iconGap = 4;
  static const double _rightInset = 8;

  static DateTime? _lastBackPressTime;

  static String _dashboardRouteForRole(UserRole role) {
    switch (role) {
      case UserRole.parent:
        return '/dashboard/parent';
      case UserRole.student:
        return '/dashboard/student';
      case UserRole.classTeacher:
        return '/dashboard/class-teacher';
      case UserRole.subjectTeacher:
        return '/dashboard/subject-teacher';
      case UserRole.principal:
      case UserRole.vicePrincipal:
        return '/dashboard/principal';
      case UserRole.accountant:
        return '/dashboard/accounts';
      case UserRole.librarian:
        return '/dashboard/library';
      case UserRole.receptionist:
        return '/admissions/enquiries';
      case UserRole.superAdmin:
        return '/dashboard/admin';
    }
  }

  void _handleBack(BuildContext context) {
    if (onBackPressed != null) {
      onBackPressed!();
    } else if (Navigator.of(context).canPop()) {
      context.pop();
    } else {
      try {
        final auth = context.read<AuthState>();
        context.go(_dashboardRouteForRole(auth.currentRole));
      } catch (_) {
        context.go('/');
      }
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(barHeight);

  @override
  Widget build(BuildContext context) {
    final bool isRootDashboard = showBrand;
    final bool canPop = Navigator.of(context).canPop();
    final bool shouldShowBack = showBackButton ?? (!isRootDashboard);

    return PopScope(
      canPop: isRootDashboard ? false : canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (isRootDashboard) {
          final now = DateTime.now();
          if (_lastBackPressTime == null ||
              now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
            _lastBackPressTime = now;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Press back again to exit ONPS',
                  style: GoogleFonts.manrope(fontSize: 13, color: Colors.white),
                ),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                backgroundColor: AcademicColors.primaryDark,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            );
          } else {
            SystemNavigator.pop();
          }
        } else {
          _handleBack(context);
        }
      },
      child: SafeArea(
        bottom: false,
        child: Container(
          height: barHeight,
          decoration: const BoxDecoration(
            color: AcademicColors.surface,
            border: Border(
              bottom: BorderSide(color: AcademicColors.border, width: 1),
            ),
          ),
          child: Row(
            children: [
              if (shouldShowBack)
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: AcademicColors.primary),
                  onPressed: () => _handleBack(context),
                )
              else
                const SizedBox(width: _rightInset),
              Expanded(
                child: showBrand ? const _BrandMark() : _TitleText(title!),
              ),
              ...actions,
              _FixedActionIcon(
                icon: Icons.search,
                tooltip: 'Search',
                onTap: () => context.push('/search/cross-entity'),
              ),
              const SizedBox(width: _iconGap),
              _FixedActionIcon(
                icon: Icons.notifications_outlined,
                tooltip: 'Notifications',
                onTap: () => context.push('/notifications'),
              ),
              const SizedBox(width: _iconGap),
              const _ThreeDotsMenuButton(),
              const SizedBox(width: _rightInset),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleText extends StatelessWidget {
  final String text;
  const _TitleText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.newsreader(
          fontSize: 16.5,
          fontWeight: FontWeight.w600,
          color: AcademicColors.textPrimary,
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const ONPSLogo(size: 32),
        const SizedBox(width: 10),
        Text(
          'ONPS',
          style: GoogleFonts.newsreader(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AcademicColors.textPrimary,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

class _FixedActionIcon extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _FixedActionIcon({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppTopBar._iconTapTarget,
      height: AppTopBar._iconTapTarget,
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 21, color: AcademicColors.primary),
        tooltip: tooltip,
        onPressed: onTap,
      ),
    );
  }
}

class _ThreeDotsMenuButton extends StatelessWidget {
  const _ThreeDotsMenuButton();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final roleTitle = AuthState.roleTitle(auth.currentRole);
    final fullName = auth.fullName.isNotEmpty ? auth.fullName : (auth.currentUsername.isNotEmpty ? auth.currentUsername : roleTitle);
    final initials = fullName.isNotEmpty
        ? fullName.split(RegExp(r'\s+')).where((e) => e.isNotEmpty).map((e) => e[0].toUpperCase()).take(2).join()
        : 'U';

    return Theme(
      data: Theme.of(context).copyWith(
        popupMenuTheme: PopupMenuThemeData(
          color: AcademicColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: AcademicColors.border, width: 1),
          ),
          elevation: 8,
        ),
      ),
      child: SizedBox(
        width: AppTopBar._iconTapTarget,
        height: AppTopBar._iconTapTarget,
        child: PopupMenuButton<String>(
          padding: EdgeInsets.zero,
          tooltip: 'Account & Settings',
          icon: const Icon(
            Icons.more_vert,
            color: AcademicColors.primary,
            size: 22,
          ),
          offset: const Offset(0, 48),
          onSelected: (value) {
            switch (value) {
              case 'profile':
                AccountProfileSheet.show(context);
                break;
              case 'settings':
                AccountSettingsSheet.show(context);
                break;
              case 'devices':
                context.push('/auth/devices');
                break;
              case 'switch_role':
                RoleSwitcherSheet.show(context);
                break;
              case 'help':
                context.push('/help/faqs');
                break;
              case 'sign_out':
                auth.signOut();
                context.go('/login');
                break;
            }
          },
          itemBuilder: (BuildContext ctx) => [
            // User Identity Header in Menu
            PopupMenuItem<String>(
              enabled: false,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                      color: AcademicColors.primaryDark,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: GoogleFonts.newsreader(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.accent,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.newsreader(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AcademicColors.textPrimary,
                          ),
                        ),
                        Text(
                          roleTitle,
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AcademicColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const PopupMenuDivider(height: 1),
            PopupMenuItem<String>(
              value: 'profile',
              child: _buildMenuItem(Icons.person_outline, 'My Profile'),
            ),
            PopupMenuItem<String>(
              value: 'settings',
              child: _buildMenuItem(Icons.settings_outlined, 'Settings'),
            ),
            PopupMenuItem<String>(
              value: 'devices',
              child: _buildMenuItem(Icons.devices_outlined, 'Active Devices'),
            ),
            PopupMenuItem<String>(
              value: 'switch_role',
              child: _buildMenuItem(Icons.swap_horiz_outlined, 'Switch Role'),
            ),
            PopupMenuItem<String>(
              value: 'help',
              child: _buildMenuItem(Icons.help_outline, 'Help & FAQ'),
            ),
            const PopupMenuDivider(height: 1),
            PopupMenuItem<String>(
              value: 'sign_out',
              child: Row(
                children: [
                  const Icon(Icons.logout, size: 18, color: AcademicColors.error),
                  const SizedBox(width: 12),
                  Text(
                    'Sign Out',
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AcademicColors.error,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildMenuItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AcademicColors.primaryDark),
        const SizedBox(width: 12),
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AcademicColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

