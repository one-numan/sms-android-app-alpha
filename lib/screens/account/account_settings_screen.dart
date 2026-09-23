// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen: Account Settings (Security, 2FA, Devices & Governance)
// Design System: Espresso Heritage Academic
// Aligned to Backend: apps.accounts.views.settings_view
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/config/app_config.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/onps_logo.dart';
import '../../widgets/shared_widgets.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  bool _twoFactorEnabled = true;
  bool _pushNotifications = true;
  bool _emailCirculars = true;
  bool _cbseHighContrast = false;

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

  void _showPasswordDialog() {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AcademicColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Update Password',
          style: GoogleFonts.newsreader(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Secret Key',
                hintText: 'Enter current password',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Secret Key',
                hintText: 'Minimum 8 characters',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm Secret Key',
                hintText: 'Repeat new password',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AcademicColors.primaryDark,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password updated successfully'),
                  backgroundColor: AcademicColors.primaryDark,
                ),
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: const AppTopBar(
        title: 'Account Settings',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Security & Authentication
            _buildSectionHeader('SECURITY & AUTHENTICATION'),
            const SizedBox(height: 8),
            InsetCard(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.lock_outline, color: AcademicColors.primaryDark),
                    title: Text(
                      'Password & Credentials',
                      style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'Update your secret password key',
                      style: GoogleFonts.manrope(fontSize: 11, color: AcademicColors.textSecondary),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: AcademicColors.textSecondary),
                    onTap: _showPasswordDialog,
                  ),
                  const Divider(height: 1, indent: 48, color: AcademicColors.border),
                  SwitchListTile(
                    secondary: const Icon(Icons.security, color: AcademicColors.primaryDark),
                    title: Text(
                      'Two-Factor Authentication (OTP)',
                      style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'Mandatory 6-digit email OTP on login',
                      style: GoogleFonts.manrope(fontSize: 11, color: AcademicColors.textSecondary),
                    ),
                    value: _twoFactorEnabled,
                    activeThumbColor: AcademicColors.primaryDark,
                    onChanged: (val) {
                      setState(() => _twoFactorEnabled = val);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            val
                                ? 'Two-Factor Authentication enabled'
                                : 'Two-Factor Authentication disabled',
                          ),
                          backgroundColor: AcademicColors.primaryDark,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Multi-Device Governance
            _buildSectionHeader('MULTI-DEVICE GOVERNANCE'),
            const SizedBox(height: 8),
            InsetCard(
              margin: EdgeInsets.zero,
              child: ListTile(
                leading: const Icon(Icons.devices_outlined, color: AcademicColors.primaryDark),
                title: Text(
                  'Manage Active Devices',
                  style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Limit: 3 concurrent devices • 1 active session',
                  style: GoogleFonts.manrope(fontSize: 11, color: AcademicColors.textSecondary),
                ),
                trailing: const Icon(Icons.chevron_right, color: AcademicColors.textSecondary),
                onTap: () => context.push('/auth/devices'),
              ),
            ),

            const SizedBox(height: 20),

            // Communication Preferences
            _buildSectionHeader('COMMUNICATION PREFERENCES'),
            const SizedBox(height: 8),
            InsetCard(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.notifications_active_outlined, color: AcademicColors.primaryDark),
                    title: Text(
                      'In-App Push Alerts',
                      style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'Instant alerts for notices & emergency circulars',
                      style: GoogleFonts.manrope(fontSize: 11, color: AcademicColors.textSecondary),
                    ),
                    value: _pushNotifications,
                    activeThumbColor: AcademicColors.primaryDark,
                    onChanged: (val) => setState(() => _pushNotifications = val),
                  ),
                  const Divider(height: 1, indent: 48, color: AcademicColors.border),
                  SwitchListTile(
                    secondary: const Icon(Icons.mail_outline, color: AcademicColors.primaryDark),
                    title: Text(
                      'Email Circulars & Receipts',
                      style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'Send official PDF vouchers to registered email',
                      style: GoogleFonts.manrope(fontSize: 11, color: AcademicColors.textSecondary),
                    ),
                    value: _emailCirculars,
                    activeThumbColor: AcademicColors.primaryDark,
                    onChanged: (val) => setState(() => _emailCirculars = val),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Academic Display & Standards
            _buildSectionHeader('ACADEMIC DISPLAY & STANDARDS'),
            const SizedBox(height: 8),
            InsetCard(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.contrast_outlined, color: AcademicColors.primaryDark),
                    title: Text(
                      'CBSE High-Contrast',
                      style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'Enhance legibility for marks tables & schedules',
                      style: GoogleFonts.manrope(fontSize: 11, color: AcademicColors.textSecondary),
                    ),
                    value: _cbseHighContrast,
                    activeThumbColor: AcademicColors.primaryDark,
                    onChanged: (val) => setState(() => _cbseHighContrast = val),
                  ),
                  const Divider(height: 1, indent: 48, color: AcademicColors.border),
                  ListTile(
                    leading: const Icon(Icons.calendar_month_outlined, color: AcademicColors.primaryDark),
                    title: Text(
                      'Academic Session',
                      style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'Current: ${AppConfig.academicSession} (Active)',
                      style: GoogleFonts.manrope(fontSize: 11, color: AcademicColors.textSecondary),
                    ),
                    trailing: PillBadge.info('Affiliated'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Help & Institutional Support
            _buildSectionHeader('HELP & INSTITUTIONAL SUPPORT'),
            const SizedBox(height: 8),
            InsetCard(
              margin: EdgeInsets.zero,
              child: ListTile(
                leading: const Icon(Icons.help_outline_rounded, color: AcademicColors.primaryDark),
                title: Text(
                  'School FAQs & Knowledge Base',
                  style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Offline guide for fees, bus transit, exams, & leave',
                  style: GoogleFonts.manrope(fontSize: 11, color: AcademicColors.textSecondary),
                ),
                trailing: const Icon(Icons.chevron_right, color: AcademicColors.textSecondary),
                onTap: () => context.push('/help/faqs'),
              ),
            ),

            const SizedBox(height: 20),

            // Institutional Information Card
            InsetCard(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const ONPSLogo(size: 44),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppConfig.schoolName,
                            style: GoogleFonts.newsreader(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${AppConfig.affiliation} • ERP Mobile ${AppConfig.appVersion}',
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              color: AcademicColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
