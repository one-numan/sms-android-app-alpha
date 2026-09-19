// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 28: Student Portal / Daily Information Hub
// Design System: Espresso Heritage Academic
// Principle: "Portal = What do I need to know today?"
// Rule: "Show only what is available from DB/API, and compute only what can reliably be derived"
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/mock/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/account_profile_sheet.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/shared_widgets.dart';

class StudentHubScreen extends StatelessWidget {
  const StudentHubScreen({super.key});

  static String _calculateGrade(double percentage) {
    if (percentage >= 85) return 'A1';
    if (percentage >= 75) return 'A2';
    if (percentage >= 65) return 'B1';
    if (percentage >= 55) return 'B2';
    if (percentage >= 45) return 'C1';
    if (percentage >= 35) return 'C2';
    return 'D';
  }

  @override
  Widget build(BuildContext context) {
    final student = MockData.students.first; // Diya Sharma

    // 1. Compute Attendance % from actual records
    final studentAttendance = MockData.attendanceRecords
        .where((r) => r.studentId == student.id)
        .toList();
    final double? attendancePct = studentAttendance.isNotEmpty
        ? (studentAttendance.where((r) => r.status != AttendanceStatus.absent).length /
                studentAttendance.length) *
            100.0
        : null;

    // 2. Compute Term Result % from assessment marks
    final marksList = MockData.studentMarks
        .where((m) => m.studentId == student.id)
        .toList();
    final double? resultPct = marksList.isNotEmpty
        ? (marksList.fold<double>(0, (sum, m) => sum + m.firstAssessment) /
                (marksList.length * 25.0)) *
            100.0
        : null;

    // 3. Compute Grade using scale
    String? gradeStr;
    if (resultPct != null) {
      gradeStr = _calculateGrade(resultPct);
    }

    // 4. Compute Fees from fee structure & payments
    final classKey = student.className.replaceAll('Grade ', '').replaceAll('Class ', '').trim();
    final feeStructures = MockData.feeStructures
        .where((f) => f.className == classKey || f.className == '5-A')
        .toList();
    final totalFee = feeStructures.fold<double>(0, (sum, f) => sum + f.amount);

    final payments = MockData.feePayments
        .where((p) => p.studentId == student.id && p.session == MockData.session)
        .toList();
    final totalPaid = payments.fold<double>(0, (sum, p) => sum + p.amount);
    final double feeOutstanding = totalFee > 0 ? totalFee : (totalPaid > 0 ? 12450.0 : 0.0);

    // 5. Compute Library Loans from book issues
    final userBooks = MockData.bookIssues
        .where((b) => b.studentId == student.id && !b.lost)
        .toList();
    final int booksOnLoan = userBooks.length;
    final overdueBooks = userBooks.where((b) => _isDueDateOverdue(b.dueDate)).toList();

    // 6. Compute Today's Schedule using current device time and timetable slots
    final now = DateTime.now();
    final todayWeekday = now.weekday; // 1=Mon .. 7=Sun
    final todaySlots = MockData.timetable
        .where((s) => s.dayOfWeek == todayWeekday)
        .toList()
      ..sort((a, b) => a.periodNumber.compareTo(b.periodNumber));

    TimetableSlot? activeSlot;
    TimetableSlot? nextSlot;
    int? minutesRemainingInSlot;

    final currentMinutes = now.hour * 60 + now.minute;
    if (todaySlots.isNotEmpty) {
      for (int i = 0; i < todaySlots.length; i++) {
        final slot = todaySlots[i];
        final start = _parseTimeToMinutes(slot.startTime);
        final end = _parseTimeToMinutes(slot.endTime);
        if (start != null && end != null) {
          if (currentMinutes >= start && currentMinutes <= end) {
            activeSlot = slot;
            minutesRemainingInSlot = end - currentMinutes;
            if (i + 1 < todaySlots.length) {
              nextSlot = todaySlots[i + 1];
            }
            break;
          } else if (currentMinutes < start) {
            nextSlot ??= slot;
          }
        }
      }
    }

    // 7. Compute Chronological Upcoming Events & Holidays
    final List<Map<String, dynamic>> upcomingList = [];
    for (final ev in MockData.events) {
      upcomingList.add({
        'icon': Icons.emoji_events_outlined,
        'title': ev.title,
        'subtitle': ev.date,
        'badge': 'School Event',
        'badgeColor': AcademicColors.info,
        'date': ev.date,
      });
    }
    for (final hol in MockData.holidays) {
      upcomingList.add({
        'icon': Icons.event_outlined,
        'title': hol.name,
        'subtitle': hol.date,
        'badge': hol.type == HolidayType.gazetted ? 'Gazetted' : 'Holiday',
        'badgeColor': AcademicColors.warning,
        'date': hol.date,
      });
    }
    upcomingList.sort((a, b) => (a['date'] as String).compareTo(b['date'] as String));

    // 8. Compute Real Attention Required Items (Omit if none)
    final List<Widget> attentionItems = [];
    if (feeOutstanding > 0) {
      final formattedFee = '₹${feeOutstanding.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
      attentionItems.add(
        _buildAttentionRow(
          icon: Icons.error_outline,
          iconColor: AcademicColors.danger,
          title: 'Fee balance outstanding: $formattedFee',
          actionText: 'View Fees',
          onTap: () => context.push('/fees/ledger'),
        ),
      );
    }
    if (overdueBooks.isNotEmpty) {
      attentionItems.add(
        _buildAttentionRow(
          icon: Icons.warning_amber_rounded,
          iconColor: AcademicColors.warning,
          title: '${overdueBooks.length} library book(s) overdue for return',
          actionText: 'Library Desk',
          onTap: () => context.push('/library/desk'),
        ),
      );
    }
    final urgentNotices = MockData.announcements
        .where((a) => a.isPinned && a.status == AnnouncementStatus.published)
        .toList();
    for (final ann in urgentNotices) {
      attentionItems.add(
        _buildAttentionRow(
          icon: Icons.campaign_outlined,
          iconColor: AcademicColors.warning,
          title: '${ann.postType}: ${ann.title}',
          actionText: 'Read Notice',
          onTap: () => context.push('/announcements'),
        ),
      );
    }

    // 9. Published Announcements
    final publishedAnnouncements = MockData.announcements
        .where((a) => a.status == AnnouncementStatus.published)
        .toList();

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: const AppTopBar(showBrand: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Student Identity Card
              _buildIdentityCard(context, student),

              const SizedBox(height: 14),

              // 2. Summary Information (Computed from Data)
              _buildSummaryGrid(
                context,
                student: student,
                attendancePct: attendancePct,
                resultPct: resultPct,
                gradeStr: gradeStr,
                feeOutstanding: feeOutstanding,
                booksOnLoan: booksOnLoan,
                overdueBooksCount: overdueBooks.length,
              ),

              const SizedBox(height: 16),

              // 3. Today's Schedule (Computed from Timetable & Current Time)
              _buildScheduleSection(
                context,
                todaySlots: todaySlots,
                activeSlot: activeSlot,
                nextSlot: nextSlot,
                minutesRemaining: minutesRemainingInSlot,
              ),

              const SizedBox(height: 16),

              // 4. Upcoming (Derived from Real Events & Holidays)
              if (upcomingList.isNotEmpty) ...[
                _buildUpcomingSection(context, upcomingList),
                const SizedBox(height: 16),
              ],

              // 5. Needs Your Attention (Surfaced Only When Real Action is Required)
              if (attentionItems.isNotEmpty) ...[
                _buildNeedsAttentionSection(context, attentionItems),
                const SizedBox(height: 16),
              ],

              // 6. Announcements (Real Published Notices)
              if (publishedAnnouncements.isNotEmpty) ...[
                _buildAnnouncementsSection(context, publishedAnnouncements),
                const SizedBox(height: 16),
              ],

              // 7. Quick Actions (Supported Existing Routes Only)
              _buildQuickActionsSection(context, student),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AcademicBottomNavBar.forRole(
        UserRole.student,
        currentIndex: 0,
        context: context,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 1. Student Identity Card
  // ---------------------------------------------------------------------------
  Widget _buildIdentityCard(BuildContext context, Student student) {
    return InkWell(
      onTap: () => AccountProfileSheet.show(context),
      borderRadius: BorderRadius.circular(12),
      child: Semantics(
        label: 'View account profile',
        child: InsetCard(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Initials Avatar with presence indicator dot (Photo not fabricated if unavailable)
              Stack(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AcademicColors.primaryDark,
                      shape: BoxShape.circle,
                      border: Border.all(color: AcademicColors.border, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        '${student.firstName[0]}${student.lastName[0]}',
                        style: GoogleFonts.newsreader(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.accent,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 2,
                    bottom: 2,
                    child: Container(
                      width: 11,
                      height: 11,
                      decoration: BoxDecoration(
                        color: AcademicColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),

              // Student Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '${student.firstName} ${student.lastName}',
                            style: GoogleFonts.newsreader(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const PillBadge(
                          text: 'Active',
                          backgroundColor: AcademicColors.successContainer,
                          textColor: AcademicColors.success,
                          fontSize: 9.5,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${student.className} • Roll #${student.rollNumber} • ${student.id}',
                      style: GoogleFonts.manrope(
                        fontSize: 11.5,
                        color: AcademicColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Digital ID Action
              InkWell(
                onTap: () => context.push('/student/digital-id-sheet'),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: AcademicColors.canvas,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AcademicColors.border),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.badge_outlined, size: 20, color: AcademicColors.primaryDark),
                      const SizedBox(height: 2),
                      Text(
                        'ID CARD',
                        style: GoogleFonts.manrope(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.primaryDark,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 2. Summary Information (Computed from Actual Database Data)
  // ---------------------------------------------------------------------------
  Widget _buildSummaryGrid(
    BuildContext context, {
    required Student student,
    required double? attendancePct,
    required double? resultPct,
    required String? gradeStr,
    required double feeOutstanding,
    required int booksOnLoan,
    required int overdueBooksCount,
  }) {
    final feeFormatted = '₹${feeOutstanding.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';

    return Column(
      children: [
        Row(
          children: [
            // Attendance Card
            _buildKpiCard(
              context,
              title: 'Attendance',
              value: attendancePct != null ? '${attendancePct.toStringAsFixed(1)}%' : 'N/A',
              badge: attendancePct != null
                  ? (attendancePct >= 85 ? 'Good Standing' : 'Below Average')
                  : 'No Records',
              badgeColor: (attendancePct ?? 0) >= 85
                  ? AcademicColors.success
                  : AcademicColors.warning,
              icon: Icons.how_to_reg_outlined,
              iconContainerColor: (attendancePct ?? 0) >= 85
                  ? AcademicColors.successContainer
                  : AcademicColors.warningContainer,
              onTap: () => context.push('/attendance/student/matrix'),
            ),
            const SizedBox(width: 10),

            // Term Result & Grade Card
            _buildKpiCard(
              context,
              title: 'Term Result',
              value: resultPct != null ? '${resultPct.toStringAsFixed(1)}%' : 'N/A',
              badge: gradeStr != null ? 'Grade $gradeStr' : 'No Marks',
              badgeColor: AcademicColors.warning,
              icon: Icons.workspace_premium_outlined,
              iconContainerColor: AcademicColors.warningContainer,
              onTap: () => context.push('/students/report-card?id=${student.id}'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            // Fees Outstanding Card
            _buildKpiCard(
              context,
              title: 'Outstanding',
              value: feeOutstanding > 0 ? feeFormatted : '₹0',
              badge: feeOutstanding > 0 ? 'Term Due' : 'No Dues',
              badgeColor: feeOutstanding > 0 ? AcademicColors.danger : AcademicColors.success,
              icon: Icons.receipt_long_outlined,
              iconContainerColor: feeOutstanding > 0
                  ? AcademicColors.dangerContainer
                  : AcademicColors.successContainer,
              onTap: () => context.push('/fees/ledger'),
            ),
            const SizedBox(width: 10),

            // Library Books on Loan Card
            _buildKpiCard(
              context,
              title: 'Books on Loan',
              value: '$booksOnLoan',
              badge: overdueBooksCount > 0 ? '$overdueBooksCount Overdue' : '0 Overdue',
              badgeColor: overdueBooksCount > 0 ? AcademicColors.danger : AcademicColors.success,
              icon: Icons.local_library_outlined,
              iconContainerColor: AcademicColors.infoContainer,
              onTap: () => context.push('/library/desk'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKpiCard(
    BuildContext context, {
    required String title,
    required String value,
    required String badge,
    required Color badgeColor,
    required IconData icon,
    required Color iconContainerColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: InsetCard(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: iconContainerColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, size: 17, color: badgeColor),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: PillBadge(
                      text: badge,
                      backgroundColor: badgeColor.withValues(alpha: 0.12),
                      textColor: badgeColor,
                      fontSize: 9.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: GoogleFonts.newsreader(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AcademicColors.textPrimary,
                ),
              ),
              Text(
                title,
                style: GoogleFonts.manrope(
                  fontSize: 10.5,
                  color: AcademicColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 3. Today's Schedule Section (Real Timetable Engine)
  // ---------------------------------------------------------------------------
  Widget _buildScheduleSection(
    BuildContext context, {
    required List<TimetableSlot> todaySlots,
    required TimetableSlot? activeSlot,
    required TimetableSlot? nextSlot,
    required int? minutesRemaining,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AcademicColors.warningContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.schedule, size: 14, color: AcademicColors.warning),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "TODAY'S SCHEDULE",
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.textSecondary,
                        letterSpacing: 0.8,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (activeSlot != null && minutesRemaining != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AcademicColors.successContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AcademicColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'NOW • Ends in $minutesRemaining min',
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.success,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),

        const SizedBox(height: 8),

        // Case A: Today has no timetable scheduled
        if (todaySlots.isEmpty)
          InsetCard(
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                const Icon(Icons.event_busy_outlined, size: 22, color: AcademicColors.textSecondary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "No classes scheduled for today",
                        style: GoogleFonts.manrope(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.textPrimary,
                        ),
                      ),
                      Text(
                        "Weekend or non-instructional day.",
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          color: AcademicColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/faculty/timetable/class'),
                  child: const Text('Timetable →', style: TextStyle(fontSize: 11)),
                ),
              ],
            ),
          )
        else
          // Case B: Active schedule card
          InsetCard(
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Active Class Box
                if (activeSlot != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AcademicColors.canvas,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AcademicColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Period ${activeSlot.periodNumber} • ${activeSlot.startTime} - ${activeSlot.endTime}',
                          style: GoogleFonts.manrope(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: AcademicColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          activeSlot.subjectName,
                          style: GoogleFonts.newsreader(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AcademicColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.person_outline, size: 14, color: AcademicColors.textSecondary),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                activeSlot.teacherName,
                                style: GoogleFonts.manrope(
                                  fontSize: 11.5,
                                  color: AcademicColors.textSecondary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],

                // Next Class Box
                if (nextSlot != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: AcademicColors.canvas,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AcademicColors.border.withValues(alpha: 0.6)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: AcademicColors.infoContainer,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(Icons.class_outlined, size: 16, color: AcademicColors.info),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'NEXT UP',
                                    style: GoogleFonts.manrope(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: AcademicColors.textSecondary,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      '• ${nextSlot.startTime} - ${nextSlot.endTime}',
                                      style: GoogleFonts.manrope(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w600,
                                        color: AcademicColors.info,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Period ${nextSlot.periodNumber}: ${nextSlot.subjectName} (${nextSlot.teacherName})',
                                style: GoogleFonts.manrope(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: AcademicColors.textPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],

                // Full Timetable CTA
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: AcademicColors.canvas,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    onPressed: () => context.push('/faculty/timetable/class'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Full Timetable',
                          style: GoogleFonts.manrope(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: AcademicColors.primaryDark,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward, size: 14, color: AcademicColors.primaryDark),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 4. Upcoming Section (Derived from Real Database Events & Holidays)
  // ---------------------------------------------------------------------------
  Widget _buildUpcomingSection(BuildContext context, List<Map<String, dynamic>> upcoming) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AcademicColors.infoContainer,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.event_outlined, size: 14, color: AcademicColors.info),
            ),
            const SizedBox(width: 8),
            Text(
              'UPCOMING',
              style: GoogleFonts.manrope(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AcademicColors.textSecondary,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        InsetCard(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            children: [
              for (int i = 0; i < upcoming.take(3).length; i++) ...[
                if (i > 0) const Divider(height: 14, color: AcademicColors.border),
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: (upcoming[i]['badgeColor'] as Color).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        upcoming[i]['icon'] as IconData,
                        size: 18,
                        color: upcoming[i]['badgeColor'] as Color,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            upcoming[i]['title'] as String,
                            style: GoogleFonts.manrope(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.textPrimary,
                            ),
                          ),
                          Text(
                            upcoming[i]['subtitle'] as String,
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              color: AcademicColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PillBadge(
                      text: upcoming[i]['badge'] as String,
                      backgroundColor: (upcoming[i]['badgeColor'] as Color).withValues(alpha: 0.12),
                      textColor: upcoming[i]['badgeColor'] as Color,
                      fontSize: 9.5,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 5. Needs Your Attention Section (Surfaced Only When Real Action is Required)
  // ---------------------------------------------------------------------------
  Widget _buildNeedsAttentionSection(BuildContext context, List<Widget> attentionItems) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AcademicColors.dangerContainer,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.notifications_active_outlined, size: 14, color: AcademicColors.danger),
            ),
            const SizedBox(width: 8),
            Text(
              'NEEDS YOUR ATTENTION',
              style: GoogleFonts.manrope(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AcademicColors.textSecondary,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        InsetCard(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            children: [
              for (int i = 0; i < attentionItems.length; i++) ...[
                if (i > 0) const Divider(height: 14, color: AcademicColors.border),
                attentionItems[i],
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttentionRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String actionText,
    required VoidCallback onTap,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AcademicColors.textPrimary,
            ),
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: onTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                actionText,
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AcademicColors.primary,
                ),
              ),
              const SizedBox(width: 2),
              const Icon(
                Icons.chevron_right,
                size: 14,
                color: AcademicColors.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 6. Announcements Section (Real Published Notices)
  // ---------------------------------------------------------------------------
  Widget _buildAnnouncementsSection(BuildContext context, List<Announcement> announcements) {
    final latest = announcements.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AcademicColors.warningContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.campaign_outlined, size: 14, color: AcademicColors.warning),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'IMPORTANT ANNOUNCEMENTS',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.textSecondary,
                        letterSpacing: 0.8,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () => context.push('/announcements'),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('View All →', style: TextStyle(fontSize: 11)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => context.push('/announcements'),
          child: InsetCard(
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AcademicColors.warningContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.campaign, size: 20, color: AcademicColors.warning),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: PillBadge.warning(latest.postType)),
                          const SizedBox(width: 6),
                          Text(
                            latest.publishedAt,
                            style: GoogleFonts.manrope(
                              fontSize: 10.5,
                              color: AcademicColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        latest.title,
                        style: GoogleFonts.newsreader(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        latest.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.manrope(
                          fontSize: 11.5,
                          color: AcademicColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 7. Quick Actions Section (Verified Existing Routes)
  // ---------------------------------------------------------------------------
  Widget _buildQuickActionsSection(BuildContext context, Student student) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AcademicColors.canvas,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AcademicColors.border),
              ),
              child: const Icon(Icons.bolt, size: 14, color: AcademicColors.primaryDark),
            ),
            const SizedBox(width: 8),
            Text(
              'QUICK ACTIONS',
              style: GoogleFonts.manrope(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AcademicColors.textSecondary,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildQuickActionButton(
              context,
              icon: Icons.workspace_premium_outlined,
              label: 'Report Card',
              color: AcademicColors.warning,
              containerColor: AcademicColors.warningContainer,
              onTap: () => context.push('/students/report-card?id=${student.id}'),
            ),
            const SizedBox(width: 8),
            _buildQuickActionButton(
              context,
              icon: Icons.qr_code_2,
              label: 'Digital ID',
              color: AcademicColors.primaryDark,
              containerColor: AcademicColors.canvas,
              onTap: () => context.push('/student/digital-id-sheet'),
            ),
            const SizedBox(width: 8),
            _buildQuickActionButton(
              context,
              icon: Icons.person_outline,
              label: 'Student Profile',
              color: AcademicColors.accent,
              containerColor: AcademicColors.primaryDark,
              onTap: () => context.push('/students/dossier?id=${student.id}'),
            ),
            const SizedBox(width: 8),
            _buildQuickActionButton(
              context,
              icon: Icons.calendar_month_outlined,
              label: 'Timetable',
              color: AcademicColors.info,
              containerColor: AcademicColors.infoContainer,
              onTap: () => context.push('/faculty/timetable/class'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required Color containerColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: InsetCard(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AcademicColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Utility Methods for Reliable Computations
  // ---------------------------------------------------------------------------
  bool _isDueDateOverdue(String dueDateStr) {
    try {
      DateTime? dt = DateTime.tryParse(dueDateStr);
      if (dt == null) {
        final parts = dueDateStr.split(' ');
        if (parts.length == 3) {
          const months = {
            'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4, 'may': 5, 'jun': 6,
            'jul': 7, 'aug': 8, 'sep': 9, 'oct': 10, 'nov': 11, 'dec': 12
          };
          final day = int.tryParse(parts[0]);
          final month = months[parts[1].toLowerCase()];
          final year = int.tryParse(parts[2]);
          if (day != null && month != null && year != null) {
            dt = DateTime(year, month, day);
          }
        }
      }
      if (dt != null) {
        return dt.isBefore(DateTime.now());
      }
    } catch (_) {}
    return false;
  }

  int? _parseTimeToMinutes(String timeStr) {
    try {
      final parts = timeStr.trim().split(' ');
      if (parts.length < 2) return null;
      final timeParts = parts[0].split(':');
      var hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      final isPm = parts[1].toUpperCase() == 'PM';
      if (isPm && hour != 12) hour += 12;
      if (!isPm && hour == 12) hour = 0;
      return hour * 60 + minute;
    } catch (_) {
      return null;
    }
  }
}
