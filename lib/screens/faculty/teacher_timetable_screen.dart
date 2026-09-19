// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 21: Teacher Weekly Timetable Grid Desk
// Design System: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8/21_teacher_weekly_timetable_grid
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/mock/mock_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/shared_widgets.dart';

class TeacherTimetableScreen extends StatefulWidget {
  final String? teacherName;
  const TeacherTimetableScreen({super.key, this.teacherName});

  @override
  State<TeacherTimetableScreen> createState() => _TeacherTimetableScreenState();
}

class _TeacherTimetableScreenState extends State<TeacherTimetableScreen> {
  late String _selectedTeacher;
  int _selectedDay = 1; // 1=Mon .. 6=Sat

  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  final List<String> _dayDates = ['14', '15', '16', '17', '18', '19'];

  @override
  void initState() {
    super.initState();
    _selectedTeacher = widget.teacherName ?? (MockData.teachers.isNotEmpty ? MockData.teachers.first.name : 'Mrs. Anita Desai');
  }

  @override
  Widget build(BuildContext context) {
    final teachers = MockData.teachers;
    final currentTeacher = teachers.firstWhere(
      (t) => t.name == _selectedTeacher,
      orElse: () => teachers.first,
    );

    // Timetable slots for this teacher on this day
    final teacherSlots = MockData.timetable
        .where((s) => s.dayOfWeek == _selectedDay && (s.teacherName == currentTeacher.name || s.teacherName.contains('Anita') || s.teacherName.contains('Rajesh')))
        .toList();
    teacherSlots.sort((a, b) => a.periodNumber.compareTo(b.periodNumber));

    // Calculate total periods for the week
    final totalWeekPeriods = MockData.timetable
        .where((s) => s.teacherName == currentTeacher.name || s.teacherName.contains('Anita'))
        .length;

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: AppTopBar(
        title: 'Faculty Timetable',
        actions: [
          IconButton(
            tooltip: 'Export Schedule PDF',
            icon: const Icon(Icons.picture_as_pdf_outlined, color: AcademicColors.caramel),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AcademicColors.primary,
                  content: Text(
                    '${currentTeacher.name} Timetable PDF exported successfully.',
                    style: const TextStyle(color: AcademicColors.surface),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Faculty Profile & Workload Hero Capsule
            Container(
              padding: const EdgeInsets.all(16),
              color: AcademicColors.surface,
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: AcademicColors.canvas,
                        child: Text(
                          currentTeacher.name.isNotEmpty ? currentTeacher.name[0] : 'T',
                          style: GoogleFonts.newsreader(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AcademicColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: teachers.any((t) => t.name == _selectedTeacher)
                                    ? _selectedTeacher
                                    : teachers.first.name,
                                isDense: true,
                                icon: const Icon(Icons.keyboard_arrow_down, color: AcademicColors.primary),
                                style: GoogleFonts.newsreader(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AcademicColors.textPrimary,
                                ),
                                items: teachers.map((t) {
                                  return DropdownMenuItem<String>(
                                    value: t.name,
                                    child: Text(t.name),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => _selectedTeacher = val);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${currentTeacher.subjectSpecialization} • Senior Faculty',
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
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AcademicColors.canvas,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(Icons.schedule, size: 16, color: AcademicColors.caramelDark),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Workload: $totalWeekPeriods Teaching Slots',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.manrope(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AcademicColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        PillBadge.info('2026-27'),
                      ],
                    ),
                  ),
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

            // Timetable Slots List
            Expanded(
              child: teacherSlots.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.event_busy_outlined, size: 48, color: AcademicColors.textSecondary.withValues(alpha: 0.5)),
                          const SizedBox(height: 12),
                          Text(
                            'No scheduled periods on ${_days[_selectedDay - 1]}',
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
                      itemCount: teacherSlots.length,
                      itemBuilder: (context, index) {
                        final slot = teacherSlots[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: InsetCard(
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: AcademicColors.canvas,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'P${slot.periodNumber}',
                                    style: GoogleFonts.manrope(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AcademicColors.primary,
                                    ),
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
                                          Text(
                                            slot.className,
                                            style: GoogleFonts.newsreader(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: AcademicColors.textPrimary,
                                            ),
                                          ),
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
                                      const SizedBox(height: 3),
                                      Text(
                                        slot.subjectName,
                                        style: GoogleFonts.manrope(
                                          fontSize: 13,
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
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
