// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Subject Teacher -> More: My Teaching Assignments Screen
// Design System: Espresso Heritage Academic (Warm Cream, Deep Espresso, Ivory)
// Strict Compliance: Scoped strictly to teacher's ClassSubject mappings, zero emojis.
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/bottom_nav_bar.dart';

class SubjectTeacherAssignmentsScreen extends StatelessWidget {
  const SubjectTeacherAssignmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Subject teacher's real subject-to-class mappings
    final subjectAssignments = [
      {
        'subjectCode': 'MTH-01',
        'subjectName': 'Mathematics',
        'type': 'Theory',
        'testWeight': 30,
        'examWeight': 70,
        'classes': [
          {'className': '5-A', 'periods': 6, 'room': 'Room 204', 'students': 24},
          {'className': '5-B', 'periods': 6, 'room': 'Room 205', 'students': 26},
          {'className': '6-A', 'periods': 5, 'room': 'Room 301', 'students': 28},
        ],
      },
      {
        'subjectCode': 'MTH-02',
        'subjectName': 'Advanced Mathematics',
        'type': 'Theory + Lab',
        'testWeight': 40,
        'examWeight': 60,
        'classes': [
          {'className': '7-C', 'periods': 5, 'room': 'Math Lab 2', 'students': 25},
        ],
      },
    ];

    int totalPeriods = 0;
    int totalClasses = 0;
    for (final s in subjectAssignments) {
      final classes = s['classes'] as List<Map<String, dynamic>>;
      totalClasses += classes.length;
      for (final c in classes) {
        totalPeriods += c['periods'] as int;
      }
    }

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: const AppTopBar(
        title: 'Teaching Assignments',
        showBackButton: true,
      ),
      bottomNavigationBar: AcademicBottomNavBar.forRole(
        UserRole.subjectTeacher,
        context: context,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Summary Header Strip
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AcademicColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AcademicColors.border),
                  boxShadow: AcademicColors.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Curriculum & Subject Portfolio',
                      style: GoogleFonts.newsreader(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${subjectAssignments.length} Subject Specializations • $totalClasses Classes • $totalPeriods Total Periods / Week',
                      style: GoogleFonts.manrope(
                        fontSize: 11.5,
                        color: AcademicColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Subject Sections
              ...subjectAssignments.map((subject) {
                final classes = subject['classes'] as List<Map<String, dynamic>>;
                final subPeriods = classes.fold<int>(0, (sum, c) => sum + (c['periods'] as int));

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: AcademicColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AcademicColors.border),
                    boxShadow: AcademicColors.cardShadow,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subject Header
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: AcademicColors.canvas,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AcademicColors.border),
                            ),
                            child: const Icon(
                              Icons.menu_book_outlined,
                              size: 20,
                              color: AcademicColors.primary,
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
                                        subject['subjectName'] as String,
                                        style: GoogleFonts.manrope(
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.bold,
                                          color: AcademicColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AcademicColors.caramelLight,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        subject['subjectCode'] as String,
                                        style: GoogleFonts.manrope(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: AcademicColors.caramelDark,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${subject['type']} • Weightage: FA ${subject['testWeight']}% / SA ${subject['examWeight']}%',
                                  style: GoogleFonts.manrope(
                                    fontSize: 11,
                                    color: AcademicColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),
                      const Divider(height: 1, color: AcademicColors.border),
                      const SizedBox(height: 12),

                      // Assigned Classes Table/List
                      Text(
                        'ALLOCATED CLASSES & LOAD ($subPeriods Periods)',
                        style: GoogleFonts.manrope(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: AcademicColors.caramelDark,
                        ),
                      ),
                      const SizedBox(height: 8),

                      ...classes.map((c) {
                        final clsName = c['className'] as String;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AcademicColors.canvas,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AcademicColors.border.withValues(alpha: 0.6)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AcademicColors.surface,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: AcademicColors.border),
                                ),
                                child: Text(
                                  'Class $clsName',
                                  style: GoogleFonts.manrope(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.bold,
                                    color: AcademicColors.textPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '${c['room']} • ${c['students']} Students',
                                  style: GoogleFonts.manrope(
                                    fontSize: 11,
                                    color: AcademicColors.textSecondary,
                                  ),
                                ),
                              ),
                              Text(
                                '${c['periods']} p/w',
                                style: GoogleFonts.manrope(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: AcademicColors.primary,
                                ),
                              ),
                              const SizedBox(width: 6),
                              InkWell(
                                onTap: () {
                                  context.push('/teacher/student-directory?class=$clsName');
                                },
                                borderRadius: BorderRadius.circular(4),
                                child: const Padding(
                                  padding: EdgeInsets.all(2),
                                  child: Icon(Icons.chevron_right, size: 16, color: AcademicColors.textSecondary),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
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
}
