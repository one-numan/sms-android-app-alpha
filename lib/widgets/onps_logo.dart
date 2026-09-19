// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Global Brand Component: ONPS Logo (Option 5 — Minimal & Classy)
// Colors: Dark Rich Brown (#3E2A22), Primary Gold (#D4AF37), Light Gold (#F7D87A), Dark Gold (#B8860B)
// ==============================================================================

import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Master ONPS Academic Brand Logo Component (Option 5 - Minimal & Classy).
///
/// Features:
/// - Dark rich brown circular background (#3E2A22)
/// - Thin refined metallic gold perimeter ring
/// - 3D faceted metallic gold graduation cap (mortarboard)
/// - Metallic gold crown/skull-cap base with rim
/// - Gold center button, draping cord, and detailed tassel pendant
/// - Seamless infinite vector scaling from 16px to 1024px+
class ONPSLogo extends StatelessWidget {
  /// Diameter of the circular brand logo.
  final double size;

  /// Optional custom semantics label for accessibility.
  final String semanticLabel;

  /// Optional shadow elevation.
  final bool hasShadow;

  const ONPSLogo({
    super.key,
    this.size = 32.0,
    this.semanticLabel = 'One Numan Public School Logo',
    this.hasShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget logo = SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        size: Size(size, size),
        painter: const _ONPSOption5Painter(),
      ),
    );

    if (hasShadow) {
      logo = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0x40000000),
              blurRadius: size * 0.12,
              offset: Offset(0, size * 0.04),
            ),
          ],
        ),
        child: logo,
      );
    }

    return Semantics(
      label: semanticLabel,
      image: true,
      child: logo,
    );
  }
}

/// Alias for [ONPSLogo] adhering to SchoolBrandLogo naming convention.
typedef SchoolBrandLogo = ONPSLogo;

/// High-precision CustomPainter rendering the Option 5 Minimal & Classy logo.
class _ONPSOption5Painter extends CustomPainter {
  const _ONPSOption5Painter();

  // Official Brand Palette
  static const Color darkBrownBase = Color(0xFF3E2A22);
  static const Color darkBrownLight = Color(0xFF4A332A);
  static const Color darkBrownDark = Color(0xFF32211A);

  static const Color primaryGold = Color(0xFFD4AF37);
  static const Color lightGold = Color(0xFFF7D87A);
  static const Color brightGold = Color(0xFFFFF3C4);
  static const Color darkGold = Color(0xFFB8860B);
  static const Color deepGoldShadow = Color(0xFF8B6508);
  static const Color goldSpecular = Color(0xFFFFFDF0);

