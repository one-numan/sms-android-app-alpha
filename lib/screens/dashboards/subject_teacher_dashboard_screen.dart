// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 18c: Subject Teacher Academic Assessment Dashboard
// Design System: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8/18c_subject_teacher_academic_assessment_dashboard
// Strict adherence: No fabricated staff IDs (#FAC-), clean domain fixtures.
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/mock/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/account_profile_sheet.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/shared_widgets.dart';

class SubjectTeacherDashboardScreen extends StatelessWidget {
  const SubjectTeacherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final teacher = MockData.teachers[1]; // Robert Chen (Science Faculty)

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: const AppTopBar(showBrand: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Teacher Greeting Card
              InsetCard(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => AccountProfileSheet.show(context),
                      borderRadius: BorderRadius.circular(10),
                      child: Semantics(
                        label: 'View account profile',
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                color: AcademicColors.primaryDark,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  teacher.name.split(' ').where((n) => n.isNotEmpty).map((n) => n[0]).take(2).join(),
                                  style: GoogleFonts.newsreader(
                                    fontSize: 18,
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
                                    'Good Morning, ${teacher.name}',
                                    style: GoogleFonts.newsreader(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: AcademicColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    '${teacher.subjectSpecialization} Faculty • Senior Department',
                                    style: GoogleFonts.manrope(
                                      fontSize: 11.5,
                                      color: AcademicColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            PillBadge.success('Faculty Active'),
                            const SizedBox(width: 4),
                            const Icon(Icons.chevron_right, size: 18, color: AcademicColors.textSecondary),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Actions row
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AcademicColors.border),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            onPressed: () => context.push('/dashboard/subject-teacher/cohorts'),
                            icon: const Icon(Icons.groups, size: 16, color: AcademicColors.primaryDark),
                            label: Text(
                              'My Classes',
                              style: GoogleFonts.manrope(fontSize: 11.5, fontWeight: FontWeight.bold, color: AcademicColors.textPrimary),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AcademicColors.primaryDark,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            onPressed: () => context.push('/students/marks-entry'),
                            icon: const Icon(Icons.edit_note, size: 16),
                            label: Text(
                              'Enter Marks',
                              style: GoogleFonts.manrope(fontSize: 11.5, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 4 Core Academic KPI Tiles (2x2 Grid)
              Row(
                children: [
                  _buildKpiCard(
                    title: 'My Subjects',
                    value: '02',
                    subtitle: 'Science & Physics',
                    icon: Icons.menu_book,
                  ),
                  const SizedBox(width: 12),
                  _buildKpiCard(
                    title: 'Teaching Classes',
                    value: '03',
                    subtitle: 'Classes 5-A, 5-B, 6-A',
                    icon: Icons.meeting_room,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildKpiCard(
                    title: 'Students Taught',
                    value: '96',
                    subtitle: 'All Classes Assigned',
                    icon: Icons.groups,
                  ),
                  const SizedBox(width: 12),
                  _buildKpiCard(
                    title: 'Grading Status',
                    value: '82%',
                    subtitle: 'Assessments Logged',
                    icon: Icons.analytics_outlined,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Assigned Classes Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ASSIGNED TEACHING CLASSES',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AcademicColors.textSecondary,
                      letterSpacing: 0.8,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push('/dashboard/subject-teacher/cohorts'),
                    child: Text(
                      'View All Classes →',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.secondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              ...MockData.classes.take(2).map((cls) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InsetCard(
                    margin: EdgeInsets.zero,
                    padding: const EdgeInsets.all(14),
                    onTap: () => context.push('/students/marks-entry'),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: AcademicColors.canvas,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              cls.name,
                              style: GoogleFonts.newsreader(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AcademicColors.primaryDark,
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
                                'Class ${cls.name} • Science',
                                style: GoogleFonts.manrope(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AcademicColors.textPrimary,
                                ),
                              ),
                              Text(
                                '32 Enrolled • Formative Assessment 2 Active',
                                style: GoogleFonts.manrope(
                                  fontSize: 11,
                                  color: AcademicColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PillBadge.info('Grade Entry'),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 16),

              // Weekly Teaching Schedule Link Card
              InsetCard(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(16),
                onTap: () => context.push('/faculty/timetable'),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AcademicColors.infoContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.grid_on, color: AcademicColors.info, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Weekly Faculty Timetable Grid',
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.textPrimary,
                            ),
                          ),
                          Text(
                            'View 6-day period distribution across grades',
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              color: AcademicColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, size: 18, color: AcademicColors.textSecondary),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AcademicBottomNavBar.forRole(
        UserRole.subjectTeacher,
        currentIndex: 0,
        context: context,
      ),
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
  }) {
    return Expanded(
      child: InsetCard(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.manrope(fontSize: 10.5, color: AcademicColors.textSecondary),
                ),
                Icon(icon, size: 18, color: AcademicColors.secondary),
              ],
            ),
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
              subtitle,
              style: GoogleFonts.manrope(fontSize: 10.5, color: AcademicColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
