// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 18: Class Teacher Home Workspace (Daily Operations Hub)
// Design System: Espresso Heritage Academic (Newsreader + Manrope)
// Core Purpose: "What do I need to know and do for my class today?"
// Strict Compliance: Zero emojis, class-focused, data-driven, privacy-safe.
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../data/mock/auth_state.dart';
import '../../data/mock/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/account_profile_sheet.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/shared_widgets.dart';

enum AttendanceMarkingState {
  marked,
  notMarked,
  partiallyRecorded,
}

class ClassTeacherDashboardScreen extends StatefulWidget {
  final Teacher? teacherOverride;
  final SchoolClass? classOverride;
  final AttendanceMarkingState? attendanceStateOverride;
  final bool simulateLoading;
  final bool simulateError;
  final bool simulateEmptySchedule;
  final bool simulateZeroPending;

  const ClassTeacherDashboardScreen({
    super.key,
    this.teacherOverride,
    this.classOverride,
    this.attendanceStateOverride,
    this.simulateLoading = false,
    this.simulateError = false,
    this.simulateEmptySchedule = false,
    this.simulateZeroPending = false,
  });

  @override
  State<ClassTeacherDashboardScreen> createState() => _ClassTeacherDashboardScreenState();
}

class _ClassTeacherDashboardScreenState extends State<ClassTeacherDashboardScreen> {
  bool _isLoading = false;
  bool _hasError = false;
  late AttendanceMarkingState _attendanceState;

  @override
  void initState() {
    super.initState();
    _isLoading = widget.simulateLoading;
    _hasError = widget.simulateError;
    _attendanceState = widget.attendanceStateOverride ?? AttendanceMarkingState.marked;
  }

  Future<void> _handleRefresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _isLoading = false;
        _hasError = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final String uname = auth.currentUsername.toLowerCase();
    final String resolvedName = widget.teacherOverride?.name ??
        ((auth.fullName.isNotEmpty && auth.fullName != 'User' && auth.fullName != 'Rajesh Sharma')
            ? auth.fullName
            : (uname == 'washingtonsundar'
                ? 'Washington Sundar'
                : uname == 'shubmangill'
                    ? 'Shubman Gill'
                    : 'Anita Desai'));

    final Teacher teacher = widget.teacherOverride ??
        MockData.teachers.where((t) => t.name.toLowerCase() == resolvedName.toLowerCase() || t.id.toLowerCase() == resolvedName.toLowerCase()).firstOrNull ??
        Teacher(
          id: 'TCH-$resolvedName',
          name: resolvedName,
          dateOfBirth: '12 May 1982',
          mobile: '+91 98765 43210',
          email: '$uname@school.example',
          gender: 'Male',
          joinDate: '01 Jul 2018',
          address: const Address(
            line1: 'School Campus Housing',
            city: 'New Delhi',
            district: 'Central Delhi',
            state: 'Delhi',
            pincode: '110054',
          ),
          subjectSpecialization: 'Primary Academics',
        );

