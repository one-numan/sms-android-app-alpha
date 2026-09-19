// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 02: 2-Factor OTP & Multi-Device Eviction Notice
// Design System: Espresso Heritage Academic
// Strict rule: Verification sent via registered email / authenticator.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../data/mock/auth_state.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/shared_widgets.dart';

class TwoFactorOtpScreen extends StatefulWidget {
  const TwoFactorOtpScreen({super.key});

  @override
  State<TwoFactorOtpScreen> createState() => _TwoFactorOtpScreenState();
}

class _TwoFactorOtpScreenState extends State<TwoFactorOtpScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  int _secondsRemaining = 45;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _secondsRemaining = 45);
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
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _verifyOtp() {
    final auth = context.read<AuthState>();
    final role = auth.currentRole;
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
      appBar: AppTopBar(
        title: 'Security Verification',
        actions: [
          Center(
            child: Text(
              'AUTH-P0-002',
              style: GoogleFonts.manrope(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AcademicColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              // Shield Icon Emblem
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AcademicColors.primaryDark,
                  shape: BoxShape.circle,
                  boxShadow: AcademicColors.elevatedShadow,
                ),
                child: const Center(
                  child: Icon(Icons.verified_user, color: Colors.white, size: 36),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Two-Step Verification',
                style: GoogleFonts.newsreader(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AcademicColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'One Numan Public School • Session 2026-27',
                style: GoogleFonts.manrope(fontSize: 12, color: AcademicColors.textSecondary),
              ),
              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Enter the 6-digit authentication code sent to your registered email address d***@onps.edu.in and mobile session push token.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    color: AcademicColors.textPrimary,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 6 Digits OTP Inset Card
              InsetCard(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (index) {
                        return SizedBox(
                          width: 44,
                          height: 54,
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            style: GoogleFonts.newsreader(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.primaryDark,
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              contentPadding: EdgeInsets.zero,
                              filled: true,
                              fillColor: AcademicColors.canvas,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: AcademicColors.border),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: AcademicColors.primaryDark, width: 2),
                              ),
                            ),
                            onChanged: (val) {
                              if (val.isNotEmpty && index < 5) {
                                _focusNodes[index + 1].requestFocus();
                              } else if (val.isEmpty && index > 0) {
                                _focusNodes[index - 1].requestFocus();
                              }
                            },
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 18),

                    // Countdown Timer & Resend
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.timer_outlined, size: 16, color: AcademicColors.textSecondary),
                            const SizedBox(width: 6),
                            Text(
                              'Code expires in 0:${_secondsRemaining.toString().padLeft(2, '0')}',
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                color: AcademicColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: _secondsRemaining == 0 ? _startCountdown : null,
                          child: Text(
                            'Resend Code',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _secondsRemaining == 0
                                  ? AcademicColors.primary
                                  : AcademicColors.border,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Device Eviction Alert Box (FIFO max 3 terminals)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AcademicColors.warningContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AcademicColors.warning.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: AcademicColors.warning, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Multi-Device Session Eviction (3/3 Limit)',
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AcademicColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Your institutional account has reached the maximum quota of 3 simultaneous handheld/terminal sessions. Authenticating here will automatically evict the oldest inactive session (macOS Safari, Delhi).',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        color: AcademicColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Verify CTA
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AcademicColors.primaryDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _verifyOtp,
                  child: Text(
                    'Verify Identity & Proceed →',
                    style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Cancel button
              TextButton(
                onPressed: () => context.go('/login'),
                child: Text(
                  'Cancel & Return to Login',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AcademicColors.textSecondary,
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
