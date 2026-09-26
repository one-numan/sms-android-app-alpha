// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 11: Institutional Attendance Matrix (Principal Executive View & Student Calendar)
// Design System: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8/11_student_monthly_attendance_matrix
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../data/mock/auth_state.dart';
import '../../models/models.dart';
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
    final authState = context.watch<AuthState>();
    final role = authState.currentRole;
    final isExecutiveView = (role == UserRole.principal || role == UserRole.vicePrincipal || role == UserRole.superAdmin);

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: AppTopBar(
        title: isExecutiveView ? 'School-Wide Attendance Matrix' : 'Student Attendance Matrix',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: isExecutiveView
              ? _buildInstitutionalAttendanceMatrix(context)
              : _buildSingleStudentMonthlyCalendar(context, authState),
        ),
      ),
    );
  }

  // Principal / Vice Principal School-Wide Executive Attendance Matrix
  Widget _buildInstitutionalAttendanceMatrix(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Executive Today KPI Banner
        InsetCard(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(16),
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
                          'INSTITUTIONAL ROLL CALL SUMMARY',
                          style: GoogleFonts.manrope(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: AcademicColors.caramelDark,
                          ),
                        ),
                        Text(
                          '26 September 2026',
                          style: GoogleFonts.newsreader(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AcademicColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  PillBadge.success('94.8% Present'),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _buildMetricBox('TOTAL BODY', '10,000', AcademicColors.primary),
                  const SizedBox(width: 8),
                  _buildMetricBox('PRESENT', '9,480', AcademicColors.success),
                  const SizedBox(width: 8),
                  _buildMetricBox('ABSENT', '420', AcademicColors.danger),
                  const SizedBox(width: 8),
                  _buildMetricBox('UNMARKED', '2 Secs', AcademicColors.warning),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Actionable Alert Card: Pending Roll Calls
        InsetCard(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: AcademicColors.warning, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pending Homeroom Submissions',
                      style: GoogleFonts.manrope(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Grade 9-B (Pooja Saxena) & Grade 11-C (Robert Chen)',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        color: AcademicColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pinging class teachers for pending roll call...')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AcademicColors.warning,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                ),
                child: const Text('Ping Teachers', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Grade-Wise Attendance Matrix Table
        _buildSectionHeader('GRADE & SECTION ATTENDANCE BREAKDOWN'),
        const SizedBox(height: 8),
        InsetCard(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              _buildGradeRow('Grade 5', '5-A, 5-B, 5-C, 5-D, 5-E', '175 / 180', '97.2%', AcademicColors.success),
              const Divider(height: 14),
              _buildGradeRow('Grade 10', '10-A, 10-B, 10-C, 10-D, 10-E', '168 / 180', '93.3%', AcademicColors.success),
              const Divider(height: 14),
              _buildGradeRow('Grade 9', '9-A, 9-B (Pending), 9-C, 9-D', '135 / 150', '90.0%', AcademicColors.warning),
              const Divider(height: 14),
              _buildGradeRow('Grade 12', '12-A, 12-B, 12-C, 12-D, 12-E', '172 / 180', '95.5%', AcademicColors.success),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Chronic Low Attendance Alerts (< 75%)
        _buildSectionHeader('CHRONIC ABSENTEEISM ALERT (< 75%)'),
        const SizedBox(height: 8),
        InsetCard(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: AcademicColors.dangerContainer,
                  child: Text('RV', style: TextStyle(color: AcademicColors.danger, fontWeight: FontWeight.bold)),
                ),
                title: Text('Rohan Verma', style: GoogleFonts.newsreader(fontSize: 15, fontWeight: FontWeight.bold)),
                subtitle: const Text('Grade 4-B • Attendance: 68.5% (12 Days Absent)'),
                trailing: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Contacting Sanjay Malhotra (Father)...')),
                    );
                  },
                  child: const Text('Notify Parent', style: TextStyle(fontSize: 11)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricBox(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 8.5,
                fontWeight: FontWeight.bold,
                color: AcademicColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeRow(String grade, String sections, String count, String rate, Color color) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                grade,
                style: GoogleFonts.newsreader(fontSize: 15, fontWeight: FontWeight.bold, color: AcademicColors.textPrimary),
              ),
              Text(
                sections,
                style: GoogleFonts.manrope(fontSize: 11, color: AcademicColors.textSecondary),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            count,
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w600, color: AcademicColors.textPrimary),
          ),
        ),
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                rate,
                style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.bold, color: color),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.manrope(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: AcademicColors.caramelDark,
        letterSpacing: 0.8,
      ),
    );
  }

  // Student / Parent Monthly Attendance Calendar View
  Widget _buildSingleStudentMonthlyCalendar(BuildContext context, AuthState authState) {
    final student = authState.selectedChild;

    return Column(
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
