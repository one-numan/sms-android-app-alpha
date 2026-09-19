// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 24b: All ERP Modules Directory Sheet & Super Admin Console
// Design System: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8/24b_all_erp_modules_directory_sheet
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/account_profile_sheet.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/shared_widgets.dart';

class SuperAdminModulesScreen extends StatefulWidget {
  const SuperAdminModulesScreen({super.key});

  @override
  State<SuperAdminModulesScreen> createState() => _SuperAdminModulesScreenState();
}

class _SuperAdminModulesScreenState extends State<SuperAdminModulesScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<Map<String, dynamic>> _modules = [
    {
      'title': 'Student 360 Ledger',
      'category': 'Academics',
      'icon': Icons.groups,
      'route': '/students/all-students',
      'desc': 'Complete student directory & profiles',
    },
    {
      'title': 'Faculty Allocation',
      'category': 'Academics',
      'icon': Icons.badge,
      'route': '/faculty/allocation',
      'desc': 'Class teacher & subject faculty matrix',
    },
    {
      'title': 'Daily Roll Call',
      'category': 'Academics',
      'icon': Icons.how_to_reg,
      'route': '/attendance/teacher/roll-call',
      'desc': 'Classroom attendance register (P/A/L/E)',
    },
    {
      'title': 'Marks Entry Desk',
      'category': 'Academics',
      'icon': Icons.rate_review,
      'route': '/academics/marks/entry-desk',
      'desc': 'CBSE 4-exam assessment grading',
    },
    {
      'title': 'Terminal Report Cards',
      'category': 'Academics',
      'icon': Icons.workspace_premium,
      'route': '/student/ADM-2024-0412/report-card',
      'desc': 'Official term transcripts & grade cards',
    },
    {
      'title': 'Class Timetable',
      'category': 'Academics',
      'icon': Icons.calendar_view_week,
      'route': '/student/ADM-2024-0412/timetable',
      'desc': 'Weekly 6-day period distribution grid',
    },
    {
      'title': 'Accounts & Fees Desk',
      'category': 'Finance',
      'icon': Icons.account_balance_wallet,
      'route': '/accounts/dashboard',
      'desc': 'Dues realization, payment logs & cash receipting',
    },
    {
      'title': 'Fee Receipt Desk',
      'category': 'Finance',
      'icon': Icons.receipt,
      'route': '/fees/receipt/REC-2026-0891',
      'desc': 'Official stamped vouchers & vouchers archive',
    },
    {
      'title': 'Central Library',
      'category': 'Operations',
      'icon': Icons.local_library,
      'route': '/library/desk',
      'desc': 'Catalog search, book loans & overdue tracking',
    },
    {
      'title': 'Safe Transit Bus Route',
      'category': 'Operations',
      'icon': Icons.directions_bus,
      'route': '/transport/route-card',
      'desc': 'Vehicles, drivers & stop transit cards',
    },
    {
      'title': 'Inventory & Low Stock',
      'category': 'Operations',
      'icon': Icons.inventory_2,
      'route': '/inventory/desk',
      'desc': 'Textbooks, lab apparatus & low stock alerts',
    },
    {
      'title': 'Admissions Intake Desk',
      'category': 'Admissions',
      'icon': Icons.contact_mail,
      'route': '/admissions/enquiries',
      'desc': 'Prospective student enquiries & intake funnel',
    },
    {
      'title': 'Enrollment Applications',
      'category': 'Admissions',
      'icon': Icons.assignment_turned_in,
      'route': '/admissions/applications',
      'desc': 'Formal admission forms & registration queue',
    },
    {
      'title': 'School Events Desk',
      'category': 'Administration',
      'icon': Icons.event,
      'route': '/principal/calendar/events',
      'desc': 'Institutional calendar & event scheduler',
    },
    {
      'title': 'Academic Calendar',
      'category': 'Administration',
      'icon': Icons.calendar_month,
      'route': '/calendar/gazetted-holidays',
      'desc': 'Official school holidays & breaks timeline',
    },
    {
      'title': 'Moderated Circulars',
      'category': 'Administration',
      'icon': Icons.campaign,
      'route': '/circulars/board',
      'desc': 'School notice board & official circulars',
    },
    {
      'title': 'Announcement Queue',
      'category': 'Administration',
      'icon': Icons.mark_email_unread,
      'route': '/announcements/approval-queue',
      'desc': 'Principal editorial review & publish approval',
    },
    {
      'title': 'Notification Center',
      'category': 'Administration',
      'icon': Icons.notifications_active,
      'route': '/notifications/center',
      'desc': 'Push dispatch log & urgency categorization',
    },
    {
      'title': 'Parents Directory',
      'category': 'Administration',
      'icon': Icons.family_restroom,
      'route': '/parents/directory',
      'desc': 'Guardian records & linked students registry',
    },
    {
      'title': 'Cross-Entity Search',
      'category': 'Administration',
      'icon': Icons.search,
      'route': '/search/cross-entity',
      'desc': 'Global index across students, staff & documents',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredModules = _modules.where((m) {
      final matchesSearch = m['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m['desc'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || m['category'] == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: const AppTopBar(title: 'Institutional ERP Modules'),
      body: SafeArea(
        child: Column(
          children: [
            // Super Admin Identity Header
            InkWell(
              onTap: () => AccountProfileSheet.show(context),
              child: Semantics(
                label: 'View account profile',
                child: Container(
                  color: AcademicColors.surface,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: AcademicColors.primaryDark,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            'SA',
                            style: GoogleFonts.newsreader(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.accent,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Super Administrator',
                              style: GoogleFonts.newsreader(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AcademicColors.textPrimary,
                              ),
                            ),
                            Text(
                              'Full ERP Access • AY 2026–27',
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                color: AcademicColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PillBadge.info('Admin'),
                    ],
                  ),
                ),
              ),
            ),

            // Search Bar & Categories
            Container(
              color: AcademicColors.surface,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                children: [
                  TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: GoogleFonts.manrope(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Search module, register, report...',
                      prefixIcon: const Icon(Icons.search, size: 20, color: AcademicColors.textSecondary),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      fillColor: AcademicColors.canvas,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AcademicColors.border),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['All', 'Academics', 'Finance', 'Operations', 'Admissions', 'Administration'].map((cat) {
                        final isSel = _selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(cat),
                            selected: isSel,
                            onSelected: (_) => setState(() => _selectedCategory = cat),
                            selectedColor: AcademicColors.primaryDark,
                            labelStyle: GoogleFonts.manrope(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: isSel ? Colors.white : AcademicColors.textPrimary,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // Modules Grid
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredModules.length,
                itemBuilder: (context, index) {
                  final m = filteredModules[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InsetCard(
                      margin: EdgeInsets.zero,
                      padding: const EdgeInsets.all(14),
                      onTap: () => context.push(m['route'] as String),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AcademicColors.canvas,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(m['icon'] as IconData, color: AcademicColors.primaryDark, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      m['title'] as String,
                                      style: GoogleFonts.manrope(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.bold,
                                        color: AcademicColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    PillBadge.neutral(m['category'] as String),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  m['desc'] as String,
                                  style: GoogleFonts.manrope(
                                    fontSize: 11,
                                    color: AcademicColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, size: 18, color: AcademicColors.textSecondary),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AcademicBottomNavBar.forRole(
        UserRole.superAdmin,
        currentIndex: 0,
        context: context,
      ),
    );
  }
}
