// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Class Teacher: Attendance 5-A Register (Operational Hub)
// Design System: Espresso Heritage Academic (Newsreader + Manrope)
// Core Purpose: Fast, accurate, data-driven daily attendance recording.
// Strict Compliance: Zero emojis, 4-state toggles, safe mark all in header,
// tappable roll-no student profile popup, preview before submission,
// single father name format, zero overflow at 320px+.
// ==============================================================================

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/mock/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/bottom_nav_bar.dart';

class DailyRollCallScreen extends StatefulWidget {
  final Teacher? teacherOverride;
  final SchoolClass? classOverride;
  final DateTime? dateOverride;
  final List<Student>? studentOverrides;
  final Map<String, AttendanceStatus?>? initialAttendanceMap;
  final bool isHolidayOverride;
  final String? holidayNameOverride;
  final bool isFutureDateOverride;
  final bool isLockedOverride;
  final bool simulateLoading;
  final bool simulateError;
  final bool simulateEmptyClass;

  const DailyRollCallScreen({
    super.key,
    this.teacherOverride,
    this.classOverride,
    this.dateOverride,
    this.studentOverrides,
    this.initialAttendanceMap,
    this.isHolidayOverride = false,
    this.holidayNameOverride,
    this.isFutureDateOverride = false,
    this.isLockedOverride = false,
    this.simulateLoading = false,
    this.simulateError = false,
    this.simulateEmptyClass = false,
  });

  @override
  State<DailyRollCallScreen> createState() => _DailyRollCallScreenState();
}

class _DailyRollCallScreenState extends State<DailyRollCallScreen> {
  late DateTime _selectedDate;
  late final Map<String, AttendanceStatus?> _attendanceMap;
  late List<Student> _roster;
  String _activeFilter = 'ALL';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  bool _isSubmitted = false;
  bool _hasUnsavedChanges = false;
  bool _isSubmitting = false;
  bool _justMarkedAllPresent = false;
  Timer? _allPresentFeedbackTimer;

  // Deterministic parent name mappings for 5-A roster
  static const Map<String, String> _fatherNames = {
    'Aarav Agarwal': 'Rajesh Agarwal',
    'Ananya Dixit': 'Sanjay Dixit',
    'Aarav Sharma': 'Vivek Sharma',
    'Aditya Roy': 'Subhash Roy',
    'Anika Bose': 'Soumitra Bose',
    'Aryan Chopra': 'Rakesh Chopra',
    'Bhavya Patel': 'Manoj Patel',
    'Chirag Joshi': 'Prakash Joshi',
    'Devansh Nanda': 'Alok Nanda',
    'Divya Kapoor': 'Vikram Kapoor',
    'Diya Sharma': 'Rajesh Sharma',
    'Eshaan Varma': 'Arun Varma',
    'Gauri Nair': 'Suresh Nair',
    'Harsh Vardhan': 'Anand Vardhan',
    'Kabir Mehta': 'Sameer Mehta',
    'Zoya Akhtar': 'Javed Akhtar',
    'Karan Johar': 'Yash Johar',
    'Kavya Menon': 'Radhakrishnan Menon',
    'Lakshya Sen': 'D.K. Sen',
    'Manan Gupta': 'Sunil Gupta',
    'Rohan Verma': 'Ashok Verma',
    'Meera Iyer': 'Ramaswamy Iyer',
    'Nikhil Sethi': 'Deepak Sethi',
    'Prisha Das': 'Anirban Das',
    'Rahul Khanna': 'Vinod Khanna',
    'Rhea Pillai': 'Raymond Pillai',
    'Rishi Kapoor': 'Raj Kapoor',
    'Saanvi Reddy': 'Venkat Reddy',
    'Samar Pratap': 'Mahendra Pratap',
    'Tanvi Malik': 'Satish Malik',
    'Utkarsh Sinha': 'Akhilesh Sinha',
    'Vedika Rao': 'Krishna Rao',
  };

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.dateOverride ?? DateTime.now();
    _isSubmitted = widget.isLockedOverride;

    // Resolve Class Roster
    if (widget.simulateEmptyClass) {
      _roster = [];
    } else if (widget.studentOverrides != null) {
      _roster = List.from(widget.studentOverrides!);
    } else {
      _roster = _generateFullClassRoster();
    }

