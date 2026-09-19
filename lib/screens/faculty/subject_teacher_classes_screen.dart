// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Subject Teacher -> More: My Assigned Classes Screen
// Design System: Espresso Heritage Academic (Warm Cream, Deep Espresso, Ivory)
// Strict Compliance: Scoped strictly to teacher's subject allocations, zero emojis.
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/bottom_nav_bar.dart';

class SubjectTeacherClassesScreen extends StatelessWidget {
  const SubjectTeacherClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Subject teacher's real assigned classes
    final assignedClasses = [
      {
        'grade': '5',
        'section': 'A',
        'className': '5-A',
        'subject': 'Mathematics',
        'students': 24,
        'periodsPerWeek': 6,
        'type': 'Theory',
        'room': 'Room 204',
      },
      {
        'grade': '5',
        'section': 'B',
        'className': '5-B',
        'subject': 'Mathematics',
        'students': 26,
        'periodsPerWeek': 6,
        'type': 'Theory',
        'room': 'Room 205',
      },
      {
        'grade': '6',
        'section': 'A',
        'className': '6-A',
        'subject': 'Mathematics',
        'students': 28,
        'periodsPerWeek': 5,
        'type': 'Theory',
        'room': 'Room 301',
      },
      {
        'grade': '7',
        'section': 'C',
        'className': '7-C',
        'subject': 'Advanced Mathematics',
        'students': 25,
        'periodsPerWeek': 5,
        'type': 'Theory + Lab',
        'room': 'Math Lab 2',
      },
    ];

    final totalStudents = assignedClasses.fold<int>(0, (sum, c) => sum + (c['students'] as int));
    final totalPeriods = assignedClasses.fold<int>(0, (sum, c) => sum + (c['periodsPerWeek'] as int));

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: const AppTopBar(
        title: 'My Classes',
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
              // Hero Summary Card
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Subject Faculty Classes',
                                style: GoogleFonts.newsreader(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AcademicColors.textPrimary,
                                ),
                              ),
                              Text(
                                '${assignedClasses.length} Assigned Sections • Session 2026–27',
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
                            'Active',
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Divider(height: 1, color: AcademicColors.border),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricMini(
                            label: 'Total Students',
                            value: '$totalStudents',
                            icon: Icons.groups_outlined,
                          ),
                        ),
                        Container(width: 1, height: 32, color: AcademicColors.border),
                        Expanded(
                          child: _buildMetricMini(
                            label: 'Weekly Load',
                            value: '$totalPeriods Periods',
                            icon: Icons.schedule_outlined,
                          ),
                        ),
                        Container(width: 1, height: 32, color: AcademicColors.border),
                        Expanded(
                          child: _buildMetricMini(
                            label: 'Class Count',
                            value: '${assignedClasses.length} Classes',
                            icon: Icons.meeting_room_outlined,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Section Header
              Text(
                'ASSIGNED CLASSES & SECTIONS',
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AcademicColors.caramelDark,
                ),
              ),
              const SizedBox(height: 10),

              // Class Cards List
              ...assignedClasses.map((item) {
                final clsName = item['className'] as String;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: AcademicColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AcademicColors.border),
                    boxShadow: AcademicColors.cardShadow,
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AcademicColors.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                clsName,
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
                                  'Grade ${item['grade']} • Section ${item['section']}',
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AcademicColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Subject: ${item['subject']} • ${item['room']}',
                                  style: GoogleFonts.manrope(
                                    fontSize: 11.5,
                                    color: AcademicColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AcademicColors.canvas,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AcademicColors.border),
                            ),
                            child: Text(
                              '${item['students']} Students',
                              style: GoogleFonts.manrope(
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                color: AcademicColors.caramelDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1, color: AcademicColors.border),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.schedule, size: 14, color: AcademicColors.textSecondary),
                              const SizedBox(width: 4),
                              Text(
                                '${item['periodsPerWeek']} Periods / Week',
                                style: GoogleFonts.manrope(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AcademicColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              context.push('/teacher/student-directory?class=$clsName');
                            },
                            borderRadius: BorderRadius.circular(6),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              child: Row(
                                children: [
                                  Text(
                                    'View Students',
                                    style: GoogleFonts.manrope(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.bold,
                                      color: AcademicColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  const Icon(Icons.chevron_right, size: 14, color: AcademicColors.primary),
                                ],
                              ),
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

  Widget _buildMetricMini({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, size: 16, color: AcademicColors.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AcademicColors.textPrimary,
          ),
        ),
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
}
