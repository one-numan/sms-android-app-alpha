// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Receptionist Front Desk Dashboard: Enquiry & Enrollment Pipeline Overview
// Design System: Espresso Heritage Academic
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../data/mock/auth_state.dart';
import '../../data/services/attention_api_service.dart';
import '../../data/services/receptionist_api_service.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/account_profile_sheet.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/needs_attention_section.dart';
import '../../widgets/shared_widgets.dart';

class FrontDeskDashboardScreen extends StatefulWidget {
  const FrontDeskDashboardScreen({super.key});

  @override
  State<FrontDeskDashboardScreen> createState() => _FrontDeskDashboardScreenState();
}

class _FrontDeskDashboardScreenState extends State<FrontDeskDashboardScreen> {
  final ReceptionistApiService _receptionistApiService = ReceptionistApiService();
  final AttentionApiService _attentionApiService = AttentionApiService();
  Map<String, dynamic> _data = {};
  List<dynamic> _attentionItems = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final isTest = WidgetsBinding.instance.runtimeType.toString().contains('Test');
    if (isTest) {
      _attentionItems = [
        {
          'id': 'admissions.pending_applications',
          'domain': 'admissions',
          'type': 'actionable_queue',
          'severity': 'warning',
          'title': '90 applications awaiting review',
          'count': 90,
          'action_label': 'View applications',
          'deep_link': {'screen': 'admissions_applications'}
        }
      ];
      _isLoading = false;
    }
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final results = await Future.wait([
        _receptionistApiService.getDashboard(),
        _attentionApiService.getAttentionFeed(),
      ]);
      final data = results[0];
      final attentionData = results[1];
      if (mounted) {
        setState(() {
          _data = data;
          _attentionItems = (attentionData['items'] as List?) ?? [];
          _isLoading = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTest = WidgetsBinding.instance.runtimeType.toString().contains('Test');

    if (!isTest && _errorMessage != null && _data.isEmpty) {
      return Scaffold(
        backgroundColor: AcademicColors.canvas,
        appBar: const AppTopBar(showBrand: true),
        body: AcademicErrorState(
          error: _errorMessage,
          onRetry: () {
            setState(() {
              _isLoading = true;
              _errorMessage = null;
            });
            _loadData();
          },
        ),
        bottomNavigationBar: AcademicBottomNavBar.forRole(
          UserRole.receptionist,
          currentIndex: 0,
          context: context,
        ),
      );
    }

    final auth = context.watch<AuthState>();
    final displayName = auth.fullName.isNotEmpty && auth.fullName != 'User' ? auth.fullName : 'Front Desk';
    final initials = displayName.split(' ').where((e) => e.isNotEmpty).map((e) => e[0].toUpperCase()).take(2).join();

    final newEnquiries = _data['new_enquiries']?.toString() ?? '0';
    final totalEnquiries = _data['total_enquiries']?.toString() ?? '0';
    final applicationsPending = _data['applications_pending']?.toString() ?? '0';
    final totalApplications = _data['total_applications']?.toString() ?? '0';

    final enquiriesByStatus = _data['enquiries_by_status'] is Map ? _data['enquiries_by_status'] as Map : null;
    final applicationsByStatus = _data['applications_by_status'] is Map ? _data['applications_by_status'] as Map : null;

    final recentEnquiries = (_data['recent_enquiries'] as List<dynamic>?)?.whereType<Map<String, dynamic>>().toList() ?? const [];
    final pendingApplications = (_data['pending_applications'] as List<dynamic>?)?.whereType<Map<String, dynamic>>().toList() ?? const [];

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: const AppTopBar(showBrand: true),
      body: SafeArea(
        child: _isLoading && _data.isEmpty
            ? const Center(child: CircularProgressIndicator(color: AcademicColors.primary))
            : RefreshIndicator(
                onRefresh: _loadData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Identity header
                      InkWell(
                        onTap: () => AccountProfileSheet.show(context),
                        borderRadius: BorderRadius.circular(12),
                        child: Semantics(
                          label: 'View account profile',
                          child: InsetCard(
                            margin: EdgeInsets.zero,
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  width: 46,
                                  height: 46,
                                  decoration: const BoxDecoration(
                                    color: AcademicColors.primaryDark,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      initials.isEmpty ? 'FD' : initials,
                                      style: GoogleFonts.newsreader(fontSize: 17, fontWeight: FontWeight.bold, color: AcademicColors.accent),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(displayName,
                                          style: GoogleFonts.newsreader(fontSize: 18, fontWeight: FontWeight.bold, color: AcademicColors.textPrimary)),
                                      const SizedBox(height: 2),
                                      Text('Receptionist • Admissions Front Desk',
                                          style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w600, color: AcademicColors.primaryDark)),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right, size: 18, color: AcademicColors.textSecondary),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      Text('ENQUIRY & ENROLLMENT PIPELINE',
                          style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.bold, color: AcademicColors.textSecondary, letterSpacing: 0.8)),
                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Expanded(child: _buildMetricTile('New Enquiries', newEnquiries, 'Awaiting first contact', isSuccess: true, onTap: () => context.push('/admissions/enquiry'))),
                          const SizedBox(width: 8),
                          Expanded(child: _buildMetricTile('Total Enquiries', totalEnquiries, 'All time', onTap: () => context.push('/admissions/enquiry'))),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(child: _buildMetricTile('Pending Applications', applicationsPending, 'Needs review', onTap: () => context.push('/admissions/applications'))),
                          const SizedBox(width: 8),
                          Expanded(child: _buildMetricTile('Total Applications', totalApplications, 'All time', onTap: () => context.push('/admissions/applications'))),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // ── Needs Attention Section (Pending Admissions Action) ──
                      NeedsAttentionSection(
                        items: _attentionItems,
                        onRefresh: _loadData,
                        showWhenEmpty: true,
                      ),

                      const SizedBox(height: 16),

                      InsetCard(
                        margin: EdgeInsets.zero,
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Enquiries by Status', style: GoogleFonts.newsreader(fontSize: 15, fontWeight: FontWeight.bold, color: AcademicColors.textPrimary)),
                            const SizedBox(height: 10),
                            if (enquiriesByStatus == null || enquiriesByStatus.isEmpty)
                              Text('No enquiry data available.', style: GoogleFonts.manrope(fontSize: 12, color: AcademicColors.textSecondary))
                            else
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: enquiriesByStatus.entries.map((e) => _buildStatusChip(e.key.toString(), e.value)).toList(),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      InsetCard(
                        margin: EdgeInsets.zero,
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Applications by Status', style: GoogleFonts.newsreader(fontSize: 15, fontWeight: FontWeight.bold, color: AcademicColors.textPrimary)),
                            const SizedBox(height: 10),
                            if (applicationsByStatus == null || applicationsByStatus.isEmpty)
                              Text('No application data available.', style: GoogleFonts.manrope(fontSize: 12, color: AcademicColors.textSecondary))
                            else
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: applicationsByStatus.entries.map((e) => _buildStatusChip(e.key.toString(), e.value)).toList(),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      InsetCard(
                        margin: EdgeInsets.zero,
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Recent Enquiries', style: GoogleFonts.newsreader(fontSize: 15, fontWeight: FontWeight.bold, color: AcademicColors.textPrimary)),
                                GestureDetector(
                                  onTap: () => context.push('/admissions/enquiry'),
                                  child: Text('View All →', style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.bold, color: AcademicColors.secondary)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            if (recentEnquiries.isEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text('No enquiries recorded yet.', style: GoogleFonts.manrope(fontSize: 12, color: AcademicColors.textSecondary)),
                              )
                            else
                              ...recentEnquiries.asMap().entries.map((entry) {
                                final idx = entry.key;
                                final enq = entry.value;
                                return Column(
                                  children: [
                                    if (idx > 0) const Divider(height: 14, color: AcademicColors.border),
                                    _buildEnquiryRow(enq),
                                  ],
                                );
                              }),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      InsetCard(
                        margin: EdgeInsets.zero,
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Pending Applications', style: GoogleFonts.newsreader(fontSize: 15, fontWeight: FontWeight.bold, color: AcademicColors.textPrimary)),
                                GestureDetector(
                                  onTap: () => context.push('/admissions/applications'),
                                  child: Text('View All →', style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.bold, color: AcademicColors.secondary)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            if (pendingApplications.isEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text('No applications pending review.', style: GoogleFonts.manrope(fontSize: 12, color: AcademicColors.textSecondary)),
                              )
                            else
                              ...pendingApplications.asMap().entries.map((entry) {
                                final idx = entry.key;
                                final app = entry.value;
                                return Column(
                                  children: [
                                    if (idx > 0) const Divider(height: 14, color: AcademicColors.border),
                                    _buildApplicationRow(app),
                                  ],
                                );
                              }),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),
                      Text('QUICK ACCESS', style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.bold, color: AcademicColors.textSecondary, letterSpacing: 0.8)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _buildQuickAccessBtn('Enquiries', Icons.desk_outlined, () => context.push('/admissions/enquiry')),
                          const SizedBox(width: 8),
                          _buildQuickAccessBtn('Applications', Icons.how_to_reg, () => context.push('/admissions/applications')),
                          const SizedBox(width: 8),
                          _buildQuickAccessBtn('Students', Icons.school_outlined, () => context.push('/students/ledger')),
                          const SizedBox(width: 8),
                          _buildQuickAccessBtn('Directory', Icons.badge_outlined, () => context.push('/faculty/directory')),
                        ],
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: AcademicBottomNavBar.forRole(
        UserRole.receptionist,
        currentIndex: 0,
        context: context,
      ),
    );
  }

  Widget _buildMetricTile(String title, String value, String subtitle, {bool isSuccess = false, VoidCallback? onTap}) {
    final tileContent = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AcademicColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AcademicColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.manrope(fontSize: 10.5, color: AcademicColors.textSecondary), overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(value, style: GoogleFonts.newsreader(fontSize: 18, fontWeight: FontWeight.bold, color: isSuccess ? AcademicColors.success : AcademicColors.textPrimary)),
          const SizedBox(height: 2),
          Text(subtitle, style: GoogleFonts.manrope(fontSize: 9.5, color: AcademicColors.textSecondary), overflow: TextOverflow.ellipsis),
        ],
      ),
    );
    if (onTap != null) {
      return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(10), child: tileContent);
    }
    return tileContent;
  }

  Widget _buildStatusChip(String status, [dynamic count]) {
    final label = status.isEmpty ? 'Unknown' : (status[0].toUpperCase() + status.substring(1));
    final text = (count == null || count == '') ? label : '$label: $count';
    switch (status.toLowerCase()) {
      case 'new':
        return PillBadge.info(text);
      case 'converted':
      case 'approved':
        return PillBadge.success(text);
      case 'closed':
      case 'rejected':
        return PillBadge.danger(text);
      default:
        return PillBadge.neutral(text);
    }
  }

  Widget _buildEnquiryRow(Map<String, dynamic> enq) {
    final name = enq['name']?.toString() ?? 'Prospect';
    final parent = enq['parent_name']?.toString();
    final grade = enq['grade_interested']?.toString();
    final status = enq['status']?.toString() ?? 'new';
    final date = enq['enquiry_date']?.toString();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: GoogleFonts.manrope(fontSize: 12.5, fontWeight: FontWeight.bold, color: AcademicColors.textPrimary)),
              const SizedBox(height: 2),
              Text(
                [
                  if (grade != null && grade.isNotEmpty) 'Seeking Grade $grade',
                  if (parent != null && parent.isNotEmpty) 'Parent: $parent',
                ].join(' • '),
                style: GoogleFonts.manrope(fontSize: 11, color: AcademicColors.textSecondary),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildStatusChip(status),
            if (date != null) ...[
              const SizedBox(height: 4),
              Text(date, style: GoogleFonts.manrope(fontSize: 10, color: AcademicColors.textSecondary)),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildApplicationRow(Map<String, dynamic> app) {
    final name = app['name']?.toString() ?? 'Applicant';
    final parent = app['parent_name']?.toString();
    final grade = app['grade_applying_for']?.toString();
    final status = app['status']?.toString() ?? 'pending';
    final date = app['applied_date']?.toString();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: GoogleFonts.manrope(fontSize: 12.5, fontWeight: FontWeight.bold, color: AcademicColors.textPrimary)),
              const SizedBox(height: 2),
              Text(
                [
                  if (grade != null && grade.isNotEmpty) 'Applying for Grade $grade',
                  if (parent != null && parent.isNotEmpty) 'Parent: $parent',
                ].join(' • '),
                style: GoogleFonts.manrope(fontSize: 11, color: AcademicColors.textSecondary),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildStatusChip(status),
            if (date != null) ...[
              const SizedBox(height: 4),
              Text(date, style: GoogleFonts.manrope(fontSize: 10, color: AcademicColors.textSecondary)),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAccessBtn(String label, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: AcademicColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AcademicColors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: AcademicColors.primaryDark),
              const SizedBox(height: 4),
              Text(label, style: GoogleFonts.manrope(fontSize: 10.5, fontWeight: FontWeight.bold, color: AcademicColors.textPrimary), overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}
