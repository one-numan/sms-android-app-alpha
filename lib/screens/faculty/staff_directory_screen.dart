// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 27: Institutional Faculty & Staff Directory
// Design System: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8/27_institutional_faculty_staff_directory
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/mock/mock_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/shared_widgets.dart';

class StaffDirectoryScreen extends StatefulWidget {
  const StaffDirectoryScreen({super.key});

  @override
  State<StaffDirectoryScreen> createState() => _StaffDirectoryScreenState();
}

class _StaffDirectoryScreenState extends State<StaffDirectoryScreen> {
  String _selectedDept = 'All';
  String _searchQuery = '';

  final List<String> _departments = ['All', 'Faculty', 'Administration', 'Support'];

  @override
  Widget build(BuildContext context) {
    final teachers = MockData.teachers;
    final staffMembers = MockData.staffMembers;

    // Filter list
    final List<_DirectoryMember> allMembers = [];

    for (var t in teachers) {
      allMembers.add(_DirectoryMember(
        name: t.name,
        roleOrSubject: t.subjectSpecialization,
        department: 'Faculty',
        email: t.email,
        phone: t.phone,
        avatarLetter: t.name.isNotEmpty ? t.name[0] : 'T',
        tag: 'Academic Faculty',
      ));
    }

    for (var s in staffMembers) {
      final dept = (s.designation.contains('Admin') || s.designation.contains('Principal') || s.designation.contains('Accountant'))
          ? 'Administration'
          : 'Support';
      allMembers.add(_DirectoryMember(
        name: s.name,
        roleOrSubject: s.designation,
        department: dept,
        email: s.email,
        phone: s.phone,
        avatarLetter: s.name.isNotEmpty ? s.name[0] : 'S',
        tag: dept,
      ));
    }

    final filtered = allMembers.where((m) {
      final matchesDept = _selectedDept == 'All' || m.department == _selectedDept;
      final matchesQuery = _searchQuery.isEmpty ||
          m.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m.roleOrSubject.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m.department.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesDept && matchesQuery;
    }).toList();

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: AppTopBar(
        title: 'Faculty & Staff Directory',
        actions: [
          Center(child: PillBadge.info('${filtered.length} Personnel')),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Input
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              color: AcademicColors.surface,
              child: TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Search faculty by name, department, or subject...',
                  hintStyle: GoogleFonts.manrope(
                    fontSize: 13,
                    color: AcademicColors.textSecondary,
                  ),
                  prefixIcon: const Icon(Icons.search, color: AcademicColors.textSecondary, size: 20),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18, color: AcademicColors.textSecondary),
                          onPressed: () => setState(() => _searchQuery = ''),
                        )
                      : null,
                  filled: true,
                  fillColor: AcademicColors.canvas,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Department Filter Chips
            Container(
              height: 52,
              color: AcademicColors.surface,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                scrollDirection: Axis.horizontal,
                itemCount: _departments.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final dept = _departments[index];
                  final isSelected = _selectedDept == dept;
                  return ChoiceChip(
                    label: Text(dept),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedDept = dept),
                    selectedColor: AcademicColors.primary,
                    backgroundColor: AcademicColors.canvas,
                    labelStyle: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AcademicColors.textPrimary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? AcademicColors.primary : AcademicColors.border,
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 1, color: AcademicColors.border),

            // Directory List
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_search_outlined, size: 48, color: AcademicColors.textSecondary.withValues(alpha: 0.5)),
                          const SizedBox(height: 12),
                          Text(
                            'No faculty or staff found matching "$_searchQuery"',
                            style: GoogleFonts.newsreader(
                              fontSize: 16,
                              color: AcademicColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final member = filtered[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: InsetCard(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: AcademicColors.canvas,
                                  child: Text(
                                    member.avatarLetter,
                                    style: GoogleFonts.newsreader(
                                      fontSize: 18,
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
                                          Expanded(
                                            child: Text(
                                              member.name,
                                              style: GoogleFonts.newsreader(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: AcademicColors.textPrimary,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          PillBadge.secondary(member.tag),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        member.roleOrSubject,
                                        style: GoogleFonts.manrope(
                                          fontSize: 13,
                                          color: AcademicColors.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.email_outlined, size: 14, color: AcademicColors.textSecondary),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              member.email,
                                              style: GoogleFonts.manrope(
                                                fontSize: 12,
                                                color: AcademicColors.textSecondary,
                                              ),
                                              maxLines: 1,
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
    );
  }
}

class _DirectoryMember {
  final String name;
  final String roleOrSubject;
  final String department;
  final String email;
  final String phone;
  final String avatarLetter;
  final String tag;

  const _DirectoryMember({
    required this.name,
    required this.roleOrSubject,
    required this.department,
    required this.email,
    required this.phone,
    required this.avatarLetter,
    required this.tag,
  });
}
