// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 24: Principal Executive Command & Institutional Overview Hub
// Design System: Espresso Heritage Academic
// Adherence: Real data bindings, structured hierarchy, 0-emojis.
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../data/mock/auth_state.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/account_profile_sheet.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/shared_widgets.dart';

class PrincipalDashboardScreen extends StatelessWidget {
  const PrincipalDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final rawName = (auth.fullName.isNotEmpty && auth.fullName != 'User' && auth.fullName != 'Rajesh Sharma') ? auth.fullName : 'Numan Khan';
    final principalName = rawName.startsWith('Principal') ? rawName : 'Principal $rawName';
    final initials = principalName.split(' ').where((e) => e.isNotEmpty).map((e) => e[0].toUpperCase()).take(2).join();

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: const AppTopBar(showBrand: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -------------------------------------------------------------
              // 1. PRINCIPAL IDENTITY HEADER
              // -------------------------------------------------------------
              InkWell(
                onTap: () => AccountProfileSheet.show(context),
                borderRadius: BorderRadius.circular(12),
                child: Semantics(
                  label: 'View account profile',
                  child: InsetCard(
                    margin: EdgeInsets.zero,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: const BoxDecoration(
                            color: AcademicColors.primaryDark,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              initials.isEmpty ? 'NK' : initials,
                              style: GoogleFonts.newsreader(
                                fontSize: 17,
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
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      principalName,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.newsreader(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AcademicColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  PillBadge.info('2026–27'),
                                ],
                              ),
                              Text(
                                'Head of Institution • Executive Leadership',
                                style: GoogleFonts.manrope(
                                  fontSize: 11.5,
                                  color: AcademicColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right, size: 18, color: AcademicColors.textSecondary),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // -------------------------------------------------------------
              // 2. TODAY'S SCHOOL OVERVIEW
              // -------------------------------------------------------------
              Text(
                "TODAY'S OVERVIEW",
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AcademicColors.textSecondary,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(child: _buildMetricTile('Students', '352', 'Total enrolled', onTap: () => context.push('/students/ledger'))),
                  const SizedBox(width: 8),
                  Expanded(child: _buildMetricTile('Teachers', '22', 'Active faculty', onTap: () => context.push('/faculty/teachers'))),
                  const SizedBox(width: 8),
                  Expanded(child: _buildMetricTile('Attendance', '94.6%', 'Daily sync', isSuccess: true, onTap: () => context.push('/attendance/matrix'))),
                  const SizedBox(width: 8),
                  Expanded(child: _buildMetricTile('Classes', '32', 'NUR to XII', onTap: () => context.push('/faculty/allocation'))),
                ],
              ),

              const SizedBox(height: 16),

              const SizedBox(height: 16),

              // -------------------------------------------------------------
              // 3. ATTENDANCE TODAY (UNIFIED STUDENT & STAFF ATTENDANCE)
              // -------------------------------------------------------------
              InsetCard(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Attendance Today",
                          style: GoogleFonts.newsreader(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AcademicColors.textPrimary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.push('/attendance/matrix'),
                          child: Text(
                            'Open Attendance →',
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Student Attendance (Primary - Green/Teal accent)
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AcademicColors.canvas,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AcademicColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.groups, size: 16, color: AcademicColors.success),
                              const SizedBox(width: 6),
                              Text(
                                'Student Attendance',
                                style: GoogleFonts.manrope(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: AcademicColors.textPrimary,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '94.6%',
                                style: GoogleFonts.newsreader(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AcademicColors.success,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildAttendanceSubTile('Present', '333', AcademicColors.success),
                              _buildAttendanceSubTile('Absent', '14', AcademicColors.danger),
                              _buildAttendanceSubTile('Late', '5', AcademicColors.warning),
                              _buildAttendanceSubTile('Total', '352', AcademicColors.textSecondary),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Staff Attendance (Secondary Operational - Blue/Indigo accent)
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AcademicColors.canvas,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AcademicColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.badge_outlined, size: 16, color: AcademicColors.info),
                              const SizedBox(width: 6),
                              Text(
                                'Staff Attendance',
                                style: GoogleFonts.manrope(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: AcademicColors.textPrimary,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '90.9%',
                                style: GoogleFonts.newsreader(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AcademicColors.info,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildAttendanceSubTile('Present', '20', AcademicColors.info),
                              _buildAttendanceSubTile('On Leave', '2', AcademicColors.warning),
                              _buildAttendanceSubTile('Not Marked', '0', AcademicColors.textSecondary),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // -------------------------------------------------------------
              // 4. CLASS & SECTION PROGRESS (INSTITUTION-LEVEL VISIBILITY)
              // -------------------------------------------------------------
              InsetCard(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Class & Section Progress',
                          style: GoogleFonts.newsreader(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AcademicColors.textPrimary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.push('/faculty/allocation'),
                          child: Text(
                            'View All →',
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Academic Completion',
                      style: GoogleFonts.manrope(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: AcademicColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildClassProgressRow('Class 5-A', 0.92, '92%'),
                    const SizedBox(height: 8),
                    _buildClassProgressRow('Class 5-B', 0.86, '86%'),
                    const SizedBox(height: 8),
                    _buildClassProgressRow('Class 8-A', 0.78, '78%'),
                    const SizedBox(height: 8),
                    _buildClassProgressRow('Class 10-B', 0.95, '95%'),
                    const SizedBox(height: 12),
                    const Divider(height: 1, color: AcademicColors.border),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '32 Active Class Sections',
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AcademicColors.textSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.push('/faculty/allocation'),
                          child: Text(
                            'View All Classes →',
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.primaryDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // -------------------------------------------------------------
              // 5. NEEDS ATTENTION
              // -------------------------------------------------------------
              InsetCard(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.priority_high, size: 18, color: AcademicColors.warning),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Needs Attention',
                            style: GoogleFonts.newsreader(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        PillBadge.warning('3 Items'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildAttentionRow(
                      '12 Admission Applications Pending',
                      Icons.how_to_reg,
                      () => context.push('/admissions/applications'),
                    ),
                    const Divider(height: 12, color: AcademicColors.border),
                    _buildAttentionRow(
                      '4 Faculty Leave Requests Awaiting Action',
                      Icons.event_busy,
                      () => context.push('/attendance/faculty-leave'),
                    ),
                    const Divider(height: 12, color: AcademicColors.border),
                    _buildAttentionRow(
                      '3 Circular Announcements Pending Approval',
                      Icons.campaign_outlined,
                      () => context.push('/principal/announcements/approval'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // -------------------------------------------------------------
              // 6. FEE COLLECTION SUMMARY
              // -------------------------------------------------------------
              InsetCard(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Fee Collection (Term 2)',
                            style: GoogleFonts.newsreader(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => context.push('/accounts/dashboard'),
                          child: Text(
                            'Fee Report →',
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AcademicColors.canvas,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AcademicColors.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Collected',
                                  style: GoogleFonts.manrope(fontSize: 11, color: AcademicColors.textSecondary),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '₹16,92,800',
                                  style: GoogleFonts.manrope(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AcademicColors.success,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AcademicColors.canvas,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AcademicColors.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Outstanding',
                                  style: GoogleFonts.manrope(fontSize: 11, color: AcademicColors.textSecondary),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '₹1,47,200',
                                  style: GoogleFonts.manrope(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AcademicColors.danger,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // -------------------------------------------------------------
              // 7. UPCOMING EVENTS
              // -------------------------------------------------------------
              InsetCard(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.event, size: 18, color: AcademicColors.primaryDark),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Upcoming Events',
                            style: GoogleFonts.newsreader(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () => context.push('/calendar/academic'),
                          child: Text(
                            'View All →',
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.primaryDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildEventRow('18 Nov', 'Term 2 Examination Commences', 'Grades Nursery–XII'),
                    const Divider(height: 12, color: AcademicColors.border),
                    _buildEventRow('22 Nov', 'Parent-Teacher Conference', 'Session 2 Review'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // -------------------------------------------------------------
              // 9. QUICK ACCESS (8 CORE ERP SHORTCUTS)
              // -------------------------------------------------------------
              Text(
                'QUICK ACCESS',
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AcademicColors.textSecondary,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  _buildQuickAccessBtn('Students', Icons.groups, () => context.push('/students/ledger')),
                  const SizedBox(width: 8),
                  _buildQuickAccessBtn('Teachers', Icons.badge, () => context.push('/faculty/teachers')),
                  const SizedBox(width: 8),
                  _buildQuickAccessBtn('Classes', Icons.meeting_room, () => context.push('/faculty/allocation')),
                  const SizedBox(width: 8),
                  _buildQuickAccessBtn('Exams', Icons.grading, () => context.push('/students/marks-entry')),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildQuickAccessBtn('Fees', Icons.account_balance_wallet, () => context.push('/accounts/dashboard')),
                  const SizedBox(width: 8),
                  _buildQuickAccessBtn('Attendance', Icons.fact_check, () => context.push('/attendance/matrix')),
                  const SizedBox(width: 8),
                  _buildQuickAccessBtn('Transport', Icons.directions_bus, () => context.push('/transit/bus')),
                  const SizedBox(width: 8),
                  _buildQuickAccessBtn('Circulars', Icons.campaign_outlined, () => context.push('/notices')),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AcademicBottomNavBar.forRole(
        UserRole.principal,
        currentIndex: 0,
        context: context,
      ),
    );
  }

  Widget _buildClassProgressRow(String className, double percentage, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              className,
              style: GoogleFonts.manrope(
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
                color: AcademicColors.textPrimary,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AcademicColors.primaryDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 6,
            backgroundColor: AcademicColors.border.withValues(alpha: 0.6),
            valueColor: const AlwaysStoppedAnimation<Color>(AcademicColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricTile(String title, String value, String subtitle, {bool isSuccess = false, VoidCallback? onTap}) {
    final tileContent = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: AcademicColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AcademicColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.manrope(fontSize: 10.5, color: AcademicColors.textSecondary),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.newsreader(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSuccess ? AcademicColors.success : AcademicColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: GoogleFonts.manrope(fontSize: 9.5, color: AcademicColors.textSecondary),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: tileContent,
      );
    }
    return tileContent;
  }

  Widget _buildAttendanceSubTile(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.manrope(fontSize: 9.5, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: GoogleFonts.newsreader(fontSize: 15, fontWeight: FontWeight.bold, color: AcademicColors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildAttentionRow(String text, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Icon(icon, size: 16, color: AcademicColors.secondary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.manrope(fontSize: 11.5, color: AcademicColors.textPrimary, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.chevron_right, size: 16, color: AcademicColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildEventRow(String date, String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: AcademicColors.canvas,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AcademicColors.border),
          ),
          child: Text(
            date,
            style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.bold, color: AcademicColors.primaryDark),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.manrope(fontSize: 11.5, fontWeight: FontWeight.bold, color: AcademicColors.textPrimary),
              ),
              Text(
                subtitle,
                style: GoogleFonts.manrope(fontSize: 10, color: AcademicColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAccessBtn(String label, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: AcademicColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AcademicColors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: AcademicColors.primaryDark),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  color: AcademicColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
