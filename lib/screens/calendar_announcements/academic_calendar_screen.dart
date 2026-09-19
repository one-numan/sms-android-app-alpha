// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 14: Academic Calendar & Gazetted Holidays
// Design System: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8/14_academic_calendar_gazetted_holidays
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/mock/mock_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/shared_widgets.dart';

class AcademicCalendarScreen extends StatefulWidget {
  const AcademicCalendarScreen({super.key});

  @override
  State<AcademicCalendarScreen> createState() => _AcademicCalendarScreenState();
}

class _AcademicCalendarScreenState extends State<AcademicCalendarScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Gazetted', 'School Break', 'Events'];

  @override
  Widget build(BuildContext context) {
    final holidays = MockData.holidays;
    final events = MockData.events;

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: AppTopBar(
        title: 'Academic Calendar',
        actions: [
          SizedBox(
            width: 38,
            height: 38,
            child: IconButton(
              padding: EdgeInsets.zero,
              tooltip: 'Export Calendar PDF',
              icon: const Icon(Icons.download_rounded, color: AcademicColors.primary, size: 21),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: AcademicColors.primary,
                    content: Text('Academic Calendar 2026-27 PDF downloaded.'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header Info Capsule
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AcademicColors.surface,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gazetted Holidays & Institutional Schedule',
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AcademicColors.textSecondary,
                          ),
                        ),
                        Text(
                          'Session 2026–27',
                          style: GoogleFonts.newsreader(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AcademicColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  PillBadge.info('${holidays.length} Observances'),
                ],
              ),
            ),

            // Filter Chips
            Container(
              height: 48,
              color: AcademicColors.surface,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                    backgroundColor: AcademicColors.canvas,
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
            const Divider(height: 1, color: AcademicColors.border),

            // Holidays & Observances List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (_selectedFilter == 'All' || _selectedFilter == 'Gazetted' || _selectedFilter == 'School Break') ...[
                    Text(
                      'Official Gazetted Holidays',
                      style: GoogleFonts.newsreader(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...holidays.map((h) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InsetCard(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 50,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: AcademicColors.primary.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    const Icon(Icons.event, size: 20, color: AcademicColors.primary),
                                    const SizedBox(height: 2),
                                    Text(
                                      h.date.split('-').last,
                                      style: GoogleFonts.newsreader(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AcademicColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            h.name,
                                            style: GoogleFonts.newsreader(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: AcademicColors.textPrimary,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        PillBadge.secondary(h.typeLabel),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Date: ${h.date}',
                                      style: GoogleFonts.manrope(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AcademicColors.caramelDark,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      h.description,
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
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                  ],

                  if (_selectedFilter == 'All' || _selectedFilter == 'Events') ...[
                    Text(
                      'Institutional Events & Activities',
                      style: GoogleFonts.newsreader(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...events.map((e) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InsetCard(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 50,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: AcademicColors.caramel.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(Icons.star_outline, size: 22, color: AcademicColors.caramelDark),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            e.title,
                                            style: GoogleFonts.newsreader(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: AcademicColors.textPrimary,
                                            ),
                                          ),
                                        ),
                                        PillBadge.info(e.categoryLabel),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Date: ${e.date} • Audience: ${e.audience}',
                                      style: GoogleFonts.manrope(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AcademicColors.caramelDark,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      e.description,
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
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
