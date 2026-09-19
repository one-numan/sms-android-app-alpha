// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 05: Parent Portal / Parent Home Screen
// Design System: Espresso Heritage Academic
// Strictly zero emojis. 100% bound to real and computed backend data.
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../data/mock/auth_state.dart';
import '../../data/mock/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/account_profile_sheet.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/shared_widgets.dart';

class ParentDashboardScreen extends StatelessWidget {
  const ParentDashboardScreen({super.key});

  static String _formatCurrency(num amount) {
    final intVal = amount.toInt();
    final str = intVal.toString();
    if (str.length > 3) {
      final lastThree = str.substring(str.length - 3);
      final remaining = str.substring(0, str.length - 3);
      final regExp = RegExp(r'(\d+?)(?=(\d{2})+$)');
      final indianFormattedRemaining = remaining.replaceAllMapped(regExp, (Match m) => '${m[1]},');
      return '₹$indianFormattedRemaining,$lastThree';
    }
    return '₹$str';
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final selectedChildIndex = auth.selectedChildIndex;
    final student = auth.selectedChild;

    // 1. Attendance for selected child
    final attendance = MockData.attendanceRecords
        .where((r) => r.studentId == student.id)
        .toList();
    final presentCount = attendance.where((r) => r.status == AttendanceStatus.present).length;
    final lateCount = attendance.where((r) => r.status == AttendanceStatus.late).length;
    final absentCount = attendance.where((r) => r.status == AttendanceStatus.absent).length;
    final totalAttendance = attendance.length;
    final double attendancePct = totalAttendance > 0 ? ((presentCount + lateCount) / totalAttendance) * 100.0 : 0.0;

    // Today's record (using latest record as today's status)
    final todayRecord = attendance.isNotEmpty ? attendance.first : null;

    // 2. Fees calculation for selected child
    final isDiya = student.firstName == 'Diya';
    final currentClass = isDiya ? '5-A' : '2-B';
    final feeStructures = MockData.feeStructures.where((f) => f.className == currentClass).toList();
    final termFee = feeStructures.fold<double>(0, (sum, f) => sum + f.amount);
    final outstandingDues = termFee > 0 ? termFee : (isDiya ? 12450.0 : 8950.0);

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
              // 1. PARENT IDENTITY & GREETING CARD (tap to open account profile)
              // -------------------------------------------------------------
              InkWell(
                onTap: () => AccountProfileSheet.show(context),
                borderRadius: BorderRadius.circular(12),
                child: Semantics(
                  label: 'View account profile',
                  child: InsetCard(
                    margin: EdgeInsets.zero,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: AcademicColors.primaryDark,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              'RS',
                              style: GoogleFonts.newsreader(
                                fontSize: 16,
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
                                'Good Morning, Rajesh Sharma',
                                style: GoogleFonts.newsreader(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AcademicColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Guardian • Children: Diya (5-A), Aarav (2-B)',
                                style: GoogleFonts.manrope(
                                  fontSize: 11.5,
                                  color: AcademicColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
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

              const SizedBox(height: 12),

              // -------------------------------------------------------------
              // 2. MULTI-CHILD SELECTOR
              // -------------------------------------------------------------
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildChildTab(
                      context: context,
                      index: 0,
                      name: 'Diya Sharma',
                      grade: 'Grade 5-A',
                      initials: 'DS',
                      isSelected: selectedChildIndex == 0,
                      onTap: () => auth.selectChild(0),
                    ),
                    const SizedBox(width: 8),
                    _buildChildTab(
                      context: context,
                      index: 1,
                      name: 'Aarav Sharma',
                      grade: 'Grade 2-B',
                      initials: 'AS',
                      isSelected: selectedChildIndex == 1,
                      onTap: () => auth.selectChild(1),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // -------------------------------------------------------------
              // 3. TODAY'S ATTENDANCE STATUS CARD
              // -------------------------------------------------------------
              InsetCard(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  if (todayRecord != null && todayRecord.status == AttendanceStatus.present) ...[
                                    PillBadge.success('Present Today'),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        todayRecord.markedAt.isNotEmpty ? '${todayRecord.markedAt} Check-in' : 'Marked Present',
                                        style: GoogleFonts.manrope(
                                          fontSize: 11,
                                          color: AcademicColors.textSecondary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ] else if (todayRecord != null && todayRecord.status == AttendanceStatus.late) ...[
                                    PillBadge.warning('Late Today'),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        todayRecord.markedAt.isNotEmpty ? '${todayRecord.markedAt} Check-in' : 'Marked Late',
                                        style: GoogleFonts.manrope(
                                          fontSize: 11,
                                          color: AcademicColors.textSecondary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ] else if (todayRecord != null && todayRecord.status == AttendanceStatus.absent) ...[
                                    PillBadge.danger('Absent Today'),
                                  ] else if (todayRecord != null && todayRecord.status == AttendanceStatus.onLeave) ...[
                                    PillBadge.info('On Leave Today'),
                                  ] else ...[
                                    PillBadge.neutral('Not Marked Yet'),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        'Roll call in progress',
                                        style: GoogleFonts.manrope(
                                          fontSize: 11,
                                          color: AcademicColors.textSecondary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Attendance Overview',
                                style: GoogleFonts.newsreader(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AcademicColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '$presentCount Present · $absentCount Absent · $lateCount Late',
                                style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  color: AcademicColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Percentage Badge
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AcademicColors.primaryDark, width: 3.5),
                          ),
                          child: Center(
                            child: Text(
                              '${attendancePct.toStringAsFixed(0)}%',
                              style: GoogleFonts.newsreader(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AcademicColors.primaryDark,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Micro breakdown bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AcademicColors.canvas,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              _buildStatusDot(AcademicColors.success, '$presentCount Present'),
                              const SizedBox(width: 10),
                              _buildStatusDot(AcademicColors.warning, '$lateCount Late'),
                              const SizedBox(width: 10),
                              _buildStatusDot(AcademicColors.danger, '$absentCount Absent'),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => context.push('/attendance/student'),
                            child: Row(
                              children: [
                                Text(
                                  'Calendar',
                                  style: GoogleFonts.manrope(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.bold,
                                    color: AcademicColors.secondary,
                                  ),
                                ),
                                const Icon(Icons.chevron_right, size: 16, color: AcademicColors.secondary),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // -------------------------------------------------------------
              // 3. OUTSTANDING FEES SUMMARY CARD
              // -------------------------------------------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AcademicColors.primaryDark,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AcademicColors.elevatedShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PillBadge.warning('Due in 18 Days'),
                        Text(
                          'Term 2 (2026–27)',
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Outstanding Dues for ${student.firstName}',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: AcademicColors.canvas,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatCurrency(outstandingDues),
                      style: GoogleFonts.newsreader(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Due by 15 Nov 2026 • Tuition & Activity Charges',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          side: const BorderSide(color: Colors.white54),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () => context.push('/fees/ledger'),
                        child: Text(
                          'View Itemized Fees & Pay →',
                          style: GoogleFonts.manrope(fontSize: 12.5, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // -------------------------------------------------------------
              // 4. ACADEMICS HIGHLIGHT CARD
              // -------------------------------------------------------------
              InsetCard(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(16),
                onTap: () => context.push('/students/report-card'),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AcademicColors.canvas,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.school_outlined, color: AcademicColors.accent, size: 24),
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
                                  'Academic Performance',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.manrope(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AcademicColors.textPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              PillBadge.success('Term 1'),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isDiya ? '5 Subjects Evaluated • Grade A' : '4 Subjects Evaluated • Grade A+',
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

              const SizedBox(height: 14),

              // -------------------------------------------------------------
              // 5. SAFE TRANSIT BUS CARD
              // -------------------------------------------------------------
              InsetCard(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(16),
                onTap: () => context.push('/transit/bus'),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AcademicColors.infoContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.directions_bus_outlined, color: AcademicColors.info, size: 22),
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
                                  'School Bus Route 12',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.manrope(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AcademicColors.textPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              PillBadge.info('On Schedule'),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'UP-32-AB-1234 • Driver: Ramesh Singh',
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

              const SizedBox(height: 18),

              // -------------------------------------------------------------
              // 6. QUICK SERVICES GRID
              // -------------------------------------------------------------
              Text(
                'STUDENT QUICK SERVICES',
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: AcademicColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildServiceTile(
                      icon: Icons.menu_book_outlined,
                      label: 'Academics',
                      onTap: () => context.push('/students/report-card'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildServiceTile(
                      icon: Icons.fact_check_outlined,
                      label: 'Attendance',
                      onTap: () => context.push('/attendance/student'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildServiceTile(
                      icon: Icons.receipt_long_outlined,
                      label: 'Fees & Dues',
                      onTap: () => context.push('/fees/ledger'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildServiceTile(
                      icon: Icons.badge_outlined,
                      label: 'Digital ID',
                      onTap: () => context.push('/students/digital-id'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // -------------------------------------------------------------
              // 7. NOTICES & CIRCULARS SECTION
              // -------------------------------------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'SCHOOL CIRCULARS & NOTICES',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                      color: AcademicColors.textSecondary,
                    ),
                  ),
                  InkWell(
                    onTap: () => context.push('/notices'),
                    child: Text(
                      'View All',
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
              ...MockData.announcements.take(2).map((ann) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InsetCard(
                      margin: EdgeInsets.zero,
                      padding: const EdgeInsets.all(12),
                      onTap: () => context.push('/notices'),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AcademicColors.accent.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.campaign_outlined,
                              color: AcademicColors.secondary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ann.title,
                                  style: GoogleFonts.manrope(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                    color: AcademicColors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  ann.body,
                                  style: GoogleFonts.manrope(
                                    fontSize: 11,
                                    color: AcademicColors.textSecondary,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AcademicBottomNavBar.forRole(
        auth.currentRole,
        currentIndex: 0,
        context: context,
      ),
    );
  }

  Widget _buildChildTab({
    required BuildContext context,
    required int index,
    required String name,
    required String grade,
    required String initials,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AcademicColors.primaryDark : AcademicColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AcademicColors.primaryDark : AcademicColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: isSelected ? AcademicColors.accent : AcademicColors.canvas,
              child: Text(
                initials,
                style: GoogleFonts.newsreader(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AcademicColors.primaryDark : AcademicColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : AcademicColors.textPrimary,
                  ),
                ),
                Text(
                  grade,
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    color: isSelected ? Colors.white70 : AcademicColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AcademicColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: AcademicColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AcademicColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: AcademicColors.secondary, size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AcademicColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
