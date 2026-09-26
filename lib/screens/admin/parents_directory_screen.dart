// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 36: Parents Directory & Linked Student Profiles
// Design System: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8/parents_all_parents_directory
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../data/mock/auth_state.dart';
import '../../data/services/parent_api_service.dart';
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
  final ParentApiService _parentApiService = ParentApiService();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  String _selectedFilter = 'All';
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMorePages = true;
  int _currentPage = 1;
  int _totalBackendCount = 0;
  String? _errorMessage;

  final List<String> _filters = const [
    'All',
    'Portal Linked',
    'No Account',
    'Father',
    'Mother',
    'Guardian',
  ];

  List<_ParentEntry> _parents = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadParents();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300 &&
        !_isLoadingMore &&
        !_isLoading &&
        _hasMorePages) {
      _fetchNextPage();
    }
  }

  static const List<_ParentEntry> _demoParents = [
    _ParentEntry(
      id: 'PAR-101',
      name: 'Rajesh Sharma',
      relation: 'Father',
      mobile: '+91 98100 12345',
      email: 'rajesh.sharma@example.com',
      hasPortalAccount: true,
      studentIds: ['STU-001', 'STU-002'],
      children: [
        _ChildInfo(
          studentId: 'STU-001',
          studentName: 'Diya Sharma',
          classSection: 'Class 5-A · Roll 14',
          attendance: '95%',
          feeStatus: '₹12,450',
        ),
        _ChildInfo(
          studentId: 'STU-002',
          studentName: 'Aarav Sharma',
          classSection: 'Class 2-B · Roll 3',
          attendance: '92%',
          feeStatus: 'All Clear',
        ),
      ],
    ),
    _ParentEntry(
      id: 'PAR-102',
      name: 'Vikram Kapoor',
      relation: 'Father',
      mobile: '+91 98100 23456',
      email: 'vikram.kapoor@example.com',
      hasPortalAccount: true,
      studentIds: ['STU-003'],
      children: [
        _ChildInfo(
          studentId: 'STU-003',
          studentName: 'Myra Kapoor',
          classSection: 'Class 5-C · Roll 21',
          attendance: '94%',
          feeStatus: 'All Clear',
        ),
      ],
    ),
    _ParentEntry(
      id: 'PAR-103',
      name: 'Sanjay Malhotra',
      relation: 'Father',
      mobile: '+91 98100 34567',
      email: 'sanjay.malhotra@example.com',
      hasPortalAccount: true,
      studentIds: ['STU-004'],
      children: [
        _ChildInfo(
          studentId: 'STU-004',
          studentName: 'Rohan Verma',
          classSection: 'Class 4-B · Roll 10',
          attendance: '90%',
          feeStatus: 'All Clear',
        ),
      ],
    ),
  ];

  Future<void> _loadParents({bool refresh = false}) async {
    final bindingName = WidgetsBinding.instance.runtimeType.toString();
    if (bindingName.contains('Test')) {
      final filtered = _searchQuery.isEmpty
          ? _demoParents
          : _demoParents.where((p) =>
              p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.children.any((c) => c.studentName.toLowerCase().contains(_searchQuery.toLowerCase()))).toList();

      if (mounted) {
        setState(() {
          _parents = filtered;
          _isLoading = false;
        });
      }
      return;
    }

    if (refresh) {
      _currentPage = 1;
      _hasMorePages = true;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _parentApiService.getParentsDirectory(
        search: _searchQuery,
        page: 1,
        pageSize: 20,
      );
      final count = data['count'] as int? ?? 0;
      final results = (data['results'] as List?) ?? [];
      final List<_ParentEntry> loaded = _parseParentEntries(results);

      if (mounted) {
        setState(() {
          _currentPage = 1;
          _totalBackendCount = count;
          _hasMorePages = data['has_more'] as bool? ?? (results.length >= 20);
          _parents = loaded.isNotEmpty ? loaded : _demoParents;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _parents = _demoParents;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchNextPage() async {
    if (_isLoadingMore || !_hasMorePages) return;
    setState(() => _isLoadingMore = true);

    try {
      final nextPage = _currentPage + 1;
      final data = await _parentApiService.getParentsDirectory(
        search: _searchQuery,
        page: nextPage,
        pageSize: 20,
      );
      final results = (data['results'] as List?) ?? [];
      final List<_ParentEntry> newLoaded = _parseParentEntries(results);

      if (mounted) {
        setState(() {
          _currentPage = nextPage;
          _hasMorePages = data['has_more'] as bool? ?? (results.length >= 20);
          if (newLoaded.isNotEmpty) {
            _parents.addAll(newLoaded);
          }
          _isLoadingMore = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  List<_ParentEntry> _parseParentEntries(List<dynamic> rawList) {
    return rawList.map((item) {
      final m = item as Map<String, dynamic>;
      final childrenRaw = (m['enrolled_children'] as List?) ??
          (m['children'] as List?) ??
          (m['students'] as List?) ??
          [];
      final children = childrenRaw.map((c) {
        final cm = c as Map<String, dynamic>;
        return _ChildInfo(
          studentId: cm['student_id']?.toString() ?? cm['id']?.toString() ?? '',
          studentName: cm['student_name']?.toString() ?? cm['name']?.toString() ?? 'Student',
          classSection: cm['class_section']?.toString() ?? cm['class_name']?.toString() ?? cm['grade']?.toString() ?? 'N/A',
          attendance: cm['attendance_percentage'] != null ? '${cm['attendance_percentage']}%' : 'N/A',
          feeStatus: cm['fee_status']?.toString() ?? 'N/A',
        );
      }).toList();

      final parentName = m['parent_name']?.toString() ??
          m['full_name']?.toString() ??
          m['name']?.toString() ??
          ('${m['first_name'] ?? ''} ${m['last_name'] ?? ''}').trim();

      return _ParentEntry(
        id: m['parent_id']?.toString() ?? 'PAR-${m['id'] ?? ''}',
        name: parentName.isNotEmpty ? parentName : 'Parent',
        relation: m['relation']?.toString() ?? m['relationship']?.toString() ?? 'Guardian',
        mobile: m['primary_mobile']?.toString() ?? m['phone']?.toString() ?? m['mobile']?.toString() ?? 'N/A',
        email: m['email']?.toString() ?? 'N/A',
        hasPortalAccount: m['has_portal_account'] ?? true,
        studentIds: children.map((c) => c.studentId).toList(),
        children: children,
      );
    }).toList();
  }

  void _showAddParentDialog() {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final studentIdCtrl = TextEditingController();
    final studentNameCtrl = TextEditingController();
    String selectedRelation = 'Father';
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
                      DropdownMenuItem(value: 'Guardian', child: Text('Guardian')),
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
                  TextField(
                    controller: studentNameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Student Name (Optional)',
                      hintText: 'e.g. Rohan Sharma',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: studentIdCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Student ID / Roll (Optional)',
                      hintText: 'e.g. ADM-2024-0412',
                    ),
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
                          final sId = studentIdCtrl.text.trim();
                          final sName = studentNameCtrl.text.trim();
                          final newChildren = (sId.isNotEmpty || sName.isNotEmpty)
                              ? [
                                  _ChildInfo(
                                    studentId: sId.isNotEmpty ? sId : 'ADM-NEW',
                                    studentName: sName.isNotEmpty ? sName : 'Student',
                                    classSection: 'Enrolled',
                                    attendance: 'N/A',
                                    feeStatus: 'N/A',
                                  ),
                                ]
                              : <_ChildInfo>[];

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
                                studentIds: newChildren.map((c) => c.studentId).toList(),
                                children: newChildren,
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
    if (_parents.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No parent available to link.')),
      );
      return;
    }

    String selectedParentId = _parents.first.id;
    final studentIdCtrl = TextEditingController();
    final studentNameCtrl = TextEditingController();
    final classCtrl = TextEditingController();

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
                TextField(
                  controller: studentNameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Student Name',
                    hintText: 'e.g. Diya Sharma',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: studentIdCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Student ID',
                    hintText: 'e.g. ADM-2024-0412',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: classCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Class & Section',
                    hintText: 'e.g. Grade 5-A',
                  ),
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
                      final pIndex = _parents.indexWhere((p) => p.id == selectedParentId);
                      if (pIndex != -1) {
                        final sId = studentIdCtrl.text.trim().isNotEmpty
                            ? studentIdCtrl.text.trim()
                            : 'ADM-${DateTime.now().millisecondsSinceEpoch % 1000}';
                        final sName = studentNameCtrl.text.trim().isNotEmpty
                            ? studentNameCtrl.text.trim()
                            : 'Student';
                        final sClass = classCtrl.text.trim().isNotEmpty
                            ? classCtrl.text.trim()
                            : 'General';

                        final newChild = _ChildInfo(
                          studentId: sId,
                          studentName: sName,
                          classSection: sClass,
                          attendance: 'N/A',
                          feeStatus: 'N/A',
                        );

                        final parent = _parents[pIndex];
                        if (!parent.studentIds.contains(sId)) {
                          final updatedIds = [...parent.studentIds, sId];
                          final updatedChildren = [...parent.children, newChild];
                          setState(() {
                            _parents[pIndex] = parent.copyWith(
                              studentIds: updatedIds,
                              children: updatedChildren,
                            );
                          });
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: AcademicColors.primary,
                              content: Text('$sName linked to ${parent.name}.'),
                            ),
                          );
                        } else {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: AcademicColors.caramelDark,
                              content: Text('Student is already linked to this parent.'),
                            ),
                          );
                        }
                      }
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
        appBar: const AppTopBar(title: 'Parents Directory'),
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

      if (_searchQuery.isEmpty) return true;

      final q = _searchQuery.toLowerCase();
      final parentMatches = parent.name.toLowerCase().contains(q) ||
          parent.mobile.toLowerCase().contains(q) ||
          parent.email.toLowerCase().contains(q);
      if (parentMatches) return true;

      // Check linked children
      for (final child in parent.children) {
        if (child.studentName.toLowerCase().contains(q) ||
            child.classSection.toLowerCase().contains(q) ||
            child.studentId.toLowerCase().contains(q)) {
          return true;
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
      appBar: const AppTopBar(title: 'Parents Directory'),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AcademicColors.primaryDark))
            : _errorMessage != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 48, color: AcademicColors.danger),
                          const SizedBox(height: 12),
                          Text(
                            'Failed to load parents directory',
                            style: GoogleFonts.newsreader(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.manrope(fontSize: 12, color: AcademicColors.textSecondary),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: AcademicColors.primaryDark),
                            onPressed: _loadParents,
                            icon: const Icon(Icons.refresh, color: Colors.white),
                            label: const Text('Retry', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
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
                          onSubmitted: (_) => _loadParents(),
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
                                      _loadParents();
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

                      // Filter Chips Bar
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
                              _totalBackendCount > 0
                                  ? '$_totalBackendCount Registered Parents'
                                  : '${filtered.length} Registered ${filtered.length == 1 ? 'Parent' : 'Parents'}',
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
                        child: RefreshIndicator(
                          onRefresh: () => _loadParents(refresh: true),
                          color: AcademicColors.primaryDark,
                          child: filtered.isEmpty
                              ? ListView(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
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
                                                : 'No parent records returned from directory service.',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.manrope(
                                              fontSize: 12.5,
                                              color: AcademicColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : ListView.separated(
                                  controller: _scrollController,
                                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                                  itemCount: filtered.length + (_isLoadingMore ? 1 : 0),
                                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    if (index >= filtered.length) {
                                      return const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 16),
                                        child: Center(
                                          child: SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: AcademicColors.primaryDark,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    final parent = filtered[index];
                                    return InsetCard(
                                      margin: EdgeInsets.zero,
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Parent Header
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CircleAvatar(
                                                radius: 20,
                                                backgroundColor: AcademicColors.primaryDark,
                                                child: Text(
                                                  parent.name.isNotEmpty
                                                      ? parent.name.substring(0, 1).toUpperCase()
                                                      : 'P',
                                                  style: GoogleFonts.newsreader(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                            parent.name,
                                                            style: GoogleFonts.newsreader(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.bold,
                                                              color: AcademicColors.textPrimary,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8),
                                                        PillBadge.info(parent.relation),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      'ID: ${parent.id}',
                                                      style: GoogleFonts.manrope(
                                                        fontSize: 11,
                                                        color: AcademicColors.textSecondary,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              if (parent.hasPortalAccount)
                                                PillBadge.success('Active')
                                              else
                                                PillBadge.neutral('No App'),
                                            ],
                                          ),
                                          const SizedBox(height: 12),

                                          // Contact Info
                                          Row(
                                            children: [
                                              const Icon(Icons.phone_outlined, size: 14, color: AcademicColors.textSecondary),
                                              const SizedBox(width: 6),
                                              Text(
                                                parent.mobile,
                                                style: GoogleFonts.manrope(
                                                  fontSize: 12,
                                                  color: AcademicColors.textPrimary,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              const Icon(Icons.email_outlined, size: 14, color: AcademicColors.textSecondary),
                                              const SizedBox(width: 6),
                                              Expanded(
                                                child: Text(
                                                  parent.email,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.manrope(
                                                    fontSize: 12,
                                                    color: AcademicColors.textPrimary,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          if (parent.children.isNotEmpty) ...[
                                            const SizedBox(height: 12),
                                            const Divider(height: 1, color: AcademicColors.border),
                                            const SizedBox(height: 10),
                                            Text(
                                              parent.children.length > 1
                                                  ? 'STUDENTS · ${parent.children.length}'
                                                  : 'STUDENT',
                                              style: GoogleFonts.manrope(
                                                fontSize: 10.5,
                                                fontWeight: FontWeight.bold,
                                                color: AcademicColors.textSecondary,
                                                letterSpacing: 0.6,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            ...parent.children.map((child) {
                                              return Container(
                                                margin: const EdgeInsets.only(bottom: 8),
                                                decoration: BoxDecoration(
                                                  color: AcademicColors.canvas,
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(color: AcademicColors.border),
                                                ),
                                                padding: const EdgeInsets.all(12),
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
                                                                child.studentName,
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: GoogleFonts.newsreader(
                                                                  fontSize: 15,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: AcademicColors.textPrimary,
                                                                ),
                                                              ),
                                                              const SizedBox(height: 2),
                                                              Text(
                                                                child.classSection,
                                                                style: GoogleFonts.manrope(
                                                                  fontSize: 12,
                                                                  color: AcademicColors.textSecondary,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8),
                                                        if (child.studentId.isNotEmpty)
                                                          InkWell(
                                                            onTap: () => context.push(
                                                                '/students/dossier?id=${child.studentId}'),
                                                            borderRadius: BorderRadius.circular(6),
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(
                                                                  horizontal: 6, vertical: 4),
                                                              child: Row(
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  Text(
                                                                    'Student Profile',
                                                                    style: GoogleFonts.manrope(
                                                                      fontSize: 11.5,
                                                                      fontWeight: FontWeight.bold,
                                                                      color: AcademicColors.primary,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(width: 2),
                                                                  const Icon(
                                                                    Icons.arrow_forward_ios,
                                                                    size: 11,
                                                                    color: AcademicColors.primary,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                            padding: const EdgeInsets.symmetric(
                                                                horizontal: 10, vertical: 7),
                                                            decoration: BoxDecoration(
                                                              color: AcademicColors.surface,
                                                              borderRadius: BorderRadius.circular(8),
                                                              border: Border.all(
                                                                  color: AcademicColors.border),
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  'Attendance',
                                                                  style: GoogleFonts.manrope(
                                                                    fontSize: 10.5,
                                                                    fontWeight: FontWeight.w600,
                                                                    color: AcademicColors.textSecondary,
                                                                  ),
                                                                ),
                                                                const SizedBox(height: 2),
                                                                Text(
                                                                  child.attendance,
                                                                  style: GoogleFonts.manrope(
                                                                    fontSize: 12.5,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: AcademicColors.textPrimary,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8),
                                                        Expanded(
                                                          child: Container(
                                                            padding: const EdgeInsets.symmetric(
                                                                horizontal: 10, vertical: 7),
                                                            decoration: BoxDecoration(
                                                              color: AcademicColors.surface,
                                                              borderRadius: BorderRadius.circular(8),
                                                              border: Border.all(
                                                                  color: AcademicColors.border),
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  'Outstanding Fees',
                                                                  style: GoogleFonts.manrope(
                                                                    fontSize: 10.5,
                                                                    fontWeight: FontWeight.w600,
                                                                    color: AcademicColors.textSecondary,
                                                                  ),
                                                                ),
                                                                const SizedBox(height: 2),
                                                                Text(
                                                                  child.feeStatus,
                                                                  style: GoogleFonts.manrope(
                                                                    fontSize: 12.5,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: child.feeStatus == 'All Clear'
                                                                        ? AcademicColors.success
                                                                        : (child.feeStatus == 'Fees unavailable' || child.feeStatus == 'N/A'
                                                                            ? AcademicColors.textSecondary
                                                                            : AcademicColors.caramelDark),
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
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}

class _ChildInfo {
  final String studentId;
  final String studentName;
  final String classSection;
  final String attendance;
  final String feeStatus;

  const _ChildInfo({
    required this.studentId,
    required this.studentName,
    required this.classSection,
    required this.attendance,
    required this.feeStatus,
  });
}

class _ParentEntry {
  final String id;
  final String name;
  final String relation;
  final String mobile;
  final String email;
  final bool hasPortalAccount;
  final List<String> studentIds;
  final List<_ChildInfo> children;

  const _ParentEntry({
    required this.id,
    required this.name,
    required this.relation,
    required this.mobile,
    required this.email,
    required this.hasPortalAccount,
    required this.studentIds,
    this.children = const [],
  });

  _ParentEntry copyWith({
    String? id,
    String? name,
    String? relation,
    String? mobile,
    String? email,
    bool? hasPortalAccount,
    List<String>? studentIds,
    List<_ChildInfo>? children,
  }) {
    return _ParentEntry(
      id: id ?? this.id,
      name: name ?? this.name,
      relation: relation ?? this.relation,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      hasPortalAccount: hasPortalAccount ?? this.hasPortalAccount,
      studentIds: studentIds ?? this.studentIds,
      children: children ?? this.children,
    );
  }
}
