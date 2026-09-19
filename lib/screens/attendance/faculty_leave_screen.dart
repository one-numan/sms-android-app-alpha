// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 22: Faculty Leave Application & Balance Tracker
// Design System: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8/22_faculty_leave_application_balance_tracker
// Strictly 4 leave types: Casual Leave, Sick Leave, Earned Leave, Other.
// Zero fabricated employee IDs.
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/mock/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/shared_widgets.dart';

class FacultyLeaveScreen extends StatefulWidget {
  const FacultyLeaveScreen({super.key});

  @override
  State<FacultyLeaveScreen> createState() => _FacultyLeaveScreenState();
}

class _FacultyLeaveScreenState extends State<FacultyLeaveScreen> {
  TeacherLeaveType _selectedType = TeacherLeaveType.casualLeave;
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _submitLeave() {
    if (_reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a reason for the leave request')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Leave requisition submitted to Principal moderation queue'),
        backgroundColor: AcademicColors.success,
      ),
    );
    _reasonController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final teacher = MockData.teachers.first; // Anita Desai

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: AppTopBar(
        title: 'Faculty Leave Management',
        actions: [
          Center(child: PillBadge.info(MockData.session)),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Teacher Identity
              InsetCard(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(14),
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
                          'AD',
                          style: GoogleFonts.newsreader(
                            fontSize: 17,
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
                            style: GoogleFonts.newsreader(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.textPrimary,
                            ),
                          ),
                          Text(
                            '${teacher.subjectSpecialization} Faculty • Class Teacher 5-A',
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              color: AcademicColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PillBadge.success('Staff Active'),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Leave Balance Summary Cards
              Text(
                'ANNUAL LEAVE ENTITLEMENT SUMMARY',
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AcademicColors.textSecondary,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  _buildBalanceTile('Casual (CL)', '8', '3 Days Taken', Icons.event_available),
                  const SizedBox(width: 8),
                  _buildBalanceTile('Sick (SL)', '7', '3 Days Taken', Icons.healing),
                  const SizedBox(width: 8),
                  _buildBalanceTile('Earned (EL)', '14', '1 Day Taken', Icons.work_history),
                ],
              ),

              const SizedBox(height: 20),

              // Leave Requisition Form
              InsetCard(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Submit Leave Requisition',
                      style: GoogleFonts.newsreader(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 14),

                    Text(
                      'Leave Classification',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AcademicColors.canvas,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AcademicColors.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<TeacherLeaveType>(
                          value: _selectedType,
                          isExpanded: true,
                          items: TeacherLeaveType.values.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(
                                type.label,
                                style: GoogleFonts.manrope(fontSize: 13, color: AcademicColors.textPrimary),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedType = val);
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      'Leave Schedule (2 Calendar Days)',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AcademicColors.canvas,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('COMMENCES', style: GoogleFonts.manrope(fontSize: 9, color: AcademicColors.textSecondary)),
                                Text('04 Nov 2026', style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AcademicColors.canvas,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('CONCLUDES', style: GoogleFonts.manrope(fontSize: 9, color: AcademicColors.textSecondary)),
                                Text('05 Nov 2026', style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    Text(
                      'Reason & Substitution Notes',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),

                    TextField(
                      controller: _reasonController,
                      maxLines: 2,
                      style: GoogleFonts.manrope(fontSize: 13),
                      decoration: const InputDecoration(
                        hintText: 'e.g. Attending academic conference; Science periods covered by Robert Chen',
                      ),
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AcademicColors.primaryDark,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: _submitLeave,
                        child: Text(
                          'Submit Requisition to Principal →',
                          style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Requisition History
              Text(
                'LEAVE REQUISITION HISTORY',
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AcademicColors.textSecondary,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 10),

              ...MockData.teacherLeaves.map((l) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InsetCard(
                    margin: EdgeInsets.zero,
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AcademicColors.canvas,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.event_note, color: AcademicColors.primaryDark, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l.type.label,
                                style: GoogleFonts.manrope(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AcademicColors.textPrimary,
                                ),
                              ),
                              Text(
                                '${l.startDate} to ${l.endDate} • ${l.days} Day(s)',
                                style: GoogleFonts.manrope(
                                  fontSize: 11,
                                  color: AcademicColors.textSecondary,
                                ),
                              ),
                              Text(
                                l.reason,
                                style: GoogleFonts.manrope(
                                  fontSize: 10.5,
                                  color: AcademicColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildLeaveStatusBadge(l.status),
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
      bottomNavigationBar: AcademicStickyActionBar(
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AcademicColors.primaryDark,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: _submitLeave,
            icon: const Icon(Icons.send, size: 18),
            label: Text(
              'Submit Leave Requisition →',
              style: GoogleFonts.manrope(fontSize: 13.5, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceTile(String type, String count, String sub, IconData icon) {
    return Expanded(
      child: InsetCard(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  type,
                  style: GoogleFonts.manrope(fontSize: 10.5, fontWeight: FontWeight.bold),
                ),
                Icon(icon, size: 16, color: AcademicColors.secondary),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              count,
              style: GoogleFonts.newsreader(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AcademicColors.primaryDark,
              ),
            ),
            Text(
              sub,
              style: GoogleFonts.manrope(fontSize: 9.5, color: AcademicColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveStatusBadge(LeaveStatus status) {
    switch (status) {
      case LeaveStatus.approved:
        return PillBadge.success('Approved');
      case LeaveStatus.pending:
        return PillBadge.warning('Pending');
      case LeaveStatus.rejected:
        return PillBadge.danger('Rejected');
    }
  }
}
