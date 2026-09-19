// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 02b: Security Lockout & OTP Cooldown
// Design System: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8/02b_security_lockout_otp_cooldown
// ==============================================================================

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/shared_widgets.dart';

class SecurityLockoutScreen extends StatefulWidget {
  const SecurityLockoutScreen({super.key});

  @override
  State<SecurityLockoutScreen> createState() => _SecurityLockoutScreenState();
}

class _SecurityLockoutScreenState extends State<SecurityLockoutScreen> {
  int _secondsRemaining = 840; // 14 minutes
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: AppTopBar(
        title: 'Security Lockout',
        showBackButton: true,
        onBackPressed: () => context.go('/login'),
        actions: [
          Center(child: PillBadge.danger('SEC-403')),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Hero Locked Card
              InsetCard(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    Container(
                      width: 76,
                      height: 76,
                      decoration: const BoxDecoration(
                        color: AcademicColors.dangerContainer,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.security,
                          size: 44,
                          color: AcademicColors.danger,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Account Temporarily Locked',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.newsreader(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Too many consecutive failed authentication attempts have been detected. To protect institutional and student academic records under DPDP Act compliance, access has been temporarily suspended.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        fontSize: 12.5,
                        color: AcademicColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 14),
                    PillBadge.danger('OTPLockout Active Protection'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Countdown Ring & Cooldown Telemetry
              InsetCard(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AcademicColors.danger,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Lockout Telemetry',
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AcademicColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        PillBadge.warning('Tier 2 (15-Min Cooldown)'),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Countdown Ring
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AcademicColors.dangerContainer, width: 8),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _formatTime(_secondsRemaining),
                              style: GoogleFonts.newsreader(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AcademicColors.danger,
                              ),
                            ),
                            Text(
                              'Remaining',
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                color: AcademicColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Telemetry details list
                    _buildTelemetryRow('Failed Attempts', '5 / 5 Exceeded'),
                    _buildTelemetryRow('Trigger', 'Multiple Incorrect Credentials'),
                    _buildTelemetryRow('Client Terminal', 'Handheld Android (Delhi, India)'),
                    _buildTelemetryRow('Session IP', '103.212.14.88'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Emergency IT Helpdesk Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AcademicColors.primaryDark),
                    foregroundColor: AcademicColors.primaryDark,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Contacting IT Helpdesk: helpdesk@onps.edu.in'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.headset_mic, size: 18),
                  label: Text(
                    'Direct IT Helpdesk Support',
                    style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Return to login
              TextButton(
                onPressed: () => context.go('/login'),
                child: Text(
                  'Return to Login Gateway',
                  style: GoogleFonts.manrope(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AcademicColors.textSecondary,
                  ),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTelemetryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.manrope(fontSize: 12, color: AcademicColors.textSecondary),
          ),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AcademicColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
