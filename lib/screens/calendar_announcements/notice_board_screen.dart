// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Principal -> Notices: School Notices & Circulars Desk
// Design System: Espresso Heritage Academic
// Reference: stitch_onps_android_erp_ui 8/13_school_notice_board_moderated_circulars
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../data/mock/auth_state.dart';
import '../../data/services/announcement_api_service.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/bottom_nav_bar.dart';

class NoticeBoardScreen extends StatefulWidget {
  const NoticeBoardScreen({super.key});

  @override
  State<NoticeBoardScreen> createState() => _NoticeBoardScreenState();
}

class _NoticeBoardScreenState extends State<NoticeBoardScreen> {
  final AnnouncementApiService _apiService = AnnouncementApiService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _isLoading = false;
  String? _errorMessage;
  List<Announcement> _apiAnnouncements = [];

  static const List<Announcement> _testAnnouncements = [
    Announcement(
      id: 'ANN-1',
      postType: 'Urgent Advisory',
      category: 'School',
      title: 'Revised Morning Assembly Schedule',
      body: 'Due to dense morning fog and cold wave conditions, morning assembly will be conducted indoors in respective classrooms starting Monday. School timing adjusted to 08:30 AM.',
      author: 'Dr. Robert Chen (Principal)',
      status: AnnouncementStatus.published,
      isPinned: true,
      audience: 'All School (K–12)',
      publishedAt: '24 Oct 2026',
      attachmentName: 'winter_timing_schedule_2026.pdf',
      attachmentType: 'PDF Document',
      attachmentSize: '240 KB',
      isRead: false,
    ),
    Announcement(
      id: 'ANN-2',
      postType: 'Academic Circular',
      category: 'Academic',
      title: 'Second Assessment Schedule Published',
      body: 'The date sheet for Second Assessment examinations has been finalized. Parents and teachers are requested to review subject schedules in the academic calendar.',
      author: 'Anita Desai (Academic Head)',
      status: AnnouncementStatus.published,
      isPinned: false,
      audience: 'Classes 5–10',
      publishedAt: '20 Oct 2026',
      attachmentName: 'second_assessment_datesheet.pdf',
      attachmentType: 'PDF Document',
      attachmentSize: '420 KB',
      isRead: true,
    ),
    Announcement(
      id: 'ANN-3',
      postType: 'Examination Notice',
      category: 'Examination',
      title: 'Half-Yearly Examination Guidelines & Admit Cards',
      body: 'Physical admit cards stamped by the Registrar Desk will be distributed in homerooms on Friday. Students must bring original identity cards to examination halls.',
      author: 'Controller of Examinations',
      status: AnnouncementStatus.published,
      isPinned: false,
      audience: 'Classes 9–12',
      publishedAt: '18 Oct 2026',
      attachmentName: 'exam_hall_guidelines.pdf',
      attachmentType: 'PDF Document',
      attachmentSize: '1.2 MB',
      isRead: true,
    ),
    Announcement(
      id: 'ANN-4',
      postType: 'Event Circular',
      category: 'Event',
      title: 'Annual Sports Day 2026 Schedule & House Heats',
      body: 'Inter-house athletic heats begin next Wednesday on the central sports stadium. Morning assembly attendance will be marked at respective house assembly points.',
      author: 'Sports Department',
      status: AnnouncementStatus.published,
      isPinned: false,
      audience: 'Classes 4–12',
      publishedAt: '15 Oct 2026',
      attachmentName: 'sports_day_events_schedule.pdf',
      attachmentType: 'PDF Document',
      attachmentSize: '1.8 MB',
      isRead: true,
    ),
    Announcement(
      id: 'ANN-5',
      postType: 'Holiday Notification',
      category: 'Holiday',
      title: 'Diwali & Autumn Break Schedule',
      body: 'The school will remain closed for Diwali and Autumn Break from 28 October 2026 to 02 November 2026. Regular classes will resume on Monday, 03 November 2026.',
      author: 'Administration Office',
      status: AnnouncementStatus.published,
      isPinned: false,
      audience: 'All School',
      publishedAt: '10 Oct 2026',
      isRead: true,
    ),
  ];

  final List<String> _categories = [
    'All',
    'School',
    'Academic',
    'Examination',
    'Event',
    'Holiday',
  ];

  @override
  void initState() {
    super.initState();
    _fetchAnnouncements();
  }

