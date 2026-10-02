// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Module Grid Sheet: Role-Gated Administrative & Operational Hub
// Design System: Espresso Heritage Academic (Warm Cream, Deep Espresso, Ivory)
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/mock/auth_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'role_switcher_sheet.dart';

/// Descriptor for a single ERP module / administrative desk
class ModuleDescriptor {
  final String label;
  final String? subtitle;
  final IconData icon;
  final String route;
  final String categoryKey; // e.g. 'school', 'services', 'account', 'admin', 'operations'
  final String categoryLabel; // Display label for header / pill
  final String? badgeText;

  const ModuleDescriptor({
    required this.label,
    this.subtitle,
    required this.icon,
    required this.route,
    required this.categoryKey,
    required this.categoryLabel,
    this.badgeText,
  });
}

/// Role-gated All-Modules bottom sheet modal.
///
/// Functions as a focused, secondary utility hub tailored to each role:
/// - Student: "My School Utilities & Profile" (Digital ID, Timetable, Notices, Calendar, Transport, Profile, Settings)
/// - Principal: "School Administration & Operational Hub" (Administration, Operations, Account)
/// - Other roles: Gated secondary workflows tailored to permissions.
///
/// Strictly omits redundant primary bottom navigation shortcuts.
class ModuleGridSheet extends StatefulWidget {
  final BuildContext? parentContext;

  const ModuleGridSheet({super.key, this.parentContext});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color.fromRGBO(62, 42, 34, 0.45),
      builder: (_) => ModuleGridSheet(parentContext: context),
    );
  }

  static List<ModuleDescriptor> getModulesForRole(UserRole role, [AuthState? authState]) => _ModuleGridSheetState._modulesForRole(role, authState);

  @override
  State<ModuleGridSheet> createState() => _ModuleGridSheetState();
}

