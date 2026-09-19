// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Institutional AI-Enabled Splash Screen
// Visual Design: Option 5 Espresso Heritage & AI Orbit
// ==============================================================================

import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/onps_logo.dart';

class SplashScreen extends StatefulWidget {
  final String? nextRoute;

  const SplashScreen({
    super.key,
    this.nextRoute,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Master entrance & loading controllers
  late final AnimationController _entranceController;
  late final AnimationController _orbitController;
  late final AnimationController _pulseController;
  late final AnimationController _loadingController;

  Timer? _loadTimer;
  Timer? _navTimer;

  // Staggered entrance animations
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _brandOpacity;
  late final Animation<Offset> _brandSlide;
  late final Animation<double> _badgeOpacity;
  late final Animation<double> _loadingOpacity;
  late final Animation<double> _footerOpacity;

  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    // 1. Entrance orchestrator (1.6s)
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _logoScale = Tween<double>(begin: 0.72, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutBack),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeIn),
      ),
    );

    _brandOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.35, 0.75, curve: Curves.easeOut),
      ),
    );

    _brandSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.35, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    _badgeOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.60, 0.85, curve: Curves.easeOut),
      ),
    );

    _loadingOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.70, 0.95, curve: Curves.easeOut),
      ),
    );

    _footerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.85, 1.0, curve: Curves.easeOut),
      ),
    );

    // 2. Continuous Orbit (6s loop)
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    )..repeat();

    // 3. Breathing Halo & Orb (3.8s loop)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3800),
    )..repeat(reverse: true);

    // 4. Loading bar progression (3s)
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    // Start playback
    _entranceController.forward();
    _loadTimer = Timer(const Duration(milliseconds: 600), () {
      if (mounted) {
        _loadingController.forward();
      }
    });

    // Auto navigate after ~4.0 seconds
    _navTimer = Timer(const Duration(milliseconds: 4000), () {
      _navigateNext();
    });
  }

  void _navigateNext() {
    if (_navigated || !mounted) return;
    _navigated = true;

    final target = widget.nextRoute ?? '/';
    context.go(target);
  }

  @override
  void dispose() {
    _loadTimer?.cancel();
    _navTimer?.cancel();
    _entranceController.dispose();
    _orbitController.dispose();
    _pulseController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _navigateNext, // Allow user tap to skip
      child: Scaffold(
        backgroundColor: const Color(0xFFFCFAF6),
        body: Stack(
            children: [
              // 1. Background Gradient Canvas
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFFFDF8),
                        Color(0xFFFCFAF6),
                        Color(0xFFF7F3E9),
                      ],
                    ),
                  ),
                ),
              ),

              // 2. Subtle Radial Background Glow / Breathing Orb
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    final scale = 0.90 + (_pulseController.value * 0.18);
                    final opacity = 0.50 + (_pulseController.value * 0.35);
                    return Center(
                      child: Transform.scale(
                        scale: scale,
                        child: Opacity(
                          opacity: opacity,
                          child: Container(
                            width: 380,
                            height: 380,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  const Color(0xFFD4AF37).withValues(alpha: 0.16),
                                  const Color(0xFFD4AF37).withValues(alpha: 0.05),
                                  Colors.transparent,
                                ],
                                stops: const [0.0, 0.45, 0.75],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // 3. Floating gold particles
              ..._buildParticles(),

              // 4. Central Content
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),

                          // Logo Stage (Halo, Orbit Ring, AI Orbit Dot, ONPS Logo)
                          _buildLogoStage(),

                          const SizedBox(height: 30),

                          // Brand Block (ONPS, Line, Tagline, AI Badge)
                          _buildBrandBlock(),

                          const SizedBox(height: 36),

                          // Loading Bar & AI Status
                          _buildLoadingBlock(),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // 5. Footer
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _footerOpacity,
                  child: Center(
                    child: Text(
                      'ONE NUMAN PUBLIC SCHOOL',
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2.2,
                        color: const Color(0xFF806F66).withValues(alpha: 0.75),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  Widget _buildLogoStage() {
    return AnimatedBuilder(
      animation: Listenable.merge([_entranceController, _orbitController, _pulseController]),
      builder: (context, child) {
        final haloScale = 0.94 + (_pulseController.value * 0.12);
        final haloOpacity = 0.40 + (_pulseController.value * 0.35);

        return Transform.scale(
          scale: _logoScale.value,
          child: Opacity(
            opacity: _logoOpacity.value,
            child: SizedBox(
              width: 176,
              height: 176,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer Golden Halo
                  Transform.scale(
                    scale: haloScale,
                    child: Opacity(
                      opacity: haloOpacity,
                      child: Container(
                        width: 176,
                        height: 176,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFFD4AF37).withValues(alpha: 0.28),
                              const Color(0xFFD4AF37).withValues(alpha: 0.08),
                              Colors.transparent,
                            ],
                            stops: const [0.35, 0.65, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Orbit Ring (Thin spinning ring)
                  Transform.rotate(
                    angle: _orbitController.value * 2 * math.pi,
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFD4AF37).withValues(alpha: 0.30),
                          width: 1.2,
                        ),
                      ),
                    ),
                  ),

                  // AI Orbit Dot (Spinning around the logo circumference)
                  Transform.rotate(
                    angle: _orbitController.value * 2 * math.pi * 1.5,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(top: 2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFFFF0A8),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFD4AF37).withValues(alpha: 0.9),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ONPS Logo Emblem (Option 5)
                  Container(
                    width: 136,
                    height: 136,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3E2A22).withValues(alpha: 0.22),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                        BoxShadow(
                          color: const Color(0xFFD4AF37).withValues(alpha: 0.18),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const ONPSLogo(
                      size: 136,
                      hasShadow: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBrandBlock() {
    return FadeTransition(
      opacity: _brandOpacity,
      child: SlideTransition(
        position: _brandSlide,
        child: Column(
          children: [
            // ONPS Brand Header
            Text(
              'ONPS',
              style: GoogleFonts.newsreader(
                fontSize: 48,
                fontWeight: FontWeight.w700,
                letterSpacing: 4.0,
                color: const Color(0xFF2F1E17),
                height: 1.0,
              ),
            ),

            const SizedBox(height: 12),

            // Gold Gradient Accent Line
            Container(
              width: 58,
              height: 2.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF9B6B0B),
                    Color(0xFFF7D87A),
                    Color(0xFF9B6B0B),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Tagline
            Text(
              'LEARN  •  GROW  •  EXCEL',
              style: GoogleFonts.manrope(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.8,
                color: const Color(0xFF3E2A22).withValues(alpha: 0.60),
              ),
            ),

            const SizedBox(height: 20),

            // AI Badge Pill
            FadeTransition(
              opacity: _badgeOpacity,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.35),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3E2A22).withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // AI Spark Icon
                      SizedBox(
                        width: 14,
                        height: 14,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 2.5,
                              height: 13,
                              decoration: BoxDecoration(
                                color: const Color(0xFFD4AF37),
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                            Container(
                              width: 13,
                              height: 2.5,
                              decoration: BoxDecoration(
                                color: const Color(0xFFD4AF37),
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'AI ENABLED',
                        style: GoogleFonts.manrope(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                          color: const Color(0xFF3E2A22),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: const BoxDecoration(
                          color: Color(0xFF806F66),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Smart School Platform',
                        style: GoogleFonts.manrope(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF806F66),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingBlock() {
    return FadeTransition(
      opacity: _loadingOpacity,
      child: Column(
        children: [
          // Animated Gold Progress Bar
          SizedBox(
            width: 220,
            height: 3.5,
            child: Stack(
              children: [
                // Track
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF3E2A22).withValues(alpha: 0.09),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                // Progress Bar
                AnimatedBuilder(
                  animation: _loadingController,
                  builder: (context, child) {
                    return FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: _loadingController.value,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF9B6B0B),
                              Color(0xFFF7D87A),
                              Color(0xFFD4AF37),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFD4AF37).withValues(alpha: 0.5),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Label
          Text(
            'PREPARING YOUR SCHOOL EXPERIENCE',
            style: GoogleFonts.manrope(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.8,
              color: const Color(0xFF3E2A22).withValues(alpha: 0.50),
            ),
          ),

          const SizedBox(height: 12),

          // AI Ready Pulsing Status
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final dotOpacity = 0.55 + (_pulseController.value * 0.45);
                  return Opacity(
                    opacity: dotOpacity,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFF388E3C),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF388E3C).withValues(alpha: 0.6),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 6),
              Text(
                'AI services ready',
                style: GoogleFonts.manrope(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF3E2A22).withValues(alpha: 0.55),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildParticles() {
    return [
      Positioned(
        top: 140,
        left: 45,
        child: _ParticleDot(
          pulse: _pulseController,
          delay: 0.0,
          size: 3.5,
        ),
      ),
      Positioned(
        top: 190,
        right: 50,
        child: _ParticleDot(
          pulse: _pulseController,
          delay: 0.3,
          size: 4.0,
        ),
      ),
      Positioned(
        bottom: 220,
        left: 60,
        child: _ParticleDot(
          pulse: _pulseController,
          delay: 0.6,
          size: 3.0,
        ),
      ),
      Positioned(
        bottom: 180,
        right: 55,
        child: _ParticleDot(
          pulse: _pulseController,
          delay: 0.85,
          size: 3.5,
        ),
      ),
    ];
  }
}

class _ParticleDot extends StatelessWidget {
  final Animation<double> pulse;
  final double delay;
  final double size;

  const _ParticleDot({
    required this.pulse,
    required this.delay,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulse,
      builder: (context, child) {
        final shifted = (pulse.value + delay) % 1.0;
        final dy = (shifted - 0.5) * 16.0;
        final opacity = math.sin(shifted * math.pi).clamp(0.0, 0.7);

        return Transform.translate(
          offset: Offset(0, dy),
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFD4AF37),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.6),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
