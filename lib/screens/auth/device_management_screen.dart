// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 04: Multi-Device Session Revocation & Governance
// Design System: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8/04_multi_device_session_revocation
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/shared_widgets.dart';

class DeviceManagementScreen extends StatefulWidget {
  const DeviceManagementScreen({super.key});

  @override
  State<DeviceManagementScreen> createState() => _DeviceManagementScreenState();
}

class _DeviceManagementScreenState extends State<DeviceManagementScreen> {
  final List<Map<String, dynamic>> _otherDevices = [
    {
      'id': 'DEV-002',
      'name': 'macOS Safari • Desktop',
      'location': 'Delhi, India',
      'ip': '14.139.60.2',
      'lastActive': '2 hours ago',
      'icon': Icons.laptop_mac,
    },
    {
      'id': 'DEV-003',
      'name': 'Windows 11 Chrome • Workstation',
      'location': 'New Delhi, India',
      'ip': '182.73.19.45',
      'lastActive': 'Yesterday at 17:40',
      'icon': Icons.desktop_windows,
    },
  ];

  void _evictDevice(int index) {
    final dev = _otherDevices[index];
    setState(() {
      _otherDevices.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Session on ${dev['name']} successfully revoked'),
        backgroundColor: AcademicColors.primaryDark,
      ),
    );
  }

  void _evictAll() {
    setState(() {
      _otherDevices.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All other remote device sessions terminated'),
        backgroundColor: AcademicColors.primaryDark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int inUse = 1 + _otherDevices.length;

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: AppTopBar(
        title: 'Registered Devices',
        actions: [
          Center(child: PillBadge.info('M3 Policy')),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quota Hero Bento Card
              InsetCard(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'INSTITUTIONAL QUOTA',
                              style: GoogleFonts.manrope(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AcademicColors.textSecondary,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$inUse of 3 In Use',
                              style: GoogleFonts.newsreader(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AcademicColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: List.generate(3, (idx) {
                            final filled = idx < inUse;
                            return Container(
                              margin: const EdgeInsets.only(left: 6),
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: filled ? AcademicColors.primaryDark : AcademicColors.canvas,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: filled ? AcademicColors.primaryDark : AcademicColors.border,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '${idx + 1}',
                                  style: GoogleFonts.manrope(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: filled ? Colors.white : AcademicColors.textSecondary,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: inUse / 3.0,
                        minHeight: 6,
                        backgroundColor: AcademicColors.canvas,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          inUse >= 3 ? AcademicColors.warning : AcademicColors.primaryDark,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline, size: 14, color: AcademicColors.warning),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Under institutional cybersecurity policy, logging into a 4th device will automatically evict your oldest active session to prevent credential compromise.',
                            style: GoogleFonts.manrope(
                              fontSize: 10.5,
                              color: AcademicColors.textSecondary,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Section: Current Handheld
              Text(
                'CURRENT SESSION (ACTIVE NOW)',
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AcademicColors.textSecondary,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),

              InsetCard(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AcademicColors.primaryDark,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.smartphone, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Handheld Android',
                                style: GoogleFonts.manrope(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AcademicColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 6),
                              PillBadge.success('THIS HANDHELD'),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Delhi, India • IP: 103.212.14.88',
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              color: AcademicColors.textSecondary,
                            ),
                          ),
                          Text(
                            'Active right now • Biometric Authenticated',
                            style: GoogleFonts.manrope(
                              fontSize: 10.5,
                              color: AcademicColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Section: Other Sessions
              if (_otherDevices.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'OTHER ACTIVE SESSIONS (${_otherDevices.length})',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.textSecondary,
                        letterSpacing: 0.8,
                      ),
                    ),
                    GestureDetector(
                      onTap: _evictAll,
                      child: Text(
                        'Revoke All',
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.danger,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                ...List.generate(_otherDevices.length, (idx) {
                  final dev = _otherDevices[idx];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InsetCard(
                      margin: EdgeInsets.zero,
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AcademicColors.canvas,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(dev['icon'] as IconData, color: AcademicColors.secondary, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dev['name'] as String,
                                  style: GoogleFonts.manrope(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AcademicColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${dev['location']} • ${dev['ip']}',
                                  style: GoogleFonts.manrope(
                                    fontSize: 11,
                                    color: AcademicColors.textSecondary,
                                  ),
                                ),
                                Text(
                                  'Last active: ${dev['lastActive']}',
                                  style: GoogleFonts.manrope(
                                    fontSize: 10.5,
                                    color: AcademicColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AcademicColors.danger),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () => _evictDevice(idx),
                            child: Text(
                              'Evict',
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AcademicColors.danger,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ] else ...[
                InsetCard(
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.all(18),
                  child: Center(
                    child: Text(
                      'No other active devices. You are only signed in on this handheld.',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: AcademicColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Emergency IT Helpdesk Note
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.shield_outlined, size: 16, color: AcademicColors.textSecondary),
                    const SizedBox(width: 6),
                    Text(
                      'Session Governance • Security Compliance DPDP 2023',
                      style: GoogleFonts.manrope(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                        color: AcademicColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
