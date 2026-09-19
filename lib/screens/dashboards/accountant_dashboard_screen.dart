// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 31: Accounts & Fee Collection Executive Dashboard
// Design System: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8/accounts_fee_collection_executive_dashboard
// Strict adherence: Payment modes only: Cash, Cheque, Online Transfer, Card, UPI.
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/mock/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/account_profile_sheet.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/shared_widgets.dart';

class AccountantDashboardScreen extends StatelessWidget {
  const AccountantDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: const AppTopBar(showBrand: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Accountant Identity Header Card
              InkWell(
                onTap: () => AccountProfileSheet.show(context),
                borderRadius: BorderRadius.circular(12),
                child: Semantics(
                  label: 'View account profile',
                  child: InsetCard(
                    margin: EdgeInsets.zero,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: const BoxDecoration(
                            color: AcademicColors.primaryDark,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              'AC',
                              style: GoogleFonts.newsreader(
                                fontSize: 15,
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
                                'Accounts & Fees Desk',
                                style: GoogleFonts.newsreader(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AcademicColors.textPrimary,
                                ),
                              ),
                              Text(
                                'Accountant • AY 2026–27',
                                style: GoogleFonts.manrope(
                                  fontSize: 11,
                                  color: AcademicColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, size: 18, color: AcademicColors.textSecondary),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Realization Hero Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AcademicColors.primaryDark,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AcademicColors.elevatedShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PillBadge.success('91.9% Realized'),
                        Text(
                          'Term 2 FY 2026-27',
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Total Fee Collections Realized',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: AcademicColors.canvas,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '₹16,92,500',
                      style: GoogleFonts.newsreader(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: const LinearProgressIndicator(
                        value: 0.919,
                        minHeight: 6,
                        backgroundColor: Colors.white24,
                        valueColor: AlwaysStoppedAnimation<Color>(AcademicColors.accent),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Expected: ₹18,40,000',
                          style: GoogleFonts.manrope(fontSize: 11, color: Colors.white70),
                        ),
                        Text(
                          'Outstanding: ₹1,47,500',
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AcademicColors.accent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Recorded Payment Modes Breakdown
              Text(
                'PAYMENT MODES BREAKDOWN',
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AcademicColors.textSecondary,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  _buildModeTile('Online Transfer', '₹5.10L', Icons.account_balance, AcademicColors.primaryDark),
                  const SizedBox(width: 8),
                  _buildModeTile('Cash', '₹4.20L', Icons.payments, AcademicColors.success),
                  const SizedBox(width: 8),
                  _buildModeTile('Cheque', '₹3.80L', Icons.edit_document, AcademicColors.secondary),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildModeTile('UPI', '₹2.32L', Icons.qr_code_2, AcademicColors.accent),
                  const SizedBox(width: 8),
                  _buildModeTile('Card', '₹1.50L', Icons.credit_card, AcademicColors.info),
                ],
              ),

              const SizedBox(height: 20),

              // Recent Fee Payments Log
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'RECENT RECORDED TRANSACTIONS',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AcademicColors.textSecondary,
                      letterSpacing: 0.8,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push('/fees/ledger'),
                    child: Text(
                      'Full Ledger →',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.secondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              ...MockData.feePayments.map((p) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InsetCard(
                    margin: EdgeInsets.zero,
                    padding: const EdgeInsets.all(14),
                    onTap: () => context.push('/fees/receipt/${p.receiptNumber}'),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AcademicColors.canvas,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.receipt_long, color: AcademicColors.primaryDark, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Receipt #${p.receiptNumber}',
                                style: GoogleFonts.manrope(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AcademicColors.textPrimary,
                                ),
                              ),
                              Text(
                                '${p.paymentDate} • Recorded by ${p.recordedBy}',
                                style: GoogleFonts.manrope(
                                  fontSize: 11,
                                  color: AcademicColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '₹${p.amountPaid.toStringAsFixed(0)}',
                              style: GoogleFonts.newsreader(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AcademicColors.textPrimary,
                              ),
                            ),
                            PillBadge.success(p.mode.label),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AcademicBottomNavBar.forRole(
        UserRole.accountant,
        currentIndex: 0,
        context: context,
      ),
    );
  }

  Widget _buildModeTile(String mode, String amount, IconData icon, Color color) {
    return Expanded(
      child: InsetCard(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              amount,
              style: GoogleFonts.newsreader(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AcademicColors.textPrimary,
              ),
            ),
            Text(
              mode,
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(fontSize: 10, color: AcademicColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
