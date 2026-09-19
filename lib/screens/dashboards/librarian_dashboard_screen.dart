// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 16 & 32: Central School Library Circulation Desk & Management
// Design System: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8/16_central_school_library_circulation_desk
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/mock/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/account_profile_sheet.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/shared_widgets.dart';

class LibrarianDashboardScreen extends StatefulWidget {
  const LibrarianDashboardScreen({super.key});

  @override
  State<LibrarianDashboardScreen> createState() => _LibrarianDashboardScreenState();
}

class _LibrarianDashboardScreenState extends State<LibrarianDashboardScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredBooks = MockData.books.where((b) {
      return b.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          b.author.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          b.category.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: const AppTopBar(showBrand: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Librarian Identity Header Card
              InkWell(
                onTap: () => AccountProfileSheet.show(context),
                borderRadius: BorderRadius.circular(12),
                child: Semantics(
                  label: 'View account profile',
                  child: InsetCard(
                    margin: EdgeInsets.zero,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: const BoxDecoration(
                            color: AcademicColors.primaryDark,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              'LB',
                              style: GoogleFonts.newsreader(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AcademicColors.accent,
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
                                'Library Circulation Desk',
                                style: GoogleFonts.newsreader(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AcademicColors.textPrimary,
                                ),
                              ),
                              Text(
                                'Librarian • AY 2026–27',
                                style: GoogleFonts.manrope(
                                  fontSize: 11,
                                  color: AcademicColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, size: 18, color: AcademicColors.textSecondary),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Circulation Metrics Row
              Row(
                children: [
                  _buildMetricTile('Total Titles', '4,200', Icons.auto_stories, AcademicColors.primaryDark),
                  const SizedBox(width: 8),
                  _buildMetricTile('Active Loans', '142', Icons.book, AcademicColors.info),
                  const SizedBox(width: 8),
                  _buildMetricTile('Overdue', '04', Icons.warning_amber, AcademicColors.danger),
                ],
              ),

              const SizedBox(height: 16),

              // Catalog Search Bar
              TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                style: GoogleFonts.manrope(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Search title, author, ISBN or accession number...',
                  prefixIcon: const Icon(Icons.search, size: 20, color: AcademicColors.textSecondary),
                  filled: true,
                  fillColor: AcademicColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AcademicColors.border),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Active Loans Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'ACTIVE STUDENT CIRCULATION LOANS',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.textSecondary,
                        letterSpacing: 0.8,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  PillBadge.success('${MockData.bookIssues.length} Active'),
                ],
              ),
              const SizedBox(height: 10),

              ...MockData.bookIssues.map((issue) {
                final book = MockData.books.firstWhere(
                  (b) => b.id == issue.bookId,
                  orElse: () => MockData.books.first,
                );
                final student = MockData.students.firstWhere(
                  (s) => s.id == issue.studentId,
                  orElse: () => MockData.students.first,
                );

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InsetCard(
                    margin: EdgeInsets.zero,
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AcademicColors.canvas,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.menu_book, color: AcademicColors.primaryDark, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book.title,
                                style: GoogleFonts.manrope(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AcademicColors.textPrimary,
                                ),
                              ),
                              Text(
                                'Issued to: ${student.firstName} ${student.lastName} (Roll #${student.rollNumber})',
                                style: GoogleFonts.manrope(
                                  fontSize: 11,
                                  color: AcademicColors.textSecondary,
                                ),
                              ),
                              Text(
                                'Due Date: ${issue.dueDate} • Issued: ${issue.issueDate}',
                                style: GoogleFonts.manrope(
                                  fontSize: 10.5,
                                  color: AcademicColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AcademicColors.primaryDark),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Returned: ${book.title}')),
                            );
                          },
                          child: Text(
                            'Return',
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.primaryDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 20),

              // Library Catalog Titles
              Text(
                'COLLECTION TITLES IN CATALOG (${filteredBooks.length})',
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AcademicColors.textSecondary,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 10),

              ...filteredBooks.map((b) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InsetCard(
                    margin: EdgeInsets.zero,
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        const Icon(Icons.bookmark_border, color: AcademicColors.secondary, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                b.title,
                                style: GoogleFonts.manrope(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AcademicColors.textPrimary,
                                ),
                              ),
                              Text(
                                '${b.author} • Category: ${b.category} • ISBN: ${b.isbn}',
                                style: GoogleFonts.manrope(
                                  fontSize: 11,
                                  color: AcademicColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PillBadge.success('${b.availableCopies}/${b.totalCopies} Available'),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AcademicBottomNavBar.forRole(
        UserRole.librarian,
        currentIndex: 0,
        context: context,
      ),
    );
  }

  Widget _buildMetricTile(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: InsetCard(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.newsreader(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AcademicColors.textPrimary,
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(fontSize: 10, color: AcademicColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
