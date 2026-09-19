// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Class Teacher -> More: Class Information Screen
// Design System: Espresso Heritage Academic (Warm Cream, Deep Espresso, Ivory)
// Strict Compliance: Pure domain models, zero fabricated IDs, zero emojis.
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/mock/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/bottom_nav_bar.dart';

class ClassInfoScreen extends StatelessWidget {
  final String? classNameOverride;

  const ClassInfoScreen({super.key, this.classNameOverride});

  @override
  Widget build(BuildContext context) {
    // Resolve logged in teacher & class context
    final teacher = MockData.teachers.first; // Anita Desai
    final className = classNameOverride ?? '5-A';

    final schoolClass = MockData.classes.firstWhere(
      (c) => c.className == className,
      orElse: () => SchoolClass(
        id: 'C-5A',
        grade: '5',
        section: 'A',
        className: '5-A',
        classTeacherName: teacher.name,
      ),
    );

    // Resolve class students
    final classStudents = MockData.students.where((s) {
      return (s.grade == schoolClass.grade || s.grade == '5') &&
          (s.section == schoolClass.section || s.section == 'A');
    }).toList();

    // Subject assignments for Grade 5-A
    final classSubjectAssignments = [
      {'subject': 'Mathematics', 'teacher': teacher.name, 'type': 'Theory', 'periods': '6 / week', 'isLead': true},
      {'subject': 'General Science', 'teacher': 'Rahul Kumar', 'type': 'Theory + Lab', 'periods': '5 / week', 'isLead': false},
      {'subject': 'English Language', 'teacher': 'Meenakshi Sharma', 'type': 'Theory', 'periods': '5 / week', 'isLead': false},
      {'subject': 'Hindi Literature', 'teacher': 'Sunita Mehra', 'type': 'Theory', 'periods': '4 / week', 'isLead': false},
      {'subject': 'Social Studies', 'teacher': 'Vikram Batra', 'type': 'Theory', 'periods': '4 / week', 'isLead': false},
      {'subject': 'Computer Science', 'teacher': 'Robert Chen', 'type': 'Practical', 'periods': '3 / week', 'isLead': false},
      {'subject': 'Physical Education', 'teacher': 'Suresh Gupta', 'type': 'Activity', 'periods': '2 / week', 'isLead': false},
      {'subject': 'Art & Craft', 'teacher': 'Pooja Saxena', 'type': 'Activity', 'periods': '1 / week', 'isLead': false},
    ];

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: const AppTopBar(
        title: 'Class Information',
        showBackButton: true,
      ),
      bottomNavigationBar: AcademicBottomNavBar.forRole(
        UserRole.classTeacher,
        context: context,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Class Header Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AcademicColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AcademicColors.border),
                  boxShadow: AcademicColors.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: AcademicColors.primary,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              schoolClass.className,
                              style: GoogleFonts.newsreader(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AcademicColors.accent,
                              ),
                            ),
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
                            'Session 2026–27',
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AcademicColors.caramelDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Grade ${schoolClass.grade} • Section ${schoolClass.section}',
                      style: GoogleFonts.newsreader(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AcademicColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Primary Academic Wing • Room 204 • North Campus',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: AcademicColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Divider(height: 1, color: AcademicColors.border),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.person_outline, size: 16, color: AcademicColors.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Class Teacher: ${schoolClass.classTeacherName}',
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AcademicColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Metrics Overview Grid
              Row(
                children: [
                  Expanded(
                    child: _buildMetricTile(
                      label: 'Enrolled Strength',
                      value: '${classStudents.isEmpty ? 24 : classStudents.length}',
                      unit: 'Students',
                      icon: Icons.groups_outlined,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildMetricTile(
                      label: 'Active Subjects',
                      value: '${classSubjectAssignments.length}',
                      unit: 'Subjects',
                      icon: Icons.menu_book_outlined,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildMetricTile(
                      label: 'Weekly Load',
                      value: '30',
                      unit: 'Periods',
                      icon: Icons.schedule_outlined,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Quick Class Shortcuts
              Text(
                'CLASS UTILITIES',
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AcademicColors.caramelDark,
                ),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      context,
                      label: 'Student List',
                      subtitle: '${classStudents.isEmpty ? 24 : classStudents.length} Students',
                      icon: Icons.contacts_outlined,
                      onTap: () => context.push('/teacher/class-students'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildActionButton(
                      context,
                      label: 'Class Subjects',
                      subtitle: '${classSubjectAssignments.length} Assigned',
                      icon: Icons.assignment_outlined,
                      onTap: () => context.push('/teacher/class-subjects'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Subject Teachers List Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'SUBJECT FACULTY LIST',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: AcademicColors.caramelDark,
                    ),
                  ),
                  Text(
                    '${classSubjectAssignments.length} Subjects',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      color: AcademicColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Subject Faculty Cards List
              ...classSubjectAssignments.map((assignment) {
                final isLead = assignment['isLead'] == true;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AcademicColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isLead ? AcademicColors.caramelDark.withValues(alpha: 0.4) : AcademicColors.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: isLead ? AcademicColors.primary : AcademicColors.canvas,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AcademicColors.border),
                        ),
                        child: Icon(
                          isLead ? Icons.star_border : Icons.menu_book_outlined,
                          size: 18,
                          color: isLead ? AcademicColors.accent : AcademicColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    assignment['subject'] as String,
                                    style: GoogleFonts.manrope(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.bold,
                                      color: AcademicColors.textPrimary,
                                    ),
                                  ),
                                ),
                                if (isLead) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                    decoration: BoxDecoration(
                                      color: AcademicColors.caramelLight,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'You (Lead)',
                                      style: GoogleFonts.manrope(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.bold,
                                        color: AcademicColors.caramelDark,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Teacher: ${assignment['teacher']}',
                              style: GoogleFonts.manrope(
                                fontSize: 11.5,
                                color: AcademicColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            assignment['periods'] as String,
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AcademicColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            assignment['type'] as String,
                            style: GoogleFonts.manrope(
                              fontSize: 10,
                              color: AcademicColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required String unit,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AcademicColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AcademicColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AcademicColors.primary),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.newsreader(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AcademicColors.textPrimary,
            ),
          ),
          Text(
            unit,
            style: GoogleFonts.manrope(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: AcademicColors.caramelDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AcademicColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AcademicColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AcademicColors.canvas,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: AcademicColors.primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.manrope(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.textPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
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
        ),
      ),
    );
  }
}
