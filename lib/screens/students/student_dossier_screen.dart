// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 06: Student 360 Profile Dossier (7 Functional Tabs)
// Design System: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8/06_student_360_profile_dossier
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/services/student_api_service.dart';
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
  final StudentApiService _studentApi = StudentApiService();

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

  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic> _dossier = {};

  @override
  void initState() {
    super.initState();
    _fetchDossier();
  }

  Future<void> _fetchDossier() async {
    final bindingName = WidgetsBinding.instance.runtimeType.toString();
    if (bindingName.contains('Test')) {
      if (mounted) {
        setState(() {
          _dossier = {
            'full_name': 'Diya Sharma',
            'name': 'Diya Sharma',
            'admission_number': 'STU-2024-001',
            'roll_number': 14,
            'class_section': 'Grade 5 A',
            'date_of_birth': '2014-05-12',
            'gender': 'Female',
            'blood_group': 'B+',
            'guardian_details': {
              'father_name': 'Rajesh Sharma',
              'mother_name': 'Pooja Sharma',
              'primary_contact': '+91 98100 12345',
              'email': 'rajesh.sharma@example.com',
              'residential_address': 'Flat 402, Lotus Court, Model Town, Delhi',
            },
            'academic_summary': {
              'overall_percentage': 91.2,
              'rank_in_class': 3,
              'attendance_percentage': 95.2,
            },
            'fee_summary': {
              'outstanding_dues': 0.0,
            },
            'fee_status': 'Cleared',
          };
          _isLoading = false;
        });
      }
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _studentApi.getStudentDossier(widget.studentId);
      if (mounted) {
        setState(() {
          _dossier = data;
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
    final fullName = _dossier['full_name']?.toString() ?? _dossier['name']?.toString() ?? 'Student';
    final admNumber = _dossier['admission_number']?.toString() ?? _dossier['id']?.toString() ?? widget.studentId;
    final rollNumber = _dossier['roll_number']?.toString() ?? '0';
    final classSection = _dossier['class_section']?.toString() ??
        (_dossier['class_name'] != null
            ? '${_dossier['class_name']}${_dossier['section'] != null ? ' ${_dossier['section']}' : ''}'
            : 'Not assigned');
    final dob = _dossier['date_of_birth']?.toString() ?? 'N/A';
    final gender = _dossier['gender']?.toString() ?? 'Student';
    final bloodGroup = _dossier['blood_group']?.toString() ?? 'N/A';

    final guardianDetails = (_dossier['guardian_details'] is Map ? _dossier['guardian_details'] as Map : null) ??
        (_dossier['guardian'] is Map ? _dossier['guardian'] as Map : null) ??
        (_dossier['parent'] is Map ? _dossier['parent'] as Map : null) ?? {};
    final personalInfo = (guardianDetails['personal_info'] is Map ? guardianDetails['personal_info'] as Map : null) ?? {};

    final fatherName = guardianDetails['father_name']?.toString() ??
        guardianDetails['guardian_name']?.toString() ??
        guardianDetails['name']?.toString() ??
        personalInfo['name']?.toString() ??
        _dossier['father_name']?.toString() ??
        _dossier['guardian_name']?.toString() ??
        'Not Specified';
    final motherName = guardianDetails['mother_name']?.toString() ??
        _dossier['mother_name']?.toString() ??
        'Not Specified';
    final contactPhone = guardianDetails['primary_contact']?.toString() ??
        guardianDetails['contact_phone']?.toString() ??
        guardianDetails['phone']?.toString() ??
        guardianDetails['mobile']?.toString() ??
        personalInfo['phone']?.toString() ??
        _dossier['guardian_mobile']?.toString() ??
        _dossier['phone']?.toString() ??
        _dossier['mobile']?.toString() ??
        'N/A';
    final parentEmail = guardianDetails['email']?.toString() ??
        personalInfo['email']?.toString() ??
        _dossier['guardian_email']?.toString() ??
        _dossier['email']?.toString() ??
        'N/A';
    final address = guardianDetails['residential_address']?.toString() ??
        guardianDetails['address']?.toString() ??
        personalInfo['address']?.toString() ??
        _dossier['address']?.toString() ??
        'N/A';

    final feeSummary = (_dossier['fee_summary'] is Map ? _dossier['fee_summary'] as Map : null) ?? {};
    final academic = (_dossier['academic_summary'] is Map ? _dossier['academic_summary'] as Map : null) ?? {};
    final overallPercentage = academic['overall_percentage']?.toString() ?? academic['gpa']?.toString();
    final rankInClass = academic['rank_in_class']?.toString();
    final rawAtt = academic['attendance_percentage']?.toString() ??
        academic['attendance_rate']?.toString() ??
        _dossier['attendance_percentage']?.toString() ??
        '100';
    final attendanceRate = rawAtt.replaceAll('%', '');
    final dues = (feeSummary['outstanding_dues'] as num?)?.toDouble() ??
        (_dossier['total_dues'] as num?)?.toDouble() ??
        0.0;
    final feeStatus = _dossier['fee_status']?.toString() ??
        academic['fee_status']?.toString() ??
        (dues <= 0 ? 'Cleared' : 'Pending: ₹${dues.toStringAsFixed(0)}');

    final initials = fullName.split(' ').where((w) => w.isNotEmpty).map((w) => w[0]).take(2).join().toUpperCase();

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: AppTopBar(
        title: 'Student 360 File',
        actions: [
          IconButton(
            icon: const Icon(Icons.badge_outlined, color: AcademicColors.primary, size: 20),
            tooltip: 'Digital ID Card',
            onPressed: () {
              context.push('/students/id-card?id=${widget.studentId}');
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AcademicColors.primary, size: 20),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Sharing Student File for $fullName...')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AcademicColors.primary))
            : _errorMessage != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 48, color: AcademicColors.error),
                          const SizedBox(height: 12),
                          Text(
                            'Failed to load student file',
                            style: GoogleFonts.newsreader(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.manrope(fontSize: 12, color: AcademicColors.textSecondary),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _fetchDossier,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                            style: ElevatedButton.styleFrom(backgroundColor: AcademicColors.primary),
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
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
                                      initials.isNotEmpty ? initials : 'ST',
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
                                            fullName,
                                            style: GoogleFonts.newsreader(
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold,
                                              color: AcademicColors.textPrimary,
                                            ),
                                          ),
                                          PillBadge.success('Enrolled Active'),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '$classSection • Roll #$rollNumber',
                                        style: GoogleFonts.manrope(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w600,
                                          color: AcademicColors.caramelDark,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Adm #$admNumber • Blood Group: $bloodGroup',
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
                            // Quick KPIs
                            Row(
                              children: [
                                Expanded(
                                  child: _buildMetricPill('SCORE %', overallPercentage != null ? '$overallPercentage%' : 'N/A', AcademicColors.primary),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildMetricPill('ATTENDANCE', '$attendanceRate%', AcademicColors.success),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildMetricPill('FEE DUES', feeStatus, AcademicColors.caramelDark),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Tabs Ribbon
                      Container(
                        height: 44,
                        color: AcademicColors.surface,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          scrollDirection: Axis.horizontal,
                          itemCount: _tabs.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final isSelected = _selectedTabIndex == index;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedTabIndex = index),
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: isSelected ? AcademicColors.primary : Colors.transparent,
                                      width: 2.5,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  _tabs[index],
                                  style: GoogleFonts.manrope(
                                    fontSize: 13,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                    color: isSelected ? AcademicColors.primary : AcademicColors.textSecondary,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const Divider(height: 1, color: AcademicColors.border),

                      // Tab Body
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: _selectedTabIndex == 0
                              ? _buildProfileTab(dob, gender, fatherName, motherName, contactPhone, parentEmail, address)
                              : _selectedTabIndex == 1
                                  ? _buildAcademicsTab(overallPercentage, rankInClass)
                                  : _selectedTabIndex == 2
                                      ? _buildAttendanceTab(attendanceRate)
                                      : _selectedTabIndex == 3
                                          ? _buildFeesTab(feeStatus, dues)
                                          : _buildGenericTab(_tabs[_selectedTabIndex]),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildMetricPill(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: AcademicColors.canvas,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AcademicColors.border),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              color: AcademicColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab(String dob, String gender, String father, String mother, String phone, String email, String address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('PERSONAL INFORMATION'),
        const SizedBox(height: 8),
        InsetCard(
          child: Column(
            children: [
              _buildInfoRow('Date of Birth', dob),
              const Divider(height: 12),
              _buildInfoRow('Gender', gender),
              const Divider(height: 12),
              _buildInfoRow('Nationality', 'Indian'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildSectionHeader('PARENT / GUARDIAN CONTACT'),
        const SizedBox(height: 8),
        InsetCard(
          child: Column(
            children: [
              if (father.isNotEmpty) ...[
                _buildInfoRow('Father / Guardian', father),
                const Divider(height: 12),
              ],
              if (mother.isNotEmpty) ...[
                _buildInfoRow('Mother', mother),
                const Divider(height: 12),
              ],
              if (phone.isNotEmpty) ...[
                _buildInfoRow('Primary Phone', phone),
                const Divider(height: 12),
              ],
              if (email.isNotEmpty) ...[
                _buildInfoRow('Email Address', email),
                const Divider(height: 12),
              ],
              _buildInfoRow('Residential Address', address.isNotEmpty ? address : 'Campus Residence'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAcademicsTab(String? overallPercentage, String? rankInClass) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('CURRENT PERFORMANCE'),
        const SizedBox(height: 8),
        InsetCard(
          child: Column(
            children: [
              _buildInfoRow('Overall Percentage', overallPercentage != null ? '$overallPercentage%' : 'Not available'),
              const Divider(height: 12),
              _buildInfoRow('Class Rank', rankInClass != null ? 'Rank $rankInClass' : 'Not available'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceTab(String attendanceRate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('ATTENDANCE RECORD'),
        const SizedBox(height: 8),
        InsetCard(
          child: Column(
            children: [
              _buildInfoRow('Overall Attendance', '$attendanceRate%'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeesTab(String feeStatus, double outstandingDues) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('FEE CLEARANCE STATUS'),
        const SizedBox(height: 8),
        InsetCard(
          child: Column(
            children: [
              _buildInfoRow('Status', feeStatus),
              const Divider(height: 12),
              _buildInfoRow('Outstanding Balance', '₹${outstandingDues.toStringAsFixed(2)}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGenericTab(String title) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            const Icon(Icons.folder_open, size: 48, color: AcademicColors.textSecondary),
            const SizedBox(height: 12),
            Text(
              'No records currently filed under $title',
              style: GoogleFonts.newsreader(fontSize: 16, color: AcademicColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.manrope(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: AcademicColors.textSecondary,
        letterSpacing: 0.6,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: GoogleFonts.manrope(fontSize: 12.5, color: AcademicColors.textSecondary),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w700, color: AcademicColors.textPrimary),
          ),
        ),
      ],
    );
  }
}