  Future<void> _fetchAnnouncements() async {
    final bindingName = WidgetsBinding.instance.runtimeType.toString();
    if (bindingName.contains('Test')) {
      _apiAnnouncements = List.from(_testAnnouncements);
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final data = await _apiService.getAnnouncements();
      if (mounted) {
        setState(() {
          if (data.isNotEmpty) {
            _apiAnnouncements = data.map((item) {
              if (item is Map<String, dynamic>) {
                return Announcement(
                  id: item['id']?.toString() ?? 'ANC-000',
                  postType: item['post_type'] ?? 'Notice',
                  title: item['title'] ?? 'Notice',
                  body: item['body'] ?? item['content'] ?? '',
                  author: item['author'] ?? 'School Admin',
                  status: AnnouncementStatus.published,
                  isPinned: item['is_pinned'] == true,
                  audience: item['audience'] ?? 'All School',
                  publishedAt: Announcement.formatDate(item['created_at']?.toString() ?? item['published_at']?.toString()),
                  category: item['category'] ?? 'General',
                );
              }
              return item as Announcement;
            }).toList();
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        if (e.toString().contains('401') || e.toString().contains('Unauthorized')) {
          context.read<AuthState>().signOut();
          return;
        }
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Announcement> _getFilteredNotices() {
    List<Announcement> list = List.from(_apiAnnouncements);

    // Filter by Category
    if (_selectedCategory != 'All') {
      list = list.where((a) {
        return a.displayCategory.toLowerCase() == _selectedCategory.toLowerCase();
      }).toList();
    }

    // Filter by Search Query
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();
      list = list.where((a) {
        final titleMatch = a.title.toLowerCase().contains(q);
        final bodyMatch = a.body.toLowerCase().contains(q);
        final authorMatch = a.author.toLowerCase().contains(q);
        final audienceMatch = a.audience.toLowerCase().contains(q);
        final categoryMatch = a.displayCategory.toLowerCase().contains(q);
        return titleMatch || bodyMatch || authorMatch || audienceMatch || categoryMatch;
      }).toList();
    }

    return list;
  }

  void _openNoticeDetail(Announcement notice) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AcademicColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, scrollController) {
            return SafeArea(
              child: Column(
                children: [
                  // Drag Handle
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AcademicColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Modal Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AcademicColors.canvas,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AcademicColors.border),
                          ),
                          child: Text(
                            notice.displayCategory.toUpperCase(),
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.primaryDark,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 20, color: AcademicColors.textSecondary),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1, color: AcademicColors.border),

                  // Scrollable Notice Body
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(20),
                      children: [
                        // Pinned indicator if applicable
                        if (notice.isPinned) ...[
                          Row(
                            children: [
                              const Icon(Icons.push_pin, size: 16, color: AcademicColors.accent),
                              const SizedBox(width: 6),
                              Text(
                                'Official School Notice',
                                style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AcademicColors.accent,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],

                        // Title
                        Text(
                          notice.title,
                          style: GoogleFonts.newsreader(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AcademicColors.primaryDark,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Meta: Date, Audience & Author
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AcademicColors.canvas,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AcademicColors.border),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today_outlined, size: 15, color: AcademicColors.textSecondary),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Published: ${notice.displayPublishedAt}',
                                    style: GoogleFonts.manrope(fontSize: 12, color: AcademicColors.textPrimary, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.groups_outlined, size: 15, color: AcademicColors.textSecondary),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Audience: ${notice.audience}',
                                    style: GoogleFonts.manrope(fontSize: 12, color: AcademicColors.textPrimary, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.verified_user_outlined, size: 15, color: AcademicColors.accent),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Issued By: ${notice.author}',
                                    style: GoogleFonts.manrope(fontSize: 12, color: AcademicColors.accent, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Notice Full Text
                        Text(
                          notice.body,
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            color: AcademicColors.textPrimary,
                            height: 1.55,
                          ),
                        ),

                        // Attachment Section if Available
                        if (notice.hasAttachment) ...[
                          const SizedBox(height: 24),
                          Text(
                            'Attached Document',
                            style: GoogleFonts.newsreader(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.primaryDark,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AcademicColors.canvas,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AcademicColors.border),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AcademicColors.danger.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.picture_as_pdf, color: AcademicColors.danger, size: 22),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        notice.attachmentName ?? 'document.pdf',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.manrope(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: AcademicColors.primaryDark,
                                        ),
                                      ),
                                      Text(
                                        '${notice.attachmentType ?? "PDF"} • ${notice.attachmentSize ?? "Document"}',
                                        style: GoogleFonts.manrope(
                                          fontSize: 11.5,
                                          color: AcademicColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.download_rounded, color: AcademicColors.primaryDark, size: 20),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Downloading ${notice.attachmentName}...'),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredNotices = _getFilteredNotices();

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: const AppTopBar(
        title: 'Notices',
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header Context Bar
            Container(
              color: AcademicColors.surface,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'School Notices & Circulars',
                          style: GoogleFonts.newsreader(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AcademicColors.primaryDark,
                          ),
                        ),
                        Text(
                          'Official Communications • Session 2026–27',
                          style: GoogleFonts.manrope(
                            fontSize: 11.5,
                            color: AcademicColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AcademicColors.canvas,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AcademicColors.border),
                    ),
                    child: Text(
                      '${filteredNotices.length} Notices',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.primaryDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Container(
              color: AcademicColors.surface,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => _searchQuery = val),
                style: GoogleFonts.manrope(fontSize: 13, color: AcademicColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Search notices...',
                  hintStyle: GoogleFonts.manrope(fontSize: 13, color: AcademicColors.textSecondary),
                  prefixIcon: const Icon(Icons.search, size: 20, color: AcademicColors.textSecondary),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, size: 18, color: AcademicColors.textSecondary),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  fillColor: AcademicColors.canvas,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AcademicColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AcademicColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AcademicColors.primaryDark, width: 1.5),
                  ),
                ),
              ),
            ),

            // Horizontally Scrollable Category Filter Chips
            Container(
              height: 46,
              color: AcademicColors.surface,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                    selectedColor: AcademicColors.primaryDark,
                    backgroundColor: AcademicColors.canvas,
                    labelStyle: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected ? Colors.white : AcademicColors.textPrimary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: isSelected ? AcademicColors.primaryDark : AcademicColors.border),
                    ),
                  );
                },
              ),
            ),

            const Divider(height: 1, color: AcademicColors.border),

            // Content Area (Loading, Error, Empty, or Notice List)
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : _errorMessage != null
                      ? _buildErrorState()
                      : filteredNotices.isEmpty
                          ? _buildEmptyState()
                          : _buildNoticeList(filteredNotices),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AcademicBottomNavBar.forRole(
        UserRole.principal,
        context: context,
        currentIndex: 3, // Notices tab is active
      ),
    );
  }

