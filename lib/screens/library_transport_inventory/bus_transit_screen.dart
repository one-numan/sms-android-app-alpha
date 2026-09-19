// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Screen 17: Student Bus Route & Transit Card Desk
// Design System: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8/17_student_bus_route_transit_card
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../data/mock/auth_state.dart';
import '../../data/mock/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/shared_widgets.dart';

class BusTransitScreen extends StatefulWidget {
  final String? studentId;
  const BusTransitScreen({super.key, this.studentId});

  @override
  State<BusTransitScreen> createState() => _BusTransitScreenState();
}

class _BusTransitScreenState extends State<BusTransitScreen> {
  late TransportRoute _selectedRoute;

  @override
  void initState() {
    super.initState();
    _selectedRoute = MockData.routes.isNotEmpty
        ? MockData.routes.first
        : const TransportRoute(
            routeName: 'Route #12: Civil Lines to ONPS Campus',
            vehicleRegistration: 'UP-32-AB-1234',
            capacity: 42,
            driverName: 'Ram Singh',
            driverMobile: '+91 98765 43210',
            stops: ['Civil Lines Metro', 'Mall Road Crossing', 'Model Town Gate 2', 'ONPS Main Campus'],
          );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final student = MockData.students.firstWhere(
      (s) => s.id == (widget.studentId ?? 'STU-001'),
      orElse: () => MockData.students.first,
    );

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: const AppTopBar(
        title: 'Bus Route & Transit',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Transit Card (Deep Espresso)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AcademicColors.primary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AcademicColors.primary.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AcademicColors.caramel.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'MORNING COMMUTE',
                              style: GoogleFonts.manrope(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AcademicColors.caramelLight,
                                letterSpacing: 0.5,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.schedule, size: 14, color: AcademicColors.caramelLight),
                            const SizedBox(width: 4),
                            Text(
                              'On Schedule',
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                color: AcademicColors.caramelLight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _selectedRoute.routeName,
                      style: GoogleFonts.newsreader(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.surface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.directions_bus, size: 16, color: AcademicColors.caramelLight),
                            const SizedBox(width: 4),
                            Text(
                              'Capacity: ${_selectedRoute.capacity} Seats',
                              style: GoogleFonts.manrope(fontSize: 12, color: AcademicColors.surface.withValues(alpha: 0.9)),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _selectedRoute.vehicleRegistration,
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.caramelLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Student Assigned Boarding Card
              InsetCard(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AcademicColors.canvas,
                      child: Text(
                        student.name.isNotEmpty ? student.name[0] : 'S',
                        style: GoogleFonts.newsreader(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            student.name,
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Designated Stop: Civil Lines Metro Gate 2',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              color: AcademicColors.caramelDark,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    PillBadge.secondary(student.className),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Driver & Crew Contact Capsule
              Text(
                'Transit Crew & Support',
                style: GoogleFonts.newsreader(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AcademicColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              InsetCard(
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 22,
                      backgroundColor: AcademicColors.canvas,
                      child: Icon(Icons.person, color: AcademicColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedRoute.driverName,
                            style: GoogleFonts.manrope(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Institutional Fleet Driver • Phone: ${_selectedRoute.driverMobile}',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              color: AcademicColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.phone, color: AcademicColors.primary),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AcademicColors.primary,
                            content: Text('Calling Driver ${_selectedRoute.driverName}...'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Route Waypoints & Stoppage Schedule Timeline
              Text(
                'Route Stoppages & Timeline',
                style: GoogleFonts.newsreader(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AcademicColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              InsetCard(
                child: Column(
                  children: _selectedRoute.stops.asMap().entries.map((entry) {
                    final index = entry.key;
                    final stop = entry.value;
                    final isLast = index == _selectedRoute.stops.length - 1;

                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: index == 0
                                      ? AcademicColors.primary
                                      : isLast
                                          ? AcademicColors.success
                                          : AcademicColors.caramel,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                              if (!isLast)
                                Expanded(
                                  child: Container(
                                    width: 2,
                                    color: AcademicColors.border,
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    stop,
                                    style: GoogleFonts.manrope(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AcademicColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    'Stop #${index + 1} • Scheduled Stoppage',
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                      color: AcademicColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Switch Route Dropdown for Multi-route visibility
              if (MockData.routes.length > 1) ...[
                Text(
                  'Switch Route Fleet',
                  style: GoogleFonts.newsreader(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AcademicColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AcademicColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AcademicColors.border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<TransportRoute>(
                      value: _selectedRoute,
                      isExpanded: true,
                      items: MockData.routes.map((r) {
                        return DropdownMenuItem<TransportRoute>(
                          value: r,
                          child: Text(r.routeName, style: GoogleFonts.manrope(fontSize: 13)),
                        );
                      }).toList(),
                      onChanged: (r) {
                        if (r != null) setState(() => _selectedRoute = r);
                      },
                    ),
                  ),
                ),
              ],
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
}
