// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 35: Add Event & Audience Scoping Form
// Design System: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8/principal_school_calendar_add_event_audience_scoping_form
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/bottom_nav_bar.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _dateController = TextEditingController(text: '2026-11-20');
  final _timeController = TextEditingController(text: '09:00 AM');

  EventCategory _selectedCategory = EventCategory.functionCelebration;
  String _selectedAudience = 'All Students & Parents';

  final List<String> _audienceOptions = [
    'All Students & Parents',
    'All Faculty & Staff',
    'Parents & Guardians',
    'Primary Wing (Grades 1-5)',
    'Senior Secondary (Grades 9-12)',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _saveEvent() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an event title.')),
      );
      return;
    }

    final newEvent = SchoolEvent(
      id: 'EVT-${DateTime.now().millisecondsSinceEpoch % 10000}',
      title: _titleController.text.trim(),
      date: _dateController.text.trim(),
      startTime: _timeController.text.trim(),
      category: _selectedCategory,
      description: _descController.text.trim().isEmpty
          ? 'Institutional calendar event scheduled.'
          : _descController.text.trim(),
      audience: _selectedAudience,
    );

    context.pop(newEvent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: const AppTopBar(title: 'Schedule Event'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Institutional Event Details',
                style: GoogleFonts.newsreader(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AcademicColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Event Title',
                  hintText: 'e.g. Annual Scholastic Exhibition 2026',
                  filled: true,
                  fillColor: AcademicColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 14),

              // Category Selector
              Text(
                'Event Classification',
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
                  child: DropdownButton<EventCategory>(
                    value: _selectedCategory,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: EventCategory.functionCelebration, child: Text('Celebration / Function')),
                      DropdownMenuItem(value: EventCategory.testExam, child: Text('Assessment / Examination')),
                      DropdownMenuItem(value: EventCategory.tripExcursion, child: Text('Excursion / Educational Trip')),
                      DropdownMenuItem(value: EventCategory.meeting, child: Text('Institutional Meeting / PTM')),
                      DropdownMenuItem(value: EventCategory.other, child: Text('Institutional Observance')),
                    ],
                    onChanged: (cat) {
                      if (cat != null) setState(() => _selectedCategory = cat);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Date & Time
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: 'Date (YYYY-MM-DD)',
                        filled: true,
                        fillColor: AcademicColors.surface,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _timeController,
                      decoration: InputDecoration(
                        labelText: 'Time',
                        filled: true,
                        fillColor: AcademicColors.surface,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
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
                    items: _audienceOptions.map((aud) {
                      return DropdownMenuItem(value: aud, child: Text(aud));
                    }).toList(),
                    onChanged: (aud) {
                      if (aud != null) setState(() => _selectedAudience = aud);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Description
              TextField(
                controller: _descController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Event Description & Guidelines',
                  hintText: 'Detailed itinerary, requirements, and instructions...',
                  filled: true,
                  fillColor: AcademicColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 24),
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
            onPressed: _saveEvent,
            icon: const Icon(Icons.event_available, size: 18),
            label: Text(
              'Publish Institutional Event →',
              style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
