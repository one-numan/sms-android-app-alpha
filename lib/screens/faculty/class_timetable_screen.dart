// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 08: Class Weekly Timetable Desk
// Design System: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8/08_class_weekly_timetable
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../data/mock/auth_state.dart';
import '../../data/mock/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/shared_widgets.dart';

class ClassTimetableScreen extends StatefulWidget {
  final String? initialClass;
  const ClassTimetableScreen({super.key, this.initialClass});

  @override
  State<ClassTimetableScreen> createState() => _ClassTimetableScreenState();
}

class _ClassTimetableScreenState extends State<ClassTimetableScreen> {
  late String _selectedClass;
  int _selectedDay = 1; // 1 = Monday, 2 = Tuesday, etc.

  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  final List<String> _dayDates = ['14', '15', '16', '17', '18', '19'];

  @override
  void initState() {
    super.initState();
    _selectedClass = widget.initialClass ?? 'Grade 5-A';
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final availableClasses = MockData.classes.map((c) => c.displayName).toList();
    if (!availableClasses.contains(_selectedClass) && availableClasses.isNotEmpty) {
      _selectedClass = availableClasses.first;
    }

    final slots = MockData.timetable
        .where((s) => s.dayOfWeek == _selectedDay && (s.className == _selectedClass || s.className.contains('5-A') || s.className.contains('10-A')))
        .toList();
    slots.sort((a, b) => a.periodNumber.compareTo(b.periodNumber));

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: AppTopBar(
        title: 'Class Timetable',
        actions: [
          SizedBox(
            width: 38,
            height: 38,
            child: IconButton(
              padding: EdgeInsets.zero,
              tooltip: 'Export Timetable',
              icon: const Icon(Icons.download_rounded, color: AcademicColors.caramel, size: 21),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AcademicColors.primary,
                    content: Text(
                      '$_selectedClass Timetable downloaded for offline records.',
                      style: const TextStyle(color: AcademicColors.surface),
                    ),
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
            // Class Selector & Meta Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AcademicColors.surface,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Class',
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AcademicColors.textSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: availableClasses.contains(_selectedClass) ? _selectedClass : availableClasses.first,
                            isDense: true,
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AcademicColors.primary),
                            style: GoogleFonts.newsreader(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.textPrimary,
                            ),
                            items: availableClasses.map((className) {
                              return DropdownMenuItem<String>(
                                value: className,
                                child: Text(className),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _selectedClass = val);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  PillBadge.info('Session 2026-27'),
                ],
              ),
            ),
            const Divider(height: 1, color: AcademicColors.border),

            // Horizontal Day Selector Ribbon
            Container(
              height: 74,
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: AcademicColors.canvas,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _days.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final dayIndex = index + 1;
                  final isSelected = _selectedDay == dayIndex;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedDay = dayIndex),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 58,
                      decoration: BoxDecoration(
                        color: isSelected ? AcademicColors.primary : AcademicColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AcademicColors.primary : AcademicColors.border,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AcademicColors.primary.withValues(alpha: 0.2),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _days[index].toUpperCase(),
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? AcademicColors.caramelLight : AcademicColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _dayDates[index],
                            style: GoogleFonts.newsreader(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : AcademicColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Period Slots List
            Expanded(
              child: slots.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_today_outlined, size: 48, color: AcademicColors.textSecondary.withValues(alpha: 0.5)),
                          const SizedBox(height: 12),
                          Text(
                            'No scheduled periods for ${_days[_selectedDay - 1]}',
                            style: GoogleFonts.newsreader(
                              fontSize: 16,
                              color: AcademicColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: slots.length,
                      itemBuilder: (context, index) {
                        final slot = slots[index];
                        final isFirst = index == 0;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: InsetCard(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Period index badge
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: isFirst
                                        ? AcademicColors.caramel.withValues(alpha: 0.15)
                                        : AcademicColors.canvas,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'P${slot.periodNumber}',
                                        style: GoogleFonts.manrope(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: isFirst ? AcademicColors.caramelDark : AcademicColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 14),

                                // Subject & Teacher details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              slot.subjectName,
                                              style: GoogleFonts.newsreader(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: AcademicColors.textPrimary,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '${slot.startTime} - ${slot.endTime}',
                                            style: GoogleFonts.manrope(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: AcademicColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.person_outline, size: 14, color: AcademicColors.textSecondary),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              slot.teacherName,
                                              style: GoogleFonts.manrope(
                                                fontSize: 13,
                                                color: AcademicColors.textSecondary,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
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
      bottomNavigationBar: auth.currentRole == UserRole.student
          ? AcademicBottomNavBar.forRole(
              auth.currentRole,
              currentIndex: 3,
              context: context,
            )
          : null,
    );
  }
}
