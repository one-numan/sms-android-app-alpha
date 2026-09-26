import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Reusable bottom sheet displaying the Subject Teacher's students taught
/// and class roster breakdown.
class StudentsTaughtSheet {
  static void show(
    BuildContext context, {
    required String totalStudents,
    required List<Map<String, dynamic>> cohorts,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AcademicColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AcademicColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AcademicColors.primaryDark.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.groups, color: AcademicColors.primaryDark, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Students Taught By You',
                            style: GoogleFonts.newsreader(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.textPrimary,
                            ),
                          ),
                          Text(
                            '$totalStudents Students across your assigned classes',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              color: AcademicColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AcademicColors.canvas,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AcademicColors.border),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Total School Enrollment (255 Classes):',
                          style: GoogleFonts.manrope(fontSize: 12, color: AcademicColors.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '10,000 Students',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Your Assigned Class Roster Breakdown:',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AcademicColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                if (cohorts.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        'No assigned class breakdown available.',
                        style: GoogleFonts.manrope(fontSize: 12, color: AcademicColors.textSecondary),
                      ),
                    ),
                  )
                else
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: cohorts.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, idx) {
                        final c = cohorts[idx];
                        final className = c['className']?.toString() ?? 'Class';
                        final subjectName = c['subjectName']?.toString() ?? 'General';
                        final count = c['students']?.toString() ?? '0';
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '$className • $subjectName',
                                  style: GoogleFonts.manrope(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: AcademicColors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AcademicColors.canvas,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: AcademicColors.border),
                                ),
                                child: Text(
                                  '$count Students',
                                  style: GoogleFonts.manrope(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AcademicColors.caramelDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