  @override
  void paint(Canvas canvas, Size size) {
    final double side = math.min(size.width, size.height);
    if (side <= 0) return;

    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double r = side / 2;

    // -------------------------------------------------------------------------
    // 1. Dark Rich Brown Circular Background with Subtle Radial Depth
    // -------------------------------------------------------------------------
    final Rect circleRect = Rect.fromCircle(center: Offset(cx, cy), radius: r);
    final Paint bgPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.2, -0.3),
        radius: 0.95,
        colors: [darkBrownLight, darkBrownBase, darkBrownDark],
        stops: [0.0, 0.6, 1.0],
      ).createShader(circleRect)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(cx, cy), r, bgPaint);

    // -------------------------------------------------------------------------
    // 2. Refined Metallic Gold Outer Ring
    // -------------------------------------------------------------------------
    final double ringStrokeWidth = math.max(1.0, side * 0.032);
    final double ringRadius = r - (ringStrokeWidth / 2);

    final Paint ringPaint = Paint()
      ..shader = const SweepGradient(
        center: FractionalOffset.center,
        colors: [
          lightGold,
          primaryGold,
          darkGold,
          brightGold,
          primaryGold,
          darkGold,
          lightGold,
        ],
        stops: [0.0, 0.2, 0.45, 0.6, 0.75, 0.9, 1.0],
        transform: GradientRotation(-math.pi / 4),
      ).createShader(circleRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringStrokeWidth;

    canvas.drawCircle(Offset(cx, cy), ringRadius, ringPaint);

    // -------------------------------------------------------------------------
    // Geometry calculations for Mortarboard & Skull Cap
    // -------------------------------------------------------------------------
    // Diamond Mortarboard Vertices (Isometric Perspective)
    final Offset pTop = Offset(cx, cy - r * 0.36);
    final Offset pRight = Offset(cx + r * 0.60, cy - r * 0.07);
    final Offset pBottom = Offset(cx - r * 0.04, cy + r * 0.22);
    final Offset pLeft = Offset(cx - r * 0.62, cy - r * 0.09);

    final double bevelDepth = r * 0.06;

    // -------------------------------------------------------------------------
    // 3. Skull Cap / Crown Underneath Mortarboard
    // -------------------------------------------------------------------------
    final Path crownPath = Path();
    final Offset crownLeft = Offset(cx - r * 0.36, cy + r * 0.07);
    final Offset crownRight = Offset(cx + r * 0.32, cy + r * 0.08);
    final Offset crownBottom = Offset(cx - r * 0.02, cy + r * 0.43);

    crownPath.moveTo(crownLeft.dx, crownLeft.dy);
    crownPath.quadraticBezierTo(
      cx - r * 0.34,
      cy + r * 0.36,
      crownBottom.dx,
      crownBottom.dy,
    );
    crownPath.quadraticBezierTo(
      cx + r * 0.30,
      cy + r * 0.36,
      crownRight.dx,
      crownRight.dy,
    );
    crownPath.lineTo(pBottom.dx, pBottom.dy + bevelDepth);
    crownPath.close();

    final Rect crownRect = Rect.fromLTRB(
      cx - r * 0.4,
      cy,
      cx + r * 0.4,
      cy + r * 0.5,
    );
    final Paint crownPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [darkGold, deepGoldShadow, darkGold, primaryGold],
        stops: [0.0, 0.4, 0.75, 1.0],
      ).createShader(crownRect)
      ..style = PaintingStyle.fill;

    canvas.drawPath(crownPath, crownPaint);

    // Crown Bottom Metallic Rim Trim
    final Path crownRimPath = Path()
      ..moveTo(cx - r * 0.34, cy + r * 0.32)
      ..quadraticBezierTo(
        cx - r * 0.32,
        cy + r * 0.39,
        crownBottom.dx,
        crownBottom.dy,
      )
      ..quadraticBezierTo(
        cx + r * 0.28,
        cy + r * 0.39,
        cx + r * 0.30,
        cy + r * 0.32,
      );

    final Paint crownRimPaint = Paint()
      ..shader = const LinearGradient(
        colors: [primaryGold, brightGold, darkGold],
      ).createShader(crownRect)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = math.max(1.0, r * 0.04);

    canvas.drawPath(crownRimPath, crownRimPaint);

    // -------------------------------------------------------------------------
    // 4. Mortarboard 3D Thickness Bevels (Front-Left & Front-Right)
    // -------------------------------------------------------------------------
    // Front-Right Bevel Edge
    final Path rightBevel = Path()
      ..moveTo(pBottom.dx, pBottom.dy)
      ..lineTo(pRight.dx, pRight.dy)
      ..lineTo(pRight.dx, pRight.dy + bevelDepth)
      ..lineTo(pBottom.dx, pBottom.dy + bevelDepth)
      ..close();

    final Paint rightBevelPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [darkGold, deepGoldShadow],
      ).createShader(rightBevel.getBounds())
      ..style = PaintingStyle.fill;

    canvas.drawPath(rightBevel, rightBevelPaint);

    // Front-Left Bevel Edge
    final Path leftBevel = Path()
      ..moveTo(pLeft.dx, pLeft.dy)
      ..lineTo(pBottom.dx, pBottom.dy)
      ..lineTo(pBottom.dx, pBottom.dy + bevelDepth)
      ..lineTo(pLeft.dx, pLeft.dy + bevelDepth)
      ..close();

    final Paint leftBevelPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [deepGoldShadow, darkGold],
      ).createShader(leftBevel.getBounds())
      ..style = PaintingStyle.fill;

    canvas.drawPath(leftBevel, leftBevelPaint);

    // -------------------------------------------------------------------------
    // 5. Mortarboard Top Surface (Faceted Metallic Gold Diamond)
    // -------------------------------------------------------------------------
    final Path diamondPath = Path()
      ..moveTo(pTop.dx, pTop.dy)
      ..lineTo(pRight.dx, pRight.dy)
      ..lineTo(pBottom.dx, pBottom.dy)
      ..lineTo(pLeft.dx, pLeft.dy)
      ..close();

    final Rect diamondRect = diamondPath.getBounds();
    final Paint diamondPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment(-0.8, -0.9),
        end: Alignment(0.8, 0.9),
        colors: [
          goldSpecular,
          brightGold,
          lightGold,
          primaryGold,
          darkGold,
        ],
        stops: [0.0, 0.18, 0.45, 0.8, 1.0],
      ).createShader(diamondRect)
      ..style = PaintingStyle.fill;

    canvas.drawPath(diamondPath, diamondPaint);

    // Subtle edge highlight on top surface
    final Paint diamondEdgePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [goldSpecular, lightGold, darkGold],
      ).createShader(diamondRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(0.5, r * 0.015);

    canvas.drawPath(diamondPath, diamondEdgePaint);

    // -------------------------------------------------------------------------
    // 6. Center Button & Cord / Tassel Assembly
    // -------------------------------------------------------------------------
    final Offset buttonCenter = Offset(cx - r * 0.02, cy - r * 0.07);

    // Tassel Draping Cord
    final Path cordPath = Path()
      ..moveTo(buttonCenter.dx, buttonCenter.dy)
      ..quadraticBezierTo(
        cx + r * 0.22,
        cy - r * 0.01,
        cx + r * 0.42,
        cy + r * 0.07,
      )
      ..quadraticBezierTo(
        cx + r * 0.46,
        cy + r * 0.16,
        cx + r * 0.44,
        cy + r * 0.26,
      );

    final Paint cordPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [brightGold, primaryGold, darkGold],
      ).createShader(cordPath.getBounds())
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = math.max(1.0, r * 0.042);

    canvas.drawPath(cordPath, cordPaint);

    // Center Gold Button
    final double buttonRadius = r * 0.065;
    final Paint buttonPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.3, -0.4),
        radius: 0.8,
        colors: [goldSpecular, brightGold, primaryGold, darkGold],
        stops: [0.0, 0.3, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: buttonCenter, radius: buttonRadius))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(buttonCenter, buttonRadius, buttonPaint);

    // Tassel Ring / Ferrule Bead
    final Offset ferruleCenter = Offset(cx + r * 0.44, cy + r * 0.27);
    final Rect ferruleRect = Rect.fromCenter(
      center: ferruleCenter,
      width: r * 0.08,
      height: r * 0.05,
    );
    final Paint ferrulePaint = Paint()
      ..shader = const LinearGradient(
        colors: [brightGold, darkGold, brightGold],
      ).createShader(ferruleRect)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(ferruleRect, Radius.circular(r * 0.02)),
      ferrulePaint,
    );

    // Tassel Fringe / Pendant Body
    final Path fringePath = Path()
      ..moveTo(cx + r * 0.41, cy + r * 0.29)
      ..lineTo(cx + r * 0.47, cy + r * 0.29)
      ..lineTo(cx + r * 0.49, cy + r * 0.48)
      ..quadraticBezierTo(
        cx + r * 0.44,
        cy + r * 0.52,
        cx + r * 0.39,
        cy + r * 0.48,
      )
      ..close();

    final Rect fringeRect = fringePath.getBounds();
    final Paint fringePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          brightGold,
          primaryGold,
          darkGold,
          deepGoldShadow,
        ],
        stops: [0.0, 0.3, 0.75, 1.0],
      ).createShader(fringeRect)
      ..style = PaintingStyle.fill;

    canvas.drawPath(fringePath, fringePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
