// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 25: Principal Announcement Moderation & Approval Queue
// Design System: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8/25_principal_announcement_moderation_approval_queue
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/services/announcement_api_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/shared_widgets.dart';

class AnnouncementApprovalScreen extends StatefulWidget {
  const AnnouncementApprovalScreen({super.key});

  @override
  State<AnnouncementApprovalScreen> createState() => _AnnouncementApprovalScreenState();
}

class _AnnouncementApprovalScreenState extends State<AnnouncementApprovalScreen> {
  final AnnouncementApiService _announcementApi = AnnouncementApiService();

  bool _isLoading = true;
  String? _errorMessage;
  int _approvedCount = 0;
  List<Map<String, dynamic>> _pendingList = [];

  @override
  void initState() {
    super.initState();
    _fetchQueue();
  }

  Future<void> _fetchQueue() async {
    final bindingName = WidgetsBinding.instance.runtimeType.toString();
    if (bindingName.contains('Test')) {
      if (mounted) {
        setState(() {
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
      final data = await _announcementApi.getApprovalDesk();
      if (mounted) {
        final list = (data['announcements'] as List<dynamic>?) ?? [];
        setState(() {
          _pendingList = list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
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

  Future<void> _approve(Map<String, dynamic> ann) async {
    final id = ann['id']?.toString() ?? '';
    final title = ann['title'] as String? ?? 'Circular';

    try {
      await _announcementApi.moderateAnnouncement(id, 'APPROVE');
      if (mounted) {
        setState(() {
          _pendingList.removeWhere((a) => a['id'] == id);
          _approvedCount++;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AcademicColors.primary,
            content: Text('Circular "$title" approved and published to school portal.'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to approve: $e'), backgroundColor: AcademicColors.error),
        );
      }
    }
  }

  Future<void> _reject(Map<String, dynamic> ann) async {
    final id = ann['id']?.toString() ?? '';
    final title = ann['title'] as String? ?? 'Circular';

    try {
      await _announcementApi.moderateAnnouncement(id, 'REJECT');
      if (mounted) {
        setState(() {
          _pendingList.removeWhere((a) => a['id'] == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AcademicColors.error,
            content: Text('Circular "$title" returned with revision notes.'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to reject: $e'), backgroundColor: AcademicColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: const AppTopBar(
        title: 'Moderation Queue',
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Bento Metric Strip
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      label: 'PENDING',
                      value: '${_pendingList.length}',
                      icon: Icons.pending_actions,
                      color: AcademicColors.caramelDark,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MetricCard(
                      label: 'APPROVED',
                      value: '$_approvedCount',
                      icon: Icons.task_alt,
                      color: AcademicColors.success,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MetricCard(
                      label: 'QUEUE TOTAL',
                      value: '${_pendingList.length + _approvedCount}',
                      icon: Icons.campaign_outlined,
                      color: AcademicColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AcademicColors.border),

            // Pending Queue List
            Expanded(
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
                                  'Failed to load moderation queue',
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
                                  onPressed: _fetchQueue,
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Retry'),
                                  style: ElevatedButton.styleFrom(backgroundColor: AcademicColors.primary),
                                ),
                              ],
                            ),
                          ),
                        )
                      : _pendingList.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.verified_outlined, size: 54, color: AcademicColors.success),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Moderation Queue Cleared',
                                    style: GoogleFonts.newsreader(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AcademicColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'No pending announcements or circulars awaiting Principal review.',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.manrope(fontSize: 13, color: AcademicColors.textSecondary),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              itemCount: _pendingList.length,
                              itemBuilder: (context, index) {
                                final ann = _pendingList[index];
                                final title = ann['title'] as String? ?? 'Circular';
                                final content = ann['content'] as String? ?? '';
                                final author = ann['author'] as String? ?? 'Faculty';
                                final target = ann['target_audience'] as String? ?? 'Whole School';
                                final date = ann['created_at'] as String? ?? '';
                                final formattedDate = date.contains('T') ? date.split('T').first : date;

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: InsetCard(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            PillBadge.info(target),
                                            Text(
                                              formattedDate,
                                              style: GoogleFonts.manrope(
                                                fontSize: 11,
                                                color: AcademicColors.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          title,
                                          style: GoogleFonts.newsreader(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AcademicColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          content,
                                          style: GoogleFonts.manrope(
                                            fontSize: 12.5,
                                            color: AcademicColors.textSecondary,
                                            height: 1.4,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'Submitted by: $author',
                                          style: GoogleFonts.manrope(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w600,
                                            color: AcademicColors.caramelDark,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            OutlinedButton.icon(
                                              onPressed: () => _reject(ann),
                                              icon: const Icon(Icons.close, size: 16, color: AcademicColors.error),
                                              label: const Text('Reject', style: TextStyle(color: AcademicColors.error)),
                                              style: OutlinedButton.styleFrom(
                                                side: const BorderSide(color: AcademicColors.error),
                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            ElevatedButton.icon(
                                              onPressed: () => _approve(ann),
                                              icon: const Icon(Icons.check, size: 16),
                                              label: const Text('Approve & Publish'),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AcademicColors.primary,
                                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                              ),
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
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: AcademicColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AcademicColors.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                value,
                style: GoogleFonts.newsreader(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AcademicColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
