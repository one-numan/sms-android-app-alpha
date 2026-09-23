// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Component: Account Settings Sheet (Security, 2FA, & Preferences)
// Design System: Espresso Heritage Academic
// Aligned to Backend: apps.accounts.views.settings_view
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/config/app_config.dart';
import '../theme/app_theme.dart';
import 'shared_widgets.dart';

class AccountSettingsSheet extends StatefulWidget {
  const AccountSettingsSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const AccountSettingsSheet(),
    );
  }

  @override
  State<AccountSettingsSheet> createState() => _AccountSettingsSheetState();
}

class _AccountSettingsSheetState extends State<AccountSettingsSheet> {
  bool _twoFactorEnabled = true;
  bool _pushNotifications = true;
  bool _emailCirculars = true;
  bool _highContrast = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AcademicColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AcademicColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.settings, color: AcademicColors.primaryDark, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          'Account Settings',
                          style: GoogleFonts.newsreader(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AcademicColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20, color: AcademicColors.textSecondary),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Section 1: Security & Authentication (Django SimpleJWT + MFA)
                Text(
                  'SECURITY & AUTHENTICATION',
                  style: GoogleFonts.manrope(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: AcademicColors.textSecondary,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),
                InsetCard(
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.lock_outline, color: AcademicColors.primaryDark),
                        title: Text(
                          'Password & Credentials',
                          style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.bold, color: AcademicColors.textPrimary),
                        ),
                        subtitle: Text(
                          'Update your secret password key',
                          style: GoogleFonts.manrope(fontSize: 11, color: AcademicColors.textSecondary),
                        ),
                        trailing: const Icon(Icons.chevron_right, size: 18, color: AcademicColors.textSecondary),
                        onTap: () {
                          Navigator.of(context).pop();
                          context.push('/auth/password-reset');
                        },
                      ),
                      const Divider(height: 8, color: AcademicColors.border),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        secondary: const Icon(Icons.security, color: AcademicColors.primaryDark),
                        title: Text(
                          'Two-Factor Authentication (OTP)',
                          style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.bold, color: AcademicColors.textPrimary),
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
                                val ? 'Two-Factor Authentication Enabled' : 'Two-Factor Authentication Disabled (MFA Exemption)',
                                style: GoogleFonts.manrope(fontSize: 12),
                              ),
                              duration: const Duration(seconds: 2),
                              backgroundColor: AcademicColors.primaryDark,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Section 2: Session & Hardware Governance
                Text(
                  'MULTI-DEVICE GOVERNANCE',
                  style: GoogleFonts.manrope(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: AcademicColors.textSecondary,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),
                InsetCard(
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.devices, color: AcademicColors.primaryDark),
                    title: Text(
                      'Manage Active Devices',
                      style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.bold, color: AcademicColors.textPrimary),
                    ),
                    subtitle: Text(
                      'Limit: 3 concurrent devices • 1 active session',
                      style: GoogleFonts.manrope(fontSize: 11, color: AcademicColors.textSecondary),
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 18, color: AcademicColors.textSecondary),
                    onTap: () {
                      Navigator.of(context).pop();
                      context.push('/auth/devices');
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Section 3: Notification Preferences (Django NotificationPreferenceForm)
                Text(
                  'COMMUNICATION PREFERENCES',
                  style: GoogleFonts.manrope(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: AcademicColors.textSecondary,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),
                InsetCard(
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Column(
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        secondary: const Icon(Icons.notifications_active_outlined, color: AcademicColors.primaryDark),
                        title: Text(
                          'In-App Push Alerts',
                          style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.bold, color: AcademicColors.textPrimary),
                        ),
                        subtitle: Text(
                          'Instant alerts for notices & emergency circulars',
                          style: GoogleFonts.manrope(fontSize: 11, color: AcademicColors.textSecondary),
                        ),
                        value: _pushNotifications,
                        activeThumbColor: AcademicColors.primaryDark,
                        onChanged: (val) => setState(() => _pushNotifications = val),
                      ),
                      const Divider(height: 8, color: AcademicColors.border),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        secondary: const Icon(Icons.email_outlined, color: AcademicColors.primaryDark),
                        title: Text(
                          'Email Circulars & Receipts',
                          style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.bold, color: AcademicColors.textPrimary),
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

                const SizedBox(height: 16),

                // Section 4: Academic Display & Standards
                Text(
                  'ACADEMIC DISPLAY & STANDARDS',
                  style: GoogleFonts.manrope(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: AcademicColors.textSecondary,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),
                InsetCard(
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Column(
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        secondary: const Icon(Icons.contrast, color: AcademicColors.primaryDark),
                        title: Text(
                          'CBSE High-Contrast Mode',
                          style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.bold, color: AcademicColors.textPrimary),
                        ),
                        subtitle: Text(
                          'Enhanced readability for academic records',
                          style: GoogleFonts.manrope(fontSize: 11, color: AcademicColors.textSecondary),
                        ),
                        value: _highContrast,
                        activeThumbColor: AcademicColors.primaryDark,
                        onChanged: (val) => setState(() => _highContrast = val),
                      ),
                      const Divider(height: 8, color: AcademicColors.border),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Academic Session',
                              style: GoogleFonts.manrope(fontSize: 12, color: AcademicColors.textSecondary),
                            ),
                            PillBadge.neutral(AppConfig.academicSession),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Done Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AcademicColors.primaryDark,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Save & Close Settings',
                      style: GoogleFonts.manrope(fontSize: 13.5, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
