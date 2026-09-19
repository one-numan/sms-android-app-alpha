// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 28: Student Portal / Daily Information Hub
// Connected to Django REST API: GET /api/v1/student/hub/
// Design System: Espresso Heritage Academic
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/services/student_api_service.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/account_profile_sheet.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/shared_widgets.dart';

class StudentHubScreen extends StatefulWidget {
  const StudentHubScreen({super.key});

  @override
  State<StudentHubScreen> createState() => _StudentHubScreenState();
}

class _StudentHubScreenState extends State<StudentHubScreen> {
  final StudentApiService _studentApiService = StudentApiService();
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _hubData;

  @override
  void initState() {
    super.initState();
    _fetchHubData();
  }

  Future<void> _fetchHubData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final data = await _studentApiService.getStudentHub();
      if (mounted) {
        setState(() {
          _hubData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final studentName = _hubData?['student_name'] ?? 'Student';
    final classSection = _hubData?['class_section'] ?? 'Class';
    final rollNo = _hubData?['roll_no']?.toString() ?? '-';
    final double? attendancePct = _hubData?['attendance_percentage'] != null
        ? (_hubData!['attendance_percentage'] as num).toDouble()
        : null;
    final double feeOutstanding = _hubData?['dues'] != null
        ? (_hubData!['dues'] as num).toDouble()
        : 0.0;
    final int openLoans = _hubData?['open_loans'] as int? ?? 0;
    final int overdueLoans = _hubData?['overdue_loans'] as int? ?? 0;

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: const AppTopBar(showBrand: true),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchHubData,
          color: AcademicColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_errorMessage != null)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AcademicColors.dangerContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'API Connection Error: $_errorMessage',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: AcademicColors.danger,
                      ),
                    ),
                  ),

                // 1. Student Identity Card
                _buildIdentityCard(context, studentName, classSection, rollNo),

                const SizedBox(height: 14),

                // 2. Summary Information (Real Backend Data)
                _buildSummaryGrid(
                  context,
                  studentName: studentName,
                  attendancePct: attendancePct,
                  feeOutstanding: feeOutstanding,
                  booksOnLoan: openLoans,
                  overdueBooksCount: overdueLoans,
                ),

                const SizedBox(height: 16),

                // 3. Today's Schedule (Backend Payload)
                _buildScheduleSection(context),

                const SizedBox(height: 16),

                // 4. Quick Actions
                _buildQuickActionsSection(context),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AcademicBottomNavBar.forRole(
        UserRole.student,
        currentIndex: 0,
        context: context,
      ),
    );
  }

  Widget _buildIdentityCard(BuildContext context, String name, String classSec, String rollNo) {
    final initials = name.isNotEmpty ? name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join() : 'ST';
    return InkWell(
      onTap: () => AccountProfileSheet.show(context),
      borderRadius: BorderRadius.circular(12),
      child: Semantics(
        label: 'View account profile',
        child: InsetCard(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AcademicColors.primaryDark,
                      shape: BoxShape.circle,
                      border: Border.all(color: AcademicColors.border, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: GoogleFonts.newsreader(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.accent,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 2,
                    bottom: 2,
                    child: Container(
                      width: 11,
                      height: 11,
                      decoration: BoxDecoration(
                        color: AcademicColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            style: GoogleFonts.newsreader(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const PillBadge(
                          text: 'Active',
                          backgroundColor: AcademicColors.successContainer,
                          textColor: AcademicColors.success,
                          fontSize: 9.5,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$classSec • Roll #$rollNo',
                      style: GoogleFonts.manrope(
                        fontSize: 11.5,
                        color: AcademicColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => context.push('/student/digital-id-sheet'),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: AcademicColors.canvas,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AcademicColors.border),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.badge_outlined, size: 20, color: AcademicColors.primaryDark),
                      const SizedBox(height: 2),
                      Text(
                        'ID CARD',
                        style: GoogleFonts.manrope(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.primaryDark,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryGrid(
    BuildContext context, {
    required String studentName,
    required double? attendancePct,
    required double feeOutstanding,
    required int booksOnLoan,
    required int overdueBooksCount,
  }) {
    final feeFormatted = '₹${feeOutstanding.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';

    return Column(
      children: [
        Row(
          children: [
            _buildKpiCard(
              context,
              title: 'Attendance',
              value: attendancePct != null ? '${attendancePct.toStringAsFixed(1)}%' : 'N/A',
              badge: attendancePct != null
                  ? (attendancePct >= 85 ? 'Good Standing' : 'Below Average')
                  : 'No Records',
              badgeColor: (attendancePct ?? 0) >= 85
                  ? AcademicColors.success
                  : AcademicColors.warning,
              icon: Icons.how_to_reg_outlined,
              iconContainerColor: (attendancePct ?? 0) >= 85
                  ? AcademicColors.successContainer
                  : AcademicColors.warningContainer,
              onTap: () => context.push('/attendance/student/matrix'),
            ),
            const SizedBox(width: 10),
            _buildKpiCard(
              context,
              title: 'Term Result',
              value: 'View Card',
              badge: 'Report Card',
              badgeColor: AcademicColors.warning,
              icon: Icons.workspace_premium_outlined,
              iconContainerColor: AcademicColors.warningContainer,
              onTap: () => context.push('/students/report-card'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildKpiCard(
              context,
              title: 'Outstanding',
              value: feeOutstanding > 0 ? feeFormatted : '₹0',
              badge: feeOutstanding > 0 ? 'Term Due' : 'No Dues',
              badgeColor: feeOutstanding > 0 ? AcademicColors.danger : AcademicColors.success,
              icon: Icons.receipt_long_outlined,
              iconContainerColor: feeOutstanding > 0
                  ? AcademicColors.dangerContainer
                  : AcademicColors.successContainer,
              onTap: () => context.push('/fees/ledger'),
            ),
            const SizedBox(width: 10),
            _buildKpiCard(
              context,
              title: 'Books on Loan',
              value: '$booksOnLoan',
              badge: overdueBooksCount > 0 ? '$overdueBooksCount Overdue' : '0 Overdue',
              badgeColor: overdueBooksCount > 0 ? AcademicColors.danger : AcademicColors.success,
              icon: Icons.local_library_outlined,
              iconContainerColor: AcademicColors.infoContainer,
              onTap: () => context.push('/library/desk'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKpiCard(
    BuildContext context, {
    required String title,
    required String value,
    required String badge,
    required Color badgeColor,
    required IconData icon,
    required Color iconContainerColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: InsetCard(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: iconContainerColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, size: 17, color: badgeColor),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: PillBadge(
                      text: badge,
                      backgroundColor: badgeColor.withValues(alpha: 0.12),
                      textColor: badgeColor,
                      fontSize: 9.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: GoogleFonts.newsreader(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AcademicColors.textPrimary,
                ),
              ),
              Text(
                title,
                style: GoogleFonts.manrope(
                  fontSize: 10.5,
                  color: AcademicColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleSection(BuildContext context) {
    final scheduleList = (_hubData?['todays_schedule'] as List?) ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AcademicColors.warningContainer,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.schedule, size: 14, color: AcademicColors.warning),
            ),
            const SizedBox(width: 8),
            Text(
              "TODAY'S SCHEDULE",
              style: GoogleFonts.manrope(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AcademicColors.textSecondary,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (scheduleList.isEmpty)
          InsetCard(
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.event_busy_outlined, size: 22, color: AcademicColors.textSecondary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "No classes scheduled for today",
                        style: GoogleFonts.manrope(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.textPrimary,
                        ),
                      ),
                      Text(
                        "Weekend or non-instructional day.",
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          color: AcademicColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/faculty/timetable/class'),
                  child: const Text('Timetable →', style: TextStyle(fontSize: 11)),
                ),
              ],
            ),
          )
        else
          ...scheduleList.map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AcademicColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AcademicColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item['subject'] ?? 'Subject',
                    style: GoogleFonts.manrope(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Text(
                    item['time'] ?? '',
                    style: GoogleFonts.manrope(fontSize: 12, color: AcademicColors.textSecondary),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'QUICK SERVICES',
          style: GoogleFonts.manrope(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: AcademicColors.textSecondary,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildActionChip(context, Icons.receipt_long_outlined, 'Fees', () => context.push('/fees/ledger')),
            _buildActionChip(context, Icons.how_to_reg_outlined, 'Attendance', () => context.push('/attendance/student/matrix')),
            _buildActionChip(context, Icons.campaign_outlined, 'Notices', () => context.push('/announcements')),
            _buildActionChip(context, Icons.badge_outlined, 'Digital ID', () => context.push('/student/digital-id-sheet')),
          ],
        ),
      ],
    );
  }

  Widget _buildActionChip(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AcademicColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AcademicColors.border),
            ),
            child: Icon(icon, color: AcademicColors.primaryDark, size: 20),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
