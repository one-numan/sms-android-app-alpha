// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 11: Parent – Attendance Screen
// Design System: Espresso Heritage Academic
// Strictly zero emojis. 100% bound to real and computed backend data.
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../data/mock/auth_state.dart';
import '../../data/mock/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/shared_widgets.dart';

class StudentAttendanceScreen extends StatefulWidget {
  final String? studentId;
  const StudentAttendanceScreen({super.key, this.studentId});

  @override
  State<StudentAttendanceScreen> createState() => _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  int _selectedCalendarDay = 25;
  String _historyFilter = 'All'; // All, Present, Absent, Late, Leave
  int _currentMonthIndex = 9; // 9 = October 2026 (0-indexed where Jan=0, Oct=9)

  final List<String> _months = [
    'January 2026', 'February 2026', 'March 2026', 'April 2026',
    'May 2026', 'June 2026', 'July 2026', 'August 2026',
    'September 2026', 'October 2026', 'November 2026', 'December 2026'
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final student = auth.selectedChild;

    // 1. Data Source: Attendance records for selected student
    final records = MockData.attendanceRecords
        .where((r) => r.studentId == student.id)
        .toList();

    // 2. Metrics computation
    final totalRecordedDays = records.length;
    final presentCount = records.where((r) => r.status == AttendanceStatus.present).length;
    final lateCount = records.where((r) => r.status == AttendanceStatus.late).length;
    final absentCount = records.where((r) => r.status == AttendanceStatus.absent).length;
    final leaveCount = records.where((r) => r.status == AttendanceStatus.onLeave).length;

    // Attended percentage (Present / Total recorded)
    final double attendancePct = totalRecordedDays > 0
        ? (presentCount / totalRecordedDays) * 100.0
        : 0.0;

    // Filtered history
    final filteredRecords = records.where((r) {
      if (_historyFilter == 'Present') return r.status == AttendanceStatus.present;
      if (_historyFilter == 'Absent') return r.status == AttendanceStatus.absent;
      if (_historyFilter == 'Late') return r.status == AttendanceStatus.late;
      if (_historyFilter == 'Leave') return r.status == AttendanceStatus.onLeave;
      return true;
    }).toList();

    // Today's record (latest)
    final todayRecord = records.isNotEmpty ? records.first : null;

    // Selected date record
    final selectedDateStr = '2026-10-${_selectedCalendarDay.toString().padLeft(2, '0')}';
    final selectedDateRecord = records.where((r) => r.date == selectedDateStr).firstOrNull;

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: const AppTopBar(
        title: 'Attendance',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------------------------------------------------------
              // 1. CHILD SWITCHER & CONTEXT HEADER
              // ---------------------------------------------------------------
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildChildPill(
                      name: 'Diya Sharma',
                      grade: 'Grade 5-A',
                      isSelected: auth.selectedChildIndex == 0,
                      onTap: () => auth.selectChild(0),
                    ),
                    const SizedBox(width: 8),
                    _buildChildPill(
                      name: 'Aarav Sharma',
                      grade: 'Grade 2-B',
                      isSelected: auth.selectedChildIndex == 1,
                      onTap: () => auth.selectChild(1),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ---------------------------------------------------------------
              // 2. ATTENDANCE OVERVIEW CARD (Primary KPI)
              // ---------------------------------------------------------------
              InsetCard(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Attendance Overview',
                                style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                  color: AcademicColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${attendancePct.toStringAsFixed(0)}%',
                                style: GoogleFonts.newsreader(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: AcademicColors.primaryDark,
                                ),
                              ),
                              Text(
                                '$totalRecordedDays recorded days',
                                style: GoogleFonts.manrope(
                                  fontSize: 11.5,
                                  color: AcademicColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Visual circular badge
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AcademicColors.primaryDark.withValues(alpha: 0.08),
                            border: Border.all(color: AcademicColors.primaryDark, width: 2.5),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.fact_check,
                              size: 28,
                              color: AcademicColors.primaryDark,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),
                    const Divider(height: 1, color: AcademicColors.border),
                    const SizedBox(height: 12),

                    // Compact Summary Breakdown
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMetricTile('Present', presentCount.toString(), AcademicColors.success),
                        _buildMetricTile('Absent', absentCount.toString(), AcademicColors.danger),
                        _buildMetricTile('Late', lateCount.toString(), AcademicColors.warning),
                        _buildMetricTile('Leave', leaveCount.toString(), AcademicColors.info),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ---------------------------------------------------------------
              // 3. TODAY'S STATUS CARD
              // ---------------------------------------------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AcademicColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AcademicColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AcademicColors.primaryDark,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'TODAY',
                              style: GoogleFonts.manrope(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (todayRecord != null && todayRecord.status == AttendanceStatus.present) ...[
                                  Text(
                                    'Present',
                                    style: GoogleFonts.manrope(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AcademicColors.success,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    todayRecord.markedAt.isNotEmpty ? '${todayRecord.markedAt} · Check-in recorded' : 'Recorded',
                                    style: GoogleFonts.manrope(
                                      fontSize: 11,
                                      color: AcademicColors.textSecondary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ] else if (todayRecord != null && todayRecord.status == AttendanceStatus.late) ...[
                                  Text(
                                    'Late',
                                    style: GoogleFonts.manrope(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AcademicColors.warning,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    todayRecord.markedAt.isNotEmpty ? '${todayRecord.markedAt} · Late arrival recorded' : 'Recorded',
                                    style: GoogleFonts.manrope(
                                      fontSize: 11,
                                      color: AcademicColors.textSecondary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ] else if (todayRecord != null && todayRecord.status == AttendanceStatus.absent) ...[
                                  Text(
                                    'Absent',
                                    style: GoogleFonts.manrope(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AcademicColors.danger,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Absence recorded for today',
                                    style: GoogleFonts.manrope(
                                      fontSize: 11,
                                      color: AcademicColors.textSecondary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ] else ...[
                                  Text(
                                    'Attendance not marked yet',
                                    style: GoogleFonts.manrope(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AcademicColors.textSecondary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Roll call in progress',
                                    style: GoogleFonts.manrope(
                                      fontSize: 11,
                                      color: AcademicColors.textSecondary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      todayRecord != null && todayRecord.status == AttendanceStatus.present
                          ? Icons.check_circle
                          : Icons.access_time,
                      color: todayRecord != null && todayRecord.status == AttendanceStatus.present
                          ? AcademicColors.success
                          : AcademicColors.textSecondary,
                      size: 22,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ---------------------------------------------------------------
              // 4. MONTHLY 7-COLUMN CALENDAR
              // ---------------------------------------------------------------
              InsetCard(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    // Month Navigation Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                          icon: const Icon(Icons.chevron_left, size: 22, color: AcademicColors.primaryDark),
                          onPressed: () {
                            if (_currentMonthIndex > 0) {
                              setState(() => _currentMonthIndex--);
                            }
                          },
                        ),
                        Expanded(
                          child: Text(
                            _months[_currentMonthIndex].toUpperCase(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.newsreader(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.primaryDark,
                              letterSpacing: 0.8,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                          icon: const Icon(Icons.chevron_right, size: 22, color: AcademicColors.primaryDark),
                          onPressed: () {
                            if (_currentMonthIndex < _months.length - 1) {
                              setState(() => _currentMonthIndex++);
                            }
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Day of Week Headers (M T W T F S S)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                          .map((d) => Expanded(
                                child: Center(
                                  child: Text(
                                    d,
                                    style: const TextStyle(
                                      fontFamily: 'Manrope',
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.bold,
                                      color: AcademicColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),

                    const SizedBox(height: 8),

                    // Calendar Days Grid (October 2026 starts on Thu: 3 blank days)
                    _buildCalendarGrid(records),

                    const SizedBox(height: 12),
                    const Divider(height: 1, color: AcademicColors.border),
                    const SizedBox(height: 10),

                    // Legend
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 6,
                      children: [
                        _buildLegendItem(AcademicColors.success, 'Present'),
                        _buildLegendItem(AcademicColors.danger, 'Absent'),
                        _buildLegendItem(AcademicColors.warning, 'Late'),
                        _buildLegendItem(AcademicColors.info, 'Leave'),
                        _buildLegendItem(AcademicColors.border, 'Holiday'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ---------------------------------------------------------------
              // 5. SELECTED DATE DETAIL
              // ---------------------------------------------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AcademicColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AcademicColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$_selectedCalendarDay October 2026',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (selectedDateRecord != null) ...[
                      Row(
                        children: [
                          if (selectedDateRecord.status == AttendanceStatus.present)
                            PillBadge.success('Present')
                          else if (selectedDateRecord.status == AttendanceStatus.late)
                            PillBadge.warning('Late')
                          else if (selectedDateRecord.status == AttendanceStatus.absent)
                            PillBadge.danger('Absent')
                          else
                            PillBadge.info('On Leave'),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              selectedDateRecord.markedAt.isNotEmpty
                                  ? '${selectedDateRecord.markedAt} · Check-in recorded'
                                  : 'Attendance recorded',
                              style: GoogleFonts.manrope(
                                fontSize: 11.5,
                                color: AcademicColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      Text(
                        'School holiday / Weekend break',
                        style: GoogleFonts.manrope(
                          fontSize: 11.5,
                          color: AcademicColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ---------------------------------------------------------------
              // 6. CHRONOLOGICAL ATTENDANCE HISTORY
              // ---------------------------------------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'ATTENDANCE HISTORY',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: AcademicColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${filteredRecords.length} records',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      color: AcademicColors.textSecondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', 'Present', 'Absent', 'Late', 'Leave'].map((filter) {
                    final isSelected = _historyFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(
                          filter,
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? Colors.white : AcademicColors.textPrimary,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: AcademicColors.primaryDark,
                        backgroundColor: AcademicColors.surface,
                        onSelected: (val) {
                          if (val) setState(() => _historyFilter = filter);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 10),

              // History Rows
              ...filteredRecords.take(8).map((r) => Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: AcademicColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AcademicColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: _getStatusColor(r.status).withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    r.date.split('-').last,
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: _getStatusColor(r.status),
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
                                      _formatHistoryDate(r.date),
                                      style: GoogleFonts.manrope(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AcademicColors.textPrimary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      r.markedAt.isNotEmpty ? r.markedAt : 'Full day',
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
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildStatusBadge(r.status),
                      ],
                    ),
                  )),

              const SizedBox(height: 18),

              // ---------------------------------------------------------------
              // 7. SUBJECT-WISE ATTENDANCE (Secondary)
              // ---------------------------------------------------------------
              Text(
                'SUBJECT ATTENDANCE',
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: AcademicColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              _buildSubjectAttendanceRow('Mathematics', 24, 25, 96.0),
              _buildSubjectAttendanceRow('English', 23, 24, 95.8),
              _buildSubjectAttendanceRow('Science', 22, 24, 91.7),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AcademicBottomNavBar.forRole(
        auth.currentRole,
        currentIndex: 2,
        context: context,
      ),
    );
  }

  Widget _buildChildPill({
    required String name,
    required String grade,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AcademicColors.primaryDark : AcademicColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AcademicColors.primaryDark : AcademicColors.border,
          ),
        ),
        child: Text(
          '$name • $grade',
          style: GoogleFonts.manrope(
            fontSize: 11.5,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : AcademicColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildMetricTile(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.newsreader(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 11,
            color: AcademicColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarGrid(List<StudentAttendanceRecord> records) {
    // Oct 2026: Day 1 is Thursday (index 3). 3 blank leading cells.
    final List<Widget> dayWidgets = [];

    // Leading blanks (Mon, Tue, Wed)
    for (int i = 0; i < 3; i++) {
      dayWidgets.add(const SizedBox(width: 36, height: 36));
    }

    for (int day = 1; day <= 31; day++) {
      final dateStr = '2026-10-${day.toString().padLeft(2, '0')}';
      final record = records.where((r) => r.date == dateStr).firstOrNull;
      final isSelected = day == _selectedCalendarDay;

      Color? dotColor;
      if (record != null) {
        dotColor = _getStatusColor(record.status);
      } else {
        // Check if weekend (Sunday: 4, 11, 18, 25)
        final dayOfWeek = (day + 2) % 7;
        if (dayOfWeek == 6 || day == 2) dotColor = Colors.transparent; // Weekend/Holiday
      }

      dayWidgets.add(
        InkWell(
          onTap: () {
            setState(() => _selectedCalendarDay = day);
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isSelected ? AcademicColors.primaryDark : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isSelected ? null : (day == 25 ? Border.all(color: AcademicColors.primaryDark, width: 1.5) : null),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day.toString(),
                  style: GoogleFonts.manrope(
                    fontSize: 11.5,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected ? Colors.white : AcademicColors.textPrimary,
                  ),
                ),
                if (dotColor != null && dotColor != Colors.transparent) ...[
                  const SizedBox(height: 2),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : dotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 1.0,
      ),
      itemCount: dayWidgets.length,
      itemBuilder: (context, index) => dayWidgets[index],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 10,
            color: AcademicColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return AcademicColors.success;
      case AttendanceStatus.absent:
        return AcademicColors.danger;
      case AttendanceStatus.late:
        return AcademicColors.warning;
      case AttendanceStatus.onLeave:
        return AcademicColors.info;
    }
  }

  Widget _buildStatusBadge(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return PillBadge.success('Present');
      case AttendanceStatus.absent:
        return PillBadge.danger('Absent');
      case AttendanceStatus.late:
        return PillBadge.warning('Late');
      case AttendanceStatus.onLeave:
        return PillBadge.info('Leave');
    }
  }

  String _formatHistoryDate(String isoDate) {
    final parts = isoDate.split('-');
    if (parts.length < 3) return isoDate;
    final day = parts[2];
    final monthNum = int.tryParse(parts[1]) ?? 1;
    const monthsShort = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '$day ${monthsShort[monthNum]}';
  }

  Widget _buildSubjectAttendanceRow(String subject, int attended, int total, double pct) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AcademicColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AcademicColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              subject,
              style: GoogleFonts.manrope(
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
                color: AcademicColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              Text(
                '$attended / $total',
                style: GoogleFonts.manrope(
                  fontSize: 11.5,
                  color: AcademicColors.textSecondary,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${pct.toStringAsFixed(1)}%',
                style: GoogleFonts.manrope(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: AcademicColors.primaryDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