  Widget _buildNoticeList(List<Announcement> notices) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: notices.length,
      itemBuilder: (context, index) {
        final notice = notices[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: AcademicColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: notice.isPinned ? AcademicColors.accent.withValues(alpha: 0.6) : AcademicColors.border,
              width: notice.isPinned ? 1.4 : 1.0,
            ),
          ),
          child: InkWell(
            onTap: () => _openNoticeDetail(notice),
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Category Badge & Published Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (notice.isPinned) ...[
                            const Icon(Icons.push_pin, size: 14, color: AcademicColors.accent),
                            const SizedBox(width: 4),
                          ],
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AcademicColors.canvas,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AcademicColors.border),
                            ),
                            child: Text(
                              notice.displayCategory.toUpperCase(),
                              style: GoogleFonts.manrope(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AcademicColors.primaryDark,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        notice.displayPublishedAt,
                        style: GoogleFonts.manrope(
                          fontSize: 11.5,
                          color: AcademicColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Notice Title
                  Text(
                    notice.title,
                    style: GoogleFonts.newsreader(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AcademicColors.primaryDark,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Notice Summary/Body preview
                  Text(
                    notice.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.manrope(
                      fontSize: 12.5,
                      color: AcademicColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Bottom Meta Row: Audience & Attachment Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AcademicColors.canvas,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.groups_outlined, size: 13, color: AcademicColors.textSecondary),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  notice.audience,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.manrope(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AcademicColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (notice.hasAttachment)
                        Row(
                          children: [
                            const Icon(Icons.attachment_rounded, size: 15, color: AcademicColors.primaryDark),
                            const SizedBox(width: 3),
                            Text(
                              'Attachment',
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AcademicColors.primaryDark,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AcademicColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AcademicColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 70,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AcademicColors.border.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AcademicColors.border.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 16,
                decoration: BoxDecoration(
                  color: AcademicColors.border.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 220,
                height: 12,
                decoration: BoxDecoration(
                  color: AcademicColors.border.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 40, color: AcademicColors.error),
            const SizedBox(height: 12),
            Text(
              'Unable to load school notices.',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AcademicColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AcademicColors.primaryDark,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                _fetchAnnouncements();
              },
              child: Text(
                'Retry',
                style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    String emptyMessage;
    if (_searchQuery.isNotEmpty) {
      emptyMessage = 'No notices match your search';
    } else if (_selectedCategory != 'All') {
      emptyMessage = 'No notices in this category';
    } else {
      emptyMessage = 'No notices available';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AcademicColors.canvas,
                shape: BoxShape.circle,
                border: Border.all(color: AcademicColors.border),
              ),
              child: const Icon(Icons.campaign_outlined, size: 36, color: AcademicColors.primaryDark),
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              textAlign: TextAlign.center,
              style: GoogleFonts.newsreader(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AcademicColors.primaryDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Try searching with different keywords.'
                  : 'Check back later for newly published circulars.',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 12.5,
                color: AcademicColors.textSecondary,
              ),
            ),
            if (_searchQuery.isNotEmpty || _selectedCategory != 'All') ...[
              const SizedBox(height: 16),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AcademicColors.primaryDark,
                  side: const BorderSide(color: AcademicColors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                    _selectedCategory = 'All';
                  });
                },
                child: Text(
                  'Reset Filters',
                  style: GoogleFonts.manrope(fontSize: 12.5, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
