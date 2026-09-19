// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 34: Principal School Calendar & Institutional Events Desk
// Design System: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8/principal_school_calendar_institutional_events_desk_android_mobile
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/mock/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/shared_widgets.dart';

class EventsDeskScreen extends StatefulWidget {
  const EventsDeskScreen({super.key});

  @override
  State<EventsDeskScreen> createState() => _EventsDeskScreenState();
}

class _EventsDeskScreenState extends State<EventsDeskScreen> {
  String _selectedCategory = 'All';
  late List<SchoolEvent> _events;

  final List<String> _categories = ['All', 'Celebrations', 'Examinations', 'Excursions', 'Meetings'];

  @override
  void initState() {
    super.initState();
    _events = List.from(MockData.events);
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _events.where((e) {
      if (_selectedCategory == 'All') return true;
      if (_selectedCategory == 'Celebrations') return e.category == EventCategory.functionCelebration;
      if (_selectedCategory == 'Examinations') return e.category == EventCategory.testExam;
      if (_selectedCategory == 'Excursions') return e.category == EventCategory.tripExcursion;
      if (_selectedCategory == 'Meetings') return e.category == EventCategory.meeting;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: AppTopBar(
        title: 'Institutional Events Desk',
        actions: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AcademicColors.primary,
              foregroundColor: AcademicColors.surface,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () async {
              final newEvent = await context.push<SchoolEvent>('/calendar/add-event');
              if (newEvent != null) {
                setState(() => _events.insert(0, newEvent));
              }
            },
            icon: const Icon(Icons.add, size: 16),
            label: Text(
              'Add Event',
              style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Category Filter Ribbon
            Container(
              height: 52,
              color: AcademicColors.surface,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedCategory = cat),
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

            // Events List
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        'No institutional events found for $_selectedCategory',
                        style: GoogleFonts.newsreader(fontSize: 16, color: AcademicColors.textSecondary),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final event = filtered[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: InsetCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        event.title,
                                        style: GoogleFonts.newsreader(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AcademicColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    PillBadge.info(event.categoryLabel),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.event_outlined, size: 14, color: AcademicColors.caramelDark),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Date: ${event.date}',
                                      style: GoogleFonts.manrope(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AcademicColors.caramelDark,
                                      ),
                                    ),
                                    if (event.startTime != null) ...[
                                      const SizedBox(width: 8),
                                      const Text('•', style: TextStyle(color: AcademicColors.border)),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.schedule, size: 14, color: AcademicColors.textSecondary),
                                      const SizedBox(width: 4),
                                      Text(
                                        event.startTime!,
                                        style: GoogleFonts.manrope(
                                          fontSize: 12,
                                          color: AcademicColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  event.description,
                                  style: GoogleFonts.manrope(
                                    fontSize: 13,
                                    color: AcademicColors.textPrimary,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    PillBadge.secondary('Audience: ${event.audience}'),
                                    Text(
                                      'Session 2026-27',
                                      style: GoogleFonts.manrope(
                                        fontSize: 11,
                                        color: AcademicColors.textSecondary,
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
