// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Principal -> Students: Student Directory & Progressive Drilldown
// Design System: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8/student_see_all_students_ledger
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/mock/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/bottom_nav_bar.dart';

enum StudentSortBy {
  nameAsc,
  rollNumber,
  admissionNo,
}

class AllStudentsLedgerScreen extends StatefulWidget {
  const AllStudentsLedgerScreen({super.key});

  @override
  State<AllStudentsLedgerScreen> createState() => _AllStudentsLedgerScreenState();
}

class _AllStudentsLedgerScreenState extends State<AllStudentsLedgerScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedGrade = 'All'; // 'All', 'K', '1', '2', ..., '12'
  String _selectedSection = 'All'; // 'All', 'A', 'B', 'C', 'D', 'E'
  StudentSortBy _sortBy = StudentSortBy.nameAsc;
  bool _isLoading = false;
  bool _hasError = false;

  final List<String> _grades = [
    'All',
    'K',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatGradeLabel(String g) {
    if (g == 'All') return 'All Classes';
    if (g == 'K') return 'Kindergarten';
    return 'Grade $g';
  }

  List<String> _getAvailableSections(String grade) {
    if (grade == 'All') return ['All'];
    final matchingClasses = MockData.classes.where((c) => c.grade == grade).toList();
    if (matchingClasses.isEmpty) return ['All', 'A', 'B', 'C', 'D', 'E'];
    final sections = matchingClasses.map((c) => c.section).toSet().toList()..sort();
    return ['All', ...sections];
  }

  void _openGradePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AcademicColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 6),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AcademicColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Class',
                      style: GoogleFonts.newsreader(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.primaryDark,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20, color: AcademicColors.textSecondary),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: AcademicColors.border),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _grades.length,
                  itemBuilder: (context, i) {
                    final g = _grades[i];
                    final isSel = _selectedGrade == g;
                    return ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                      title: Text(
                        _formatGradeLabel(g),
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                          color: isSel ? AcademicColors.primaryDark : AcademicColors.textPrimary,
                        ),
                      ),
                      trailing: isSel
                          ? const Icon(Icons.check_circle, color: AcademicColors.primaryDark, size: 20)
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedGrade = g;
                          _selectedSection = 'All';
                        });
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openSectionPicker() {
    final sections = _getAvailableSections(_selectedGrade);
    showModalBottomSheet(
      context: context,
      backgroundColor: AcademicColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 6),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AcademicColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Section (${_formatGradeLabel(_selectedGrade)})',
                      style: GoogleFonts.newsreader(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.primaryDark,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20, color: AcademicColors.textSecondary),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: AcademicColors.border),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: sections.length,
                  itemBuilder: (context, i) {
                    final sec = sections[i];
                    final isSel = _selectedSection == sec;
                    final label = sec == 'All' ? 'All Sections' : 'Section $_selectedGrade-$sec';
                    return ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                      title: Text(
                        label,
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                          color: isSel ? AcademicColors.primaryDark : AcademicColors.textPrimary,
                        ),
                      ),
                      trailing: isSel
                          ? const Icon(Icons.check_circle, color: AcademicColors.primaryDark, size: 20)
                          : null,
                      onTap: () {
                        setState(() => _selectedSection = sec);
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openSortPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AcademicColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 6),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AcademicColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sort Students',
                      style: GoogleFonts.newsreader(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.primaryDark,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20, color: AcademicColors.textSecondary),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: AcademicColors.border),
              ListTile(
                dense: true,
                title: Text('Name (A–Z)', style: GoogleFonts.manrope(fontSize: 14, fontWeight: _sortBy == StudentSortBy.nameAsc ? FontWeight.bold : FontWeight.w500)),
                trailing: _sortBy == StudentSortBy.nameAsc ? const Icon(Icons.check_circle, color: AcademicColors.primaryDark, size: 20) : null,
                onTap: () {
                  setState(() => _sortBy = StudentSortBy.nameAsc);
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                dense: true,
                title: Text('Roll Number', style: GoogleFonts.manrope(fontSize: 14, fontWeight: _sortBy == StudentSortBy.rollNumber ? FontWeight.bold : FontWeight.w500)),
                trailing: _sortBy == StudentSortBy.rollNumber ? const Icon(Icons.check_circle, color: AcademicColors.primaryDark, size: 20) : null,
                onTap: () {
                  setState(() => _sortBy = StudentSortBy.rollNumber);
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                dense: true,
                title: Text('Admission Number', style: GoogleFonts.manrope(fontSize: 14, fontWeight: _sortBy == StudentSortBy.admissionNo ? FontWeight.bold : FontWeight.w500)),
                trailing: _sortBy == StudentSortBy.admissionNo ? const Icon(Icons.check_circle, color: AcademicColors.primaryDark, size: 20) : null,
                onTap: () {
                  setState(() => _sortBy = StudentSortBy.admissionNo);
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  List<Student> _getFilteredStudents() {
    List<Student> list = List.from(MockData.students);

    // Filter by grade
    if (_selectedGrade != 'All') {
      list = list.where((s) => s.classGrade == _selectedGrade).toList();
    }

    // Filter by section
    if (_selectedSection != 'All') {
      list = list.where((s) => s.classSection == _selectedSection).toList();
    }

    // Filter by search query
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();
      list = list.where((s) {
        final nameMatch = s.fullName.toLowerCase().contains(q);
        final idMatch = s.id.toLowerCase().contains(q);
        final admMatch = s.admissionNumber.toLowerCase().contains(q);
        final rollMatch = s.rollNumber.toString().contains(q);
        return nameMatch || idMatch || admMatch || rollMatch;
      }).toList();
    }

    // Sort
    switch (_sortBy) {
      case StudentSortBy.nameAsc:
        list.sort((a, b) => a.fullName.compareTo(b.fullName));
        break;
      case StudentSortBy.rollNumber:
        list.sort((a, b) => a.rollNumber.compareTo(b.rollNumber));
        break;
      case StudentSortBy.admissionNo:
        list.sort((a, b) => a.id.compareTo(b.id));
        break;
    }

    return list;
  }

  int _getTotalCountForSelection() {
    if (_selectedGrade == 'All') {
      return 1240; // Total institutional active student body
    }
    if (_selectedSection == 'All') {
      // 5 sections * ~32 students
      return 160;
    }
    return 32;
  }

  @override
  Widget build(BuildContext context) {
    final filteredStudents = _getFilteredStudents();
    final contextCount = _getTotalCountForSelection();

    // Context label string
    String contextString;
    if (_selectedGrade == 'All') {
      contextString = 'All Classes';
    } else if (_selectedSection == 'All') {
      contextString = '${_formatGradeLabel(_selectedGrade)} • All Sections';
    } else {
      contextString = 'Grade $_selectedGrade-$_selectedSection';
    }

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: const AppTopBar(
        title: 'Students',
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header Context Bar
            Container(
              color: AcademicColors.surface,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Student Directory',
                          style: GoogleFonts.newsreader(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AcademicColors.primaryDark,
                          ),
                        ),
                        Text(
                          'Session 2026–27 • Student Registry',
                          style: GoogleFonts.manrope(
                            fontSize: 11.5,
                            color: AcademicColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AcademicColors.canvas,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AcademicColors.border),
                    ),
                    child: Text(
                      '$contextCount Students',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.primaryDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar & Filter Pickers
            Container(
              color: AcademicColors.surface,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                children: [
                  // Search Field
                  TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: GoogleFonts.manrope(fontSize: 13, color: AcademicColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Search student...',
                      hintStyle: GoogleFonts.manrope(fontSize: 13, color: AcademicColors.textSecondary),
                      prefixIcon: const Icon(Icons.search, size: 20, color: AcademicColors.textSecondary),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close, size: 18, color: AcademicColors.textSecondary),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      fillColor: AcademicColors.canvas,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AcademicColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AcademicColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AcademicColors.primaryDark, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Grade & Section Filter Pickers
                  Row(
                    children: [
                      // Grade Selector
                      Expanded(
                        child: InkWell(
                          onTap: _openGradePicker,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AcademicColors.canvas,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _selectedGrade != 'All' ? AcademicColors.primaryDark : AcademicColors.border,
                                width: _selectedGrade != 'All' ? 1.2 : 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    _formatGradeLabel(_selectedGrade),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                      fontWeight: _selectedGrade != 'All' ? FontWeight.bold : FontWeight.w600,
                                      color: _selectedGrade != 'All' ? AcademicColors.primaryDark : AcademicColors.textPrimary,
                                    ),
                                  ),
                                ),
                                const Icon(Icons.arrow_drop_down, size: 20, color: AcademicColors.textSecondary),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Section Selector
                      Expanded(
                        child: InkWell(
                          onTap: _selectedGrade == 'All' ? null : _openSectionPicker,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: _selectedGrade == 'All' ? AcademicColors.border.withValues(alpha: 0.2) : AcademicColors.canvas,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _selectedSection != 'All' ? AcademicColors.primaryDark : AcademicColors.border,
                                width: _selectedSection != 'All' ? 1.2 : 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    _selectedSection == 'All'
                                        ? 'All Sections'
                                        : 'Section $_selectedGrade-$_selectedSection',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                      fontWeight: _selectedSection != 'All' ? FontWeight.bold : FontWeight.w600,
                                      color: _selectedGrade == 'All'
                                          ? AcademicColors.textSecondary
                                          : (_selectedSection != 'All' ? AcademicColors.primaryDark : AcademicColors.textPrimary),
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  size: 20,
                                  color: _selectedGrade == 'All' ? AcademicColors.border : AcademicColors.textSecondary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Active Filter Context & Sort Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(
                color: AcademicColors.canvas,
                border: Border(
                  bottom: BorderSide(color: AcademicColors.border, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      contextString,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.textPrimary,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: _openSortPicker,
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      child: Row(
                        children: [
                          const Icon(Icons.swap_vert, size: 16, color: AcademicColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            _sortBy == StudentSortBy.nameAsc
                                ? 'Name A–Z'
                                : (_sortBy == StudentSortBy.rollNumber ? 'Roll No.' : 'Adm No.'),
                            style: GoogleFonts.manrope(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: AcademicColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content Area (Loading, Error, Empty, or Student List)
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : _hasError
                      ? _buildErrorState()
                      : filteredStudents.isEmpty
                          ? _buildEmptyState()
                          : _buildStudentList(filteredStudents),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AcademicBottomNavBar.forRole(
        UserRole.principal,
        context: context,
        currentIndex: 2, // Students tab is active
      ),
    );
  }

  Widget _buildStudentList(List<Student> students) {
    return ListView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: students.length,
      itemBuilder: (context, index) {
        final s = students[index];
        final initials = '${s.firstName.isNotEmpty ? s.firstName[0] : ""}${s.lastName.isNotEmpty ? s.lastName[0] : ""}';

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: AcademicColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AcademicColors.border),
          ),
          child: InkWell(
            onTap: () => context.push('/students/dossier?id=${s.id}'),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  // Photo / Initials Avatar
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AcademicColors.primaryDark,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: GoogleFonts.newsreader(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.accent,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Student Identity & Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.fullName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AcademicColors.primaryDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Roll No. ${s.rollNumber} • Grade ${s.classSectionName}',
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            color: AcademicColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: AcademicColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AcademicColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AcademicColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AcademicColors.border.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AcademicColors.border.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 160,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AcademicColors.border.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 40, color: AcademicColors.error),
              const SizedBox(height: 12),
              Text(
                'Unable to load student records.',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AcademicColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AcademicColors.primaryDark,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _hasError = false;
                  });
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (mounted) setState(() => _isLoading = false);
                  });
                },
                child: Text(
                  'Retry',
                  style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AcademicColors.canvas,
                  shape: BoxShape.circle,
                  border: Border.all(color: AcademicColors.border),
                ),
                child: const Icon(Icons.person_search_outlined, size: 36, color: AcademicColors.primaryDark),
              ),
              const SizedBox(height: 16),
              Text(
                'No students found.',
                style: GoogleFonts.newsreader(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AcademicColors.primaryDark,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _searchQuery.isNotEmpty
                    ? 'Try another name, roll number, or admission number.'
                    : 'No students found for this selection.',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 12.5,
                  color: AcademicColors.textSecondary,
                ),
              ),
              if (_searchQuery.isNotEmpty || _selectedGrade != 'All' || _selectedSection != 'All') ...[
                const SizedBox(height: 16),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AcademicColors.primaryDark,
                    side: const BorderSide(color: AcademicColors.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                      _selectedGrade = 'All';
                      _selectedSection = 'All';
                    });
                  },
                  child: Text(
                    'Reset Filters',
                    style: GoogleFonts.manrope(fontSize: 12.5, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
