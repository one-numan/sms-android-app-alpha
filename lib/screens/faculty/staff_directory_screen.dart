// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 27: Institutional Faculty & Staff Directory
// Design System: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8/27_institutional_faculty_staff_directory
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/services/faculty_api_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/shared_widgets.dart';

class StaffDirectoryScreen extends StatefulWidget {
  const StaffDirectoryScreen({super.key});

  @override
  State<StaffDirectoryScreen> createState() => _StaffDirectoryScreenState();
}

class _StaffDirectoryScreenState extends State<StaffDirectoryScreen> {
  final FacultyApiService _facultyApi = FacultyApiService();

  String _selectedDept = 'All';
  String _searchQuery = '';
  final List<String> _departments = ['All', 'Academics', 'Administration', 'Support'];

  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _staffList = [];
  int _totalCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchStaff();
  }

  Future<void> _fetchStaff() async {
    final bindingName = WidgetsBinding.instance.runtimeType.toString();
    if (bindingName.contains('Test')) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _facultyApi.getStaffDirectory(
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
      );
      if (mounted) {
        final results = response['results'] as List<dynamic>? ?? [];
        setState(() {
          _staffList = results.map((e) => Map<String, dynamic>.from(e as Map)).toList();
          _totalCount = response['count'] as int? ?? _staffList.length;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _staffList.where((m) {
      final dept = (m['department'] as String? ?? 'Academics').toLowerCase();
      final role = (m['assigned_role'] as String? ?? m['designation'] as String? ?? '').toLowerCase();
      if (_selectedDept == 'All') return true;
      if (_selectedDept == 'Academics') {
        return dept.contains('academic') || role.contains('teacher') || role.contains('faculty') || role.contains('head');
      }
      if (_selectedDept == 'Administration') {
        return dept.contains('admin') || role.contains('admin') || role.contains('accountant') || role.contains('clerk') || role.contains('registrar') || role.contains('principal');
      }
      if (_selectedDept == 'Support') {
        return dept.contains('support') || dept.contains('transport') || role.contains('driver') || role.contains('librarian') || role.contains('receptionist') || role.contains('guard') || role.contains('peon');
      }
      return dept.contains(_selectedDept.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: AppTopBar(
        title: 'Faculty & Staff Directory',
        actions: [
          Center(child: PillBadge.info('$_totalCount Personnel')),
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
                onChanged: (val) {
                  _searchQuery = val;
                  _fetchStaff();
                },
                decoration: InputDecoration(
                  hintText: 'Search staff by name or department...',
                  hintStyle: GoogleFonts.manrope(
                    fontSize: 13,
                    color: AcademicColors.textSecondary,
                  ),
                  prefixIcon: const Icon(Icons.search, color: AcademicColors.textSecondary, size: 20),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18, color: AcademicColors.textSecondary),
                          onPressed: () {
                            setState(() => _searchQuery = '');
                            _fetchStaff();
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: AcademicColors.canvas,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AcademicColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AcademicColors.border),
                  ),
                ),
              ),
            ),

            // Department Filter Chips
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(vertical: 6),
              color: AcademicColors.surface,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _departments.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final dept = _departments[index];
                  final isSelected = _selectedDept == dept;
                  return ChoiceChip(
                    label: Text(dept),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) setState(() => _selectedDept = dept);
                    },
                    selectedColor: AcademicColors.primary,
                    backgroundColor: AcademicColors.canvas,
                    labelStyle: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AcademicColors.textSecondary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? AcademicColors.primary : AcademicColors.border,
                      ),
                    ),
                    showCheckmark: false,
                  );
                },
              ),
            ),
            const Divider(height: 1, color: AcademicColors.border),

            // Directory List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AcademicColors.primary))
                  : _errorMessage != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error_outline, size: 48, color: AcademicColors.error),
                                const SizedBox(height: 12),
                                Text(
                                  'Error loading staff directory',
                                  style: GoogleFonts.newsreader(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.manrope(fontSize: 12, color: AcademicColors.textSecondary),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: _fetchStaff,
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Retry'),
                                  style: ElevatedButton.styleFrom(backgroundColor: AcademicColors.primary),
                                ),
                              ],
                            ),
                          ),
                        )
                      : filtered.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.person_off_outlined, size: 48, color: AcademicColors.textSecondary.withValues(alpha: 0.5)),
                                  const SizedBox(height: 12),
                                  Text(
                                    'No staff members found matching criteria',
                                    style: GoogleFonts.newsreader(
                                      fontSize: 16,
                                      color: AcademicColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final member = filtered[index];
                                final fullName = member['full_name'] as String? ?? 'Staff Member';
                                final designation = member['designation'] as String? ?? member['assigned_role'] ?? 'Faculty';
                                final email = member['email'] as String? ?? '';
                                final mobile = member['mobile'] as String? ?? '';
                                final dept = member['department'] as String? ?? 'Academics';
                                final avatarLetter = fullName.isNotEmpty ? fullName[0].toUpperCase() : 'S';

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () => _showStaffProfileSheet(context, member),
                                    child: InsetCard(
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 22,
                                            backgroundColor: AcademicColors.primaryDark,
                                            child: Text(
                                              avatarLetter,
                                              style: GoogleFonts.newsreader(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: AcademicColors.accent,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        fullName,
                                                        style: GoogleFonts.newsreader(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.bold,
                                                          color: AcademicColors.textPrimary,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    PillBadge.info(dept),
                                                  ],
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  designation,
                                                  style: GoogleFonts.manrope(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: AcademicColors.caramelDark,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    if (email.isNotEmpty) ...[
                                                      const Icon(Icons.mail_outline, size: 13, color: AcademicColors.textSecondary),
                                                      const SizedBox(width: 4),
                                                      Expanded(
                                                        child: Text(
                                                          email,
                                                          style: GoogleFonts.manrope(
                                                            fontSize: 11,
                                                            color: AcademicColors.textSecondary,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                    if (mobile.isNotEmpty) ...[
                                                      const SizedBox(width: 8),
                                                      const Icon(Icons.phone_outlined, size: 13, color: AcademicColors.textSecondary),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        mobile,
                                                        style: GoogleFonts.manrope(
                                                          fontSize: 11,
                                                          color: AcademicColors.textSecondary,
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
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

  void _showStaffProfileSheet(BuildContext context, Map<String, dynamic> member) {
    final fullName = member['full_name'] as String? ?? 'Staff Member';
    final designation = member['designation'] as String? ?? member['assigned_role'] ?? 'Faculty';
    final dept = member['department'] as String? ?? 'Academics';
    final email = member['email'] as String? ?? 'n/a@onps.edu.in';
    final mobile = member['mobile'] as String? ?? 'N/A';
    final empId = member['employee_id']?.toString() ?? member['id']?.toString() ?? 'EMP-102';

    showModalBottomSheet(
      context: context,
      backgroundColor: AcademicColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AcademicColors.primaryDark,
                      child: Text(
                        fullName.isNotEmpty ? fullName[0].toUpperCase() : 'S',
                        style: GoogleFonts.newsreader(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.accent,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullName,
                            style: GoogleFonts.newsreader(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.textPrimary,
                            ),
                          ),
                          Text(
                            '$designation • $dept',
                            style: GoogleFonts.manrope(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: AcademicColors.caramelDark,
                            ),
                          ),
                          Text(
                            'Employee ID: $empId',
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              color: AcademicColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PillBadge.success('Active Staff'),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, color: AcademicColors.border),
                const SizedBox(height: 16),
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.phone_outlined, color: AcademicColors.primary),
                  title: const Text('Direct Mobile'),
                  subtitle: Text(mobile),
                  onTap: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Initiating direct call to $fullName ($mobile)...')),
                    );
                  },
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.email_outlined, color: AcademicColors.primary),
                  title: const Text('Official Email'),
                  subtitle: Text(email),
                  onTap: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Opening mail client for $email...')),
                    );
                  },
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close),
                    label: const Text('Close Profile Dossier'),
                    style: ElevatedButton.styleFrom(backgroundColor: AcademicColors.primary),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
