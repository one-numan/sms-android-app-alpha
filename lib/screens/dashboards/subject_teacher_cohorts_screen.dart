// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 18d: Subject Teacher My Classes & Student Roster
// Design System: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8/18d_subject_teacher_my_classes_student_cohorts_roster
// Strict adherence: No fabricated staff IDs, no room fields, pure domain models.
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
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/shared_widgets.dart';

class SubjectTeacherCohortsScreen extends StatelessWidget {
  const SubjectTeacherCohortsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final teacher = MockData.teachers[1]; // Robert Chen

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: const AppTopBar(
        title: 'My Classes',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Teacher & Subject Strip
              InsetCard(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(14),
                child: Row(
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
                          'RC',
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
                            teacher.name,
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.textPrimary,
                            ),
                          ),
                          Text(
                            '${teacher.subjectSpecialization} Faculty • Senior Department',
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
              ),

              const SizedBox(height: 14),

              // Allocation Summary Grid (3 columns)
              Row(
                children: [
                  _buildSummaryBox('03', 'Assigned Classes'),
                  const SizedBox(width: 8),
                  _buildSummaryBox('96', 'Total Students'),
                  const SizedBox(width: 8),
                  _buildSummaryBox('18', 'Periods / Week'),
                ],
              ),

              const SizedBox(height: 18),

              Text(
                'ASSIGNED TEACHING CLASSES',
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AcademicColors.textSecondary,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 10),

              // Class List
              ...MockData.classes.map((cls) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InsetCard(
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
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: AcademicColors.primaryDark,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      cls.name,
                                      style: GoogleFonts.newsreader(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Class ${cls.name} • Science',
                                      style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AcademicColors.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      'Academic Year 2026–27',
                                      style: GoogleFonts.manrope(
                                        fontSize: 11,
                                        color: AcademicColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            PillBadge.success('32 Enrolled'),
                          ],
                        ),

                        const SizedBox(height: 14),

                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AcademicColors.canvas,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildMetricItem('Attendance', '96.2%'),
                              _buildMetricItem('Avg Score', '78.4%'),
                              _buildMetricItem('FA2 Status', 'In Progress'),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: AcademicColors.border),
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                ),
                                onPressed: () => context.push('/students/all-students'),
                                child: Text(
                                  'Student List',
                                  style: GoogleFonts.manrope(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.bold,
                                    color: AcademicColors.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AcademicColors.primaryDark,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                ),
                                onPressed: () => context.push('/academics/marks/entry-desk'),
                                child: Text(
                                  'Enter Marks →',
                                  style: GoogleFonts.manrope(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AcademicBottomNavBar.forRole(
        auth.currentRole,
        currentIndex: auth.currentRole == UserRole.subjectTeacher ? 1 : 2,
        context: context,
      ),
    );
  }

  Widget _buildSummaryBox(String value, String label) {
    return Expanded(
      child: InsetCard(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.newsreader(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AcademicColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(fontSize: 10, color: AcademicColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(String label, String val) {
    return Column(
      children: [
        Text(
          val,
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AcademicColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.manrope(fontSize: 10, color: AcademicColors.textSecondary),
        ),
      ],
    );
  }
}
