// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 01: Secure Login Gateway
// Design System: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8/01_secure_login_gateway
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../data/mock/auth_state.dart';
import '../../data/mock/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/onps_logo.dart';
import '../../widgets/shared_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _identifierController = TextEditingController(text: '9876543210');
  final _passwordController = TextEditingController(text: 'password123');
  bool _obscurePassword = true;
  bool _rememberDevice = true;
  UserRole _selectedRole = UserRole.parent;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() {
    final auth = context.read<AuthState>();
    auth.login(
      role: _selectedRole,
      username: _identifierController.text.trim().isEmpty
          ? 'user@onps.edu.in'
          : _identifierController.text.trim(),
    );

    // Route based on role
    _navigateForRole(_selectedRole);
  }

  void _navigateForRole(UserRole role) {
    switch (role) {
      case UserRole.parent:
        context.go('/parent/dashboard');
        break;
      case UserRole.student:
        context.go('/student/hub');
        break;
      case UserRole.classTeacher:
        context.go('/teacher/class-dashboard');
        break;
      case UserRole.subjectTeacher:
        context.go('/teacher/subject-dashboard');
        break;
      case UserRole.principal:
      case UserRole.vicePrincipal:
        context.go('/principal/briefing');
        break;
      case UserRole.accountant:
        context.go('/accounts/dashboard');
        break;
      case UserRole.librarian:
        context.go('/library/desk');
        break;
      case UserRole.receptionist:
        context.go('/admissions/enquiries');
        break;
      case UserRole.superAdmin:
        context.go('/admin/modules');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),

              // Emblem / Crest Container
              const ONPSLogo(size: 88, hasShadow: true),

              const SizedBox(height: 14),

              // Academic Session Tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0E5DF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AcademicColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      MockData.session,
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AcademicColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // School Titles
              Text(
                MockData.schoolName,
                textAlign: TextAlign.center,
                style: GoogleFonts.newsreader(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AcademicColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Senior Secondary Affiliated to CBSE (#2130456)',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: AcademicColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 24),

              // Segmented Role Selector (4 Main Portals)
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFEFE8E3),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    _buildRoleTab(UserRole.parent, 'Parent', Icons.family_restroom),
                    _buildRoleTab(UserRole.classTeacher, 'Teacher', Icons.menu_book),
                    _buildRoleTab(UserRole.student, 'Student', Icons.school),
                    _buildRoleTab(UserRole.principal, 'Staff', Icons.badge),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Authentication Inset Card
              InsetCard(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mobile and Email',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _identifierController,
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.manrope(fontSize: 14, color: AcademicColors.textPrimary),
                      decoration: const InputDecoration(
                        hintText: 'Enter registered mobile number or email',
                        prefixIcon: Icon(Icons.alternate_email, size: 20, color: AcademicColors.textSecondary),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Password Field
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Enter Password',
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AcademicColors.textPrimary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.push('/auth/password-reset'),
                          child: Text(
                            'Forgot Password?',
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AcademicColors.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: GoogleFonts.manrope(fontSize: 14, color: AcademicColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Enter Password',
                        prefixIcon: const Icon(Icons.lock, size: 20, color: AcademicColors.textSecondary),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility : Icons.visibility_off,
                            size: 20,
                            color: AcademicColors.textSecondary,
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Remember Device Switch
                    Row(
                      children: [
                        SizedBox(
                          height: 24,
                          width: 36,
                          child: Switch(
                            value: _rememberDevice,
                            activeThumbColor: AcademicColors.primaryDark,
                            activeTrackColor: AcademicColors.accent.withValues(alpha: 0.4),
                            onChanged: (val) => setState(() => _rememberDevice = val),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Remember this device',
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            color: AcademicColors.textPrimary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Submit CTA Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AcademicColors.primaryDark,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 2,
                        ),
                        onPressed: _handleSignIn,
                        child: Text(
                          'Sign in as ${_getRoleTitle(_selectedRole)} →',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Multi-Device Governance Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AcademicColors.warningContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AcademicColors.warning.withValues(alpha: 0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: AcademicColors.warning,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.shield, color: Colors.white, size: 16),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Multi-Device Governance',
                                style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AcademicColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'MAX=3',
                                  style: GoogleFonts.manrope(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.bold,
                                    color: AcademicColors.warning,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Active limit: 3 authenticated terminals per ledger. Continuing on this handheld may automatically terminate the oldest inactive session.',
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              color: AcademicColors.textSecondary,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Emergency IT Helpdesk Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.headset_mic, size: 16, color: AcademicColors.textSecondary),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'Emergency IT Helpdesk: helpdesk@onps.edu.in',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AcademicColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleTab(UserRole role, String label, IconData icon) {
    final isSelected = _selectedRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedRole = role;
            if (role == UserRole.parent) {
              _identifierController.text = 'rajesh.sharma';
            } else if (role == UserRole.classTeacher) {
              _identifierController.text = 'anita.desai';
            } else if (role == UserRole.student) {
              _identifierController.text = 'ADM-2024-0412';
            } else {
              _identifierController.text = 'principal';
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AcademicColors.primaryDark : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected ? AcademicColors.cardShadow : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : AcademicColors.secondary,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 10.5,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.white : AcademicColors.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  String _getRoleTitle(UserRole role) {
    switch (role) {
      case UserRole.parent:
        return 'Parent';
      case UserRole.classTeacher:
        return 'Teacher';
      case UserRole.student:
        return 'Student';
      default:
        return 'Staff';
    }
  }
}
