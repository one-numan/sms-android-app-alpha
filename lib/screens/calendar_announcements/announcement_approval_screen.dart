// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 25: Principal Announcement Moderation & Approval Queue
// Design System: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8/25_principal_announcement_moderation_approval_queue
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/mock/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/shared_widgets.dart';

class AnnouncementApprovalScreen extends StatefulWidget {
  const AnnouncementApprovalScreen({super.key});

  @override
  State<AnnouncementApprovalScreen> createState() => _AnnouncementApprovalScreenState();
}

class _AnnouncementApprovalScreenState extends State<AnnouncementApprovalScreen> {
  late List<Announcement> _pendingList;
  int _approvedCount = 14;

  @override
  void initState() {
    super.initState();
    _pendingList = [
      const Announcement(
        id: 'MOD-01',
        postType: 'Circular',
        title: 'CBSE Secondary Board Practical Examination Schedule',
        body: 'Grade 10 and Grade 12 students are hereby notified that internal practical examinations for Science and Computer Science will commence from 24th November 2026. Detailed class lists are affixed.',
        author: 'Vice Principal',
        status: AnnouncementStatus.pending,
        isPinned: true,
        audience: 'Senior Secondary (Grades 10 & 12)',
        publishedAt: '2026-11-12',
      ),
      const Announcement(
        id: 'MOD-02',
        postType: 'Academic Notice',
        title: 'Inter-House English Debate & Elocution Prelims',
        body: 'Auditions for the Inter-House Literary Championship will be held during the 5th and 6th periods on Friday. House masters must submit nominations by Thursday 2 PM.',
        author: 'Head of English Dept.',
        status: AnnouncementStatus.pending,
        isPinned: false,
        audience: 'All Students (Grades 6-12)',
        publishedAt: '2026-11-14',
      ),
      const Announcement(
        id: 'MOD-03',
        postType: 'Circular',
        title: 'Revised Winter Uniform Directive 2026-27',
        body: 'With drop in morning temperatures, all students from Nursery to Grade 12 must transition to official navy blazers and winter pullover as per institutional dress code guidelines starting next Monday.',
        author: 'Administrative Officer',
        status: AnnouncementStatus.pending,
        isPinned: false,
        audience: 'All Students & Parents',
        publishedAt: '2026-11-15',
      ),
    ];
  }

  void _approve(Announcement ann) {
    setState(() {
      _pendingList.removeWhere((a) => a.id == ann.id);
      _approvedCount++;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AcademicColors.primary,
        content: Text('Circular "${ann.title}" approved and published to school portal.'),
      ),
    );
  }

  void _reject(Announcement ann) {
    setState(() {
      _pendingList.removeWhere((a) => a.id == ann.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AcademicColors.error,
        content: Text('Circular "${ann.title}" returned with revision notes.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: AppTopBar(
        title: 'Moderation Queue',
        actions: [
          Center(child: PillBadge.warning('${_pendingList.length} Awaiting Review')),
          const SizedBox(width: 8),
        ],
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
                      label: 'ACTIVE LIVE',
                      value: '${MockData.announcements.length}',
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
              child: _pendingList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.verified_outlined, size: 54, color: AcademicColors.success),
                          const SizedBox(height: 12),
                          Text(
                            'All Circulars Reviewed',
                            style: GoogleFonts.newsreader(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'The moderation queue is currently clear.',
                            style: GoogleFonts.manrope(fontSize: 13, color: AcademicColors.textSecondary),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _pendingList.length,
                      itemBuilder: (context, index) {
                        final item = _pendingList[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: InsetCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    PillBadge.secondary(item.postType),
                                    Text(
                                      'Submitted: ${item.publishedAt}',
                                      style: GoogleFonts.manrope(fontSize: 11, color: AcademicColors.textSecondary),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item.title,
                                  style: GoogleFonts.newsreader(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: AcademicColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item.body,
                                  style: GoogleFonts.manrope(
                                    fontSize: 13,
                                    color: AcademicColors.textPrimary,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(Icons.person_outline, size: 14, color: AcademicColors.textSecondary),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Author: ${item.author}',
                                      style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w600, color: AcademicColors.textSecondary),
                                    ),
                                    const SizedBox(width: 12),
                                    const Icon(Icons.group_outlined, size: 14, color: AcademicColors.textSecondary),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        item.audience,
                                        style: GoogleFonts.manrope(fontSize: 12, color: AcademicColors.textSecondary),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 20, color: AcademicColors.border),

                                // Action Buttons: Approve / Reject
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: AcademicColors.error,
                                          side: const BorderSide(color: AcademicColors.error),
                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        ),
                                        onPressed: () => _reject(item),
                                        icon: const Icon(Icons.close, size: 16),
                                        label: const Text('Return Revision'),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AcademicColors.primary,
                                          foregroundColor: AcademicColors.surface,
                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        ),
                                        onPressed: () => _approve(item),
                                        icon: const Icon(Icons.check, size: 16),
                                        label: const Text('Approve & Publish'),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AcademicColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AcademicColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.bold, color: AcademicColors.textSecondary),
              ),
              Icon(icon, size: 16, color: color),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.newsreader(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AcademicColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
