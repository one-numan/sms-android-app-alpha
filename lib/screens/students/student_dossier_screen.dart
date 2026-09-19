// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 06: Student 360 Profile Dossier (7 Functional Tabs)
// Design System: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8/06_student_360_profile_dossier
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/mock/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/shared_widgets.dart';

class StudentDossierScreen extends StatefulWidget {
  final String studentId;

  const StudentDossierScreen({super.key, required this.studentId});

  @override
  State<StudentDossierScreen> createState() => _StudentDossierScreenState();
}

class _StudentDossierScreenState extends State<StudentDossierScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = [
    'Profile',
    'Academics',
    'Attendance',
    'Fees',
    'Transport',
    'Documents',
    'Awards',
  ];

  @override
  Widget build(BuildContext context) {
    final student = MockData.students.firstWhere(
      (s) => s.id == widget.studentId,
      orElse: () => MockData.students.first,
    );

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: AppTopBar(
        title: 'Student 360 File',
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AcademicColors.primary, size: 20),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing Official Student File...')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Student Master Hero Card
            Container(
              color: AcademicColors.surface,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: AcademicColors.primaryDark,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${student.firstName[0]}${student.lastName[0]}',
                            style: GoogleFonts.newsreader(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.accent,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                Text(
                                  '${student.firstName} ${student.lastName}',
                                  style: GoogleFonts.newsreader(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AcademicColors.textPrimary,
                                  ),
                                ),
                                PillBadge.success('Enrolled'),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Class 5-A • Roll #${student.rollNumber} • Adm #${student.id}',
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                color: AcademicColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'DOB: ${student.dateOfBirth} • Gender: ${student.gender}',
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
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AcademicColors.primaryDark),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          onPressed: () => context.push('/student/digital-id-sheet'),
                          icon: const Icon(Icons.badge_outlined, size: 16, color: AcademicColors.primaryDark),
                          label: Text(
                            'Digital ID Card',
                            style: GoogleFonts.manrope(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.primaryDark,
                            ),
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
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Generating Student File PDF...')),
                            );
                          },
                          icon: const Icon(Icons.download, size: 16),
                          label: Text(
                            'Student File PDF',
                            style: GoogleFonts.manrope(fontSize: 11.5, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Horizontal 7-Tab Bar
            Container(
              color: AcademicColors.surface,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_tabs.length, (idx) {
                    final isSel = _selectedTabIndex == idx;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(_tabs[idx]),
                        selected: isSel,
                        selectedColor: AcademicColors.primaryDark,
                        onSelected: (_) => setState(() => _selectedTabIndex = idx),
                        labelStyle: GoogleFonts.manrope(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: isSel ? Colors.white : AcademicColors.textPrimary,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            const Divider(height: 1, color: AcademicColors.border),

            // Tab Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _buildTabContent(student),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(Student student) {
    switch (_selectedTabIndex) {
      case 0: // Profile
        return Column(
          children: [
            _buildSectionCard(
              'Official Student Information',
              [
                _buildInfoRow('Full Name', '${student.firstName} ${student.lastName}'),
                _buildInfoRow('Date of Birth', student.dateOfBirth),
                _buildInfoRow('Gender', student.gender),
                _buildInfoRow('Admission Date', student.admissionDate),
                _buildInfoRow('Dwelling Type', student.dwellingType),
                _buildInfoRow('House Affiliation', 'Ruby House'),
              ],
            ),
            const SizedBox(height: 12),
            _buildSectionCard(
              'Residential Address',
              [
                _buildInfoRow('Street', student.address.line1),
                _buildInfoRow('District', student.address.district),
                _buildInfoRow('State', student.address.state),
                _buildInfoRow('Pincode', student.address.pincode),
              ],
            ),
          ],
        );
      case 1: // Academics
        return InsetCard(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Term 1 Academic Summary',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.newsreader(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  PillBadge.success('Cumulative 92.4%'),
                ],
              ),
              const SizedBox(height: 12),
              _buildInfoRow('Mathematics', '92 / 100 (Grade A1)'),
              _buildInfoRow('Science', '88 / 100 (Grade A2)'),
              _buildInfoRow('English', '94 / 100 (Grade A1)'),
              _buildInfoRow('Social Studies', '90 / 100 (Grade A1)'),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.push('/student/${student.id}/report-card'),
                  child: const Text('View Full Terminal Report Card →'),
                ),
              ),
            ],
          ),
        );
      case 2: // Attendance
        return InsetCard(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Attendance Standing (Session 2026-27)',
                style: GoogleFonts.newsreader(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AcademicColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              _buildInfoRow('Present Rate', '94.2%'),
              _buildInfoRow('Instructional Days', '140 Total'),
              _buildInfoRow('Days Present', '132 Days'),
              _buildInfoRow('Absences', '8 Days'),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.push('/attendance/student/matrix'),
                  child: const Text('Open 4-State Attendance Matrix →'),
                ),
              ),
            ],
          ),
        );
      case 3: // Fees
        return InsetCard(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fee Realization Ledger (Read-Only)',
                style: GoogleFonts.newsreader(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AcademicColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              _buildInfoRow('Term 1 Dues', '₹15,000.00 (PAID)'),
              _buildInfoRow('Term 2 Dues', '₹12,500.00 (PENDING)'),
              _buildInfoRow('Outstanding Due Date', '15 Oct 2026'),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.push('/fees/ledger'),
                  child: const Text('Open Itemized Fee Ledger →'),
                ),
              ),
            ],
          ),
        );
      case 4: // Transport
        return InsetCard(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Assigned Safe Transit',
                style: GoogleFonts.newsreader(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AcademicColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              _buildInfoRow('Transit Route', 'North Route #4'),
              _buildInfoRow('Vehicle Reg', 'DL-01-AB-1294'),
              _buildInfoRow('Driver Name', 'Surinder Kumar'),
              _buildInfoRow('Morning Pickup', '07:20 AM'),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.push('/transport/route-card'),
                  child: const Text('View Live Route Transit Card →'),
                ),
              ),
            ],
          ),
        );
      case 5: // Documents
        return InsetCard(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Official Verification Documents',
                style: GoogleFonts.newsreader(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AcademicColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              _buildInfoRow('Birth Certificate', 'Verified on File'),
              _buildInfoRow('Transfer Certificate', 'Verified on File'),
              _buildInfoRow('Medical Immunization', 'Blood Group B+'),
            ],
          ),
        );
      default: // Awards
        return InsetCard(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Honors & Commendations',
                style: GoogleFonts.newsreader(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AcademicColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              _buildInfoRow('Scholastic Merit', '1st Rank in Mathematics (2025)'),
              _buildInfoRow('Annual Science Fair', '2nd Position (Junior Wing)'),
            ],
          ),
        );
    }
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return InsetCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.newsreader(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AcademicColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: GoogleFonts.manrope(fontSize: 12, color: AcademicColors.textSecondary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 6,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AcademicColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
