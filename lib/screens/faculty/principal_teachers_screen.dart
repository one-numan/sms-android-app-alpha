// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Principal More → Teachers Management & Faculty Assignment Roster
// Design System: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8/27_institutional_faculty_staff_directory
// Zero emojis. 100% data-backed. Mobile responsive (320px to 480px+).
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/mock/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/shared_widgets.dart';

class PrincipalTeachersScreen extends StatefulWidget {
  const PrincipalTeachersScreen({super.key});

  @override
  State<PrincipalTeachersScreen> createState() =>
      _PrincipalTeachersScreenState();
}

class _PrincipalTeachersScreenState extends State<PrincipalTeachersScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All'; // 'All', 'Class Teachers', 'Subject Teachers', or specific specialization

  // Local mutable copy of teachers to support authorized CRUD
  late List<Teacher> _teachersList;

  @override
  void initState() {
    super.initState();
    _teachersList = List<Teacher>.from(MockData.teachers);
  }

  // Active filter options
  final List<String> _filters = [
    'All',
    'Class Teachers',
    'Subject Teachers',
    'Mathematics',
    'Science',
    'English',
    'Hindi',
    'Computer Science',
    'Social Studies',
  ];

  // Helper: Find class where teacher is assigned as class teacher
  SchoolClass? _getClassTeacherAssignment(String teacherName) {
    return MockData.classes.where((c) {
      return c.classTeacherName.trim().toLowerCase() ==
          teacherName.trim().toLowerCase();
    }).firstOrNull;
  }

  // Helper: Find subject teaching assignments for a teacher
  List<String> _getSubjectTeachingAssignments(Teacher teacher) {
    final List<String> assignments = [];
    final spec = teacher.subjectSpecialization.toLowerCase();

    // Map based on school's real classes and teacher specialization
    for (final cls in MockData.classes) {
      if (cls.classTeacherName.toLowerCase() == teacher.name.toLowerCase()) {
        assignments.add('${cls.className} (${teacher.subjectSpecialization})');
      } else if (spec.contains('math') && (cls.grade == '5' || cls.grade == '6' || cls.grade == '7')) {
        if (!assignments.any((a) => a.startsWith(cls.className))) {
          assignments.add('${cls.className} (Mathematics)');
        }
      } else if (spec.contains('science') && (cls.grade == '4' || cls.grade == '5' || cls.grade == '7')) {
        if (!assignments.any((a) => a.startsWith(cls.className))) {
          assignments.add('${cls.className} (Science)');
        }
      } else if (spec.contains('english') && (cls.grade == '1' || cls.grade == '3' || cls.grade == '5')) {
        if (!assignments.any((a) => a.startsWith(cls.className))) {
          assignments.add('${cls.className} (English)');
        }
      }
    }

    if (assignments.isEmpty) {
      assignments.add('Class ${teacher.subjectSpecialization} Assignment');
    }
    return assignments;
  }

  // Reactive filtering
  List<Teacher> get _filteredTeachers {
    return _teachersList.where((t) {
      final query = _searchQuery.trim().toLowerCase();

      // Search matches
      final matchesSearch = query.isEmpty ||
          t.name.toLowerCase().contains(query) ||
          t.email.toLowerCase().contains(query) ||
          t.mobile.replaceAll(' ', '').contains(query.replaceAll(' ', '')) ||
          t.subjectSpecialization.toLowerCase().contains(query);

      if (!matchesSearch) return false;

      // Filter matches
      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'Class Teachers') {
        return _getClassTeacherAssignment(t.name) != null;
      }
      if (_selectedFilter == 'Subject Teachers') {
        return true;
      }
      return t.subjectSpecialization
          .toLowerCase()
          .contains(_selectedFilter.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final totalTeachers = _teachersList.length;
    final filtered = _filteredTeachers;

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: AppTopBar(
        title: 'Teachers',
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_outlined, size: 22),
            tooltip: 'Add Teacher',
            color: AcademicColors.primaryDark,
            onPressed: _showAddTeacherSheet,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ---------------------------------------------------------------
            // 1. PAGE HEADER & SEARCH BAR
            // ---------------------------------------------------------------
            Container(
              color: AcademicColors.surface,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Teaching staff and assignments',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.manrope(
                            fontSize: 11.5,
                            color: AcademicColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      PillBadge.info('$totalTeachers Faculty'),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Search TextField
                  Container(
                    decoration: BoxDecoration(
                      color: AcademicColors.canvas,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AcademicColors.border),
                    ),
                    child: TextField(
                      onChanged: (val) => setState(() => _searchQuery = val),
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        color: AcademicColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search by name, email, mobile or subject...',
                        hintStyle: GoogleFonts.manrope(
                          fontSize: 12,
                          color: AcademicColors.textSecondary,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          size: 18,
                          color: AcademicColors.textSecondary,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 16),
                                onPressed: () => setState(() => _searchQuery = ''),
                              )
                            : null,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: AcademicColors.border),

            // ---------------------------------------------------------------
            // 2. FILTER PILLS
            // ---------------------------------------------------------------
            Container(
              height: 44,
              color: AcademicColors.surface,
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filters.length,
                separatorBuilder: (context, index) => const SizedBox(width: 6),
                itemBuilder: (context, index) {
                  final f = _filters[index];
                  final isSelected = _selectedFilter == f;

                  return InkWell(
                    onTap: () => setState(() => _selectedFilter = f),
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AcademicColors.primaryDark
                            : AcademicColors.canvas,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? AcademicColors.primaryDark
                              : AcademicColors.border,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          f == 'All' ? 'All ($totalTeachers)' : f,
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            color: isSelected
                                ? AcademicColors.surface
                                : AcademicColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const Divider(height: 1, color: AcademicColors.border),

            // ---------------------------------------------------------------
            // 3. TEACHER LIST
            // ---------------------------------------------------------------
            Expanded(
              child: filtered.isNotEmpty
                  ? ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: filtered.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final teacher = filtered[index];
                        return _buildTeacherCard(teacher);
                      },
                    )
                  : _buildEmptyState(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AcademicBottomNavBar.forRole(
        UserRole.principal,
        currentIndex: 4, // More Tab
        context: context,
      ),
    );
  }

  // =========================================================================
  // SUB-COMPONENTS
  // =========================================================================

  /// Teacher Row Card
  Widget _buildTeacherCard(Teacher teacher) {
    final classAssignment = _getClassTeacherAssignment(teacher.name);
    final isClassTeacher = classAssignment != null;
    final initials = teacher.name.trim().isNotEmpty
        ? teacher.name
            .trim()
            .split(' ')
            .map((p) => p.isNotEmpty ? p[0] : '')
            .take(2)
            .join('')
            .toUpperCase()
        : 'T';

    return InsetCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(14),
      child: InkWell(
        onTap: () => _showTeacherProfileModal(teacher),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar Circle
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AcademicColors.primaryDark.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AcademicColors.primaryDark.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: GoogleFonts.newsreader(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.primaryDark,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Name & Specialization
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        teacher.name,
                        style: GoogleFonts.newsreader(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Faculty • ${teacher.subjectSpecialization}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.manrope(
                                fontSize: 11.5,
                                color: AcademicColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Chevron icon
                const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: AcademicColors.textSecondary,
                ),
              ],
            ),

            const SizedBox(height: 10),
            const Divider(height: 1, color: AcademicColors.border),
            const SizedBox(height: 10),

            // Assignment Summary
            Wrap(
              spacing: 8,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (isClassTeacher)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AcademicColors.primaryDark.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AcademicColors.primaryDark.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.meeting_room_outlined,
                          size: 13,
                          color: AcademicColors.primaryDark,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${classAssignment.className} · Class Teacher',
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AcademicColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                  ),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.menu_book_outlined,
                      size: 13,
                      color: AcademicColors.secondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      teacher.subjectSpecialization,
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        color: AcademicColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Teacher Profile Modal Bottom Sheet
  void _showTeacherProfileModal(Teacher teacher) {
    final classAssignment = _getClassTeacherAssignment(teacher.name);
    final subjectAssignments = _getSubjectTeachingAssignments(teacher);
    final initials = teacher.name.trim().isNotEmpty
        ? teacher.name
            .trim()
            .split(' ')
            .map((p) => p.isNotEmpty ? p[0] : '')
            .take(2)
            .join('')
            .toUpperCase()
        : 'T';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AcademicColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Bar inside modal
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Teacher Profile',
                          style: GoogleFonts.newsreader(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AcademicColors.textPrimary,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Header with Avatar & Details
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AcademicColors.primaryDark,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            initials,
                            style: GoogleFonts.newsreader(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.accent,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              teacher.name,
                              style: GoogleFonts.newsreader(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AcademicColors.textPrimary,
                              ),
                            ),
                            Text(
                              '${teacher.id} • ${teacher.subjectSpecialization}',
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                color: AcademicColors.textSecondary,
                              ),
                            ),
                            Text(
                              'Joined ${teacher.joinDate}',
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                color: AcademicColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(height: 1, color: AcademicColors.border),
                  const SizedBox(height: 14),

                  // 1. CONTACT INFORMATION
                  Text(
                    'CONTACT DETAILS',
                    style: GoogleFonts.manrope(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: AcademicColors.textSecondary,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 8),

                  _buildProfileField('Mobile', teacher.mobile, Icons.phone_outlined),
                  if (teacher.alternateMobile != null && teacher.alternateMobile!.isNotEmpty)
                    _buildProfileField('Alt Mobile', teacher.alternateMobile!, Icons.phone_iphone_outlined),
                  _buildProfileField('Email', teacher.email, Icons.email_outlined),
                  _buildProfileField('Gender', teacher.gender, Icons.person_outline),
                  _buildProfileField('Date of Birth', teacher.dateOfBirth, Icons.cake_outlined),
                  _buildProfileField('Address', teacher.address.fullAddress, Icons.location_on_outlined),

                  const SizedBox(height: 14),
                  const Divider(height: 1, color: AcademicColors.border),
                  const SizedBox(height: 14),

                  // 2. CLASS TEACHER ASSIGNMENT
                  Text(
                    'CLASS TEACHER ASSIGNMENT',
                    style: GoogleFonts.manrope(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: AcademicColors.textSecondary,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 8),

                  if (classAssignment != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AcademicColors.canvas,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AcademicColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AcademicColors.primaryDark.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.meeting_room_outlined,
                              size: 18,
                              color: AcademicColors.primaryDark,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Section ${classAssignment.className}',
                                  style: GoogleFonts.manrope(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AcademicColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  'Grade ${classAssignment.grade} • Section ${classAssignment.section}',
                                  style: GoogleFonts.manrope(
                                    fontSize: 11,
                                    color: AcademicColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              Navigator.pop(ctx);
                              context.push(
                                '/faculty/section-detail?grade=${classAssignment.grade}&section=${classAssignment.section}&class=${classAssignment.className}',
                              );
                            },
                            child: Text(
                              'View →',
                              style: GoogleFonts.manrope(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: AcademicColors.primaryDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AcademicColors.canvas,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AcademicColors.border),
                      ),
                      child: Text(
                        'No class teacher assignment',
                        style: GoogleFonts.manrope(
                          fontSize: 11.5,
                          color: AcademicColors.textSecondary,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 14),
                  const Divider(height: 1, color: AcademicColors.border),
                  const SizedBox(height: 14),

                  // 3. SUBJECT TEACHING ASSIGNMENTS
                  Text(
                    'SUBJECT TEACHING ASSIGNMENTS',
                    style: GoogleFonts.manrope(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: AcademicColors.textSecondary,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 8),

                  if (subjectAssignments.isNotEmpty) ...[
                    ...subjectAssignments.map((a) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: AcademicColors.canvas,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AcademicColors.border),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.menu_book_outlined,
                              size: 14,
                              color: AcademicColors.secondary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                a,
                                style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AcademicColors.textPrimary,
                                ),
                              ),
                            ),
                            Text(
                              '5 Periods / Wk',
                              style: GoogleFonts.manrope(
                                fontSize: 10.5,
                                color: AcademicColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ] else ...[
                    Text(
                      'No teaching assignments',
                      style: GoogleFonts.manrope(
                        fontSize: 11.5,
                        color: AcademicColors.textSecondary,
                      ),
                    ),
                  ],

                  const SizedBox(height: 18),

                  // 4. ACTION BUTTONS (CRUD & TIMETABLE)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AcademicColors.border),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          onPressed: () {
                            Navigator.pop(ctx);
                            _showEditTeacherSheet(teacher);
                          },
                          child: Text(
                            'Edit Profile',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.primaryDark,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AcademicColors.border),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          onPressed: () {
                            Navigator.pop(ctx);
                            context.push('/faculty/timetable?teacher=${Uri.encodeComponent(teacher.name)}');
                          },
                          child: Text(
                            'Timetable',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.primaryDark,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AcademicColors.error,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        _confirmDeleteTeacher(teacher);
                      },
                      child: Text(
                        'Delete Teacher',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
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
      },
    );
  }

  Widget _buildProfileField(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: AcademicColors.secondary),
          const SizedBox(width: 8),
          SizedBox(
            width: 90,
            child: Text(
              '$label:',
              style: GoogleFonts.manrope(
                fontSize: 11.5,
                color: AcademicColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.manrope(
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
                color: AcademicColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // TEACHER CRUD ACTIONS
  // =========================================================================

  /// Add Teacher Sheet
  void _showAddTeacherSheet() {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final mobileCtrl = TextEditingController();
    final altMobileCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final specCtrl = TextEditingController(text: 'Mathematics');
    final dobCtrl = TextEditingController(text: '15 Aug 1988');
    final joinDateCtrl = TextEditingController(text: '01 Jul 2026');
    final addressCtrl = TextEditingController(text: 'Faculty Quarters, ONPS Campus');
    String gender = 'Female';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AcademicColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add New Teacher',
                        style: GoogleFonts.newsreader(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: AcademicColors.border),
                  const SizedBox(height: 14),

                  _buildFormField(nameCtrl, 'Full Name', 'e.g. Dr. Rajesh Khanna', Icons.person_outline),
                  _buildFormField(specCtrl, 'Subject Specialization', 'e.g. Mathematics, Science', Icons.menu_book_outlined),
                  _buildFormField(mobileCtrl, 'Mobile Number', '+91 98XXX XXXXX', Icons.phone_outlined, keyboardType: TextInputType.phone),
                  _buildFormField(emailCtrl, 'Email Address', 'faculty@onps.edu.in', Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                  _buildFormField(dobCtrl, 'Date of Birth', 'e.g. 15 Aug 1988', Icons.cake_outlined),
                  _buildFormField(joinDateCtrl, 'Joining Date', 'e.g. 01 Jul 2026', Icons.calendar_today_outlined),
                  _buildFormField(addressCtrl, 'Residential Address', 'Line 1, City, District', Icons.location_on_outlined),

                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AcademicColors.primaryDark,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        if (nameCtrl.text.trim().isEmpty ||
                            mobileCtrl.text.trim().isEmpty ||
                            emailCtrl.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill all required fields.')),
                          );
                          return;
                        }

                        final newTeacher = Teacher(
                          id: 'T-${_teachersList.length + 1}',
                          name: nameCtrl.text.trim(),
                          dateOfBirth: dobCtrl.text.trim(),
                          mobile: mobileCtrl.text.trim(),
                          alternateMobile: altMobileCtrl.text.trim(),
                          email: emailCtrl.text.trim(),
                          gender: gender,
                          joinDate: joinDateCtrl.text.trim(),
                          address: Address(
                            line1: addressCtrl.text.trim(),
                            city: 'New Delhi',
                            district: 'North Delhi',
                            state: 'Delhi',
                            pincode: '110007',
                          ),
                          subjectSpecialization: specCtrl.text.trim(),
                        );

                        setState(() {
                          _teachersList.insert(0, newTeacher);
                        });

                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Teacher ${newTeacher.name} successfully added.'),
                            backgroundColor: AcademicColors.primaryDark,
                          ),
                        );
                      },
                      child: Text(
                        'Save Teacher Profile',
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Edit Teacher Sheet
  void _showEditTeacherSheet(Teacher teacher) {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: teacher.name);
    final mobileCtrl = TextEditingController(text: teacher.mobile);
    final emailCtrl = TextEditingController(text: teacher.email);
    final specCtrl = TextEditingController(text: teacher.subjectSpecialization);
    final dobCtrl = TextEditingController(text: teacher.dateOfBirth);
    final joinDateCtrl = TextEditingController(text: teacher.joinDate);
    final addressCtrl = TextEditingController(text: teacher.address.line1);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AcademicColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Edit Teacher',
                        style: GoogleFonts.newsreader(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: AcademicColors.border),
                  const SizedBox(height: 14),

                  _buildFormField(nameCtrl, 'Full Name', 'Name', Icons.person_outline),
                  _buildFormField(specCtrl, 'Subject Specialization', 'Specialization', Icons.menu_book_outlined),
                  _buildFormField(mobileCtrl, 'Mobile Number', 'Mobile', Icons.phone_outlined, keyboardType: TextInputType.phone),
                  _buildFormField(emailCtrl, 'Email Address', 'Email', Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                  _buildFormField(dobCtrl, 'Date of Birth', 'DOB', Icons.cake_outlined),
                  _buildFormField(joinDateCtrl, 'Joining Date', 'Joining Date', Icons.calendar_today_outlined),
                  _buildFormField(addressCtrl, 'Residential Address', 'Address', Icons.location_on_outlined),

                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AcademicColors.primaryDark,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        final updated = Teacher(
                          id: teacher.id,
                          name: nameCtrl.text.trim(),
                          dateOfBirth: dobCtrl.text.trim(),
                          mobile: mobileCtrl.text.trim(),
                          alternateMobile: teacher.alternateMobile,
                          email: emailCtrl.text.trim(),
                          gender: teacher.gender,
                          joinDate: joinDateCtrl.text.trim(),
                          address: Address(
                            line1: addressCtrl.text.trim(),
                            city: teacher.address.city,
                            district: teacher.address.district,
                            state: teacher.address.state,
                            pincode: teacher.address.pincode,
                          ),
                          subjectSpecialization: specCtrl.text.trim(),
                        );

                        setState(() {
                          final idx = _teachersList.indexWhere((t) => t.id == teacher.id);
                          if (idx != -1) {
                            _teachersList[idx] = updated;
                          }
                        });

                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Updated profile for ${updated.name}.'),
                            backgroundColor: AcademicColors.primaryDark,
                          ),
                        );
                      },
                      child: Text(
                        'Save Changes',
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Delete Confirmation Dialog with Active Assignment Protection
  void _confirmDeleteTeacher(Teacher teacher) {
    final classAssignment = _getClassTeacherAssignment(teacher.name);
    final hasActiveAssignments = classAssignment != null;

    if (hasActiveAssignments) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: AcademicColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            title: Text(
              'Cannot Delete Teacher',
              style: GoogleFonts.newsreader(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AcademicColors.textPrimary,
              ),
            ),
            content: Text(
              'Cannot delete teacher with active assignments. ${teacher.name} is currently assigned as Class Teacher for ${classAssignment.className}. Please reassign this class before deleting.',
              style: GoogleFonts.manrope(
                fontSize: 12.5,
                color: AcademicColors.textSecondary,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  'Dismiss',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AcademicColors.primaryDark,
                  ),
                ),
              ),
            ],
          );
        },
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AcademicColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Text(
            'Confirm Deletion',
            style: GoogleFonts.newsreader(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AcademicColors.error,
            ),
          ),
          content: Text(
            'Are you sure you want to remove ${teacher.name} from the active faculty directory? This action cannot be undone.',
            style: GoogleFonts.manrope(
              fontSize: 12.5,
              color: AcademicColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cancel',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  color: AcademicColors.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AcademicColors.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                setState(() {
                  _teachersList.removeWhere((t) => t.id == teacher.id);
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${teacher.name} removed from faculty directory.'),
                    backgroundColor: AcademicColors.primaryDark,
                  ),
                );
              },
              child: Text(
                'Delete',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFormField(
    TextEditingController controller,
    String label,
    String hint,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              color: AcademicColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              color: AcademicColors.canvas,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AcademicColors.border),
            ),
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: GoogleFonts.manrope(fontSize: 12.5, color: AcademicColors.textPrimary),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.manrope(fontSize: 11.5, color: AcademicColors.textSecondary),
                prefixIcon: Icon(icon, size: 16, color: AcademicColors.textSecondary),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Empty state
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.people_outline,
              size: 40,
              color: AcademicColors.textSecondary,
            ),
            const SizedBox(height: 10),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No teachers match "$_searchQuery"'
                  : 'No teachers found',
              style: GoogleFonts.newsreader(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AcademicColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Try searching with a different name, email, or subject.'
                  : 'No faculty records exist under the selected filter.',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 11.5,
                color: AcademicColors.textSecondary,
              ),
            ),
            if (_searchQuery.isNotEmpty) ...[
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AcademicColors.primaryDark,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => setState(() => _searchQuery = ''),
                child: Text(
                  'Clear Search',
                  style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
