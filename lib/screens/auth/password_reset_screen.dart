// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 03: Password Reset & Credential Recovery
// Design System: Espresso Heritage Academic
// Strict Rule: Verification sent via registered official email / push.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/shared_widgets.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _identifierController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _submitted = false;
  String _selectedChannel = 'email'; // 'email' or 'inApp'

  @override
  void dispose() {
    _identifierController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleReset() {
    if (_identifierController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your registered username or email')),
      );
      return;
    }
    setState(() => _submitted = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: AppTopBar(
        title: 'Credential Recovery',
        actions: [
          Center(child: PillBadge.success('TLS 1.3 Secure')),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Registrar Banner
              InsetCard(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: AcademicColors.canvas,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.account_balance, size: 18, color: AcademicColors.primaryDark),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ONPS Central Registrar Gateway',
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AcademicColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Authorized Self-Service Credential Reset',
                          style: GoogleFonts.manrope(
                            fontSize: 10.5,
                            color: AcademicColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              if (!_submitted) ...[
                // Recovery Form
                InsetCard(
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AcademicColors.canvas,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.lock_reset, size: 28, color: AcademicColors.primaryDark),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Forgot Your Password?',
                        style: GoogleFonts.newsreader(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Enter your registered institutional username or official email address to receive secure reset credentials.',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: AcademicColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        'Registered Username / Email',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _identifierController,
                        style: GoogleFonts.manrope(fontSize: 14, color: AcademicColors.textPrimary),
                        decoration: const InputDecoration(
                          hintText: 'e.g. parent.sharma or staff@onps.edu.in',
                          prefixIcon: Icon(Icons.badge_outlined, size: 20, color: AcademicColors.textSecondary),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        'Reset Verification Channel',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedChannel = 'email'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: _selectedChannel == 'email'
                                      ? AcademicColors.primaryDark
                                      : AcademicColors.canvas,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _selectedChannel == 'email'
                                        ? AcademicColors.primaryDark
                                        : AcademicColors.border,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.email_outlined,
                                      size: 16,
                                      color: _selectedChannel == 'email' ? Colors.white : AcademicColors.textPrimary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Official Email',
                                      style: GoogleFonts.manrope(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w600,
                                        color: _selectedChannel == 'email' ? Colors.white : AcademicColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedChannel = 'inApp'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: _selectedChannel == 'inApp'
                                      ? AcademicColors.primaryDark
                                      : AcademicColors.canvas,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _selectedChannel == 'inApp'
                                        ? AcademicColors.primaryDark
                                        : AcademicColors.border,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.phonelink_ring_outlined,
                                      size: 16,
                                      color: _selectedChannel == 'inApp' ? Colors.white : AcademicColors.textPrimary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'In-App Push',
                                      style: GoogleFonts.manrope(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w600,
                                        color: _selectedChannel == 'inApp' ? Colors.white : AcademicColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AcademicColors.primaryDark,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: _handleReset,
                          child: Text(
                            'Dispatch Recovery Token →',
                            style: GoogleFonts.manrope(fontSize: 13.5, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Submitted Confirmation Card
                InsetCard(
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          color: AcademicColors.successContainer,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(Icons.mark_email_read, color: AcademicColors.success, size: 28),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Recovery Token Dispatched',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.newsreader(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'A cryptographically signed recovery token has been transmitted to your registered official email. Follow the email link to complete credential renewal.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.manrope(
                          fontSize: 12.5,
                          color: AcademicColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AcademicColors.primaryDark,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () => context.go('/login'),
                          child: const Text('Return to Login Gateway'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // Helpdesk Support Note
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Contact: helpdesk@onps.edu.in | Registrar Office')),
                    );
                  },
                  icon: const Icon(Icons.help_outline, size: 16, color: AcademicColors.textSecondary),
                  label: Text(
                    'Need Help? Contact Registrar Desk',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AcademicColors.textSecondary,
                    ),
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
