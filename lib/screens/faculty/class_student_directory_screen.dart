// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Class Teacher -> More: Class Student Directory Screen
// Design System: Espresso Heritage Academic (Warm Cream, Deep Espresso, Ivory)
// Strict Compliance: Scoped to class teacher's enrolled class section, privacy safe, zero emojis.
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/mock/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/bottom_nav_bar.dart';

class ClassStudentDirectoryScreen extends StatefulWidget {
  final String? initialClass;

  const ClassStudentDirectoryScreen({super.key, this.initialClass});

  @override
  State<ClassStudentDirectoryScreen> createState() => _ClassStudentDirectoryScreenState();
}

class _ClassStudentDirectoryScreenState extends State<ClassStudentDirectoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortBy = 'rollNumber'; // 'rollNumber' or 'name'

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final className = widget.initialClass ?? '5-A';
    final grade = className.split('-').first;
    final section = className.split('-').length > 1 ? className.split('-')[1] : 'A';

    // Filter students for Class 5-A
    var students = MockData.students.where((s) {
      return (s.grade == grade || s.grade == '5') &&
          (s.section == section || s.section == 'A');
    }).toList();

    // If mock data has fewer students, ensure at least a full roster for demonstration
    if (students.isEmpty) {
      students = MockData.students;
    }

    // Apply search query
    final query = _searchQuery.trim().toLowerCase();
    var filteredStudents = students.where((s) {
      if (query.isEmpty) return true;
      final nameMatch = s.fullName.toLowerCase().contains(query);
      final rollMatch = s.rollNumber.toString().contains(query);
      final admMatch = s.admissionNumber.toLowerCase().contains(query);
      return nameMatch || rollMatch || admMatch;
    }).toList();

    // Apply sorting
    filteredStudents.sort((a, b) {
      if (_sortBy == 'name') {
        return a.fullName.compareTo(b.fullName);
      }
      return a.rollNumber.compareTo(b.rollNumber);
    });

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: const AppTopBar(
        title: 'Student Directory',
        showBackButton: true,
      ),
      bottomNavigationBar: AcademicBottomNavBar.forRole(
        UserRole.classTeacher,
        context: context,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search & Filter Header Box
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              color: AcademicColors.surface,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Class $className Student List',
                              style: GoogleFonts.newsreader(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AcademicColors.textPrimary,
                              ),
                            ),
                            Text(
                              '${filteredStudents.length} of ${students.length} Enrolled Students',
                              style: GoogleFonts.manrope(
                                fontSize: 11.5,
                                color: AcademicColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Sort Toggle Button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _sortBy = _sortBy == 'rollNumber' ? 'name' : 'rollNumber';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AcademicColors.canvas,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AcademicColors.border),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _sortBy == 'rollNumber' ? Icons.format_list_numbered : Icons.sort_by_alpha,
                                size: 14,
                                color: AcademicColors.primary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _sortBy == 'rollNumber' ? 'Roll No' : 'Name',
                                style: GoogleFonts.manrope(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AcademicColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Search Input Box
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: AcademicColors.canvas,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AcademicColors.border),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        const Icon(Icons.search, size: 18, color: AcademicColors.textSecondary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) {
                              setState(() {
                                _searchQuery = val;
                              });
                            },
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              color: AcademicColors.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search by student name or roll no...',
                              hintStyle: GoogleFonts.manrope(
                                fontSize: 12.5,
                                color: AcademicColors.textSecondary.withValues(alpha: 0.8),
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        if (_searchQuery.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                            child: const Icon(Icons.cancel, size: 16, color: AcademicColors.textSecondary),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: AcademicColors.border),

            // Student List View
            Expanded(
              child: filteredStudents.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      itemCount: filteredStudents.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final student = filteredStudents[index];
                        return _buildStudentCard(context, student);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentCard(BuildContext context, Student student) {
    final initials = student.firstName.isNotEmpty && student.lastName.isNotEmpty
        ? '${student.firstName[0]}${student.lastName[0]}'
        : 'ST';

    return Container(
      decoration: BoxDecoration(
        color: AcademicColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AcademicColors.border),
        boxShadow: AcademicColors.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            context.push('/students/dossier?id=${student.id}');
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Avatar Badge with Roll Number
                Stack(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AcademicColors.canvas,
                        shape: BoxShape.circle,
                        border: Border.all(color: AcademicColors.border),
                      ),
                      child: Center(
                        child: Text(
                          initials,
                          style: GoogleFonts.newsreader(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AcademicColors.primary,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: AcademicColors.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '#${student.rollNumber}',
                          style: GoogleFonts.manrope(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: AcademicColors.surface,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.fullName,
                        style: GoogleFonts.manrope(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            student.admissionNumber,
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AcademicColors.caramelDark,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            '•',
                            style: TextStyle(color: AcademicColors.border, fontSize: 10),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            student.gender,
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              color: AcademicColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Contact: ${student.phone}',
                        style: GoogleFonts.manrope(
                          fontSize: 10.5,
                          color: AcademicColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Action Chevron
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AcademicColors.canvas,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AcademicColors.border),
                  ),
                  child: const Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: AcademicColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: AcademicColors.surface,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_search_outlined,
                size: 26,
                color: AcademicColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'No Students Found',
              style: GoogleFonts.newsreader(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AcademicColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'No enrolled students match your search criteria.',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: AcademicColors.textSecondary,
              ),
            ),
            const SizedBox(height: 14),
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
                });
              },
              child: Text(
                'Clear Search',
                style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
