// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 23: Announcement Authoring & Audience Scoping Form
// Design System: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8/23_announcement_authoring_audience_scoping_form
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/bottom_nav_bar.dart';

class AnnouncementAuthoringScreen extends StatefulWidget {
  const AnnouncementAuthoringScreen({super.key});

  @override
  State<AnnouncementAuthoringScreen> createState() => _AnnouncementAuthoringScreenState();
}

class _AnnouncementAuthoringScreenState extends State<AnnouncementAuthoringScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  String _selectedClassification = 'Circular';
  String _selectedAudience = 'All Students & Parents';
  bool _isUrgent = false;

  final List<String> _classifications = ['Circular', 'Academic Notice', 'Event', 'General Alert'];
  final List<String> _audiences = [
    'All Students & Parents',
    'Parents & Students',
    'Faculty & Staff',
    'Secondary Wing (Grades 9-12)',
    'Primary Wing (Grades 1-5)',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _submitForApproval() {
    if (_titleController.text.trim().isEmpty || _bodyController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter circular title and content.')),
      );
      return;
    }

    final newAnnouncement = Announcement(
      id: 'CIR-${DateTime.now().millisecondsSinceEpoch % 10000}',
      postType: _selectedClassification,
      title: _titleController.text.trim(),
      body: _bodyController.text.trim(),
      author: 'Academic Coordinator',
      status: AnnouncementStatus.pending,
      isPinned: _isUrgent,
      audience: _selectedAudience,
      publishedAt: DateTime.now().toIso8601String().substring(0, 10),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AcademicColors.primary,
        content: Text('Circular submitted to Principal Moderation Queue.'),
      ),
    );

    context.pop(newAnnouncement);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: const AppTopBar(
        title: 'Compose Circular',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notice Classification
              Text(
                'Notice Classification',
                style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.bold, color: AcademicColors.textSecondary),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _classifications.map((cat) {
                  final isSelected = _selectedClassification == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedClassification = cat),
                    selectedColor: AcademicColors.primary,
                    backgroundColor: AcademicColors.surface,
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
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Title Field
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Circular Title / Subject',
                  hintText: 'e.g. Schedule of Term Examination & Remedial Sessions',
                  filled: true,
                  fillColor: AcademicColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 14),

              // Audience Scoping
              Text(
                'Audience Scoping',
                style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.bold, color: AcademicColors.textSecondary),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AcademicColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AcademicColors.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedAudience,
                    isExpanded: true,
                    items: _audiences.map((aud) {
                      return DropdownMenuItem(value: aud, child: Text(aud));
                    }).toList(),
                    onChanged: (aud) {
                      if (aud != null) setState(() => _selectedAudience = aud);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Body Field
              TextField(
                controller: _bodyController,
                maxLines: 6,
                decoration: InputDecoration(
                  labelText: 'Circular Body & Institutional Directives',
                  hintText: 'Enter complete announcement, instructions, and dates...',
                  filled: true,
                  fillColor: AcademicColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 12),

              // Urgent Switch
              CheckboxListTile(
                value: _isUrgent,
                onChanged: (val) => setState(() => _isUrgent = val ?? false),
                title: Text(
                  'Pin as Urgent Institutional Circular',
                  style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w600, color: AcademicColors.textPrimary),
                ),
                subtitle: Text(
                  'Urgent circulars appear with top priority on parent and student portals.',
                  style: GoogleFonts.manrope(fontSize: 11, color: AcademicColors.textSecondary),
                ),
                activeColor: AcademicColors.primary,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 12),

              // Workflow Notice Box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AcademicColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AcademicColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.shield_outlined, color: AcademicColors.caramelDark, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Administrative Protocol: All circulars require Principal moderation approval before being broadcasted institutional-wide.',
                        style: GoogleFonts.manrope(fontSize: 11, color: AcademicColors.textSecondary, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AcademicStickyActionBar(
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AcademicColors.primaryDark,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: _submitForApproval,
            icon: const Icon(Icons.send_rounded, size: 18),
            label: Text(
              'Submit for Principal Moderation →',
              style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
