// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 02c: Principal Post-Login Transition Screen
// Design System: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8/02c_principal_executive_morning_briefing_transition_1
// Cleaned: Streamlined transition, zero security theater, auto-navigation to Principal Portal.
// ==============================================================================

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/config/app_config.dart';
import '../../data/mock/auth_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/onps_logo.dart';
import '../../widgets/shared_widgets.dart';

class MorningBriefingTransitionScreen extends StatefulWidget {
  const MorningBriefingTransitionScreen({super.key});

  @override
  State<MorningBriefingTransitionScreen> createState() =>
      _MorningBriefingTransitionScreenState();
}

class _MorningBriefingTransitionScreenState
    extends State<MorningBriefingTransitionScreen>
    with SingleTickerProviderStateMixin {
  Timer? _transitionTimer;
  double _progress = 0.25;
  bool _hasError = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _startTransition();
  }

  void _startTransition() {
    setState(() {
      _hasError = false;
      _progress = 0.25;
    });

    // Animate progress smoothly
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted && !_hasError) {
        setState(() => _progress = 0.70);
      }
    });

    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted && !_hasError) {
        setState(() => _progress = 1.0);
      }
    });

    // Auto-navigate to Principal Dashboard
    _transitionTimer = Timer(const Duration(milliseconds: 1300), () {
      if (mounted && !_hasError) {
        context.go('/dashboard/principal');
      }
    });
  }

  @override
  void dispose() {
    _transitionTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final userProfile = auth.userProfile;
    final roleTitle = AuthState.roleTitle(auth.currentRole);
    final fullName = (userProfile?['full_name'] as String?)?.trim().isNotEmpty == true
        ? (userProfile!['full_name'] as String).trim()
        : (auth.fullName.isNotEmpty ? auth.fullName : (auth.currentUsername.isNotEmpty ? auth.currentUsername : 'User'));
    final initials = fullName != 'User' && fullName.isNotEmpty
        ? fullName.split(RegExp(r'\s+')).where((e) => e.isNotEmpty).map((e) => e[0].toUpperCase()).take(2).join()
        : (auth.currentUsername.isNotEmpty ? auth.currentUsername[0].toUpperCase() : 'U');
    final designation = (userProfile?['designation'] as String?)?.trim().isNotEmpty == true
        ? (userProfile!['designation'] as String).trim()
        : '$roleTitle & Institutional Member';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go('/login');
        }
      },
      child: Scaffold(
        backgroundColor: AcademicColors.canvas,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ONPS Crest / Logo with gentle glow
                    ScaleTransition(
                      scale: _pulseAnimation,
                      child: Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          color: AcademicColors.surface,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AcademicColors.border,
                            width: 2,
                          ),
                          boxShadow: AcademicColors.cardShadow,
                        ),
                        child: const Center(
                          child: ONPSLogo(size: 54),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // School Identity
                    Text(
                      AppConfig.schoolName,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.newsreader(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${AppConfig.academicSession} • Main Campus',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: AcademicColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Principal Identity Card
                    InsetCard(
                      margin: EdgeInsets.zero,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Success confirmation chip
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AcademicColors.success.withValues(
                                  alpha: 0.12,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    size: 13,
                                    color: AcademicColors.success,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Signed in successfully',
                                    style: GoogleFonts.manrope(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AcademicColors.success,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          // User profile info
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: const BoxDecoration(
                                  color: AcademicColors.primaryDark,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    initials,
                                    style: GoogleFonts.newsreader(
                                      fontSize: 18,
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
                                      'Welcome back',
                                      style: GoogleFonts.manrope(
                                        fontSize: 10.5,
                                        color: AcademicColors.textSecondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      fullName,
                                      style: GoogleFonts.newsreader(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: AcademicColors.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      designation,
                                      style: GoogleFonts.manrope(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w500,
                                        color: AcademicColors.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),
                          const Divider(
                            height: 1,
                            color: AcademicColors.border,
                          ),
                          const SizedBox(height: 10),

                          // School context details with responsive wrap
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.domain_outlined,
                                    size: 14,
                                    color: AcademicColors.secondary,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Senior Wing',
                                    style: GoogleFonts.manrope(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AcademicColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                AppConfig.affiliation,
                                style: GoogleFonts.manrope(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: AcademicColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Initialization / Loading State
                    if (!_hasError) ...[
                      const SizedBox(
                        width: 26,
                        height: 26,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AcademicColors.primaryDark,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Preparing your Principal Portal...',
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AcademicColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Loading institutional overview & workspace',
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          color: AcademicColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: 160,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: _progress,
                            minHeight: 3.5,
                            backgroundColor: AcademicColors.border,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AcademicColors.primaryDark,
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      // Graceful Error State
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AcademicColors.danger.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AcademicColors.danger.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 16,
                                  color: AcademicColors.danger,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Unable to open Principal Portal',
                                  style: GoogleFonts.manrope(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: AcademicColors.danger,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Please check your connection and try again.',
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                color: AcademicColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AcademicColors.primaryDark,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 6,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: _startTransition,
                              child: Text(
                                'Try Again',
                                style: GoogleFonts.manrope(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
