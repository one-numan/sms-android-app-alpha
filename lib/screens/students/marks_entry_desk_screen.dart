// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 20: Subject Teacher Assessment Marks Entry Desk
// Design System: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8/20_subject_teacher_assessment_marks_entry_desk
// Strict adherence: Exactly 4 exam terms, no room numbers, no banned terms.
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/mock/mock_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/shared_widgets.dart';

class MarksEntryDeskScreen extends StatefulWidget {
  const MarksEntryDeskScreen({super.key});

  @override
  State<MarksEntryDeskScreen> createState() => _MarksEntryDeskScreenState();
}

class _MarksEntryDeskScreenState extends State<MarksEntryDeskScreen> {
  String _selectedExam = 'Second Assessment';
  final Map<String, TextEditingController> _scoreControllers = {};

  final List<String> _examTypes = [
    'First Assessment',
    'Half Yearly',
    'Second Assessment',
    'Final Exam',
  ];

  @override
  void initState() {
    super.initState();
    for (final s in MockData.students) {
      _scoreControllers[s.id] = TextEditingController(
        text: s.id == 'ADM-2024-0412' ? '46' : '42',
      );
    }
  }

  @override
  void dispose() {
    for (final c in _scoreControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  String _getGrade(double score) {
    if (score >= 45) return 'A1';
    if (score >= 40) return 'A2';
    if (score >= 35) return 'B1';
    if (score >= 30) return 'B2';
    return 'C';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: AppTopBar(
        title: 'Marks Entry Desk',
        actions: [
          Center(child: PillBadge.success('Online Sync Live')),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Context Header Card
            Container(
              color: AcademicColors.surface,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AcademicColors.primaryDark,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.functions, color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Class 5-A • Mathematics',
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AcademicColors.textPrimary,
                              ),
                            ),
                            Text(
                              'Core Subject • Max Marks: 50 • Session 2026-27',
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                color: AcademicColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PillBadge.info('Active Term'),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Exam Type Dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AcademicColors.canvas,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AcademicColors.border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedExam,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down, color: AcademicColors.primaryDark),
                        items: _examTypes.map((exam) {
                          return DropdownMenuItem(
                            value: exam,
                            child: Text(
                              exam,
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AcademicColors.textPrimary,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedExam = val);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: AcademicColors.border),

            // Student Scoring Roster
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: MockData.students.length,
                itemBuilder: (context, index) {
                  final student = MockData.students[index];
                  final controller = _scoreControllers[student.id];
                  final double score = double.tryParse(controller?.text ?? '0') ?? 0.0;
                  final grade = _getGrade(score);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InsetCard(
                      margin: EdgeInsets.zero,
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: AcademicColors.canvas,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '#${student.rollNumber}',
                                style: GoogleFonts.manrope(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AcademicColors.primaryDark,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${student.firstName} ${student.lastName}',
                                  style: GoogleFonts.manrope(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AcademicColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  'Adm #${student.id} • Grade: $grade',
                                  style: GoogleFonts.manrope(
                                    fontSize: 11,
                                    color: AcademicColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 60,
                            height: 40,
                            child: TextField(
                              controller: controller,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.newsreader(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AcademicColors.primaryDark,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                filled: true,
                                fillColor: AcademicColors.canvas,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: AcademicColors.border),
                                ),
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '/ 50',
                            style: GoogleFonts.manrope(fontSize: 11, color: AcademicColors.textSecondary),
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
      bottomNavigationBar: AcademicStickyActionBar(
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AcademicColors.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Marks draft saved locally')),
                    );
                  },
                  child: Text(
                    'Save Draft',
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AcademicColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AcademicColors.primaryDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Marks locked and finalized into official ledger'),
                        backgroundColor: AcademicColors.success,
                      ),
                    );
                  },
                  child: Text(
                    'Lock & Finalize',
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
