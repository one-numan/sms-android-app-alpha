// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 31: Principal Admissions Applications & Enrollment Desk
// Design System: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8/principal_admissions_applications_enrollment_desk
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/mock/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/shared_widgets.dart';

class ApplicationsEnrollmentScreen extends StatefulWidget {
  const ApplicationsEnrollmentScreen({super.key});

  @override
  State<ApplicationsEnrollmentScreen> createState() => _ApplicationsEnrollmentScreenState();
}

class _ApplicationsEnrollmentScreenState extends State<ApplicationsEnrollmentScreen> {
  String _selectedFilter = 'All';
  String _searchQuery = '';
  late List<AdmissionsApplication> _applications;

  final List<String> _filters = ['All', 'Submitted', 'Under Review', 'Accepted', 'Enrolled'];

  @override
  void initState() {
    super.initState();
    _applications = List.from(MockData.applications);
  }

  void _updateApplicationStatus(AdmissionsApplication app, ApplicationStatus newStatus) {
    setState(() {
      final index = _applications.indexWhere((a) => a.id == app.id);
      if (index != -1) {
        _applications[index] = AdmissionsApplication(
          id: app.id,
          applicantName: app.applicantName,
          gradeApplyingFor: app.gradeApplyingFor,
          parentName: app.parentName,
          parentPhone: app.parentPhone,
          submissionDate: app.submissionDate,
          status: newStatus,
          score: app.score,
        );
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AcademicColors.primary,
        content: Text('Application ${app.id} updated to ${newStatus.name.toUpperCase()}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _applications.where((app) {
      final matchesQuery = _searchQuery.isEmpty ||
          app.applicantName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          app.parentName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          app.gradeApplyingFor.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          app.id.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesFilter = _selectedFilter == 'All' ||
          (_selectedFilter == 'Submitted' && app.status == ApplicationStatus.submitted) ||
          (_selectedFilter == 'Under Review' && app.status == ApplicationStatus.underReview) ||
          (_selectedFilter == 'Accepted' && app.status == ApplicationStatus.accepted) ||
          (_selectedFilter == 'Enrolled' && app.status == ApplicationStatus.enrolled);

      return matchesQuery && matchesFilter;
    }).toList();

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: AppTopBar(
        title: 'Admissions & Enrollment Desk',
        actions: [
          Center(child: PillBadge.success('Phase 1 Active')),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 2x2 Bento Metrics Grid
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _StatTile(
                          label: 'Total Filed',
                          count: '${_applications.length + 140}',
                          icon: Icons.folder_open_outlined,
                          color: AcademicColors.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: _StatTile(
                          label: 'Doc Verification',
                          count: '24',
                          icon: Icons.assignment_late_outlined,
                          color: AcademicColors.caramelDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Expanded(
                        child: _StatTile(
                          label: 'Cleared Entrance',
                          count: '86',
                          icon: Icons.verified_outlined,
                          color: AcademicColors.info,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _StatTile(
                          label: 'Seats Enrolled',
                          count: '38',
                          icon: Icons.how_to_reg_outlined,
                          color: AcademicColors.success,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Search applicant name, ID, or grade...',
                  hintStyle: GoogleFonts.manrope(fontSize: 13, color: AcademicColors.textSecondary),
                  prefixIcon: const Icon(Icons.search, size: 20, color: AcademicColors.textSecondary),
                  filled: true,
                  fillColor: AcademicColors.surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AcademicColors.border),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Filter Chips Ribbon
            Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final f = _filters[index];
                  final isSelected = _selectedFilter == f;
                  return ChoiceChip(
                    label: Text(f),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedFilter = f),
                    selectedColor: AcademicColors.primary,
                    backgroundColor: AcademicColors.surface,
                    labelStyle: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AcademicColors.textPrimary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: isSelected ? AcademicColors.primary : AcademicColors.border),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            // Applications List
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        'No applications found',
                        style: GoogleFonts.newsreader(fontSize: 16, color: AcademicColors.textSecondary),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final app = filtered[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: InsetCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          app.applicantName,
                                          style: GoogleFonts.newsreader(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: AcademicColors.textPrimary,
                                          ),
                                        ),
                                        Text(
                                          'ID: ${app.id} • Applied for ${app.gradeApplyingFor}',
                                          style: GoogleFonts.manrope(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: AcademicColors.caramelDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                    _buildStatusBadge(app.status),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Parent: ${app.parentName}',
                                      style: GoogleFonts.manrope(
                                        fontSize: 12,
                                        color: AcademicColors.textSecondary,
                                      ),
                                    ),
                                    Text(
                                      'Assessment Score: ${app.score ?? "Pending"}',
                                      style: GoogleFonts.manrope(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AcademicColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 16, color: AcademicColors.border),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Filed: ${app.submissionDate}',
                                      style: GoogleFonts.manrope(
                                        fontSize: 11,
                                        color: AcademicColors.textSecondary,
                                      ),
                                    ),
                                    PopupMenuButton<ApplicationStatus>(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AcademicColors.canvas,
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: AcademicColors.border),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Action',
                                              style: GoogleFonts.manrope(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: AcademicColors.primary,
                                              ),
                                            ),
                                            const Icon(Icons.arrow_drop_down, size: 16, color: AcademicColors.primary),
                                          ],
                                        ),
                                      ),
                                      onSelected: (status) => _updateApplicationStatus(app, status),
                                      itemBuilder: (ctx) => [
                                        const PopupMenuItem(
                                          value: ApplicationStatus.underReview,
                                          child: Text('Mark Under Review'),
                                        ),
                                        const PopupMenuItem(
                                          value: ApplicationStatus.accepted,
                                          child: Text('Approve for Admission'),
                                        ),
                                        const PopupMenuItem(
                                          value: ApplicationStatus.enrolled,
                                          child: Text('Confirm Enrollment'),
                                        ),
                                        const PopupMenuItem(
                                          value: ApplicationStatus.rejected,
                                          child: Text('Reject Application'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.submitted:
        return PillBadge.secondary('Submitted');
      case ApplicationStatus.underReview:
        return PillBadge.warning('Under Review');
      case ApplicationStatus.accepted:
        return PillBadge.info('Accepted');
      case ApplicationStatus.enrolled:
        return PillBadge.success('Enrolled');
      case ApplicationStatus.rejected:
        return PillBadge.secondary('Rejected');
      default:
        return PillBadge.secondary('Submitted');
    }
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String count;
  final IconData icon;
  final Color color;

  const _StatTile({
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AcademicColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AcademicColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.manrope(fontSize: 10, color: AcademicColors.textSecondary),
                ),
                Text(
                  count,
                  style: GoogleFonts.newsreader(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AcademicColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
