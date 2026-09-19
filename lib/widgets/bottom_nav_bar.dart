// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Bottom Navigation & Sticky Action Bars: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8 (Persistent Bottom Navigation)
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'module_grid_sheet.dart';

/// Single item descriptor for academic bottom navigation
class AcademicNavItem {
  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final String? route;
  final VoidCallback? onTap;

  const AcademicNavItem({
    required this.label,
    required this.icon,
    this.activeIcon,
    this.route,
    this.onTap,
  });
}

/// Espresso Heritage Academic persistent 5-item bottom navigation bar
class AcademicBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final List<AcademicNavItem> items;
  final ValueChanged<int>? onTap;

  const AcademicBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.items,
    this.onTap,
  });

  /// Factory for the 9 institutional roles
  factory AcademicBottomNavBar.forRole(
    UserRole role, {
    Key? key,
    required BuildContext context,
    int currentIndex = 0,
  }) {
    List<AcademicNavItem> roleItems;

    switch (role) {
      case UserRole.parent:
        roleItems = [
          const AcademicNavItem(
            label: 'Portal',
            icon: Icons.dashboard_outlined,
            activeIcon: Icons.dashboard,
            route: '/dashboard/parent',
          ),
          const AcademicNavItem(
            label: 'Academics',
            icon: Icons.menu_book_outlined,
            activeIcon: Icons.menu_book,
            route: '/students/report-card',
          ),
          const AcademicNavItem(
            label: 'Attendance',
            icon: Icons.fact_check_outlined,
            activeIcon: Icons.fact_check,
            route: '/attendance/student',
          ),
          const AcademicNavItem(
            label: 'Fees',
            icon: Icons.receipt_long_outlined,
            activeIcon: Icons.receipt_long,
            route: '/fees/ledger',
          ),
          AcademicNavItem(
            label: 'More',
            icon: Icons.apps_outlined,
            activeIcon: Icons.apps,
            onTap: () => ModuleGridSheet.show(context),
          ),
        ];
        break;

      case UserRole.student:
        roleItems = [
          const AcademicNavItem(
            label: 'Portal',
            icon: Icons.dashboard_outlined,
            activeIcon: Icons.dashboard,
            route: '/dashboard/student',
          ),
          const AcademicNavItem(
            label: 'Academics',
            icon: Icons.school_outlined,
            activeIcon: Icons.school,
            route: '/students/report-card',
          ),
          const AcademicNavItem(
            label: 'Attendance',
            icon: Icons.fact_check_outlined,
            activeIcon: Icons.fact_check,
            route: '/attendance/student',
          ),
          const AcademicNavItem(
            label: 'Fees',
            icon: Icons.receipt_long_outlined,
            activeIcon: Icons.receipt_long,
            route: '/fees/ledger',
          ),
          AcademicNavItem(
            label: 'More',
            icon: Icons.apps_outlined,
            activeIcon: Icons.apps,
            onTap: () => ModuleGridSheet.show(context),
          ),
        ];
        break;

      case UserRole.classTeacher:
        roleItems = [
          const AcademicNavItem(
            label: 'Hub',
            icon: Icons.dashboard_outlined,
            activeIcon: Icons.dashboard,
            route: '/dashboard/class-teacher',
          ),
          const AcademicNavItem(
            label: 'Attendance',
            icon: Icons.fact_check_outlined,
            activeIcon: Icons.fact_check,
            route: '/attendance/roll-call',
          ),
          const AcademicNavItem(
            label: 'Classes',
            icon: Icons.groups_outlined,
            activeIcon: Icons.groups,
            route: '/dashboard/subject-teacher/cohorts',
          ),
          const AcademicNavItem(
            label: 'Timetable',
            icon: Icons.calendar_today_outlined,
            activeIcon: Icons.calendar_today,
            route: '/faculty/timetable',
          ),
          AcademicNavItem(
            label: 'More',
            icon: Icons.apps_outlined,
            activeIcon: Icons.apps,
            onTap: () => ModuleGridSheet.show(context),
          ),
        ];
        break;

      case UserRole.subjectTeacher:
        roleItems = [
          const AcademicNavItem(
            label: 'Portal',
            icon: Icons.dashboard_outlined,
            activeIcon: Icons.dashboard,
            route: '/dashboard/subject-teacher',
          ),
          const AcademicNavItem(
            label: 'Academics',
            icon: Icons.menu_book_outlined,
            activeIcon: Icons.menu_book,
            route: '/dashboard/subject-teacher/cohorts',
          ),
          const AcademicNavItem(
            label: 'Attendance',
            icon: Icons.fact_check_outlined,
            activeIcon: Icons.fact_check,
            route: '/attendance/roll-call',
          ),
          const AcademicNavItem(
            label: 'Timetable',
            icon: Icons.calendar_today_outlined,
            activeIcon: Icons.calendar_today,
            route: '/faculty/timetable',
          ),
          AcademicNavItem(
            label: 'More',
            icon: Icons.apps_outlined,
            activeIcon: Icons.apps,
            onTap: () => ModuleGridSheet.show(context),
          ),
        ];
        break;

      case UserRole.principal:
      case UserRole.vicePrincipal:
        roleItems = [
          const AcademicNavItem(
            label: 'Portal',
            icon: Icons.dashboard_outlined,
            activeIcon: Icons.dashboard,
            route: '/dashboard/principal',
          ),
          const AcademicNavItem(
            label: 'Academics',
            icon: Icons.school_outlined,
            activeIcon: Icons.school,
            route: '/faculty/allocation',
          ),
          const AcademicNavItem(
            label: 'Students',
            icon: Icons.groups_outlined,
            activeIcon: Icons.groups,
            route: '/students/ledger',
          ),
          const AcademicNavItem(
            label: 'Notices',
            icon: Icons.campaign_outlined,
            activeIcon: Icons.campaign,
            route: '/announcements',
          ),
          AcademicNavItem(
            label: 'More',
            icon: Icons.grid_view_outlined,
            activeIcon: Icons.grid_view,
            onTap: () => ModuleGridSheet.show(context),
          ),
        ];
        break;

      case UserRole.accountant:
        roleItems = [
          const AcademicNavItem(
            label: 'Hub',
            icon: Icons.grid_view_outlined,
            activeIcon: Icons.grid_view,
            route: '/dashboard/accountant',
          ),
          const AcademicNavItem(
            label: 'Fees Desk',
            icon: Icons.receipt_long_outlined,
            activeIcon: Icons.receipt_long,
            route: '/fees/ledger',
          ),
          const AcademicNavItem(
            label: 'Students',
            icon: Icons.group_outlined,
            activeIcon: Icons.group,
            route: '/students/ledger',
          ),
          const AcademicNavItem(
            label: 'Receipts',
            icon: Icons.description_outlined,
            activeIcon: Icons.description,
            route: '/fees/receipt',
          ),
          AcademicNavItem(
            label: 'More',
            icon: Icons.apps_outlined,
            activeIcon: Icons.apps,
            onTap: () => ModuleGridSheet.show(context),
          ),
        ];
        break;

      case UserRole.librarian:
        roleItems = [
          const AcademicNavItem(
            label: 'Desk',
            icon: Icons.dashboard_outlined,
            activeIcon: Icons.dashboard,
            route: '/dashboard/librarian',
          ),
          const AcademicNavItem(
            label: 'Inventory',
            icon: Icons.inventory_2_outlined,
            activeIcon: Icons.inventory_2,
            route: '/inventory/desk',
          ),
          const AcademicNavItem(
            label: 'Transport',
            icon: Icons.directions_bus_outlined,
            activeIcon: Icons.directions_bus,
            route: '/transit/bus',
          ),
          const AcademicNavItem(
            label: 'Directory',
            icon: Icons.badge_outlined,
            activeIcon: Icons.badge,
            route: '/faculty/directory',
          ),
          AcademicNavItem(
            label: 'More',
            icon: Icons.apps_outlined,
            activeIcon: Icons.apps,
            onTap: () => ModuleGridSheet.show(context),
          ),
        ];
        break;

      case UserRole.receptionist:
        roleItems = [
          const AcademicNavItem(
            label: 'Enquiries',
            icon: Icons.desk_outlined,
            activeIcon: Icons.desk,
            route: '/admissions/enquiry',
          ),
          const AcademicNavItem(
            label: 'Enrollment',
            icon: Icons.how_to_reg_outlined,
            activeIcon: Icons.how_to_reg,
            route: '/admissions/applications',
          ),
          const AcademicNavItem(
            label: 'Students',
            icon: Icons.school_outlined,
            activeIcon: Icons.school,
            route: '/students/ledger',
          ),
          const AcademicNavItem(
            label: 'Directory',
            icon: Icons.badge_outlined,
            activeIcon: Icons.badge,
            route: '/faculty/directory',
          ),
          AcademicNavItem(
            label: 'More',
            icon: Icons.apps_outlined,
            activeIcon: Icons.apps,
            onTap: () => ModuleGridSheet.show(context),
          ),
        ];
        break;

      case UserRole.superAdmin:
        roleItems = [
          const AcademicNavItem(
            label: 'Ops Hub',
            icon: Icons.terminal_outlined,
            activeIcon: Icons.terminal,
            route: '/dashboard/modules',
          ),
          const AcademicNavItem(
            label: 'Search',
            icon: Icons.search_outlined,
            activeIcon: Icons.search,
            route: '/search/cross-entity',
          ),
          const AcademicNavItem(
            label: 'Calendar',
            icon: Icons.event_outlined,
            activeIcon: Icons.event,
            route: '/calendar/academic',
          ),
          const AcademicNavItem(
            label: 'Directory',
            icon: Icons.people_outline,
            activeIcon: Icons.people,
            route: '/admin/parents',
          ),
          AcademicNavItem(
            label: 'More',
            icon: Icons.apps_outlined,
            activeIcon: Icons.apps,
            onTap: () => ModuleGridSheet.show(context),
          ),
        ];
        break;
    }

    return AcademicBottomNavBar(
      key: key,
      currentIndex: currentIndex,
      items: roleItems,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AcademicColors.surface,
        border: Border(
          top: BorderSide(color: AcademicColors.border, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x103E2A22),
            blurRadius: 12,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = index == currentIndex;
              final iconColor = isSelected ? AcademicColors.primaryDark : AcademicColors.textSecondary;

              return Expanded(
                child: InkWell(
                  onTap: () {
                    if (item.onTap != null) {
                      item.onTap!();
                    } else if (item.route != null) {
                      if (!isSelected) {
                        context.go(item.route!);
                      }
                    }
                    if (onTap != null) {
                      onTap!(index);
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Active indicator pill
                      Container(
                        width: 24,
                        height: 3,
                        decoration: BoxDecoration(
                          color: isSelected ? AcademicColors.primaryDark : Colors.transparent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Icon(
                        isSelected ? (item.activeIcon ?? item.icon) : item.icon,
                        size: 22,
                        color: iconColor,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.manrope(
                          fontSize: 10.5,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? AcademicColors.primaryDark : AcademicColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

/// Persistent, sticky bottom action container for operational desks
/// (Submit Roll Call, Save Marks, Add Item, Apply Leave, Register Enquiry)
class AcademicStickyActionBar extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;

  const AcademicStickyActionBar({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(16, 10, 16, 10),
    this.backgroundColor = AcademicColors.surface,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: const Border(
          top: BorderSide(color: AcademicColors.border, width: 1),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x123E2A22),
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
