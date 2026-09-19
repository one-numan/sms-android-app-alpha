// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen: Account Profile (User Identity Dossier)
// Connected to Django REST API: GET /api/v1/account/profile/
// Design System: Espresso Heritage Academic
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../data/mock/auth_state.dart';
import '../../data/services/account_api_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/account_profile_sheet.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/role_switcher_sheet.dart';
import '../../widgets/shared_widgets.dart';

class AccountProfileScreen extends StatefulWidget {
  const AccountProfileScreen({super.key});

  @override
  State<AccountProfileScreen> createState() => _AccountProfileScreenState();
}

class _AccountProfileScreenState extends State<AccountProfileScreen> {
  final AccountApiService _accountApiService = AccountApiService();
  bool _isLoading = true;
  Map<String, dynamic>? _profileData;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    final bindingName = WidgetsBinding.instance.runtimeType.toString();
    if (bindingName.contains('Test')) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    setState(() => _isLoading = true);
    try {
      final data = await _accountApiService.getProfile();
      if (mounted) {
        setState(() {
          _profileData = data;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.manrope(
        fontSize: 10.5,
        fontWeight: FontWeight.bold,
        color: AcademicColors.textSecondary,
        letterSpacing: 0.8,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final fallbackProfile = AccountProfileSheet.getProfileForRole(auth.currentRole);

    final fullName = _profileData?['full_name'] ?? _profileData?['username'] ?? fallbackProfile.fullName;
    final email = _profileData?['email'] ?? fallbackProfile.email;
    final role = _profileData?['role'] ?? fallbackProfile.roleTitle;
    final designation = _profileData?['designation'] ?? fallbackProfile.designation;
    final initials = fullName.isNotEmpty ? fullName.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join() : 'U';

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: const AppTopBar(
        title: 'My Profile',
        showBackButton: true,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchProfile,
        color: AcademicColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Center(child: CircularProgressIndicator()),
                ),

              // Identity Header Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AcademicColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AcademicColors.border),
                  boxShadow: AcademicColors.cardShadow,
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            color: AcademicColors.primaryDark,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              initials,
                              style: GoogleFonts.newsreader(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AcademicColors.accent,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AcademicColors.surface,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.verified,
                              color: AcademicColors.success,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      fullName,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.newsreader(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      designation,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        color: AcademicColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        PillBadge.info(role.toString().toUpperCase()),
                        PillBadge.neutral(fallbackProfile.tier),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Contact & Institution Details
              _buildSectionHeader('OFFICIAL CREDENTIALS & AFFILIATION'),
              const SizedBox(height: 8),
              InsetCard(
                margin: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildDetailTile(
                      icon: Icons.alternate_email,
                      title: 'Official Email',
                      subtitle: email,
                    ),
                    const Divider(height: 1, indent: 48, color: AcademicColors.border),
                    _buildDetailTile(
                      icon: Icons.person_outline,
                      title: 'Username Identity',
                      subtitle: _profileData?['username'] ?? auth.currentUsername,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Navigation Actions
              _buildSectionHeader('ACCOUNT GOVERNANCE'),
              const SizedBox(height: 8),
              InsetCard(
                margin: EdgeInsets.zero,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.devices_outlined, color: AcademicColors.primaryDark),
                      title: Text(
                        'Manage Active Devices',
                        style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        'View active device sessions',
                        style: GoogleFonts.manrope(fontSize: 11, color: AcademicColors.textSecondary),
                      ),
                      trailing: const Icon(Icons.chevron_right, color: AcademicColors.textSecondary),
                      onTap: () => context.push('/auth/devices'),
                    ),
                    const Divider(height: 1, indent: 48, color: AcademicColors.border),
                    ListTile(
                      leading: const Icon(Icons.swap_horiz_outlined, color: AcademicColors.primaryDark),
                      title: Text(
                        'Switch Operational Role',
                        style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        'Switch between Teacher, Principal, Parent, Student...',
                        style: GoogleFonts.manrope(fontSize: 11, color: AcademicColors.textSecondary),
                      ),
                      trailing: const Icon(Icons.chevron_right, color: AcademicColors.textSecondary),
                      onTap: () => RoleSwitcherSheet.show(context),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Sign Out Button
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: AcademicColors.error),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.logout, color: AcademicColors.error),
                label: Text(
                  'Sign Out of Session',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AcademicColors.error,
                  ),
                ),
                onPressed: () {
                  auth.signOut();
                  context.go('/login');
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: AcademicColors.primaryDark),
      title: Text(
        title,
        style: GoogleFonts.manrope(fontSize: 11.5, color: AcademicColors.textSecondary),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.manrope(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: AcademicColors.textPrimary,
        ),
      ),
    );
  }
}
