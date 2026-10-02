// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Reusable Empty State Widget: Espresso Heritage Academic
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Centered empty-state placeholder for list/grid screens with no data.
class AcademicEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const AcademicEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 48,
              color: AcademicColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.newsreader(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AcademicColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 13,
                color: AcademicColors.textSecondary,
                height: 1.4,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AcademicColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: onAction,
                child: Text(
                  actionLabel!,
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Standardized Academic Error State widget with error classification and retry action.
class AcademicErrorState extends StatelessWidget {
  final Object? error;
  final String? message;
  final VoidCallback onRetry;

  const AcademicErrorState({
    super.key,
    this.error,
    this.message,
    required this.onRetry,
  });

  String get _resolvedTitle {
    final errStr = (error ?? message ?? '').toString().toLowerCase();
    if (errStr.contains('timeout') || errStr.contains('socket') || errStr.contains('connection') || errStr.contains('network')) {
      return 'Connection Problem';
    } else if (errStr.contains('401') || errStr.contains('403') || errStr.contains('unauthorized')) {
      return 'Access Denied';
    } else if (errStr.contains('500') || errStr.contains('server')) {
      return 'Server Temporarily Unavailable';
    }
    return 'Unable to Load Data';
  }

  String get _resolvedSubtitle {
    if (message != null && message!.isNotEmpty) return message!;
    final errStr = (error ?? '').toString().toLowerCase();
    if (errStr.contains('timeout') || errStr.contains('socket') || errStr.contains('connection') || errStr.contains('network')) {
      return 'Could not reach the school server. Please verify your internet connection and try again.';
    } else if (errStr.contains('401') || errStr.contains('403') || errStr.contains('unauthorized')) {
      return 'Your session may have expired or you do not have permission to view this resource.';
    }
    return 'An unexpected issue occurred while fetching records. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 52,
              color: AcademicColors.danger,
            ),
            const SizedBox(height: 16),
            Text(
              _resolvedTitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.newsreader(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AcademicColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _resolvedSubtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 13,
                color: AcademicColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AcademicColors.primaryDark,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 16),
              label: Text(
                'Retry',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

