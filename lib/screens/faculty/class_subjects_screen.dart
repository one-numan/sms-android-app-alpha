// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Class Teacher -> More: Class Subjects & Faculty Allocation Screen
// Design System: Espresso Heritage Academic (Warm Cream, Deep Espresso, Ivory)
// Strict Compliance: Scoped to class curriculum & faculty assignments, zero emojis.
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../data/mock/auth_state.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/bottom_nav_bar.dart';

class ClassSubjectsScreen extends StatefulWidget {
  final String? initialClass;

  const ClassSubjectsScreen({super.key, this.initialClass});

  @override
  State<ClassSubjectsScreen> createState() => _ClassSubjectsScreenState();
}

class _ClassSubjectsScreenState extends State<ClassSubjectsScreen> {
  String _selectedFilter = 'All'; // 'All', 'Theory', 'Practical', 'Activity'

  final List<Map<String, dynamic>> _subjectsData = [
    {
      'code': 'SUB-501',
      'name': 'Mathematics',
      'teacher': 'Teacher Faculty',
      'designation': 'Class Teacher • Math Faculty',
      'type': 'Theory',
      'periods': 6,
      'testWeight': 30,
      'examWeight': 70,
      'isSelf': true,
    },
    {
      'code': 'SUB-502',
      'name': 'General Science',
      'teacher': 'Rahul Kumar',
      'designation': 'Science Faculty • Physics Specialization',
      'type': 'Theory + Lab',
      'periods': 5,
      'testWeight': 30,
      'examWeight': 70,
      'isSelf': false,
    },
    {
      'code': 'SUB-503',
      'name': 'English Language & Lit.',
      'teacher': 'Meenakshi Sharma',
      'designation': 'English Faculty • Language Lead',
      'type': 'Theory',
      'periods': 5,
      'testWeight': 30,
      'examWeight': 70,
      'isSelf': false,
    },
    {
      'code': 'SUB-504',
      'name': 'Hindi Literature',
      'teacher': 'Sunita Mehra',
      'designation': 'Hindi Faculty • Vernacular Lead',
      'type': 'Theory',
      'periods': 4,
      'testWeight': 30,
      'examWeight': 70,
      'isSelf': false,
    },
    {
      'code': 'SUB-505',
      'name': 'Social Studies & Civics',
      'teacher': 'Vikram Batra',
      'designation': 'Social Sciences Faculty',
      'type': 'Theory',
      'periods': 4,
      'testWeight': 30,
      'examWeight': 70,
      'isSelf': false,
    },
    {
      'code': 'SUB-506',
      'name': 'Computer Science & ICT',
      'teacher': 'Robert Chen',
      'designation': 'ICT Faculty • Systems Specialist',
      'type': 'Practical',
      'periods': 3,
      'testWeight': 40,
      'examWeight': 60,
      'isSelf': false,
    },
    {
      'code': 'SUB-507',
      'name': 'Physical Education & Yoga',
      'teacher': 'Suresh Gupta',
      'designation': 'Sports & Physical Fitness Coach',
      'type': 'Activity',
      'periods': 2,
      'testWeight': 50,
      'examWeight': 50,
      'isSelf': false,
    },
    {
      'code': 'SUB-508',
      'name': 'Art, Craft & Design',
      'teacher': 'Pooja Saxena',
      'designation': 'Fine Arts & Creative Faculty',
      'type': 'Activity',
      'periods': 1,
      'testWeight': 50,
      'examWeight': 50,
      'isSelf': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final teacherName = (auth.fullName.isNotEmpty && auth.fullName != 'User')
        ? auth.fullName
        : (auth.currentUsername.isNotEmpty ? auth.currentUsername : 'Faculty Member');
    _subjectsData[0]['teacher'] = teacherName;

    final className = widget.initialClass ?? (auth.userProfile?['class_name'] ?? '5-A');

    final filtered = _subjectsData.where((s) {
      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'Theory') return (s['type'] as String).contains('Theory');
      if (_selectedFilter == 'Practical') return (s['type'] as String).contains('Practical') || (s['type'] as String).contains('Lab');
      if (_selectedFilter == 'Activity') return (s['type'] as String).contains('Activity');
      return true;
    }).toList();

    final totalPeriods = _subjectsData.fold<int>(0, (sum, s) => sum + (s['periods'] as int));

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: const AppTopBar(
        title: 'Class Subjects',
        showBackButton: true,
      ),
      bottomNavigationBar: AcademicBottomNavBar.forRole(
        context.watch<AuthState>().currentRole,
        currentIndex: context.watch<AuthState>().currentRole == UserRole.classTeacher ? 2 : 1,
        context: context,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header Context Strip
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              color: AcademicColors.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Class $className Subject List',
                              style: GoogleFonts.newsreader(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AcademicColors.textPrimary,
                              ),
                            ),
                            Text(
                              '${_subjectsData.length} Subjects • $totalPeriods Total Periods / Week',
                              style: GoogleFonts.manrope(
                                fontSize: 11.5,
                                color: AcademicColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AcademicColors.canvas,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AcademicColors.border),
                        ),
                        child: Text(
                          'Class $className',
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AcademicColors.caramelDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Filter Chips Row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterPill('All', 'All (${_subjectsData.length})'),
                        const SizedBox(width: 6),
                        _buildFilterPill('Theory', 'Theory (${_subjectsData.where((s) => (s['type'] as String).contains('Theory')).length})'),
                        const SizedBox(width: 6),
                        _buildFilterPill('Practical', 'Practical & Lab'),
                        const SizedBox(width: 6),
                        _buildFilterPill('Activity', 'Activity'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: AcademicColors.border),

            // Subject Cards List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = filtered[index];
                  final isSelf = item['isSelf'] == true;
                  return _buildSubjectCard(item, isSelf);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPill(String filterKey, String label) {
    final isSelected = _selectedFilter == filterKey;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = filterKey;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AcademicColors.primary : AcademicColors.canvas,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AcademicColors.primary : AcademicColors.border,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? AcademicColors.surface : AcademicColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectCard(Map<String, dynamic> item, bool isSelf) {
    return Container(
      decoration: BoxDecoration(
        color: AcademicColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelf ? AcademicColors.caramelDark.withValues(alpha: 0.5) : AcademicColors.border,
        ),
        boxShadow: AcademicColors.cardShadow,
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelf ? AcademicColors.primary : AcademicColors.canvas,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AcademicColors.border),
                ),
                child: Icon(
                  isSelf ? Icons.school : Icons.menu_book_outlined,
                  size: 20,
                  color: isSelf ? AcademicColors.accent : AcademicColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['name'] as String,
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.textPrimary,
                            ),
                          ),
                        ),
                        if (isSelf)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AcademicColors.caramelLight,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Your Subject',
                              style: GoogleFonts.manrope(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: AcademicColors.caramelDark,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.person_outline, size: 14, color: AcademicColors.textSecondary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Teacher: ${item['teacher']}',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AcademicColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      item['designation'] as String,
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
          const SizedBox(height: 12),
          const Divider(height: 1, color: AcademicColors.border),
          const SizedBox(height: 10),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildDetailBadge('Type', item['type'] as String),
              _buildDetailBadge('Weekly Load', '${item['periods']} Periods'),
              _buildDetailBadge('Weightage', 'FA ${item['testWeight']}% • SA ${item['examWeight']}%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailBadge(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AcademicColors.textSecondary,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          value,
          style: GoogleFonts.manrope(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: AcademicColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
