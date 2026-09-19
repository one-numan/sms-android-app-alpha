// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 30: Admissions Enquiry & Prospect Intake Desk
// Design System: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8/30_admissions_enquiry_prospect_intake_desk
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/mock/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/shared_widgets.dart';

class AdmissionsEnquiryScreen extends StatefulWidget {
  const AdmissionsEnquiryScreen({super.key});

  @override
  State<AdmissionsEnquiryScreen> createState() => _AdmissionsEnquiryScreenState();
}

class _AdmissionsEnquiryScreenState extends State<AdmissionsEnquiryScreen> {
  String _selectedStatus = 'All';
  String _searchQuery = '';
  late List<AdmissionsEnquiry> _enquiries;

  final List<String> _statusFilters = ['All', 'Open', 'Follow-up', 'Converted', 'Closed'];

  @override
  void initState() {
    super.initState();
    _enquiries = List.from(MockData.enquiries);
  }

  void _showNewEnquiryDialog() {
    final nameController = TextEditingController();
    final parentController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    String targetClass = 'Grade 1';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: AcademicColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'New Admission Prospect Intake',
                        style: GoogleFonts.newsreader(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: AcademicColors.textSecondary),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Student Prospect Name',
                      hintText: 'e.g. Advait Sharma',
                      filled: true,
                      fillColor: AcademicColors.canvas,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: parentController,
                    decoration: InputDecoration(
                      labelText: 'Parent / Guardian Name',
                      hintText: 'e.g. Rajesh Sharma',
                      filled: true,
                      fillColor: AcademicColors.canvas,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Contact Phone',
                            hintText: '+91 98110 00000',
                            filled: true,
                            fillColor: AcademicColors.canvas,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            hintText: 'parent@example.com',
                            filled: true,
                            fillColor: AcademicColors.canvas,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AcademicColors.primary,
                        foregroundColor: AcademicColors.surface,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        if (nameController.text.trim().isNotEmpty) {
                          setState(() {
                            _enquiries.insert(
                              0,
                              AdmissionsEnquiry(
                                id: 'ENQ-${DateTime.now().millisecondsSinceEpoch % 10000}',
                                studentName: nameController.text.trim(),
                                parentName: parentController.text.trim().isEmpty ? 'Guardian' : parentController.text.trim(),
                                email: emailController.text.trim(),
                                phone: phoneController.text.trim(),
                                seekingClass: targetClass,
                                status: EnquiryStatus.pending,
                                enquiryDate: DateTime.now().toIso8601String().substring(0, 10),
                                notes: 'Direct front-desk admissions enquiry registered.',
                              ),
                            );
                          });
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: AcademicColors.primary,
                              content: Text('Admissions enquiry recorded in admissions intake ledger.'),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'Record Prospect Intake',
                        style: GoogleFonts.manrope(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _enquiries.where((e) {
      final matchesQuery = _searchQuery.isEmpty ||
          e.studentName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          e.parentName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          e.seekingClass.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _selectedStatus == 'All' ||
          (_selectedStatus == 'Open' && e.status == EnquiryStatus.pending) ||
          (_selectedStatus == 'Follow-up' && e.status == EnquiryStatus.contacted) ||
          (_selectedStatus == 'Converted' && e.status == EnquiryStatus.converted) ||
          (_selectedStatus == 'Closed' && e.status == EnquiryStatus.rejected);
      return matchesQuery && matchesStatus;
    }).toList();

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: AppTopBar(
        title: 'Admissions Desk',
        actions: [
          IconButton(
            tooltip: 'New Intake',
            icon: const Icon(Icons.person_add_alt_1, color: AcademicColors.primary, size: 22),
            onPressed: _showNewEnquiryDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Intake Pipeline Bento Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AcademicColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AcademicColors.border),
                boxShadow: [
                  BoxShadow(
                    color: AcademicColors.primary.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.account_tree_outlined, size: 18, color: AcademicColors.caramelDark),
                          const SizedBox(width: 8),
                          Text(
                            'Intake Pipeline',
                            style: GoogleFonts.newsreader(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      PillBadge.info('Session 2026-27'),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _BentoMetric(
                          title: 'Enquiries',
                          value: '${_enquiries.length}',
                          subtitle: 'Total Registered',
                          color: AcademicColors.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _BentoMetric(
                          title: 'Contacted',
                          value: '${_enquiries.where((e) => e.status == EnquiryStatus.contacted).length + 3}',
                          subtitle: 'In Evaluation',
                          color: AcademicColors.caramelDark,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _BentoMetric(
                          title: 'Converted',
                          value: '${_enquiries.where((e) => e.status == EnquiryStatus.converted).length + 7}',
                          subtitle: 'Enrolled Seats',
                          color: AcademicColors.success,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Search Bar & Filter Chips
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Search prospects by student, parent, or class...',
                  hintStyle: GoogleFonts.manrope(fontSize: 13, color: AcademicColors.textSecondary),
                  prefixIcon: const Icon(Icons.search, size: 20, color: AcademicColors.textSecondary),
                  filled: true,
                  fillColor: AcademicColors.surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AcademicColors.border),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _statusFilters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final status = _statusFilters[index];
                  final isSelected = _selectedStatus == status;
                  return ChoiceChip(
                    label: Text(status),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedStatus = status),
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
                },
              ),
            ),
            const SizedBox(height: 8),

            // Enquiries List
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        'No admissions prospects found',
                        style: GoogleFonts.newsreader(fontSize: 16, color: AcademicColors.textSecondary),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final enquiry = filtered[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: InsetCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        enquiry.studentName,
                                        style: GoogleFonts.newsreader(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: AcademicColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    _buildStatusBadge(enquiry.status),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      'Seeking: ${enquiry.seekingClass}',
                                      style: GoogleFonts.manrope(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AcademicColors.caramelDark,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text('•', style: TextStyle(color: AcademicColors.border)),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Parent: ${enquiry.parentName}',
                                      style: GoogleFonts.manrope(
                                        fontSize: 13,
                                        color: AcademicColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                if (enquiry.notes.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    enquiry.notes,
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                      color: AcademicColors.textSecondary,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Enquiry Date: ${enquiry.enquiryDate}',
                                      style: GoogleFonts.manrope(
                                        fontSize: 11,
                                        color: AcademicColors.textSecondary,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          enquiry.phone,
                                          style: GoogleFonts.manrope(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: AcademicColors.textPrimary,
                                          ),
                                        ),
                                      ],
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
            onPressed: _showNewEnquiryDialog,
            icon: const Icon(Icons.person_add_alt_1, size: 18),
            label: Text(
              'Register New Prospect Enquiry →',
              style: GoogleFonts.manrope(fontSize: 13.5, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(EnquiryStatus status) {
    switch (status) {
      case EnquiryStatus.pending:
        return PillBadge.warning('Under Review');
      case EnquiryStatus.contacted:
        return PillBadge.info('Follow-up');
      case EnquiryStatus.converted:
        return PillBadge.success('Enrolled');
      case EnquiryStatus.rejected:
        return PillBadge.secondary('Closed');
      default:
        return PillBadge.warning('Under Review');
    }
  }
}

class _BentoMetric extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const _BentoMetric({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AcademicColors.canvas,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.manrope(fontSize: 11, color: AcademicColors.textSecondary),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.newsreader(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.manrope(fontSize: 9, color: AcademicColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
