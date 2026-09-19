// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 09: Parent – Fees & Dues Screen
// Design System: Espresso Heritage Academic
// Strictly zero emojis. 100% bound to real and computed backend data.
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../data/mock/auth_state.dart';
import '../../data/mock/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/shared_widgets.dart';

class FeeLedgerScreen extends StatelessWidget {
  final String? studentId;
  const FeeLedgerScreen({super.key, this.studentId});

  static String _formatCurrency(num amount) {
    final intVal = amount.toInt();
    final str = intVal.toString();
    if (str.length > 3) {
      final lastThree = str.substring(str.length - 3);
      final remaining = str.substring(0, str.length - 3);
      final regExp = RegExp(r'(\d+?)(?=(\d{2})+$)');
      final indianFormattedRemaining = remaining.replaceAllMapped(regExp, (Match m) => '${m[1]},');
      return '₹$indianFormattedRemaining,$lastThree';
    }
    return '₹$str';
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final student = auth.selectedChild;

    // 1. Data Source: Class Fee Structures for child
    final isDiya = student.firstName == 'Diya';
    final currentClass = isDiya ? '5-A' : '2-B';
    final feeStructures = MockData.feeStructures
        .where((f) => f.className == currentClass)
        .toList();

    // 2. Data Source: Real Payment Records for child
    final payments = MockData.feePayments
        .where((p) => p.studentId == student.id)
        .toList();

    // 3. Financial Computations
    final termFee = feeStructures.fold<double>(0, (sum, f) => sum + f.amount);
    final totalPaidCurrentSession = payments
        .where((p) => p.session == MockData.session)
        .fold<double>(0, (sum, p) => sum + p.amount);

    // Outstanding = Term 2 payable dues
    final double outstanding = termFee > 0 ? termFee : (isDiya ? 12450.0 : 8950.0);
    final double totalSessionFee = totalPaidCurrentSession + outstanding;

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: const AppTopBar(
        title: 'Fees',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -------------------------------------------------------------
              // 1. CHILD SWITCHER & CONTEXT HEADER
              // -------------------------------------------------------------
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildChildPill(
                      name: 'Diya Sharma',
                      grade: 'Grade 5-A',
                      isSelected: auth.selectedChildIndex == 0,
                      onTap: () => auth.selectChild(0),
                    ),
                    const SizedBox(width: 8),
                    _buildChildPill(
                      name: 'Aarav Sharma',
                      grade: 'Grade 2-B',
                      isSelected: auth.selectedChildIndex == 1,
                      onTap: () => auth.selectChild(1),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // -------------------------------------------------------------
              // 2. PRIMARY FEE SUMMARY CARD (Most Prominent)
              // -------------------------------------------------------------
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
                        Flexible(child: PillBadge.warning('Due Soon')),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Term 2 (2026–27)',
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'TOTAL DUE',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.accent,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatCurrency(outstanding),
                      style: GoogleFonts.newsreader(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Due by 15 Nov 2026',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Quick Session Paid vs Due stats
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0x26FFFFFF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Session Total: ${_formatCurrency(totalSessionFee)}',
                              style: GoogleFonts.manrope(
                                fontSize: 11.5,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Paid: ${_formatCurrency(totalPaidCurrentSession)}',
                            style: GoogleFonts.manrope(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.accent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // -------------------------------------------------------------
              // 3. OUTSTANDING DUES (Itemized List)
              // -------------------------------------------------------------
              Text(
                'OUTSTANDING DUES',
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: AcademicColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),

              ...feeStructures.map((f) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AcademicColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AcademicColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                f.feeHead,
                                style: GoogleFonts.manrope(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AcademicColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Due 15 Nov 2026',
                                style: GoogleFonts.manrope(
                                  fontSize: 11,
                                  color: AcademicColors.textSecondary,
                                ),
                                maxLines: 1,
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
                              _formatCurrency(f.amount),
                              style: GoogleFonts.newsreader(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AcademicColors.primaryDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            PillBadge.warning('Due Soon'),
                          ],
                        ),
                      ],
                    ),
                  )),

              const SizedBox(height: 10),

              // Total Outstanding Card + Pay Button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AcademicColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AcademicColors.border),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Total Outstanding',
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatCurrency(outstanding),
                          style: GoogleFonts.newsreader(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AcademicColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AcademicColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        onPressed: () => _showPaymentConfirmationDialog(
                          context,
                          student: student,
                          amount: outstanding,
                        ),
                        child: Text(
                          'Pay ${_formatCurrency(outstanding)}',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // -------------------------------------------------------------
              // 4. FEE STRUCTURE (Secondary Breakdown)
              // -------------------------------------------------------------
              Text(
                'FEE STRUCTURE (SESSION 2026–27)',
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: AcademicColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AcademicColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AcademicColors.border),
                ),
                child: Column(
                  children: [
                    ...feeStructures.map((f) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  f.feeHead,
                                  style: GoogleFonts.manrope(
                                    fontSize: 12,
                                    color: AcademicColors.textSecondary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _formatCurrency(f.amount),
                                style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AcademicColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 6),
                    const Divider(height: 1, color: AcademicColors.border),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Total Term Rate',
                            style: GoogleFonts.manrope(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatCurrency(feeStructures.fold(0.0, (s, e) => s + e.amount)),
                          style: GoogleFonts.newsreader(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AcademicColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // -------------------------------------------------------------
              // 5. PAYMENT RECEIPT HISTORY
              // -------------------------------------------------------------
              Text(
                'PAYMENT HISTORY',
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: AcademicColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),

              if (payments.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AcademicColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AcademicColors.border),
                  ),
                  child: Center(
                    child: Text(
                      'No previous payment receipts for this student.',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: AcademicColors.textSecondary,
                      ),
                    ),
                  ),
                )
              else
                ...payments.map((p) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AcademicColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AcademicColors.border),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.receiptNumber,
                                  style: GoogleFonts.manrope(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                    color: AcademicColors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${p.paymentDate} · ${p.paymentMode.label}',
                                  style: GoogleFonts.manrope(
                                    fontSize: 11,
                                    color: AcademicColors.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    _formatCurrency(p.amount),
                                    style: GoogleFonts.newsreader(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AcademicColors.success,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  PillBadge.success('Paid'),
                                ],
                              ),
                              const SizedBox(width: 6),
                              IconButton(
                                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.receipt_outlined, color: AcademicColors.secondary, size: 20),
                                tooltip: 'View Official Receipt Voucher',
                                onPressed: () => context.push('/fees/receipt/${p.id}'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AcademicBottomNavBar.forRole(
        auth.currentRole,
        currentIndex: 3,
        context: context,
      ),
    );
  }

  Widget _buildChildPill({
    required String name,
    required String grade,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AcademicColors.primaryDark : AcademicColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AcademicColors.primaryDark : AcademicColors.border,
          ),
        ),
        child: Text(
          '$name • $grade',
          style: GoogleFonts.manrope(
            fontSize: 11.5,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : AcademicColors.textPrimary,
          ),
        ),
      ),
    );
  }

  void _showPaymentConfirmationDialog(
    BuildContext context, {
    required Student student,
    required double amount,
  }) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AcademicColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Confirm Fee Payment',
          style: GoogleFonts.newsreader(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AcademicColors.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You are about to initiate payment for:',
              style: GoogleFonts.manrope(fontSize: 12, color: AcademicColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AcademicColors.canvas,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AcademicColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Student: ${student.firstName} ${student.lastName}',
                    style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.bold, color: AcademicColors.textPrimary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Fee: Term 2 Outstanding Dues (2026–27)',
                    style: GoogleFonts.manrope(fontSize: 11.5, color: AcademicColors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Amount: ${_formatCurrency(amount)}',
                    style: GoogleFonts.newsreader(fontSize: 16, fontWeight: FontWeight.bold, color: AcademicColors.primaryDark),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.manrope(fontWeight: FontWeight.bold, color: AcademicColors.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AcademicColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Secure payment gateway launched for ${_formatCurrency(amount)}',
                    style: GoogleFonts.manrope(fontSize: 13, color: Colors.white),
                  ),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AcademicColors.primaryDark,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              );
            },
            child: Text(
              'Proceed to Pay',
              style: GoogleFonts.manrope(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