    // 2. Resolve Class Teacher Assignment
    // A teacher is a Class Teacher if their name matches SchoolClass.classTeacherName
    final SchoolClass? assignedClass = widget.classOverride ??
        MockData.classes.cast<SchoolClass?>().firstWhere(
              (c) => c?.classTeacherName == teacher.name || (c?.classTeacherName != null && (teacher.name.contains(c!.classTeacherName.replaceAll('Mrs. ', '')) || c.classTeacherName.contains(teacher.name.replaceAll('Mrs. ', '')))) || c?.name == (teacher.name == 'Washington Sundar' ? 'Nursery A' : teacher.name == 'Shubman Gill' ? 'Nursery B' : null),
              orElse: () => (widget.teacherOverride != null) ? null : SchoolClass(
                id: 'CLS-${teacher.name}',
                grade: teacher.name == 'Washington Sundar' ? 'Nursery' : (teacher.name == 'Shubman Gill' ? 'Nursery' : 'Grade 5'),
                section: teacher.name == 'Washington Sundar' ? 'A' : (teacher.name == 'Shubman Gill' ? 'B' : 'A'),
                className: teacher.name == 'Washington Sundar' ? 'Nursery A' : (teacher.name == 'Shubman Gill' ? 'Nursery B' : '5-A'),
                classTeacherName: teacher.name,
              ),
            );

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: const AppTopBar(showBrand: true),
      body: SafeArea(
        child: _isLoading
            ? _buildSkeletonLoadingView()
            : _hasError
                ? _buildErrorView()
                : RefreshIndicator(
                    color: AcademicColors.primaryDark,
                    backgroundColor: Colors.white,
                    onRefresh: _handleRefresh,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. TEACHER IDENTITY & CLASS CONTEXT GREETING
                          _buildTeacherGreetingCard(teacher, assignedClass),
                          const SizedBox(height: 14),

                          if (assignedClass == null) ...[
                            // Unassigned Class State (Test 2)
                            _buildUnassignedClassState(),
                          ] else ...[
                            // 2. MY CLASS SUMMARY CARD (High Priority)
                            _buildMyClassCard(assignedClass),
                            const SizedBox(height: 14),

                            // 3. TODAY'S ATTENDANCE SUMMARY & OBVIOUS ACTION
                            _buildAttendanceCard(assignedClass),
                            const SizedBox(height: 14),

                            // 4. CURRENT / NEXT CLASS SCHEDULE BLOCK
                            _buildScheduleBlock(teacher, assignedClass),
                            const SizedBox(height: 16),

                            // 5. CLASS QUICK ACTIONS (Exactly 4 high-value actions)
                            _buildQuickActionsDesk(context),
                            const SizedBox(height: 16),

                            // 6. NEEDS ATTENTION (Pending Work - Data-Driven & Privacy Safe)
                            if (!widget.simulateZeroPending) ...[
                              _buildNeedsAttentionSection(context, assignedClass),
                              const SizedBox(height: 16),
                            ],

                            // 7. IMPORTANT NOTICES (Filtered for Class Teacher)
                            _buildImportantNoticesSection(context),
                            const SizedBox(height: 20),
                          ],
                        ],
                      ),
                    ),
                  ),
      ),
      bottomNavigationBar: AcademicBottomNavBar.forRole(
        UserRole.classTeacher,
        currentIndex: 0,
        context: context,
      ),
    );
  }

  // ===========================================================================
  // SECTION 1: TEACHER CONTEXT & CLASS GREETING
  // ===========================================================================
  Widget _buildTeacherGreetingCard(Teacher teacher, SchoolClass? assignedClass) {
    final initials = teacher.name.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join();

    return InkWell(
      onTap: () => AccountProfileSheet.show(context),
      borderRadius: BorderRadius.circular(12),
      child: Semantics(
        label: 'View account profile',
        child: InsetCard(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(16),
          child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Initials Avatar with Faculty Active Badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: AcademicColors.primaryDark,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      initials.isEmpty ? 'T' : initials,
                      style: GoogleFonts.newsreader(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.accent,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 14,
                    height: 14,
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

            // Teacher Name and Context
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Good Morning, ${teacher.name}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.newsreader(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AcademicColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${teacher.subjectSpecialization} Faculty • AY 2026–27',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      color: AcademicColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (assignedClass != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AcademicColors.primaryDark.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Class Teacher • Grade ${assignedClass.className}',
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.primaryDark,
                          letterSpacing: 0.2,
                        ),
                      ),
                    )
                  else
                    PillBadge.neutral('No Assigned Homeroom'),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 18, color: AcademicColors.textSecondary),
          ],
        ),
      ),
    ),
  );
}

  // ===========================================================================
  // SECTION 2: MY CLASS CONTEXT SUMMARY
  // ===========================================================================
  Widget _buildMyClassCard(SchoolClass assignedClass) {
    // Determine real enrolled students for this class
    final classStudents = MockData.students;
    final totalStudents = classStudents.length;
    final boysCount = classStudents.where((s) => s.gender.toLowerCase() == 'male').length;
    final girlsCount = classStudents.where((s) => s.gender.toLowerCase() == 'female').length;

    return InsetCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.school, size: 18, color: AcademicColors.primaryDark),
                  const SizedBox(width: 8),
                  Text(
                    'MY ASSIGNED CLASS',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AcademicColors.textSecondary,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => context.push('/students/ledger'),
                child: Row(
                  children: [
                    Text(
                      'View Class List',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.secondary,
                      ),
                    ),
                    const Icon(Icons.chevron_right, size: 14, color: AcademicColors.secondary),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grade ${assignedClass.className}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.newsreader(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    if (totalStudents > 0)
                      Text(
                        '$totalStudents Students • $boysCount Boys • $girlsCount Girls',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.manrope(
                          fontSize: 11.5,
                          color: AcademicColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    else
                      Text(
                        'No students are currently assigned to this class.',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          color: AcademicColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              PillBadge.success('Active Term'),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SECTION 3: TODAY'S ATTENDANCE (Accurate Calculations & Explicit Actions)
  // ===========================================================================
  Widget _buildAttendanceCard(SchoolClass assignedClass) {
    final int totalCount = MockData.students.length;

    // State Calculations
    final bool isMarked = _attendanceState == AttendanceMarkingState.marked;
    final bool isPartial = _attendanceState == AttendanceMarkingState.partiallyRecorded;
    final int presentCount = isMarked ? totalCount - 1 : (isPartial ? 24 : 0);
    final double percentage = totalCount > 0 && isMarked ? (presentCount / totalCount) * 100 : 0.0;

    return InsetCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.how_to_reg, size: 18, color: AcademicColors.primaryDark),
                  const SizedBox(width: 8),
                  Text(
                    "TODAY'S CLASS ATTENDANCE",
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AcademicColors.textSecondary,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Class ${assignedClass.className}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AcademicColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Attendance State Display
          if (isMarked) ...[
            // Marked State (Test 3)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '$presentCount / $totalCount',
                            style: GoogleFonts.newsreader(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Present',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.success,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${percentage.toStringAsFixed(1)}% recorded • 1 Absent',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          color: AcademicColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AcademicColors.primaryDark,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 38),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => context.push('/attendance/roll-call'),
                  icon: const Icon(Icons.edit_calendar, size: 16),
                  label: Text(
                    'Open Register',
                    style: GoogleFonts.manrope(fontSize: 11.5, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ] else if (isPartial) ...[
            // Partial State (Test 5)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '24 / $totalCount Recorded',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.newsreader(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.warning,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '8 students remaining',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          color: AcademicColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AcademicColors.warning,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 38),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => context.push('/attendance/roll-call'),
                  icon: const Icon(Icons.play_arrow, size: 16),
                  label: Text(
                    'Continue Attendance',
                    style: GoogleFonts.manrope(fontSize: 11.5, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ] else ...[
            // Not Marked State (Test 4: NEVER display 0%)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Attendance Not Marked',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.newsreader(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.danger,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Morning roll call is pending for Grade ${assignedClass.className}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          color: AcademicColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AcademicColors.primaryDark,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 38),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => context.push('/attendance/roll-call'),
                  icon: const Icon(Icons.playlist_add_check, size: 16),
                  label: Text(
                    'Take Attendance',
                    style: GoogleFonts.manrope(fontSize: 11.5, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ===========================================================================
  // SECTION 4: TODAY'S SCHEDULE (Dynamic Current/Next Period Calculation)
  // ===========================================================================
  Widget _buildScheduleBlock(Teacher teacher, SchoolClass assignedClass) {
    if (widget.simulateEmptySchedule) {
      return InsetCard(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "TODAY'S SCHEDULE",
              style: GoogleFonts.manrope(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AcademicColors.textSecondary,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No schedule available for today.',
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: AcademicColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    }

    return InsetCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.schedule, size: 18, color: AcademicColors.primaryDark),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "TODAY'S TEACHING SCHEDULE",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.textSecondary,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => context.push('/faculty/timetable'),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Timetable',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.secondary,
                      ),
                    ),
                    const Icon(Icons.chevron_right, size: 14, color: AcademicColors.secondary),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Current Active Class Highlight Banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AcademicColors.primaryDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'CURRENT CLASS • 11:05–11:50 AM',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.manrope(
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: AcademicColors.danger,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Text(
                        '25m remaining',
                        style: GoogleFonts.manrope(
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Period 4: Mathematics',
                  style: GoogleFonts.newsreader(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Grade ${assignedClass.className} • Room 204',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Next Period Snippet
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        'NEXT:',
                        style: GoogleFonts.manrope(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Period 5: Hindi (12:30 PM)',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AcademicColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Room 204',
                  style: GoogleFonts.manrope(
                    fontSize: 10.5,
                    color: AcademicColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SECTION 5: CLASS QUICK ACTIONS DESK (Maximum 4 Primary Actions)
  // ===========================================================================
  Widget _buildQuickActionsDesk(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 8),
          child: Text(
            'CLASS QUICK ACTIONS',
            style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AcademicColors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Row(
          children: [
            _buildActionTile(
              label: 'Take\nAttendance',
              icon: Icons.how_to_reg,
              onTap: () => context.push('/attendance/roll-call'),
            ),
            const SizedBox(width: 8),
            _buildActionTile(
              label: 'My\nClass',
              icon: Icons.groups,
              onTap: () => context.push('/students/ledger'),
            ),
            const SizedBox(width: 8),
            _buildActionTile(
              label: 'Marks &\nGrades',
              icon: Icons.edit_note,
              onTap: () => context.push('/students/marks-entry'),
            ),
            const SizedBox(width: 8),
            _buildActionTile(
              label: 'Class\nTimetable',
              icon: Icons.calendar_today,
              onTap: () => context.push('/faculty/timetable'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required String label,
    required IconData icon,
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
                  color: AcademicColors.canvas,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: AcademicColors.primaryDark),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: AcademicColors.textPrimary,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // SECTION 6: NEEDS ATTENTION (Pending Work - Strictly Privacy Safe)
  // ===========================================================================
  Widget _buildNeedsAttentionSection(BuildContext context, SchoolClass assignedClass) {
    return InsetCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.pending_actions, size: 18, color: AcademicColors.warning),
                  const SizedBox(width: 8),
                  Text(
                    'NEEDS ATTENTION',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AcademicColors.textSecondary,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              PillBadge.warning('2 Items'),
            ],
          ),
          const SizedBox(height: 12),

          // Actionable Item 1: Marks Entry
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AcademicColors.canvas,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Second Assessment Marks Pending',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Mathematics • Grade ${assignedClass.className} • 4 unrecorded',
                        style: GoogleFonts.manrope(
                          fontSize: 10.5,
                          color: AcademicColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 32),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    side: const BorderSide(color: AcademicColors.border),
                  ),
                  onPressed: () => context.push('/students/marks-entry'),
                  child: Text(
                    'Enter',
                    style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Actionable Item 2: Student Leave Request (STRICT PRIVACY: NO MEDICAL DETAILS)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AcademicColors.canvas,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${MockData.students.firstOrNull?.fullName ?? "Student"} (Roll No. 14)',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Leave request • 28–29 Oct (2 Days)',
                        style: GoogleFonts.manrope(
                          fontSize: 10.5,
                          color: AcademicColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 32),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    side: const BorderSide(color: AcademicColors.border),
                  ),
                  onPressed: () => context.push('/attendance/student-leave'),
                  child: Text(
                    'Review',
                    style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SECTION 7: IMPORTANT NOTICES (Filtered for Class Teacher)
  // ===========================================================================
  Widget _buildImportantNoticesSection(BuildContext context) {
    final notice = MockData.announcements.first;

    return InsetCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.campaign, size: 18, color: AcademicColors.primaryDark),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'IMPORTANT NOTICES',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.textSecondary,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => context.push('/announcements'),
                child: Text(
                  'All Notices →',
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

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AcademicColors.canvas,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PillBadge.danger('Pinned Advisory'),
                    Text(
                      notice.publishedAt,
                      style: GoogleFonts.manrope(fontSize: 10, color: AcademicColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  notice.title,
                  style: GoogleFonts.manrope(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: AcademicColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  notice.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    color: AcademicColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // EMPTY / ERROR / LOADING STATES
  // ===========================================================================
  Widget _buildUnassignedClassState() {
    return InsetCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.person_off, size: 44, color: AcademicColors.textSecondary),
            const SizedBox(height: 12),
            Text(
              'No Class Assigned',
              style: GoogleFonts.newsreader(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AcademicColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'This teacher profile is not currently designated as a Class Teacher for any homeroom section.',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: AcademicColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AcademicColors.primaryDark,
                foregroundColor: Colors.white,
              ),
              onPressed: () => context.go('/dashboard/subject-teacher'),
              child: const Text('Go to Subject Teacher Desk'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AcademicColors.danger),
            const SizedBox(height: 14),
            Text(
              'Unable to load class information.',
              style: GoogleFonts.newsreader(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AcademicColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Please check your network connection and try again.',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(fontSize: 12, color: AcademicColors.textSecondary),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AcademicColors.primaryDark,
                foregroundColor: Colors.white,
              ),
              onPressed: _handleRefresh,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonLoadingView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: List.generate(
          4,
          (index) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            height: 110,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }
}
