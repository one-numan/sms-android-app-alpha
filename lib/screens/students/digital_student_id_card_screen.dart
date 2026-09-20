// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 29: Digital Student ID Card Sheet
// Design System: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8/29_digital_student_id_card_sheet
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../data/mock/auth_state.dart';
import '../../data/mock/mock_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/onps_logo.dart';

class DigitalStudentIdCardScreen extends StatelessWidget {
  const DigitalStudentIdCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthState>();
    final student = authState.selectedChild;

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          decoration: const BoxDecoration(
            color: AcademicColors.surface,
            border: Border(
              bottom: BorderSide(color: AcademicColors.border, width: 1),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AcademicColors.primaryDark),
                    tooltip: 'Back',
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        context.go('/student/hub');
                      }
                    },
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Digital Student ID',
                          style: GoogleFonts.newsreader(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AcademicColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Verified Student Identity',
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AcademicColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.share_outlined, color: AcademicColors.primaryDark, size: 20),
                    tooltip: 'Share Identity',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Sharing Student ID for ${student.firstName} ${student.lastName} (${student.id})',
                            style: GoogleFonts.manrope(fontSize: 13, color: Colors.white),
                          ),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: AcademicColors.primaryDark,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Downloading Student ID PDF for ${student.firstName} ${student.lastName}...',
                            style: GoogleFonts.manrope(fontSize: 13, color: Colors.white),
                          ),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: AcademicColors.primaryDark,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AcademicColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.download, size: 15, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            'PDF',
                            style: GoogleFonts.manrope(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                children: [
                  // Main Institutional Card Container
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AcademicColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AcademicColors.border),
                      boxShadow: AcademicColors.elevatedShadow,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        // Gold Accent Top Stripe
                        Container(
                          height: 4,
                          width: double.infinity,
                          color: AcademicColors.accent,
                        ),

                        // Header Banner: Deep Collegiate Espresso
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                          decoration: const BoxDecoration(
                            color: AcademicColors.primaryDark,
                          ),
                          child: Column(
                            children: [
                              // School Crest Monogram
                              const ONPSLogo(size: 50, hasShadow: true),
                              const SizedBox(height: 8),
                              Text(
                                MockData.schoolName.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.newsreader(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Affiliated to CBSE • Civil Lines',
                                style: GoogleFonts.manrope(
                                  fontSize: 11,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0x26FFFFFF),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'ACADEMIC SESSION 2026–27',
                                  style: GoogleFonts.manrope(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AcademicColors.accent,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Student Visual Badge Body
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                          child: Column(
                            children: [
                              // Framed Portrait Photo with Active Indicator
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    width: 92,
                                    height: 92,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: AcademicColors.accent, width: 2.5),
                                      color: AcademicColors.canvas,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'DS',
                                        style: GoogleFonts.newsreader(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: AcademicColors.primaryDark,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 2,
                                    right: 4,
                                    child: Container(
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        color: AcademicColors.success,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: AcademicColors.surface, width: 2),
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        size: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Student Name
                              Text(
                                '${student.firstName} ${student.lastName}'.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.newsreader(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AcademicColors.textPrimary,
                                  letterSpacing: -0.2,
                                ),
                              ),

                              const SizedBox(height: 6),

                              // Class, Section & Roll Number Pill
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AcademicColors.canvas,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AcademicColors.border),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.school_outlined,
                                      size: 14,
                                      color: AcademicColors.secondary,
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        'Grade 5 • Section A • Roll No. ${student.rollNumber}',
                                        style: GoogleFonts.manrope(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AcademicColors.textPrimary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 18),

                              // 2-Column Institutional Attribute Grid
                              Row(
                                children: [
                                  _buildAttributeTile('Admission No', student.id, isMonospace: true),
                                  const SizedBox(width: 8),
                                  _buildAttributeTile('Date of Birth', student.dateOfBirth),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _buildAttributeTile(
                                    'Blood Group',
                                    'B+',
                                    badgeColor: const Color(0xFFFBEAE8),
                                    badgeTextColor: const Color(0xFFB5443C),
                                  ),
                                  const SizedBox(width: 8),
                                  _buildAttributeTile(
                                    'House',
                                    'Ruby House',
                                    badgeColor: const Color(0xFFFBEAE8),
                                    badgeTextColor: const Color(0xFFB5443C),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Card Validity Ribbon
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AcademicColors.canvas,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AcademicColors.border),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.event_available_outlined,
                                      size: 15,
                                      color: AcademicColors.secondary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Card Validity',
                                      style: GoogleFonts.manrope(
                                        fontSize: 11,
                                        color: AcademicColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        'Valid Through 31 Mar 2027',
                                        textAlign: TextAlign.end,
                                        style: GoogleFonts.manrope(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.bold,
                                          color: AcademicColors.textPrimary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Single Scannable QR Verification Block
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AcademicColors.canvas,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: AcademicColors.border),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.qr_code_2,
                                                size: 15,
                                                color: AcademicColors.secondary,
                                              ),
                                              const SizedBox(width: 6),
                                              Expanded(
                                                child: Text(
                                                  'STUDENT VERIFICATION',
                                                  style: GoogleFonts.manrope(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: AcademicColors.textSecondary,
                                                    letterSpacing: 0.8,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFEAF4ED),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.verified,
                                                size: 12,
                                                color: AcademicColors.success,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Verified',
                                                style: GoogleFonts.manrope(
                                                  fontSize: 10.5,
                                                  fontWeight: FontWeight.bold,
                                                  color: AcademicColors.success,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      width: 88,
                                      height: 88,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0x0A000000),
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.qr_code_2_rounded,
                                          size: 76,
                                          color: AcademicColors.primaryDark,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'ONPS-VERIFY-2026-ADM0412',
                                      style: GoogleFonts.manrope(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AcademicColors.textSecondary,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Institutional Authorization
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(top: 12),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: AcademicColors.border, width: 1),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.school_outlined,
                                            size: 15,
                                            color: AcademicColors.secondary,
                                          ),
                                          const SizedBox(width: 6),
                                          Flexible(
                                            child: Text(
                                              MockData.schoolName,
                                              style: GoogleFonts.manrope(
                                                fontSize: 11,
                                                color: AcademicColors.textSecondary,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Authorized By',
                                          style: GoogleFonts.manrope(
                                            fontSize: 9.5,
                                            color: AcademicColors.textSecondary,
                                          ),
                                        ),
                                        Text(
                                          'Principal',
                                          style: GoogleFonts.manrope(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.bold,
                                            color: AcademicColors.textPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Emergency Contact Capsule
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AcademicColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AcademicColors.border),
                      boxShadow: AcademicColors.cardShadow,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBEAE8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.contact_emergency_outlined,
                            color: Color(0xFFB5443C),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'EMERGENCY CONTACT (FATHER)',
                                style: GoogleFonts.manrope(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w600,
                                  color: AcademicColors.textSecondary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Rajesh Sharma',
                                style: GoogleFonts.newsreader(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AcademicColors.textPrimary,
                                ),
                              ),
                              Text(
                                student.mobile,
                                style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  color: AcademicColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Calling Rajesh Sharma (${student.mobile})...',
                                  style: GoogleFonts.manrope(fontSize: 13, color: Colors.white),
                                ),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: AcademicColors.primaryDark,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: const BoxDecoration(
                              color: Color(0xFFEAF4ED),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.call,
                              size: 18,
                              color: Color(0xFF2E7D4F),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttributeTile(
    String label,
    String value, {
    bool isMonospace = false,
    Color? badgeColor,
    Color? badgeTextColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: AcademicColors.canvas,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AcademicColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: GoogleFonts.manrope(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: AcademicColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            if (badgeColor != null && badgeTextColor != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  value,
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: badgeTextColor,
                  ),
                ),
              )
            else
              Text(
                value,
                style: GoogleFonts.manrope(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: AcademicColors.textPrimary,
                  letterSpacing: isMonospace ? 0.4 : 0,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