class _ModuleGridSheetState extends State<ModuleGridSheet> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _selectedCategory = 'all';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onFocusChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final auth = context.read<AuthState>();
        if (auth.currentRole == UserRole.classTeacher) {
          auth.ensureClassTeacherAssignment();
        }
      }
    });
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(_onFocusChange);
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  static List<ModuleDescriptor> _modulesForRole(UserRole role, [AuthState? authState]) {
    switch (role) {
      // Principal & Vice Principal: Full Administrative & Operational Hub
      case UserRole.principal:
      case UserRole.vicePrincipal:
        return const [
          // ADMINISTRATION
          ModuleDescriptor(
            label: 'Staff & Leadership',
            subtitle: 'Principal, VP, Accountant, Receptionist & Librarian',
            icon: Icons.groups_outlined,
            route: '/faculty/directory',
            categoryKey: 'admin',
            categoryLabel: 'ADMINISTRATION',
          ),
          ModuleDescriptor(
            label: 'Faculty & Teaching',
            subtitle: 'Teacher profiles, subject specializations & contact directory',
            icon: Icons.badge_outlined,
            route: '/faculty/teachers',
            categoryKey: 'admin',
            categoryLabel: 'ADMINISTRATION',
          ),
          ModuleDescriptor(
            label: 'Classes & Sections',
            subtitle: 'Grades K–12, sections A–E & class teacher allocations',
            icon: Icons.meeting_room_outlined,
            route: '/faculty/allocation',
            categoryKey: 'admin',
            categoryLabel: 'ADMINISTRATION',
          ),
          ModuleDescriptor(
            label: 'Subjects & Teaching',
            subtitle: 'Class-subject mapping & faculty teaching assignments',
            icon: Icons.menu_book_outlined,
            route: '/faculty/allocation',
            categoryKey: 'admin',
            categoryLabel: 'ADMINISTRATION',
          ),
          ModuleDescriptor(
            label: 'Parents & Guardians',
            subtitle: 'Parent directory & linked student records',
            icon: Icons.family_restroom_outlined,
            route: '/admin/parents',
            categoryKey: 'admin',
            categoryLabel: 'ADMINISTRATION',
          ),
          ModuleDescriptor(
            label: 'Admissions Desk',
            subtitle: 'Inquiries, applicant review & enrollment pipeline',
            icon: Icons.how_to_reg_outlined,
            route: '/admissions/enquiry',
            categoryKey: 'admin',
            categoryLabel: 'ADMINISTRATION',
          ),
          ModuleDescriptor(
            label: 'Cross-Entity Search',
            subtitle: 'Unified lookup across students, staff, receipts & circulars',
            icon: Icons.saved_search_outlined,
            route: '/search/cross-entity',
            categoryKey: 'admin',
            categoryLabel: 'ADMINISTRATION',
          ),

          // SCHOOL OPERATIONS
          ModuleDescriptor(
            label: 'Attendance Matrix',
            subtitle: 'Monthly grade attendance register & telemetry',
            icon: Icons.calendar_month_outlined,
            route: '/attendance/matrix',
            categoryKey: 'operations',
            categoryLabel: 'SCHOOL OPERATIONS',
          ),
          ModuleDescriptor(
            label: 'Accounts & Fee Ledger',
            subtitle: 'Fee collection desks, fee heads & payment receipts',
            icon: Icons.account_balance_wallet_outlined,
            route: '/accounts/dashboard',
            categoryKey: 'operations',
            categoryLabel: 'SCHOOL OPERATIONS',
          ),
          ModuleDescriptor(
            label: 'Master Timetables',
            subtitle: 'Class weekly schedules & faculty timetables',
            icon: Icons.calendar_view_week_outlined,
            route: '/faculty/timetable/class',
            categoryKey: 'operations',
            categoryLabel: 'SCHOOL OPERATIONS',
          ),
          ModuleDescriptor(
            label: 'Transport & Transit',
            subtitle: 'Bus routes, fleet vehicles, stops & drivers',
            icon: Icons.directions_bus_outlined,
            route: '/transit/bus',
            categoryKey: 'operations',
            categoryLabel: 'SCHOOL OPERATIONS',
          ),
          ModuleDescriptor(
            label: 'Academic Calendar',
            subtitle: 'Gazetted holidays, terms, events & schedule',
            icon: Icons.event_note_outlined,
            route: '/calendar/academic',
            categoryKey: 'operations',
            categoryLabel: 'SCHOOL OPERATIONS',
          ),
          ModuleDescriptor(
            label: 'Announcement Moderation Queue',
            subtitle: 'Review, approve & publish faculty-drafted circulars',
            icon: Icons.approval_outlined,
            route: '/announcements/approval',
            categoryKey: 'operations',
            categoryLabel: 'SCHOOL OPERATIONS',
          ),
          ModuleDescriptor(
            label: 'Central Library',
            subtitle: 'Catalog circulation, holdings & active book issues',
            icon: Icons.local_library_outlined,
            route: '/library/desk',
            categoryKey: 'operations',
            categoryLabel: 'SCHOOL OPERATIONS',
          ),
          ModuleDescriptor(
            label: 'Inventory & Supplies',
            subtitle: 'Campus consumable stock & reorder thresholds',
            icon: Icons.inventory_2_outlined,
            route: '/inventory/desk',
            categoryKey: 'operations',
            categoryLabel: 'SCHOOL OPERATIONS',
          ),
          ModuleDescriptor(
            label: 'Notification Center',
            subtitle: 'System dispatch logs & emergency push alerts',
            icon: Icons.notifications_outlined,
            route: '/notifications',
            categoryKey: 'operations',
            categoryLabel: 'SCHOOL OPERATIONS',
          ),

          // ACCOUNT & GOVERNANCE
          ModuleDescriptor(
            label: 'Executive Profile',
            subtitle: 'Principal credentials & official contact details',
            icon: Icons.account_circle_outlined,
            route: '/account/profile',
            categoryKey: 'account',
            categoryLabel: 'ACCOUNT & GOVERNANCE',
          ),
          ModuleDescriptor(
            label: 'System Settings',
            subtitle: 'App preferences & multi-device security vault',
            icon: Icons.settings_outlined,
            route: '/account/settings',
            categoryKey: 'account',
            categoryLabel: 'ACCOUNT & GOVERNANCE',
          ),
        ];

      // Student: Focused Secondary Utilities & Profile Hub
      // Does NOT duplicate Portal, Academics (Report Card), Attendance, or Fees.
      case UserRole.student:
        return const [
          // MY SCHOOL
          ModuleDescriptor(
            label: 'Digital Student ID',
            subtitle: 'Official identity card & verified credentials',
            icon: Icons.badge_outlined,
            route: '/students/id-card',
            categoryKey: 'school',
            categoryLabel: 'MY SCHOOL',
          ),
          ModuleDescriptor(
            label: 'Class Timetable',
            subtitle: 'Weekly periods, subjects & classroom schedule',
            icon: Icons.calendar_view_week_outlined,
            route: '/faculty/timetable/class',
            categoryKey: 'school',
            categoryLabel: 'MY SCHOOL',
          ),
          ModuleDescriptor(
            label: 'School Notices',
            subtitle: 'Official announcements, circulars & notices',
            icon: Icons.campaign_outlined,
            route: '/announcements',
            categoryKey: 'school',
            categoryLabel: 'MY SCHOOL',
          ),
          ModuleDescriptor(
            label: 'Academic Calendar',
            subtitle: 'Gazetted holidays, term schedules & school events',
            icon: Icons.event_outlined,
            route: '/calendar/academic',
            categoryKey: 'school',
            categoryLabel: 'MY SCHOOL',
          ),

          // SERVICES
          ModuleDescriptor(
            label: 'Bus Transit',
            subtitle: 'Assigned route, stops & driver contact',
            icon: Icons.directions_bus_outlined,
            route: '/transit/bus',
            categoryKey: 'services',
            categoryLabel: 'SERVICES',
          ),

          // ACCOUNT
          ModuleDescriptor(
            label: 'Student Profile',
            subtitle: 'Personal details, class section & roll number',
            icon: Icons.account_circle_outlined,
            route: '/students/dossier',
            categoryKey: 'account',
            categoryLabel: 'ACCOUNT',
          ),
          ModuleDescriptor(
            label: 'App Settings',
            subtitle: 'Notification preferences & session controls',
            icon: Icons.settings_outlined,
            route: '/account/settings',
            categoryKey: 'account',
            categoryLabel: 'ACCOUNT',
          ),
        ];

      // Subject Teacher
      case UserRole.subjectTeacher:
        return const [
          // MY TEACHING
          ModuleDescriptor(
            label: 'My Classes',
            subtitle: 'Assigned classes, sections & weekly load',
            icon: Icons.meeting_room_outlined,
            route: '/teacher/my-classes',
            categoryKey: 'teaching',
            categoryLabel: 'MY TEACHING',
          ),
          ModuleDescriptor(
            label: 'My Subjects',
            subtitle: 'Teaching assignments & curriculum load',
            icon: Icons.menu_book_outlined,
            route: '/teacher/teaching-assignments',
            categoryKey: 'teaching',
            categoryLabel: 'MY TEACHING',
          ),
          ModuleDescriptor(
            label: 'Student Directory',
            subtitle: 'Enrolled students in assigned classes',
            icon: Icons.contacts_outlined,
            route: '/teacher/student-directory',
            categoryKey: 'teaching',
            categoryLabel: 'MY TEACHING',
          ),

          // SCHOOL
          ModuleDescriptor(
            label: 'Notices & Circulars',
            subtitle: 'Official circulars & announcements',
            icon: Icons.campaign_outlined,
            route: '/announcements',
            categoryKey: 'school',
            categoryLabel: 'SCHOOL',
          ),
          ModuleDescriptor(
            label: 'Academic Calendar',
            subtitle: 'Holidays, examinations & events',
            icon: Icons.event_outlined,
            route: '/calendar/academic',
            categoryKey: 'school',
            categoryLabel: 'SCHOOL',
          ),
          ModuleDescriptor(
            label: 'My Leave Requests',
            subtitle: 'Apply casual & medical leave',
            icon: Icons.event_busy_outlined,
            route: '/attendance/faculty-leave',
            categoryKey: 'school',
            categoryLabel: 'SCHOOL',
          ),

          // ACCOUNT
          ModuleDescriptor(
            label: 'Teacher Profile',
            subtitle: 'Faculty identity & contact details',
            icon: Icons.person_outline,
            route: '/account/profile',
            categoryKey: 'account',
            categoryLabel: 'ACCOUNT',
          ),
          ModuleDescriptor(
            label: 'App Settings',
            subtitle: 'Notifications & preferences',
            icon: Icons.settings_outlined,
            route: '/account/settings',
            categoryKey: 'account',
            categoryLabel: 'ACCOUNT',
          ),
        ];

      // Class Teacher
      case UserRole.classTeacher:
        final rawClass = authState?.userProfile?['assigned_class']?.toString() ??
            authState?.userProfile?['class_name']?.toString() ??
            '';
        final classId = authState?.userProfile?['class_id']?.toString() ?? '';
        final displayClass = rawClass.isNotEmpty ? rawClass : 'Class';

        return [
          // MY CLASS
          ModuleDescriptor(
            label: 'Class Information',
            subtitle: '$displayClass details & enrollment overview',
            icon: Icons.meeting_room_outlined,
            route: classId.isNotEmpty
                ? '/teacher/class-info?class=${Uri.encodeComponent(displayClass)}&classId=${Uri.encodeComponent(classId)}'
                : (displayClass.isNotEmpty && displayClass != 'Class'
                    ? '/teacher/class-info?class=${Uri.encodeComponent(displayClass)}'
                    : '/teacher/class-info'),
            categoryKey: 'class',
            categoryLabel: 'MY CLASS',
          ),
          ModuleDescriptor(
            label: 'Student Directory',
            subtitle: '$displayClass student list & profiles',
            icon: Icons.contacts_outlined,
            route: classId.isNotEmpty
                ? '/teacher/class-students?class=${Uri.encodeComponent(displayClass)}&classId=${Uri.encodeComponent(classId)}'
                : (displayClass.isNotEmpty && displayClass != 'Class'
                    ? '/teacher/class-students?class=${Uri.encodeComponent(displayClass)}'
                    : '/teacher/class-students'),
            categoryKey: 'class',
            categoryLabel: 'MY CLASS',
          ),
          ModuleDescriptor(
            label: 'Class Subjects',
            subtitle: 'Subject mapping & teaching faculty',
            icon: Icons.menu_book_outlined,
            route: classId.isNotEmpty
                ? '/teacher/class-subjects?class=${Uri.encodeComponent(displayClass)}&classId=${Uri.encodeComponent(classId)}'
                : (displayClass.isNotEmpty && displayClass != 'Class'
                    ? '/teacher/class-subjects?class=${Uri.encodeComponent(displayClass)}'
                    : '/teacher/class-subjects'),
            categoryKey: 'class',
            categoryLabel: 'MY CLASS',
          ),

          // SCHOOL
          const ModuleDescriptor(
            label: 'Notices & Circulars',
            subtitle: 'Official circulars & announcements',
            icon: Icons.campaign_outlined,
            route: '/announcements',
            categoryKey: 'school',
            categoryLabel: 'SCHOOL',
          ),
          const ModuleDescriptor(
            label: 'Academic Calendar',
            subtitle: 'Holidays, examinations & events',
            icon: Icons.event_outlined,
            route: '/calendar/academic',
            categoryKey: 'school',
            categoryLabel: 'SCHOOL',
          ),
          const ModuleDescriptor(
            label: 'My Leave Requests',
            subtitle: 'Apply casual & medical leave',
            icon: Icons.event_busy_outlined,
            route: '/attendance/faculty-leave',
            categoryKey: 'school',
            categoryLabel: 'SCHOOL',
          ),

          // ACCOUNT
          const ModuleDescriptor(
            label: 'Teacher Profile',
            subtitle: 'Faculty identity & contact details',
            icon: Icons.person_outline,
            route: '/account/profile',
            categoryKey: 'account',
            categoryLabel: 'ACCOUNT',
          ),
          const ModuleDescriptor(
            label: 'App Settings',
            subtitle: 'Notifications & preferences',
            icon: Icons.settings_outlined,
            route: '/account/settings',
            categoryKey: 'account',
            categoryLabel: 'ACCOUNT',
          ),
        ];

      // Parent
      case UserRole.parent:
        return const [
          ModuleDescriptor(label: 'Student 360', subtitle: 'Student profile & details', icon: Icons.account_box_outlined, route: '/students/dossier', categoryKey: 'admin', categoryLabel: 'STUDENT RECORDS'),
          ModuleDescriptor(label: 'Report Card', subtitle: 'Term marks & evaluations', icon: Icons.assessment_outlined, route: '/students/report-card', categoryKey: 'operations', categoryLabel: 'ACADEMICS & DESKS'),
          ModuleDescriptor(label: 'Timetable', subtitle: 'Student weekly timetable', icon: Icons.calendar_today_outlined, route: '/faculty/timetable/class', categoryKey: 'operations', categoryLabel: 'ACADEMICS & DESKS'),
          ModuleDescriptor(label: 'Attendance', subtitle: 'Monthly register & record', icon: Icons.calendar_month_outlined, route: '/attendance/matrix', categoryKey: 'operations', categoryLabel: 'ACADEMICS & DESKS'),
          ModuleDescriptor(label: 'Fee Ledger', subtitle: 'Dues, receipts & online UPI', icon: Icons.receipt_long_outlined, route: '/fees/ledger', categoryKey: 'operations', categoryLabel: 'ACADEMICS & DESKS'),
          ModuleDescriptor(label: 'Digital ID Card', subtitle: 'Student identity card', icon: Icons.badge, route: '/students/id-card', categoryKey: 'account', categoryLabel: 'ACCOUNT'),
          ModuleDescriptor(label: 'Calendar', subtitle: 'Holidays & academic terms', icon: Icons.event_outlined, route: '/calendar/academic', categoryKey: 'operations', categoryLabel: 'ACADEMICS & DESKS'),
          ModuleDescriptor(label: 'Notifications', subtitle: 'Official notices & push alerts', icon: Icons.notifications_outlined, route: '/notifications', categoryKey: 'operations', categoryLabel: 'ACADEMICS & DESKS'),
          ModuleDescriptor(label: 'Bus Transit', subtitle: 'Live transit & stops', icon: Icons.directions_bus_outlined, route: '/transit/bus', categoryKey: 'operations', categoryLabel: 'ACADEMICS & DESKS'),
          ModuleDescriptor(label: 'School FAQs', subtitle: 'Help & institutional guide', icon: Icons.help_outline_rounded, route: '/help/faqs', categoryKey: 'account', categoryLabel: 'ACCOUNT'),
        ];

      // Accountant
      case UserRole.accountant:
        return const [
          ModuleDescriptor(label: 'Accounts Dashboard', subtitle: 'Institutional revenue desk', icon: Icons.grid_view_outlined, route: '/accounts/dashboard', categoryKey: 'operations', categoryLabel: 'OPERATIONS'),
          ModuleDescriptor(label: 'Fee Ledger', subtitle: 'Fee structures & balance', icon: Icons.receipt_long_outlined, route: '/fees/ledger', categoryKey: 'operations', categoryLabel: 'OPERATIONS'),
          ModuleDescriptor(label: 'Receipts Desk', subtitle: 'Payment vouchers & invoices', icon: Icons.description_outlined, route: '/fees/receipt', categoryKey: 'operations', categoryLabel: 'OPERATIONS'),
          ModuleDescriptor(label: 'All Students', subtitle: 'Student directory & records', icon: Icons.school_outlined, route: '/students/ledger', categoryKey: 'admin', categoryLabel: 'ADMINISTRATION'),
          ModuleDescriptor(label: 'Calendar', subtitle: 'Holidays & terms', icon: Icons.event_outlined, route: '/calendar/academic', categoryKey: 'operations', categoryLabel: 'OPERATIONS'),
          ModuleDescriptor(label: 'Notifications', subtitle: 'Alerts & updates', icon: Icons.notifications_outlined, route: '/notifications', categoryKey: 'operations', categoryLabel: 'OPERATIONS'),
        ];

      // Librarian
      case UserRole.librarian:
        return const [
          ModuleDescriptor(label: 'Library Desk', subtitle: 'Book circulation & catalog', icon: Icons.local_library_outlined, route: '/library/desk', categoryKey: 'operations', categoryLabel: 'OPERATIONS'),
          ModuleDescriptor(label: 'Inventory', subtitle: 'Asset tracking & stock', icon: Icons.inventory_2_outlined, route: '/inventory/desk', categoryKey: 'operations', categoryLabel: 'OPERATIONS'),
          ModuleDescriptor(label: 'Bus Transit', subtitle: 'School transit routes', icon: Icons.directions_bus_outlined, route: '/transit/bus', categoryKey: 'operations', categoryLabel: 'OPERATIONS'),
          ModuleDescriptor(label: 'Faculty Directory', subtitle: 'Staff contacts', icon: Icons.badge_outlined, route: '/faculty/directory', categoryKey: 'admin', categoryLabel: 'ADMINISTRATION'),
          ModuleDescriptor(label: 'Calendar', subtitle: 'Academic calendar', icon: Icons.event_outlined, route: '/calendar/academic', categoryKey: 'operations', categoryLabel: 'OPERATIONS'),
          ModuleDescriptor(label: 'Notifications', subtitle: 'System notifications', icon: Icons.notifications_outlined, route: '/notifications', categoryKey: 'operations', categoryLabel: 'OPERATIONS'),
        ];

      // Receptionist
      case UserRole.receptionist:
        return const [
          ModuleDescriptor(label: 'Admissions Enquiry', subtitle: 'Prospect intake pipeline', icon: Icons.question_answer_outlined, route: '/admissions/enquiry', categoryKey: 'admin', categoryLabel: 'ADMINISTRATION'),
          ModuleDescriptor(label: 'Applications', subtitle: 'Registration desk & status', icon: Icons.how_to_reg_outlined, route: '/admissions/applications', categoryKey: 'admin', categoryLabel: 'ADMINISTRATION'),
          ModuleDescriptor(label: 'All Students', subtitle: 'Student ledger & lookup', icon: Icons.school_outlined, route: '/students/ledger', categoryKey: 'admin', categoryLabel: 'ADMINISTRATION'),
          ModuleDescriptor(label: 'Faculty Directory', subtitle: 'Staff directory & faculty list', icon: Icons.badge_outlined, route: '/faculty/directory', categoryKey: 'admin', categoryLabel: 'ADMINISTRATION'),
          ModuleDescriptor(label: 'Calendar', subtitle: 'Holidays & terms', icon: Icons.event_outlined, route: '/calendar/academic', categoryKey: 'operations', categoryLabel: 'OPERATIONS'),
          ModuleDescriptor(label: 'Notifications', subtitle: 'Announcements & alerts', icon: Icons.notifications_outlined, route: '/notifications', categoryKey: 'operations', categoryLabel: 'OPERATIONS'),
        ];

      // Super Admin
      case UserRole.superAdmin:
        return const [
          ModuleDescriptor(label: 'Super Admin Console', subtitle: 'All institutional ERP modules', icon: Icons.terminal_outlined, route: '/admin/modules', categoryKey: 'admin', categoryLabel: 'ADMINISTRATION'),
          ModuleDescriptor(label: 'System Telemetry', subtitle: 'Error rates & system health', icon: Icons.monitor_heart_outlined, route: '/admin/telemetry', categoryKey: 'admin', categoryLabel: 'ADMINISTRATION'),
          ModuleDescriptor(label: 'Cross-Entity Search', subtitle: 'Global ERP query tool', icon: Icons.search, route: '/search/cross-entity', categoryKey: 'admin', categoryLabel: 'ADMINISTRATION'),
          ModuleDescriptor(label: 'School Setup', subtitle: 'Academic session & config', icon: Icons.settings_outlined, route: '/admin/setup', categoryKey: 'admin', categoryLabel: 'ADMINISTRATION'),
          ModuleDescriptor(label: 'Parents Directory', subtitle: 'Parent registry & students', icon: Icons.people_outlined, route: '/admin/parents', categoryKey: 'admin', categoryLabel: 'ADMINISTRATION'),
          ModuleDescriptor(label: 'Classes & Sections', subtitle: 'Class allocations', icon: Icons.meeting_room_outlined, route: '/faculty/allocation', categoryKey: 'admin', categoryLabel: 'ADMINISTRATION'),
          ModuleDescriptor(label: 'All Students', subtitle: 'Student registry', icon: Icons.school_outlined, route: '/students/ledger', categoryKey: 'admin', categoryLabel: 'ADMINISTRATION'),
          ModuleDescriptor(label: 'Academic Calendar', subtitle: 'Holidays & sessions', icon: Icons.event_outlined, route: '/calendar/academic', categoryKey: 'operations', categoryLabel: 'OPERATIONS'),
          ModuleDescriptor(label: 'Events Desk', subtitle: 'Institutional event planner', icon: Icons.celebration_outlined, route: '/calendar/events', categoryKey: 'operations', categoryLabel: 'OPERATIONS'),
          ModuleDescriptor(label: 'Notification Center', subtitle: 'Broadcast messaging', icon: Icons.notifications_outlined, route: '/notifications', categoryKey: 'operations', categoryLabel: 'OPERATIONS'),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final role = auth.currentRole;
    final allModules = _modulesForRole(role, auth);

    // Extract unique categories in order
    final categories = <String, String>{};
    for (final m in allModules) {
      categories.putIfAbsent(m.categoryKey, () => m.categoryLabel);
    }

    // Filter modules by search and category
    final filteredModules = allModules.where((module) {
      final matchesCategory = _selectedCategory == 'all' || module.categoryKey == _selectedCategory;
      final query = _searchQuery.toLowerCase().trim();
      final matchesQuery = query.isEmpty ||
          module.label.toLowerCase().contains(query) ||
          (module.subtitle != null && module.subtitle!.toLowerCase().contains(query));
      return matchesCategory && matchesQuery;
    }).toList();

    final headerSubtitle = role == UserRole.student
        ? 'Student Utilities & Personal Profile'
        : (role == UserRole.classTeacher
            ? 'Class Utilities & Faculty Profile'
            : (role == UserRole.subjectTeacher
                ? 'Subject Teaching & Faculty Profile'
                : (role == UserRole.principal || role == UserRole.vicePrincipal
                    ? 'Institutional Administration & Operational Suites'
                    : 'Role Utilities & System Desks')));

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      padding: EdgeInsets.only(bottom: bottomInset),
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
        decoration: const BoxDecoration(
          color: AcademicColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.fromLTRB(
          16,
          12,
          16,
          MediaQuery.of(context).padding.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
            const SizedBox(height: 14),

            // Header Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'All Modules',
                        style: GoogleFonts.newsreader(
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                          color: AcademicColors.textPrimary,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        headerSubtitle,
                        style: GoogleFonts.manrope(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: AcademicColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Material(
                  color: AcademicColors.canvas,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AcademicColors.border.withValues(alpha: 0.8)),
                      ),
                      child: const Icon(Icons.close, size: 17, color: AcademicColors.textPrimary),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Modern Focus-Aware Search Field
            TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              style: GoogleFonts.manrope(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: AcademicColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Search modules, desks, records...',
                hintStyle: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AcademicColors.textSecondary.withValues(alpha: 0.7),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 20,
                  color: _searchFocusNode.hasFocus ? AcademicColors.primary : AcademicColors.textSecondary,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.cancel, size: 18, color: AcademicColors.textSecondary),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                        tooltip: 'Clear search',
                      )
                    : null,
                filled: true,
                fillColor: _searchFocusNode.hasFocus ? AcademicColors.surface : AcademicColors.canvas,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AcademicColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AcademicColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AcademicColors.primary, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 12),

          // Category Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryPill('all', 'All (${allModules.length})'),
                ...categories.entries.map((entry) {
                  final count = allModules.where((m) => m.categoryKey == entry.key).length;
                  return Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: _buildCategoryPill(entry.key, '${_formatPillTitle(entry.value)} ($count)'),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Categorized Content
          Flexible(
            child: filteredModules.isEmpty
                ? _buildEmptyState()
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ...categories.entries.map((entry) {
                          final categoryItems = filteredModules.where((m) => m.categoryKey == entry.key).toList();
                          if (categoryItems.isEmpty) return const SizedBox.shrink();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildSectionHeader(entry.value, categoryItems.length),
                              const SizedBox(height: 8),
                              ...categoryItems.map((m) => _buildModuleCard(m)),
                              const SizedBox(height: 14),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
          ),
          const SizedBox(height: 12),

          // Institutional Footer Utilities: Switch Role & Sign Out
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AcademicColors.border),
                      foregroundColor: AcademicColors.textPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      final ctx = widget.parentContext ?? context;
                      Navigator.pop(context);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (ctx.mounted) {
                          RoleSwitcherSheet.show(ctx);
                        }
                      });
                    },
                    icon: const Icon(Icons.swap_horiz, size: 16),
                    label: Text(
                      'Switch Role',
                      style: GoogleFonts.manrope(fontSize: 12.5, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AcademicColors.danger),
                      foregroundColor: AcademicColors.danger,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      final router = GoRouter.of(context);
                      final auth = context.read<AuthState>();
                      Navigator.pop(context);
                      auth.signOut();
                      router.go('/login');
                    },
                    icon: const Icon(Icons.logout, size: 16),
                    label: Text(
                      'Sign Out',
                      style: GoogleFonts.manrope(fontSize: 12.5, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

  String _formatPillTitle(String label) {
    if (label == 'MY SCHOOL') return 'My School';
    if (label == 'MY CLASS') return 'My Class';
    if (label == 'MY TEACHING') return 'Teaching';
    if (label == 'SERVICES') return 'Services';
    if (label == 'SCHOOL') return 'School';
    if (label == 'ACCOUNT') return 'Account';
    if (label == 'ADMINISTRATION') return 'Administration';
    if (label == 'SCHOOL OPERATIONS') return 'Operations';
    if (label == 'ACCOUNT & GOVERNANCE') return 'Account';
    if (label == 'STUDENT RECORDS') return 'Student Records';
    if (label == 'ACADEMICS & DESKS') return 'Academics';
    return label;
  }

  Widget _buildCategoryPill(String key, String label) {
    final isSelected = _selectedCategory == key;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = key;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AcademicColors.primary : AcademicColors.canvas,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AcademicColors.primary : AcademicColors.border,
            width: isSelected ? 1.2 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AcademicColors.primary.withValues(alpha: 0.22),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? AcademicColors.surface : AcademicColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 3,
                height: 12,
                decoration: BoxDecoration(
                  color: AcademicColors.caramelDark,
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AcademicColors.caramelDark,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: AcademicColors.canvas,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AcademicColors.border),
            ),
            child: Text(
              '$count ${count == 1 ? 'item' : 'items'}',
              style: GoogleFonts.manrope(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AcademicColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCard(ModuleDescriptor module) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: AcademicColors.canvas,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            final router = GoRouter.of(context);
            final parentCtx = widget.parentContext ?? context;
            Navigator.pop(context);
            if (module.route.contains('dashboard') || module.route == '/student/hub') {
              router.go(module.route);
            } else {
              await router.push(module.route);
              if (parentCtx.mounted) {
                ModuleGridSheet.show(parentCtx);
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: AcademicColors.border.withValues(alpha: 0.6)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AcademicColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AcademicColors.border),
                  ),
                  child: Icon(
                    module.icon,
                    size: 20,
                    color: AcademicColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        module.label,
                        style: GoogleFonts.manrope(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: AcademicColors.textPrimary,
                        ),
                      ),
                      if (module.subtitle != null) ...[
                        const SizedBox(height: 1.5),
                        Text(
                          module.subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            color: AcademicColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: AcademicColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AcademicColors.canvas,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.search_off, size: 22, color: AcademicColors.textSecondary),
            ),
            const SizedBox(height: 10),
            Text(
              'No Matching Modules',
              style: GoogleFonts.newsreader(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AcademicColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Check your keyword or reset filters to view all available modules.',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: AcademicColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AcademicColors.border),
                foregroundColor: AcademicColors.textPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                  _selectedCategory = 'all';
                });
              },
              child: Text(
                'Reset Filters',
                style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


