// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Component: Needs Attention Section (Universal Feed Widget)
// Connected to Django REST API: GET /api/v1/attention/
// Design System: Espresso Heritage Academic
// Reference: docs/BACKEND_HANDOFF_DASHBOARD_APIS_2026-10-01.md
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'shared_widgets.dart';

/// Reusable Needs Attention Section for dashboards.
/// Implements the full contract from backend handoff specification:
/// - 3 type variants: actionable_queue, alert_count, reminder
/// - Severity-driven visual accenting (critical, warning, info)
/// - 11 deep_link.screen destinations
/// - Tolerant to count: null
/// - First-class empty state ("All Caught Up")
class NeedsAttentionSection extends StatelessWidget {
  final List<dynamic> items;
  final bool isLoading;
  final VoidCallback? onRefresh;
  final bool showWhenEmpty;
  final String title;

  const NeedsAttentionSection({
    super.key,
    required this.items,
    this.isLoading = false,
    this.onRefresh,
    this.showWhenEmpty = true,
    this.title = 'NEEDS ATTENTION',
  });

  /// Map deep_link.screen to the appropriate Flutter route across all 11 keys.
  static String? resolveRoute(Map<String, dynamic>? deepLink) {
    if (deepLink == null) return null;
    final screen = deepLink['screen']?.toString();
    if (screen == null || screen.isEmpty) return null;

    switch (screen) {
      case 'faculty_leave_review':
        return '/admin/faculty-allocation';
      case 'my_leave_requests':
        return '/teacher/attendance';
      case 'moderation_queue':
        return '/announcements/approval';
      case 'admissions_applications':
        return '/admissions/applications';
      case 'fee_defaulters':
        return '/fees/ledger';
      case 'fee_ledger':
        return '/fees/ledger';
      case 'library_overdue':
        return '/library/catalog';
      case 'my_library_loans':
        return '/library/catalog';
      case 'inventory_low_stock':
        return '/admin/modules';
      case 'calendar':
        return '/calendar';
      case 'birthdays':
        return '/calendar';
      default:
        return null;
    }
  }

  /// Resolve domain-specific academic icon.
  static IconData resolveIcon(String? domain) {
    switch (domain) {
      case 'attendance':
        return Icons.how_to_reg_outlined;
      case 'announcements':
        return Icons.campaign_outlined;
      case 'admissions':
        return Icons.assignment_outlined;
      case 'fees':
        return Icons.receipt_long_outlined;
      case 'library':
        return Icons.auto_stories_outlined;
      case 'inventory':
        return Icons.inventory_2_outlined;
      case 'calendar':
        return Icons.event_outlined;
      default:
        return Icons.pending_actions_outlined;
    }
  }

  /// Resolve color strictly by severity (critical -> danger, warning -> warning, info -> primaryDark).
  static Color resolveSeverityColor(String? severity) {
    switch (severity?.toLowerCase()) {
      case 'critical':
        return AcademicColors.danger;
      case 'warning':
        return AcademicColors.warning;
      case 'info':
      default:
        return AcademicColors.primaryDark;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const InsetCard(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.all(16),
        child: Center(
          child: SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (items.isEmpty) {
      if (!showWhenEmpty) return const SizedBox.shrink();
      return _buildEmptyCaughtUpCard(context);
    }

    return InsetCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.pending_actions, size: 18, color: AcademicColors.warning),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AcademicColors.textSecondary,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              PillBadge.warning('${items.length} ${items.length == 1 ? 'Item' : 'Items'}'),
            ],
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final raw = items[index];
              if (raw is! Map<String, dynamic>) {
                return const SizedBox.shrink();
              }
              return _buildAttentionItemTile(context, raw);
            },
          ),
        ],
      ),
    );
  }

  /// First-class "All Caught Up" state card.
  Widget _buildEmptyCaughtUpCard(BuildContext context) {
    return InsetCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AcademicColors.success.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle_outline, color: AcademicColors.success, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "All Caught Up",
                  style: GoogleFonts.manrope(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: AcademicColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "No pending items requiring attention right now.",
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
    );
  }

  /// Type-specific rendering (actionable_queue, alert_count, reminder).
  Widget _buildAttentionItemTile(BuildContext context, Map<String, dynamic> item) {
    final type = item['type']?.toString() ?? 'alert_count';
    final severity = item['severity']?.toString() ?? 'info';
    final severityColor = resolveSeverityColor(severity);
    final domain = item['domain']?.toString();
    final icon = (item['icon'] is IconData) ? item['icon'] as IconData : resolveIcon(domain);
    final title = item['title']?.toString() ?? item['text']?.toString() ?? 'Notice';
    final subtitle = item['subtitle']?.toString() ?? item['description']?.toString() ?? '';
    final actionLabel = item['action_label']?.toString();
    final actionRoute = item['action_route']?.toString();
    final deepLink = item['deep_link'] is Map<String, dynamic> ? item['deep_link'] as Map<String, dynamic> : null;
    final route = resolveRoute(deepLink) ?? item['route']?.toString() ?? actionRoute;

    final bool isActionable = type == 'actionable_queue';
    final bool isReminder = type == 'reminder';

    return Material(
      color: AcademicColors.canvas,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: route != null
            ? () async {
                await context.push(route);
                onRefresh?.call();
              }
            : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: severity == 'critical'
                  ? AcademicColors.danger.withValues(alpha: 0.4)
                  : (severity == 'warning'
                      ? AcademicColors.warning.withValues(alpha: 0.25)
                      : AcademicColors.border),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: severityColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: severityColor),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AcademicColors.textPrimary,
                        height: 1.25,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.manrope(
                          fontSize: 10.5,
                          color: AcademicColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isActionable && actionLabel != null) ...[
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: severityColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 30),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () async {
                    if (route != null) {
                      await context.push(route);
                    }
                    onRefresh?.call();
                  },
                  child: Text(
                    actionLabel,
                    style: GoogleFonts.manrope(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ] else if (!isReminder && actionLabel != null) ...[
                const SizedBox(width: 8),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 30),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    side: BorderSide(color: severityColor.withValues(alpha: 0.5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () async {
                    if (route != null) {
                      await context.push(route);
                    }
                    onRefresh?.call();
                  },
                  child: Text(
                    actionLabel,
                    style: GoogleFonts.manrope(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: severityColor,
                    ),
                  ),
                ),
              ] else if (isReminder && route != null) ...[
                const SizedBox(width: 6),
                Icon(Icons.chevron_right, size: 16, color: AcademicColors.textSecondary.withValues(alpha: 0.6)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
