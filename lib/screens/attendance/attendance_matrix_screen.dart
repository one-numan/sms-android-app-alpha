// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 11: Student Monthly Attendance Matrix (4-State P/A/L/E Calendar)
// Design System: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8/11_student_monthly_attendance_matrix
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../data/mock/auth_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/shared_widgets.dart';

class AttendanceMatrixScreen extends StatefulWidget {
  const AttendanceMatrixScreen({super.key});

  @override
  State<AttendanceMatrixScreen> createState() => _AttendanceMatrixScreenState();
}

class _AttendanceMatrixScreenState extends State<AttendanceMatrixScreen> {
  int _selectedDay = 24;

  @override
  Widget build(BuildContext context) {
    final student = context.watch<AuthState>().selectedChild;

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: const AppTopBar(
        title: 'Attendance Matrix',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Student Capsule
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
                          'DS',
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
                            '${student.firstName} ${student.lastName}',
                            style: GoogleFonts.newsreader(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Grade 5-A • Roll #${student.rollNumber} • Adm #${student.id}',
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              color: AcademicColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PillBadge.success('Good Standing'),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Month Selector & 4-State Ribbon
              InsetCard(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Month Navigation Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.chevron_left, color: AcademicColors.textSecondary),
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.calendar_month, color: AcademicColors.primaryDark, size: 20),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  'October 2026',
                                  style: GoogleFonts.newsreader(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AcademicColors.textPrimary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: AcademicColors.textSecondary),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // 4-State Badges
                    Row(
                      children: [
                        _buildStatePill('21', 'Present (P)', AcademicColors.success),
                        const SizedBox(width: 6),
                        _buildStatePill('01', 'Absent (A)', AcademicColors.danger),
                        const SizedBox(width: 6),
                        _buildStatePill('01', 'Late (L)', AcademicColors.warning),
                        const SizedBox(width: 6),
                        _buildStatePill('00', 'On Leave (E)', AcademicColors.info),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Day Labels
                    Row(
                      children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((d) {
                        return Expanded(
                          child: Text(
                            d,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.textSecondary,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 8),

                    // Calendar Days Grid (31 Days)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                        childAspectRatio: 0.92,
                      ),
                      itemCount: 31,
                      itemBuilder: (context, index) {
                        final day = index + 1;
                        final isSun = (day % 7) == 0;
                        final isSelected = _selectedDay == day;

                        Color bg = AcademicColors.successContainer;
                        Color textC = AcademicColors.success;
                        String statusLetter = 'P';

                        if (isSun) {
                          bg = AcademicColors.canvas;
                          textC = AcademicColors.textSecondary;
                          statusLetter = '-';
                        } else if (day == 14) {
                          bg = AcademicColors.dangerContainer;
                          textC = AcademicColors.danger;
                          statusLetter = 'A';
                        } else if (day == 8) {
                          bg = AcademicColors.warningContainer;
                          textC = AcademicColors.warning;
                          statusLetter = 'L';
                        }

                        return GestureDetector(
                          onTap: () => setState(() => _selectedDay = day),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected ? AcademicColors.primaryDark : bg,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected ? AcademicColors.primaryDark : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$day',
                                  style: GoogleFonts.manrope(
                                    fontSize: 10.5,
                                    height: 1.1,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? Colors.white : textC,
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  statusLetter,
                                  style: GoogleFonts.manrope(
                                    fontSize: 8.5,
                                    height: 1.1,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? Colors.white70 : textC,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Selected Day Detailed Card
              InsetCard(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AcademicColors.successContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'P',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AcademicColors.success,
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
                            '$_selectedDay October 2026 • Present',
                            style: GoogleFonts.manrope(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.textPrimary,
                            ),
                          ),
                          Text(
                            '07:48 AM Check-in • Homeroom 5-A Roll Call Verified',
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              color: AcademicColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PillBadge.success('Verified'),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatePill(String count, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: GoogleFonts.newsreader(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(fontSize: 8.5, fontWeight: FontWeight.w600, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
