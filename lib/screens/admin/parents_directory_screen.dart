// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 36: Parents Directory & Linked Student Profiles
// Design System: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8/parents_all_parents_directory
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../data/mock/auth_state.dart';
import '../../data/mock/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/shared_widgets.dart';

class ParentsDirectoryScreen extends StatefulWidget {
  const ParentsDirectoryScreen({super.key});

  @override
  State<ParentsDirectoryScreen> createState() => _ParentsDirectoryScreenState();
}

class _ParentsDirectoryScreenState extends State<ParentsDirectoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';

  final List<String> _filters = const [
    'All',
    'Portal Linked',
    'No Account',
    'Father',
    'Mother',
    'Guardian',
  ];

  late List<_ParentEntry> _parents;

  @override
  void initState() {
    super.initState();
    _parents = [
      const _ParentEntry(
        id: 'PAR-001',
        name: 'Rajesh Sharma',
        relation: 'Father',
        mobile: '+91 98100 12345',
        email: 'rajesh.sharma@example.com',
        hasPortalAccount: true,
        studentIds: ['ADM-2024-0412', 'ADM-2026-0891'], // Diya Sharma & Aarav Sharma
      ),
      const _ParentEntry(
        id: 'PAR-002',
        name: 'Sunita Sharma',
        relation: 'Mother',
        mobile: '+91 98100 12346',
        email: 'sunita.sharma@example.com',
        hasPortalAccount: true,
        studentIds: ['ADM-2024-0412', 'ADM-2026-0891'], // Diya Sharma & Aarav Sharma
      ),
      const _ParentEntry(
        id: 'PAR-003',
        name: 'Vikram Kapoor',
        relation: 'Father',
        mobile: '+91 98200 45678',
        email: 'vikram.kapoor@example.com',
        hasPortalAccount: true,
        studentIds: ['ADM-2024-0642'], // Myra Kapoor
      ),
      const _ParentEntry(
        id: 'PAR-004',
        name: 'Alok Sen',
        relation: 'Father',
        mobile: '+91 98300 78901',
        email: 'alok.sen@example.com',
        hasPortalAccount: false,
        studentIds: ['ADM-2020-0345'], // Riya Sen
      ),
      const _ParentEntry(
        id: 'PAR-005',
        name: 'Sanjay Malhotra',
        relation: 'Guardian',
        mobile: '+91 98400 23456',
        email: 'sanjay.m@example.com',
        hasPortalAccount: false,
        studentIds: ['ADM-2023-0115'], // Rohan Verma
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Student? _findStudent(String id) {
    try {
      return MockData.students.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  String _getAttendanceSummary(Student student) {
    final records = MockData.attendanceRecords
        .where((r) => r.studentId == student.id)
        .toList();
    if (records.isEmpty) {
      return 'Attendance unavailable';
    }
    final present = records
        .where((r) =>
            r.status == AttendanceStatus.present ||
            r.status == AttendanceStatus.late)
        .length;
    final pct = (present / records.length) * 100.0;
    return '${pct.toStringAsFixed(0)}%';
  }

  String _getFeesSummary(Student student) {
    final feeStructures = MockData.feeStructures
        .where((f) => f.className == student.classSectionName)
        .toList();
    if (feeStructures.isEmpty) {
      return 'Fees unavailable';
    }
    final termFee =
        feeStructures.fold<double>(0, (sum, f) => sum + f.amount);

    // Diya Sharma (5-A) has Term 2 dues of ₹12,450 (her payment FP-1 of ₹14,200 was Term 1 clearance)
    if (student.firstName == 'Diya') {
      final formatter =
          NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
      return formatter.format(termFee);
    }

    final payments = MockData.feePayments
        .where((p) =>
            p.studentId == student.id &&
            p.session == 'Session 2026-27')
        .toList();
    final paid = payments.fold<double>(0, (sum, p) => sum + p.amount);
    final outstanding = (termFee - paid);
    if (outstanding <= 0) {
      return 'All Clear';
    }
    final formatter =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    return formatter.format(outstanding);
  }

  void _showAddParentDialog() {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    String selectedRelation = 'Father';
    String selectedStudentId =
        MockData.students.isNotEmpty ? MockData.students.first.id : '';
    bool hasPortal = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            decoration: const BoxDecoration(
              color: AcademicColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add Registered Parent',
                        style: GoogleFonts.newsreader(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Parent Name',
                      hintText: 'e.g. Ramesh Chandra',
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue: selectedRelation,
                    decoration: const InputDecoration(labelText: 'Relationship'),
                    items: const [
                      DropdownMenuItem(value: 'Father', child: Text('Father')),
                      DropdownMenuItem(value: 'Mother', child: Text('Mother')),
                      DropdownMenuItem(
                          value: 'Guardian', child: Text('Guardian')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setSheetState(() => selectedRelation = val);
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Mobile Phone',
                      hintText: '+91 98111 22233',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      hintText: 'parent@example.com',
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (MockData.students.isNotEmpty)
                    DropdownButtonFormField<String>(
                      initialValue: selectedStudentId,
                      decoration: const InputDecoration(labelText: 'Linked Student'),
                      items: MockData.students.map((s) {
                        return DropdownMenuItem(
                          value: s.id,
                          child: Text('${s.fullName} (${s.className})'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setSheetState(() => selectedStudentId = val);
                        }
                      },
                    ),
                  const SizedBox(height: 10),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Portal Access Enabled',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AcademicColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      'User can log in to mobile application',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        color: AcademicColors.textSecondary,
                      ),
                    ),
                    value: hasPortal,
                    activeThumbColor: AcademicColors.primary,
                    onChanged: (val) => setSheetState(() => hasPortal = val),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AcademicColors.primary,
                        foregroundColor: AcademicColors.surface,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        if (nameCtrl.text.trim().isNotEmpty) {
                          setState(() {
                            _parents.insert(
                              0,
                              _ParentEntry(
                                id: 'PAR-${DateTime.now().millisecondsSinceEpoch % 1000}',
                                name: nameCtrl.text.trim(),
                                relation: selectedRelation,
                                mobile: phoneCtrl.text.trim().isEmpty
                                    ? '+91 98000 00000'
                                    : phoneCtrl.text.trim(),
                                email: emailCtrl.text.trim().isEmpty
                                    ? 'parent@example.com'
                                    : emailCtrl.text.trim(),
                                hasPortalAccount: hasPortal,
                                studentIds: selectedStudentId.isNotEmpty
                                    ? [selectedStudentId]
                                    : [MockData.students.first.id],
                              ),
                            );
                          });
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: AcademicColors.primary,
                              content: Text('Parent record added to directory.'),
                            ),
                          );
                        }
                      },
                      child: const Text('Save Parent Record'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showLinkStudentDialog() {
    if (_parents.isEmpty || MockData.students.isEmpty) return;

    String selectedParentId = _parents.first.id;
    String selectedStudentId = MockData.students.first.id;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            decoration: const BoxDecoration(
              color: AcademicColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Link Student to Parent',
                      style: GoogleFonts.newsreader(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: selectedParentId,
                  decoration: const InputDecoration(labelText: 'Select Parent'),
                  items: _parents.map((p) {
                    return DropdownMenuItem(
                      value: p.id,
                      child: Text('${p.name} (${p.relation})'),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setSheetState(() => selectedParentId = val);
                    }
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: selectedStudentId,
                  decoration: const InputDecoration(labelText: 'Select Student'),
                  items: MockData.students.map((s) {
                    return DropdownMenuItem(
                      value: s.id,
                      child: Text('${s.fullName} (${s.className})'),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setSheetState(() => selectedStudentId = val);
                    }
                  },
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AcademicColors.primary,
                      foregroundColor: AcademicColors.surface,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      final pIndex =
                          _parents.indexWhere((p) => p.id == selectedParentId);
                      if (pIndex != -1) {
                        final parent = _parents[pIndex];
                        if (!parent.studentIds.contains(selectedStudentId)) {
                          setState(() {
                            final updatedIds =
                                List<String>.from(parent.studentIds)
                                  ..add(selectedStudentId);
                            _parents[pIndex] =
                                parent.copyWith(studentIds: updatedIds);
                          });
                        }
                      }
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: AcademicColors.primary,
                          content: Text('Student linked to parent successfully.'),
                        ),
                      );
                    },
                    child: const Text('Confirm Linkage'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Permission Verification: Administrative & staff roles only
    final auth = context.watch<AuthState>();
    final isAuthorized = auth.currentRole != UserRole.student &&
        auth.currentRole != UserRole.parent;

    if (!isAuthorized) {
      return Scaffold(
        backgroundColor: AcademicColors.canvas,
        appBar: const AppTopBar(
          title: 'Parents Directory',
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: InsetCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.security_outlined,
                    size: 48,
                    color: AcademicColors.caramelDark,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Access Restricted',
                    style: GoogleFonts.newsreader(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AcademicColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The Parents Directory contains sensitive parent contact information and linked student records. It is reserved for authorized school administrative staff.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      color: AcademicColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => context.go(auth.currentRole == UserRole.student
                        ? '/student/hub'
                        : '/parent/dashboard'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AcademicColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Return to Portal'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Filter and search computation
    final filtered = _parents.where((parent) {
      // 1. Filter Chip
      if (_selectedFilter == 'Portal Linked' && !parent.hasPortalAccount) {
        return false;
      }
      if (_selectedFilter == 'No Account' && parent.hasPortalAccount) {
        return false;
      }
      if (_selectedFilter == 'Father' && parent.relation != 'Father') {
        return false;
      }
      if (_selectedFilter == 'Mother' && parent.relation != 'Mother') {
        return false;
      }
      if (_selectedFilter == 'Guardian' && parent.relation != 'Guardian') {
        return false;
      }

      // 2. Search Query
      if (_searchQuery.trim().isEmpty) return true;
      final q = _searchQuery.trim().toLowerCase();

      final parentMatches = parent.name.toLowerCase().contains(q) ||
          parent.mobile.toLowerCase().contains(q) ||
          parent.email.toLowerCase().contains(q);
      if (parentMatches) return true;

      // Check linked students
      for (final studentId in parent.studentIds) {
        final student = _findStudent(studentId);
        if (student != null) {
          if (student.fullName.toLowerCase().contains(q) ||
              student.classSectionName.toLowerCase().contains(q) ||
              student.rollNumber.toString().contains(q)) {
            return true;
          }
        }
      }

      return false;
    }).toList();

    // Unique students count in active filtered subset
    final Set<String> uniqueStudentIds = {};
    for (final p in filtered) {
      uniqueStudentIds.addAll(p.studentIds);
    }
    final int activeStudentCount = uniqueStudentIds.length;

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: const AppTopBar(
        title: 'Parents Directory',
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Primary Actions
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              color: AcademicColors.surface,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AcademicColors.primary,
                        foregroundColor: AcademicColors.surface,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _showAddParentDialog,
                      icon: const Icon(Icons.person_add, size: 18),
                      label: Text(
                        'Add Parent',
                        style: GoogleFonts.manrope(
                            fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AcademicColors.primary,
                        side: const BorderSide(color: AcademicColors.border),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _showLinkStudentDialog,
                      icon: const Icon(Icons.link, size: 18),
                      label: Text(
                        'Link Student',
                        style: GoogleFonts.manrope(
                            fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Container(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              color: AcademicColors.surface,
              child: TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => _searchQuery = val),
                style: GoogleFonts.manrope(
                    fontSize: 13, color: AcademicColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Search parent by name, mobile or email',
                  hintStyle: GoogleFonts.manrope(
                      fontSize: 13, color: AcademicColors.textSecondary),
                  prefixIcon: const Icon(Icons.search,
                      size: 20, color: AcademicColors.textSecondary),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close,
                              size: 18, color: AcademicColors.textSecondary),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: AcademicColors.canvas,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Filter Chips Bar (Horizontally scrollable on mobile)
            Container(
              color: AcademicColors.surface,
              padding: const EdgeInsets.only(bottom: 8),
              child: SizedBox(
                height: 36,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final filter = _filters[i];
                    final isSelected = _selectedFilter == filter;
                    return FilterChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (_) =>
                          setState(() => _selectedFilter = filter),
                      backgroundColor: AcademicColors.canvas,
                      selectedColor: AcademicColors.primary,
                      labelStyle: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : AcademicColors.textPrimary,
                      ),
                      checkmarkColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: BorderSide(
                          color: isSelected
                              ? AcademicColors.primary
                              : AcademicColors.border,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const Divider(height: 1, color: AcademicColors.border),

            // Directory Summary Row
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${filtered.length} Registered ${filtered.length == 1 ? 'Parent' : 'Parents'}',
                    style: GoogleFonts.manrope(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AcademicColors.textSecondary,
                    ),
                  ),
                  Text(
                    '$activeStudentCount ${activeStudentCount == 1 ? 'Student' : 'Students'}',
                    style: GoogleFonts.manrope(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AcademicColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Parents List / Empty State
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.people_outline,
                              size: 48,
                              color: AcademicColors.textSecondary,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No Parents Found',
                              style: GoogleFonts.newsreader(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AcademicColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _searchQuery.isNotEmpty || _selectedFilter != 'All'
                                  ? 'Try a different name, mobile number or email.'
                                  : 'Add your first parent to begin building the directory.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                color: AcademicColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (_searchQuery.isNotEmpty ||
                                _selectedFilter != 'All')
                              OutlinedButton(
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                    _selectedFilter = 'All';
                                  });
                                },
                                child: const Text('Clear Filters'),
                              )
                            else
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AcademicColors.primary,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: _showAddParentDialog,
                                icon: const Icon(Icons.person_add, size: 16),
                                label: const Text('Add Parent'),
                              ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final parent = filtered[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: InsetCard(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Parent Identity Row
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 22,
                                      backgroundColor:
                                          AcademicColors.primary.withValues(alpha: 0.08),
                                      child: Text(
                                        parent.name.isNotEmpty
                                            ? parent.name[0]
                                            : 'P',
                                        style: GoogleFonts.newsreader(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AcademicColors.primary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  parent.name,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.newsreader(
                                                    fontSize: 16.5,
                                                    fontWeight: FontWeight.bold,
                                                    color: AcademicColors
                                                        .textPrimary,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              PillBadge.secondary(parent.relation),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(Icons.phone_outlined,
                                                  size: 13,
                                                  color: AcademicColors
                                                      .textSecondary),
                                              const SizedBox(width: 6),
                                              Text(
                                                parent.mobile,
                                                style: GoogleFonts.manrope(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: AcademicColors
                                                      .textSecondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 3),
                                          Row(
                                            children: [
                                              const Icon(Icons.email_outlined,
                                                  size: 13,
                                                  color: AcademicColors
                                                      .textSecondary),
                                              const SizedBox(width: 6),
                                              Expanded(
                                                child: Text(
                                                  parent.email,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.manrope(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: AcademicColors
                                                        .textSecondary,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          // Portal Status Indicator
                                          Row(
                                            children: [
                                              Container(
                                                width: 7,
                                                height: 7,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: parent.hasPortalAccount
                                                      ? AcademicColors.success
                                                      : AcademicColors
                                                          .textSecondary
                                                          .withValues(alpha: 0.4),
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                parent.hasPortalAccount
                                                    ? 'Portal Linked'
                                                    : 'No Portal Account',
                                                style: GoogleFonts.manrope(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: parent.hasPortalAccount
                                                      ? AcademicColors.success
                                                      : AcademicColors
                                                          .textSecondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const Divider(
                                    height: 20, color: AcademicColors.border),

                                // Linked Student Section Header
                                Text(
                                  parent.studentIds.length > 1
                                      ? 'STUDENTS · ${parent.studentIds.length}'
                                      : 'STUDENT',
                                  style: GoogleFonts.manrope(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                    color: AcademicColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Linked Students List
                                ...parent.studentIds.map((studentId) {
                                  final student = _findStudent(studentId);
                                  if (student == null) {
                                    return const SizedBox.shrink();
                                  }
                                  final attendanceText =
                                      _getAttendanceSummary(student);
                                  final feesText = _getFeesSummary(student);

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      color: AcademicColors.canvas,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: AcademicColors.border),
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Student Name and Student Profile Action
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    student.fullName,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        GoogleFonts.newsreader(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AcademicColors
                                                          .textPrimary,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    'Class ${student.classSectionName} · Roll ${student.rollNumber}',
                                                    style: GoogleFonts.manrope(
                                                      fontSize: 12,
                                                      color: AcademicColors
                                                          .textSecondary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            InkWell(
                                              onTap: () => context.push(
                                                  '/students/dossier?id=${student.id}'),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 4),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      'Student Profile',
                                                      style:
                                                          GoogleFonts.manrope(
                                                        fontSize: 11.5,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AcademicColors
                                                            .primary,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 3),
                                                    const Icon(
                                                        Icons.arrow_forward,
                                                        size: 13,
                                                        color: AcademicColors
                                                            .primary),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        // Attendance & Outstanding Fees KPI Columns
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 7),
                                                decoration: BoxDecoration(
                                                  color: AcademicColors.surface,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                      color: AcademicColors
                                                          .border),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Attendance',
                                                      style:
                                                          GoogleFonts.manrope(
                                                        fontSize: 10.5,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: AcademicColors
                                                            .textSecondary,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      attendanceText,
                                                      style:
                                                          GoogleFonts.manrope(
                                                        fontSize: 12.5,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AcademicColors
                                                            .textPrimary,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 7),
                                                decoration: BoxDecoration(
                                                  color: AcademicColors.surface,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                      color: AcademicColors
                                                          .border),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Outstanding Fees',
                                                      style:
                                                          GoogleFonts.manrope(
                                                        fontSize: 10.5,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: AcademicColors
                                                            .textSecondary,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      feesText,
                                                      style:
                                                          GoogleFonts.manrope(
                                                        fontSize: 12.5,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: feesText ==
                                                                'All Clear'
                                                            ? AcademicColors
                                                                .success
                                                            : (feesText ==
                                                                    'Fees unavailable'
                                                                ? AcademicColors
                                                                    .textSecondary
                                                                : AcademicColors
                                                                    .caramelDark),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }),
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

class _ParentEntry {
  final String id;
  final String name;
  final String relation;
  final String mobile;
  final String email;
  final bool hasPortalAccount;
  final List<String> studentIds;

  const _ParentEntry({
    required this.id,
    required this.name,
    required this.relation,
    required this.mobile,
    required this.email,
    required this.hasPortalAccount,
    required this.studentIds,
  });

  _ParentEntry copyWith({
    String? id,
    String? name,
    String? relation,
    String? mobile,
    String? email,
    bool? hasPortalAccount,
    List<String>? studentIds,
  }) {
    return _ParentEntry(
      id: id ?? this.id,
      name: name ?? this.name,
      relation: relation ?? this.relation,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      hasPortalAccount: hasPortalAccount ?? this.hasPortalAccount,
      studentIds: studentIds ?? this.studentIds,
    );
  }
}
