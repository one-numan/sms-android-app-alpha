// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 05: Parent Portal / Parent Home Screen
// Connected to Django REST API: GET /api/v1/parent/dashboard/
// Design System: Espresso Heritage Academic
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../data/mock/auth_state.dart';
import '../../data/services/parent_api_service.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/account_profile_sheet.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/shared_widgets.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  final ParentApiService _parentApiService = ParentApiService();
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _dashboardData;

  @override
  void initState() {
    super.initState();
    _fetchDashboard();
  }

  Future<void> _fetchDashboard() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final data = await _parentApiService.getDashboard();
      if (mounted) {
        setState(() {
          _dashboardData = data;
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

  static String _formatCurrency(num amount) {
    final intVal = amount.toInt();
    final str = intVal.toString();
    if (str.length > 3) {
      final lastThree = str.substring(str.length - 3);
      final remaining = str.substring(0, str.length - 3);
      final regExp = RegExp(r'(\d+?)(?=(\d{2})+$)');
      final indianFormattedRemaining = remaining.replaceAllMapped(regExp, (Match m) => '${m[1]},');
      return '₹$indianFormattedRemaining,$lastThree';
    }
    return '₹$str';
  }

  @override
  Widget build(BuildContext context) {
    final children = (_dashboardData?['children'] as List?) ?? [];
    final childrenCount = _dashboardData?['children_count'] as int? ?? children.length;
    final totalDues = (_dashboardData?['total_dues'] as num?)?.toDouble() ?? 0.0;

    final selectedIndex = context.watch<AuthState>().selectedChildIndex.clamp(0, children.isNotEmpty ? children.length - 1 : 0);
    final selectedChild = children.isNotEmpty ? children[selectedIndex] : null;

    final childName = selectedChild?['full_name'] ?? 'Child';
    final childClass = selectedChild?['class_section'] ?? '-';
    final childAttendance = selectedChild?['attendance_percentage'] != null
        ? (selectedChild!['attendance_percentage'] as num).toDouble()
        : null;
    final childDues = selectedChild?['dues'] != null
        ? (selectedChild!['dues'] as num).toDouble()
        : 0.0;

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: const AppTopBar(showBrand: true),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchDashboard,
          color: AcademicColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_errorMessage != null)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AcademicColors.dangerContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'API Connection Note: $_errorMessage',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: AcademicColors.danger,
                      ),
                    ),
                  ),

                // 1. Parent Identity Card
                InkWell(
                  onTap: () => AccountProfileSheet.show(context),
                  borderRadius: BorderRadius.circular(12),
                  child: InsetCard(
                    margin: EdgeInsets.zero,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: AcademicColors.primaryDark,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              'PR',
                              style: GoogleFonts.newsreader(
                                fontSize: 16,
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
                                'Parent Portal',
                                style: GoogleFonts.newsreader(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AcademicColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Guardian • Enrolled Children: $childrenCount',
                                style: GoogleFonts.manrope(
                                  fontSize: 11.5,
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

                const SizedBox(height: 12),

                // 2. Child Selection Chips
                if (children.isNotEmpty)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(children.length, (idx) {
                        final child = children[idx];
                        final isSelected = idx == selectedIndex;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text('${child['full_name']} (${child['class_section']})'),
                            selected: isSelected,
                            onSelected: (_) {
                              context.read<AuthState>().selectChild(idx);
                            },
                          ),
                        );
                      }),
                    ),
                  ),

                const SizedBox(height: 16),

                // 3. Child Overview Cards (Real Backend Payload)
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: InsetCard(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ATTENDANCE', style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.bold, color: AcademicColors.textSecondary)),
                                const SizedBox(height: 4),
                                Text(childAttendance != null ? '${childAttendance.toStringAsFixed(1)}%' : 'N/A', style: GoogleFonts.newsreader(fontSize: 20, fontWeight: FontWeight.bold)),
                                Text(childName, style: GoogleFonts.manrope(fontSize: 11, color: AcademicColors.textSecondary)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: InsetCard(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('FEES OUTSTANDING', style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.bold, color: AcademicColors.textSecondary)),
                                const SizedBox(height: 4),
                                Text(_formatCurrency(childDues), style: GoogleFonts.newsreader(fontSize: 20, fontWeight: FontWeight.bold, color: childDues > 0 ? AcademicColors.danger : AcademicColors.success)),
                                Text('Total Dues: ${_formatCurrency(totalDues)}', style: GoogleFonts.manrope(fontSize: 11, color: AcademicColors.textSecondary)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 4. Quick Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildActionChip(context, Icons.how_to_reg_outlined, 'Attendance', () => context.push('/attendance/student/matrix')),
                    _buildActionChip(context, Icons.receipt_long_outlined, 'Fee Ledger', () => context.push('/fees/ledger')),
                    _buildActionChip(context, Icons.campaign_outlined, 'Notice Board', () => context.push('/announcements')),
                    _buildActionChip(context, Icons.directions_bus_outlined, 'Bus Track', () => context.push('/library/desk')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AcademicBottomNavBar.forRole(
        UserRole.parent,
        currentIndex: 0,
        context: context,
      ),
    );
  }

  Widget _buildActionChip(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AcademicColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AcademicColors.border),
            ),
            child: Icon(icon, color: AcademicColors.primaryDark, size: 20),
          ),
          const SizedBox(height: 4),
          Text(label, style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
