// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 10: Official Fee Payment Receipt Voucher
// Design System: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8/10_official_fee_payment_receipt
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/mock/mock_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/onps_logo.dart';

class FeeReceiptScreen extends StatelessWidget {
  final String? receiptNo;
  const FeeReceiptScreen({super.key, this.receiptNo});

  @override
  Widget build(BuildContext context) {
    final payment = MockData.feePayments.firstWhere(
      (p) => p.receiptNumber == (receiptNo ?? 'REC-2026-0891'),
      orElse: () => MockData.feePayments.first,
    );

    final student = MockData.students.firstWhere(
      (s) => s.id == payment.studentId,
      orElse: () => MockData.students.first,
    );

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: AppTopBar(
        title: 'Official Fee Receipt',
        actions: [
          SizedBox(
            width: 38,
            height: 38,
            child: IconButton(
              padding: EdgeInsets.zero,
              tooltip: 'Download Receipt PDF',
              icon: const Icon(Icons.download_rounded, color: AcademicColors.primary, size: 21),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AcademicColors.primary,
                    content: Text('Fee Receipt #$receiptNo PDF downloaded.'),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            width: 38,
            height: 38,
            child: IconButton(
              padding: EdgeInsets.zero,
              tooltip: 'Share Receipt Voucher',
              icon: const Icon(Icons.share_outlined, color: AcademicColors.primary, size: 21),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: AcademicColors.primary,
                    content: Text('Sharing official fee voucher link.'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Archival Voucher Card
              Container(
                decoration: BoxDecoration(
                  color: AcademicColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AcademicColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: AcademicColors.primary.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Top Archival Band
                    Container(
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AcademicColors.primary,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const ONPSLogo(size: 56, hasShadow: true),
                          const SizedBox(height: 10),
                          Text(
                            'Office of Accounts & Finance',
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AcademicColors.caramelDark,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            MockData.schoolName,
                            style: GoogleFonts.newsreader(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            MockData.campusAddress,
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              color: AcademicColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          const Divider(color: AcademicColors.border),
                          const SizedBox(height: 12),

                          // Receipt Meta Capsule
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AcademicColors.canvas,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'RECEIPT NUMBER',
                                        style: GoogleFonts.manrope(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: AcademicColors.textSecondary,
                                        ),
                                      ),
                                      Text(
                                        payment.receiptNumber,
                                        style: GoogleFonts.manrope(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: AcademicColors.textPrimary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'DATE RECORDED',
                                      style: GoogleFonts.manrope(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: AcademicColors.textSecondary,
                                      ),
                                    ),
                                    Text(
                                      payment.paymentDate,
                                      style: GoogleFonts.manrope(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AcademicColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Student Information
                          _DetailRow(label: 'Student Name', value: student.name),
                          _DetailRow(label: 'Admission No', value: student.admissionNumber),
                          _DetailRow(label: 'Class & Section', value: student.className),
                          _DetailRow(label: 'Roll Number', value: '${student.rollNumber}'),
                          _DetailRow(label: 'Academic Session', value: payment.session),
                          _DetailRow(label: 'Payment Mode', value: payment.paymentMode.label),
                          _DetailRow(label: 'Accounts Officer', value: payment.receivedBy),

                          const SizedBox(height: 12),
                          const Divider(color: AcademicColors.border),
                          const SizedBox(height: 12),

                          // Fee Particulars
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Particulars',
                                  style: GoogleFonts.manrope(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AcademicColors.textSecondary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Amount',
                                style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AcademicColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  payment.feeHead,
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    color: AcademicColors.textPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '₹${payment.amount.toStringAsFixed(2)}',
                                style: GoogleFonts.newsreader(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AcademicColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Divider(color: AcademicColors.border),
                          const SizedBox(height: 12),

                          // Total Paid
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Total Paid',
                                  style: GoogleFonts.newsreader(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AcademicColors.textPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '₹${payment.amount.toStringAsFixed(2)}',
                                style: GoogleFonts.newsreader(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AcademicColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Digital Seal / Verification Pill
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: AcademicColors.success.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AcademicColors.success.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.verified, size: 18, color: AcademicColors.success),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    'Digitally Verified Institutional Record',
                                    style: GoogleFonts.manrope(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.bold,
                                      color: AcademicColors.success,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
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
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 13,
                color: AcademicColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 6,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AcademicColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