    // Initialize Attendance Map
    _attendanceMap = {};
    if (widget.initialAttendanceMap != null) {
      _attendanceMap.addAll(widget.initialAttendanceMap!);
    } else {
      // Default initial state: realistic draft (29 Present, 2 Absent, 1 Late for 32 students)
      for (int i = 0; i < _roster.length; i++) {
        final student = _roster[i];
        if (i == 1) {
          _attendanceMap[student.id] = AttendanceStatus.absent;
        } else if (i == 14) {
          _attendanceMap[student.id] = AttendanceStatus.late;
        } else if (i == 24 && _roster.length > 25) {
          _attendanceMap[student.id] = AttendanceStatus.absent;
        } else {
          _attendanceMap[student.id] = AttendanceStatus.present;
        }
      }
    }
  }

  @override
  void dispose() {
    _allPresentFeedbackTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  // Helper to get relationship and parent name (appears only once)
  (String relation, String parentName) _getParentInfo(Student student) {
    final fullName = student.fullName;
    final parent = _fatherNames[fullName] ?? 'Rajesh ${student.lastName}';
    final relation = student.gender.toLowerCase() == 'female' ? 'D/o' : 'S/o';
    return (relation, parent);
  }

  // Generates complete, realistic 32-student Grade 5-A roster
  List<Student> _generateFullClassRoster() {
    final names = [
      ('Aarav', 'Agarwal'), ('Ananya', 'Dixit'), ('Aarav', 'Sharma'), ('Aditya', 'Roy'),
      ('Anika', 'Bose'), ('Aryan', 'Chopra'), ('Bhavya', 'Patel'), ('Chirag', 'Joshi'),
      ('Devansh', 'Nanda'), ('Divya', 'Kapoor'), ('Diya', 'Sharma'), ('Eshaan', 'Varma'),
      ('Gauri', 'Nair'), ('Harsh', 'Vardhan'), ('Kabir', 'Mehta'), ('Zoya', 'Akhtar'),
      ('Karan', 'Johar'), ('Kavya', 'Menon'), ('Lakshya', 'Sen'), ('Manan', 'Gupta'),
      ('Rohan', 'Verma'), ('Meera', 'Iyer'), ('Nikhil', 'Sethi'), ('Prisha', 'Das'),
      ('Rahul', 'Khanna'), ('Rhea', 'Pillai'), ('Rishi', 'Kapoor'), ('Saanvi', 'Reddy'),
      ('Samar', 'Pratap'), ('Tanvi', 'Malik'), ('Utkarsh', 'Sinha'), ('Vedika', 'Rao'),
    ];

    return List.generate(names.length, (i) {
      final roll = i + 1;
      final adm = '0${890 + i}';
      final isFemale = i % 2 == 1;
      return Student(
        id: 'ADM-2024-$adm',
        firstName: names[i].$1,
        lastName: names[i].$2,
        dateOfBirth: '14 Aug 2015',
        mobile: '+91 98000 000${i.toString().padLeft(2, '0')}',
        email: '${names[i].$1.toLowerCase()}.${names[i].$2.toLowerCase()}@example.com',
        gender: isFemale ? 'Female' : 'Male',
        admissionDate: '01 Apr 2024',
        rollNumber: roll,
        grade: '5',
        section: 'A',
        dwellingType: 'House/Apartment',
        address: const Address(
          line1: 'Campus Sector',
          city: 'New Delhi',
          district: 'Central Delhi',
          state: 'Delhi',
          pincode: '110054',
        ),
      );
    });
  }

  // Set individual student status
  void _setStudentStatus(String studentId, AttendanceStatus newStatus) {
    if (_isSubmitted || widget.isLockedOverride) return;
    setState(() {
      _attendanceMap[studentId] = newStatus;
      _hasUnsavedChanges = true;
      _justMarkedAllPresent = false;
    });
  }

  // Safe Mark All Present action from Header
  void _handleMarkAllPresent() {
    if (_isSubmitted || widget.isLockedOverride) return;

    final hasExceptions = _attendanceMap.values.any((st) =>
        st == AttendanceStatus.absent ||
        st == AttendanceStatus.late ||
        st == AttendanceStatus.onLeave);

    if (hasExceptions) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Mark All Students Present?',
            style: GoogleFonts.newsreader(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AcademicColors.textPrimary,
            ),
          ),
          content: Text(
            'The register currently has recorded exceptions (Absences or Late arrivals). This will change current selections and mark every student Present.',
            style: GoogleFonts.manrope(fontSize: 12, color: AcademicColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Cancel', style: GoogleFonts.manrope(fontWeight: FontWeight.bold, color: AcademicColors.textSecondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AcademicColors.primaryDark,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
                _applyMarkAllPresent();
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      );
    } else {
      _applyMarkAllPresent();
    }
  }

  void _applyMarkAllPresent() {
    setState(() {
      for (final s in _roster) {
        _attendanceMap[s.id] = AttendanceStatus.present;
      }
      _hasUnsavedChanges = true;
      _justMarkedAllPresent = true;
    });

    _allPresentFeedbackTimer?.cancel();
    _allPresentFeedbackTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _justMarkedAllPresent = false;
        });
      }
    });
  }

  // Format date readable e.g., "Saturday, 19 Sep 2026"
  String _formatDate(DateTime dt) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return '${weekdays[dt.weekday - 1]}, ${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  // Handle back navigation with unsaved draft check
  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges || _isSubmitted) return true;

    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Unsaved Attendance',
          style: GoogleFonts.newsreader(fontSize: 18, fontWeight: FontWeight.bold, color: AcademicColors.textPrimary),
        ),
        content: Text(
          'Your attendance changes have not been submitted. Do you want to discard your draft or stay?',
          style: GoogleFonts.manrope(fontSize: 12, color: AcademicColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Stay', style: GoogleFonts.manrope(fontWeight: FontWeight.bold, color: AcademicColors.primaryDark)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AcademicColors.danger,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    return shouldPop ?? false;
  }

  // ===========================================================================
  // STUDENT PROFILE POPUP (Roll Number Tapped)
  // ===========================================================================
  void _showStudentProfile(Student student) {
    final rollStr = student.rollNumber.toString().padLeft(2, '0');
    final (relation, parentName) = _getParentInfo(student);
    final relationLabel = relation == 'D/o' ? "Father's Name" : "Father's Name";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AcademicColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header Row: Avatar + Name + Subtitle + Close Button
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                        rollStr,
                        style: GoogleFonts.newsreader(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
                          student.fullName,
                          style: GoogleFonts.newsreader(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AcademicColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Roll No. $rollStr • Grade ${student.classGrade}-${student.classSection}',
                          style: GoogleFonts.manrope(
                            fontSize: 11.5,
                            color: AcademicColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20, color: AcademicColors.textSecondary),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Divider(height: 1, color: AcademicColors.border),
              const SizedBox(height: 14),

              // Profile Details Grid/List
              Container(
                decoration: BoxDecoration(
                  color: AcademicColors.canvas,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AcademicColors.border),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Column(
                  children: [
                    _buildProfileFieldRow('Student Name', student.fullName),
                    _buildProfileFieldRow('Roll No.', rollStr),
                    _buildProfileFieldRow(relationLabel, parentName),
                    if (student.id.isNotEmpty)
                      _buildProfileFieldRow('Admission No.', student.admissionNumber),
                    if (student.dateOfBirth.isNotEmpty)
                      _buildProfileFieldRow('Date of Birth', student.dateOfBirth),
                    if (student.gender.isNotEmpty)
                      _buildProfileFieldRow('Gender', student.gender),
                    _buildProfileFieldRow('Class', 'Grade ${student.classGrade}'),
                    _buildProfileFieldRow('Section', 'Section ${student.classSection}', isLast: true),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Close Button
              SizedBox(
                width: double.infinity,
                height: 42,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AcademicColors.textPrimary,
                    side: const BorderSide(color: AcademicColors.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(
                    'Close',
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileFieldRow(String label, String value, {bool isLast = false}) {
    if (value.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 11.5,
                color: AcademicColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: AcademicColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // ATTENDANCE PREVIEW MODAL (Prior to Final Submission)
  // ===========================================================================
  void _showAttendancePreview(
    SchoolClass assignedClass,
    int totalCount,
    int presentCount,
    int absentCount,
    int lateCount,
    int leaveCount,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Drag Handle
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AcademicColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Attendance ${assignedClass.className}',
                                style: GoogleFonts.newsreader(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AcademicColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _formatDate(_selectedDate),
                                style: GoogleFonts.manrope(
                                  fontSize: 11.5,
                                  color: AcademicColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 20, color: AcademicColors.textSecondary),
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1, color: AcademicColors.border),

                  // Summary Badges Strip
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: AcademicColors.canvas,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AcademicColors.border),
                    ),
                    child: Row(
                      children: [
                        _buildPreviewStatCell('Total', '$totalCount', AcademicColors.textPrimary),
                        const SizedBox(width: 4),
                        _buildPreviewStatCell('Present', '$presentCount', AcademicColors.success),
                        const SizedBox(width: 4),
                        _buildPreviewStatCell('Absent', '$absentCount', AcademicColors.danger),
                        const SizedBox(width: 4),
                        _buildPreviewStatCell('Late', '$lateCount', AcademicColors.warning),
                        if (leaveCount > 0) ...[
                          const SizedBox(width: 4),
                          _buildPreviewStatCell('Leave', '$leaveCount', AcademicColors.info),
                        ],
                      ],
                    ),
                  ),

                  // Student Roster Review List
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      itemCount: _roster.length,
                      separatorBuilder: (_, __) => const Divider(height: 1, color: AcademicColors.border),
                      itemBuilder: (context, i) {
                        final student = _roster[i];
                        final status = _attendanceMap[student.id];
                        final rollStr = student.rollNumber.toString().padLeft(2, '0');

                        String statusLabel = 'Unmarked';
                        Color statusFg = AcademicColors.textSecondary;
                        Color statusBg = AcademicColors.canvas;

                        if (status == AttendanceStatus.present) {
                          statusLabel = 'Present';
                          statusFg = AcademicColors.success;
                          statusBg = AcademicColors.successContainer;
                        } else if (status == AttendanceStatus.absent) {
                          statusLabel = 'Absent';
                          statusFg = AcademicColors.danger;
                          statusBg = AcademicColors.dangerContainer;
                        } else if (status == AttendanceStatus.late) {
                          statusLabel = 'Late';
                          statusFg = AcademicColors.warning;
                          statusBg = AcademicColors.warningContainer;
                        } else if (status == AttendanceStatus.onLeave) {
                          statusLabel = 'Leave';
                          statusFg = AcademicColors.info;
                          statusBg = AcademicColors.infoContainer;
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          child: Row(
                            children: [
                              Text(
                                '$rollStr ·',
                                style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AcademicColors.textSecondary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  student.fullName,
                                  style: GoogleFonts.manrope(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: AcademicColors.textPrimary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: statusBg,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  statusLabel,
                                  style: GoogleFonts.manrope(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                    color: statusFg,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Sticky Preview Bottom Actions
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(top: BorderSide(color: AcademicColors.border, width: 0.8)),
                    ),
                    child: SafeArea(
                      top: false,
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 42,
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AcademicColors.textPrimary,
                                  side: const BorderSide(color: AcademicColors.border),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                ),
                                onPressed: () => Navigator.of(ctx).pop(),
                                icon: const Icon(Icons.arrow_back, size: 15),
                                label: Text(
                                  'Back to Attendance',
                                  style: GoogleFonts.manrope(fontSize: 11.5, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: SizedBox(
                              height: 42,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AcademicColors.primaryDark,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                ),
                                onPressed: () async {
                                  Navigator.of(ctx).pop();
                                  setState(() => _isSubmitting = true);
                                  await Future.delayed(const Duration(milliseconds: 300));
                                  if (mounted) {
                                    setState(() {
                                      _isSubmitting = false;
                                      _isSubmitted = true;
                                      _hasUnsavedChanges = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Attendance register successfully recorded.'),
                                        backgroundColor: AcademicColors.success,
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.check, size: 15),
                                label: Text(
                                  'Confirm & Submit',
                                  style: GoogleFonts.manrope(fontSize: 11.5, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPreviewStatCell(String label, String count, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.manrope(fontSize: 9, fontWeight: FontWeight.bold, color: AcademicColors.textSecondary),
          ),
          const SizedBox(height: 2),
          Text(
            count,
            style: GoogleFonts.newsreader(fontSize: 15, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Teacher teacher = widget.teacherOverride ?? MockData.teachers.first;
    final SchoolClass? assignedClass = widget.classOverride ??
        MockData.classes.cast<SchoolClass?>().firstWhere(
              (c) => c?.classTeacherName == teacher.name,
              orElse: () => null,
            );

    // Check Holiday or Future date
    final bool isHoliday = widget.isHolidayOverride;
    final bool isFuture = widget.isFutureDateOverride || _selectedDate.isAfter(DateTime.now().add(const Duration(days: 1)));

    // Counters
    final totalCount = _roster.length;
    final presentCount = _roster.where((s) => _attendanceMap[s.id] == AttendanceStatus.present).length;
    final absentCount = _roster.where((s) => _attendanceMap[s.id] == AttendanceStatus.absent).length;
    final lateCount = _roster.where((s) => _attendanceMap[s.id] == AttendanceStatus.late).length;
    final leaveCount = _roster.where((s) => _attendanceMap[s.id] == AttendanceStatus.onLeave).length;
    final unmarkedCount = _roster.where((s) => _attendanceMap[s.id] == null).length;
    final double presentPct = totalCount > 0 ? (presentCount / totalCount) * 100 : 0.0;
    final bool allPresent = totalCount > 0 && presentCount == totalCount;

    // Filtered Roster
    final filteredRoster = _roster.where((s) {
      final status = _attendanceMap[s.id];

      // Filter by chip
      if (_activeFilter == 'P' && status != AttendanceStatus.present) return false;
      if (_activeFilter == 'A' && status != AttendanceStatus.absent) return false;
      if (_activeFilter == 'L' && status != AttendanceStatus.late) return false;
      if (_activeFilter == 'E' && status != AttendanceStatus.onLeave) return false;
      if (_activeFilter == 'UNMARKED' && status != null) return false;

      // Filter by search query
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase().trim();
        final fullName = '${s.firstName} ${s.lastName}'.toLowerCase();
        final rollStr = s.rollNumber.toString();
        final paddedRoll = rollStr.padLeft(2, '0');
        final hashRoll = '#$paddedRoll';
        final idStr = s.id.toLowerCase();
        final (rel, pName) = _getParentInfo(s);
        final parentLower = pName.toLowerCase();
        return fullName.contains(q) ||
            rollStr == q ||
            paddedRoll.contains(q) ||
            hashRoll.contains(q) ||
            idStr.contains(q) ||
            parentLower.contains(q);
      }

      return true;
    }).toList();

    return PopScope(
      canPop: !_hasUnsavedChanges || _isSubmitted,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: AcademicColors.canvas,
        appBar: const AppTopBar(showBrand: true),
        body: SafeArea(
          child: Column(
            children: [
              // 1. PAGE HEADER WITH CLASS & DATE + MARK ALL PRESENT ACTION
              _buildPageHeader(assignedClass, allPresent),

              Expanded(
                child: assignedClass == null
                    ? _buildUnassignedClassState()
                    : isHoliday
                        ? _buildHolidayView()
                        : isFuture
                            ? _buildFutureDateView()
                            : widget.simulateError
                                ? _buildErrorView()
                                : widget.simulateLoading
                                    ? _buildSkeletonLoading()
                                    : _buildRosterBody(
                                        assignedClass,
                                        totalCount,
                                        presentCount,
                                        absentCount,
                                        lateCount,
                                        leaveCount,
                                        unmarkedCount,
                                        presentPct,
                                        filteredRoster,
                                      ),
              ),

              // STICKY BOTTOM SUBMISSION BAR (When roster is active)
              if (assignedClass != null && !isHoliday && !isFuture && !widget.simulateError && !widget.simulateLoading)
                _buildStickySubmissionBar(
                  assignedClass,
                  totalCount,
                  presentCount,
                  absentCount,
                  lateCount,
                  leaveCount,
                  unmarkedCount,
                ),
            ],
          ),
        ),
        bottomNavigationBar: AcademicBottomNavBar.forRole(
          UserRole.classTeacher,
          currentIndex: 1, // Attendance Dock tab
          context: context,
        ),
      ),
    );
  }

  // ===========================================================================
  // 1. PAGE HEADER (Attendance 5-A, Saturday, 19 Sep 2026, Mark All Present)
  // ===========================================================================
  Widget _buildPageHeader(SchoolClass? assignedClass, bool allPresent) {
    final className = assignedClass != null ? assignedClass.className : '5-A';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AcademicColors.border, width: 0.8)),
      ),
      child: Row(
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.arrow_back, size: 22, color: AcademicColors.textPrimary),
            onPressed: () async {
              final canLeave = await _onWillPop();
              if (canLeave && mounted) context.pop();
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Attendance $className',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.newsreader(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AcademicColors.textPrimary,
                  ),
                ),
                Text(
                  _formatDate(_selectedDate),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    fontSize: 10.5,
                    color: AcademicColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),

          // Primary Header Action: [ ✓ Mark All Present ]
          if (assignedClass != null &&
              !widget.isHolidayOverride &&
              !widget.isFutureDateOverride &&
              !widget.simulateError &&
              !widget.simulateLoading)
            _buildMarkAllPresentHeaderButton(allPresent),
        ],
      ),
    );
  }

  Widget _buildMarkAllPresentHeaderButton(bool allPresent) {
    final bool isCompletedState = _justMarkedAllPresent || (allPresent && !_hasUnsavedChanges && !_isSubmitted);
    final bool isDisabled = _isSubmitted || widget.isLockedOverride;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: isDisabled ? null : _handleMarkAllPresent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4.5),
          decoration: BoxDecoration(
            color: isCompletedState
                ? const Color(0xFFE8F5E9)
                : (_justMarkedAllPresent ? const Color(0xFFE8F5E9) : AcademicColors.canvas),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isCompletedState
                  ? AcademicColors.success
                  : AcademicColors.border,
              width: 1.1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check,
                size: 12,
                color: isCompletedState
                    ? AcademicColors.success
                    : AcademicColors.primaryDark,
              ),
              const SizedBox(width: 3),
              Text(
                isCompletedState ? 'All Present' : 'Mark All Present',
                style: GoogleFonts.manrope(
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  color: isCompletedState
                      ? AcademicColors.success
                      : AcademicColors.primaryDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // 2. MAIN ROSTER OPERATIONAL BODY
  // ===========================================================================
  Widget _buildRosterBody(
    SchoolClass assignedClass,
    int totalCount,
    int presentCount,
    int absentCount,
    int lateCount,
    int leaveCount,
    int unmarkedCount,
    double presentPct,
    List<Student> filteredRoster,
  ) {
    return Column(
      children: [
        // SEARCH BAR & FILTER CHIPS
        _buildSearchAndFilters(totalCount, presentCount, absentCount, lateCount, leaveCount, unmarkedCount),

        // ROSTER LIST OR SEARCH EMPTY STATE
        Expanded(
          child: filteredRoster.isEmpty
              ? _buildSearchEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(14, 6, 14, 20),
                  itemCount: filteredRoster.length,
                  itemBuilder: (context, idx) {
                    final student = filteredRoster[idx];
                    final currentStatus = _attendanceMap[student.id];

                    return _buildStudentRow(student, currentStatus);
                  },
                ),
        ),
      ],
    );
  }

  // ===========================================================================
  // 3. SEARCH INPUT & FILTER PILLS
  // ===========================================================================
  Widget _buildSearchAndFilters(int total, int pCount, int aCount, int lCount, int eCount, int unmarkedCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 4),
      child: Column(
        children: [
          // Search input
          SizedBox(
            height: 38,
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              style: GoogleFonts.manrope(fontSize: 12, color: AcademicColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search student by name, roll no or parent...',
                hintStyle: GoogleFonts.manrope(fontSize: 11, color: AcademicColors.textSecondary),
                prefixIcon: const Icon(Icons.search, size: 16, color: AcademicColors.textSecondary),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 14, color: AcademicColors.textSecondary),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AcademicColors.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AcademicColors.border)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AcademicColors.secondary, width: 1.5)),
              ),
            ),
          ),
          const SizedBox(height: 6),

          // Filter Pills Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterPill('ALL', 'All ($total)'),
                const SizedBox(width: 5),
                _buildFilterPill('P', 'Present ($pCount)'),
                const SizedBox(width: 5),
                _buildFilterPill('A', 'Absent ($aCount)'),
                const SizedBox(width: 5),
                _buildFilterPill('L', 'Late ($lCount)'),
                const SizedBox(width: 5),
                _buildFilterPill('E', 'Leave ($eCount)'),
                if (unmarkedCount > 0) ...[
                  const SizedBox(width: 5),
                  _buildFilterPill('UNMARKED', 'Unmarked ($unmarkedCount)'),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPill(String key, String label) {
    final isSelected = _activeFilter == key;

    return GestureDetector(
      onTap: () => setState(() => _activeFilter = key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AcademicColors.primaryDark : Colors.white,
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(
            color: isSelected ? AcademicColors.primaryDark : AcademicColors.border,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 10.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : AcademicColors.textSecondary,
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // 4. STUDENT ROSTER CARD (Interactive Roll Avatar, Name, Single Parent, 2x2 Controls)
  // ===========================================================================
  Widget _buildStudentRow(Student student, AttendanceStatus? currentStatus) {
    final rollStr = student.rollNumber.toString().padLeft(2, '0');
    final (relation, parentName) = _getParentInfo(student);

    Color cardBg = Colors.white;
    Color borderColor = AcademicColors.border;
    if (currentStatus == AttendanceStatus.absent) {
      cardBg = const Color(0xFFFFF8F8);
      borderColor = AcademicColors.danger.withValues(alpha: 0.35);
    } else if (currentStatus == AttendanceStatus.late) {
      cardBg = const Color(0xFFFFFDF5);
      borderColor = AcademicColors.warning.withValues(alpha: 0.35);
    } else if (currentStatus == AttendanceStatus.onLeave) {
      cardBg = const Color(0xFFF7FAFF);
      borderColor = AcademicColors.info.withValues(alpha: 0.35);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: currentStatus == AttendanceStatus.absent ? 1.2 : 1.0),
        boxShadow: AcademicColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: [01] Roll Avatar + Student Identity
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Interactive Roll Number Avatar Circle
              Tooltip(
                message: 'View Student Profile',
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    key: ValueKey('roll_badge_${student.id}'),
                    onTap: () => _showStudentProfile(student),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: currentStatus == AttendanceStatus.absent
                            ? AcademicColors.dangerContainer
                            : AcademicColors.canvas,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: currentStatus == AttendanceStatus.absent
                              ? AcademicColors.danger.withValues(alpha: 0.4)
                              : AcademicColors.border,
                          width: 1.2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          rollStr,
                          style: GoogleFonts.newsreader(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: currentStatus == AttendanceStatus.absent
                                ? AcademicColors.danger
                                : AcademicColors.primaryDark,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Student Info Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Student Full Name
                    Text(
                      student.fullName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.textPrimary,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Roll No + Single Parent Name Format (No Duplication)
                    Text(
                      'Roll No. $rollStr · $relation $parentName',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        color: AcademicColors.textSecondary,
                        fontWeight: FontWeight.w500,
                        height: 1.15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          const Divider(height: 1, color: AcademicColors.border),
          const SizedBox(height: 10),

          // Attendance Controls: 2x2 Grid with >= 44px touch targets
          Row(
            children: [
              Expanded(
                child: _buildAttendanceGridButton(
                  studentId: student.id,
                  status: AttendanceStatus.present,
                  label: 'Present',
                  icon: Icons.check_circle_outline,
                  color: AcademicColors.success,
                  code: 'P',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildAttendanceGridButton(
                  studentId: student.id,
                  status: AttendanceStatus.absent,
                  label: 'Absent',
                  icon: Icons.cancel_outlined,
                  color: AcademicColors.danger,
                  code: 'A',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildAttendanceGridButton(
                  studentId: student.id,
                  status: AttendanceStatus.late,
                  label: 'Late',
                  icon: Icons.schedule,
                  color: AcademicColors.warning,
                  code: 'L',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildAttendanceGridButton(
                  studentId: student.id,
                  status: AttendanceStatus.onLeave,
                  label: 'Leave',
                  icon: Icons.event_busy_outlined,
                  color: AcademicColors.info,
                  code: 'E',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceGridButton({
    required String studentId,
    required AttendanceStatus status,
    required String label,
    required IconData icon,
    required Color color,
    required String code,
  }) {
    final isSelected = _attendanceMap[studentId] == status;
    final isDisabled = _isSubmitted || widget.isLockedOverride;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: ValueKey('btn_${studentId}_$code'),
        borderRadius: BorderRadius.circular(8),
        onTap: isDisabled ? null : () => _setStudentStatus(studentId, status),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 44, // Minimum 44px practical touch target
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? color : AcademicColors.canvas,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? color : AcademicColors.border,
              width: isSelected ? 1.4 : 1.0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 1.5),
                    )
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 15,
                color: isSelected ? Colors.white : AcademicColors.textSecondary,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? Colors.white : AcademicColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // 5. STICKY BOTTOM SUBMISSION BAR
  // ===========================================================================
  Widget _buildStickySubmissionBar(
    SchoolClass assignedClass,
    int totalCount,
    int presentCount,
    int absentCount,
    int lateCount,
    int leaveCount,
    int unmarkedCount,
  ) {
    final bool isComplete = unmarkedCount == 0;
    final bool canSubmit = isComplete && !_isSubmitted && !widget.isLockedOverride;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AcademicColors.border, width: 0.8)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      isComplete ? Icons.verified : Icons.info_outline,
                      size: 15,
                      color: isComplete ? AcademicColors.success : AcademicColors.danger,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        isComplete
                            ? '$presentCount Present • $absentCount Absent • $lateCount Late'
                            : '$unmarkedCount students not marked',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Text(
                isComplete ? 'All $totalCount Counted' : '$unmarkedCount Remaining',
                style: GoogleFonts.manrope(fontSize: 10, color: AcademicColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 6),

          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: canSubmit
                    ? AcademicColors.primaryDark
                    : (_isSubmitted ? AcademicColors.success : AcademicColors.border),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: canSubmit
                  ? () => _showAttendancePreview(
                        assignedClass,
                        totalCount,
                        presentCount,
                        absentCount,
                        lateCount,
                        leaveCount,
                      )
                  : null,
              icon: _isSubmitting
                  ? const SizedBox(width: 15, height: 15, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Icon(_isSubmitted ? Icons.check_circle : Icons.task_alt, size: 16),
              label: Text(
                _isSubmitted
                    ? 'Attendance Officially Recorded'
                    : isComplete
                        ? 'Submit Attendance'
                        : 'Complete All Attendance First',
                style: GoogleFonts.manrope(fontSize: 12.5, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 7. EDGE CASE & EMPTY VIEWS
  // ===========================================================================
  Widget _buildSearchEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_search, size: 40, color: AcademicColors.textSecondary),
            const SizedBox(height: 10),
            Text(
              'No students found.',
              style: GoogleFonts.newsreader(fontSize: 16, fontWeight: FontWeight.bold, color: AcademicColors.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              'No students in Grade match your search or filter.',
              style: GoogleFonts.manrope(fontSize: 11.5, color: AcademicColors.textSecondary),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                  _activeFilter = 'ALL';
                });
              },
              child: const Text('Clear search'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHolidayView() {
    final holidayName = widget.holidayNameOverride ?? 'School Holiday';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AcademicColors.warningContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.celebration, size: 32, color: AcademicColors.warning),
            ),
            const SizedBox(height: 16),
            Text(
              'School Holiday',
              style: GoogleFonts.newsreader(fontSize: 20, fontWeight: FontWeight.bold, color: AcademicColors.textPrimary),
            ),
            const SizedBox(height: 6),
            Text(
              holidayName,
              style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.bold, color: AcademicColors.warning),
            ),
            const SizedBox(height: 6),
            Text(
              'No attendance is required for this date.',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(fontSize: 12, color: AcademicColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFutureDateView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AcademicColors.infoContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.calendar_month, size: 32, color: AcademicColors.info),
            ),
            const SizedBox(height: 16),
            Text(
              'Future Date Selected',
              style: GoogleFonts.newsreader(fontSize: 20, fontWeight: FontWeight.bold, color: AcademicColors.textPrimary),
            ),
            const SizedBox(height: 6),
            Text(
              'Attendance is not available for future dates.',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(fontSize: 12, color: AcademicColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnassignedClassState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_off, size: 44, color: AcademicColors.textSecondary),
            const SizedBox(height: 12),
            Text(
              'No Class Assigned',
              style: GoogleFonts.newsreader(fontSize: 18, fontWeight: FontWeight.bold, color: AcademicColors.textPrimary),
            ),
            const SizedBox(height: 6),
            Text(
              'This teacher profile does not have an assigned homeroom class.',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(fontSize: 12, color: AcademicColors.textSecondary),
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
            const Icon(Icons.error_outline, size: 44, color: AcademicColors.danger),
            const SizedBox(height: 12),
            Text(
              'Unable to load student attendance list.',
              style: GoogleFonts.newsreader(fontSize: 18, fontWeight: FontWeight.bold, color: AcademicColors.textPrimary),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AcademicColors.primaryDark, foregroundColor: Colors.white),
              onPressed: () => setState(() {}),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (_, __) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        height: 64,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
