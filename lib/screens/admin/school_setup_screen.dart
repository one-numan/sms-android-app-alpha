// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 37: School Setup & Institutional Configuration Module
// Design System: Espresso Heritage Academic
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/mock/mock_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/shared_widgets.dart';

class SchoolSetupScreen extends StatelessWidget {
  const SchoolSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: AppTopBar(
        title: 'Institutional Setup',
        actions: [
          Center(child: PillBadge.success('Session Active')),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // School Overview Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AcademicColors.primary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AcademicColors.primary.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          MockData.schoolAbbr,
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AcademicColors.caramelLight,
                            letterSpacing: 1.5,
                          ),
                        ),
                        PillBadge.info('CBSE Affiliated'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      MockData.schoolName,
                      style: GoogleFonts.newsreader(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.surface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      MockData.campusAddress,
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: AcademicColors.surface.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Academic Session & Terminology
              Text(
                'Academic Configuration',
                style: GoogleFonts.newsreader(fontSize: 18, fontWeight: FontWeight.bold, color: AcademicColors.textPrimary),
              ),
              const SizedBox(height: 8),
              const InsetCard(
                child: Column(
                  children: [
                    _ConfigRow(label: 'Active Academic Session', value: MockData.session),
                    Divider(height: 16, color: AcademicColors.border),
                    _ConfigRow(label: 'Curriculum Framework', value: 'CBSE New Delhi'),
                    Divider(height: 16, color: AcademicColors.border),
                    _ConfigRow(label: 'Evaluation System', value: '4 Assessment Framework'),
                    Divider(height: 16, color: AcademicColors.border),
                    _ConfigRow(
                      label: 'Official Exam Terms',
                      value: 'First Assessment\nHalf Yearly\nSecond Assessment\nFinal Exam',
                      isMultiline: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Operational ERP Desks
              Text(
                'Core ERP System Desks',
                style: GoogleFonts.newsreader(fontSize: 18, fontWeight: FontWeight.bold, color: AcademicColors.textPrimary),
              ),
              const SizedBox(height: 8),
              const InsetCard(
                child: Column(
                  children: [
                    _ModuleStatusRow(name: 'Admissions Intake Desk', status: 'Operational', icon: Icons.person_add_alt_1),
                    Divider(height: 16, color: AcademicColors.border),
                    _ModuleStatusRow(name: 'Accounts & Fee Ledger', status: 'Operational', icon: Icons.receipt_long),
                    Divider(height: 16, color: AcademicColors.border),
                    _ModuleStatusRow(name: 'Roll Call & Attendance', status: 'Operational', icon: Icons.how_to_reg),
                    Divider(height: 16, color: AcademicColors.border),
                    _ModuleStatusRow(name: 'Central Library Circulation', status: 'Operational', icon: Icons.local_library),
                    Divider(height: 16, color: AcademicColors.border),
                    _ModuleStatusRow(name: 'Institutional Bus Fleet', status: 'Operational', icon: Icons.directions_bus),
                    Divider(height: 16, color: AcademicColors.border),
                    _ModuleStatusRow(name: 'Moderated Circular Desk', status: 'Operational', icon: Icons.campaign),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Reset Mock State Action Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AcademicColors.error,
                    side: const BorderSide(color: AcademicColors.error),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: AcademicColors.primary,
                        content: Text('Scholastic state reset to default institutional data.'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.restart_alt, size: 18),
                  label: Text(
                    'Reset In-Memory Fixtures',
                    style: GoogleFonts.manrope(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConfigRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isMultiline;

  const _ConfigRow({required this.label, required this.value, this.isMultiline = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(fontSize: 13, color: AcademicColors.textSecondary),
        ),
        Text(
          value,
          textAlign: TextAlign.end,
          style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.bold, color: AcademicColors.textPrimary),
        ),
      ],
    );
  }
}

class _ModuleStatusRow extends StatelessWidget {
  final String name;
  final String status;
  final IconData icon;

  const _ModuleStatusRow({required this.name, required this.status, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AcademicColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            name,
            style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w600, color: AcademicColors.textPrimary),
          ),
        ),
        PillBadge.success(status),
      ],
    );
  }
}
