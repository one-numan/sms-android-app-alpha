// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Institutional FAQ & Knowledge Base Screen
// Design System: Espresso Heritage Academic
// Storage: Offline-First SQLite Engine (sqflite)
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../data/mock/auth_state.dart';
import '../../data/repositories/faq/faq_repository.dart';
import '../../models/faq_model.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/account_profile_sheet.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/shared_widgets.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final FaqRepository _repository = FaqRepository();
  final TextEditingController _searchController = TextEditingController();

  List<FaqItem> _faqs = [];
  bool _isLoading = true;
  String _selectedCategory = 'all';
  bool _favoritesOnly = false;
  bool _filterByRole = true;
  UserRole? _lastRole;
  final Set<int> _expandedIds = {};
  final Map<int, bool> _votedMap = {};

  final List<_CategoryFilter> _categories = const [
    _CategoryFilter(id: 'all', label: 'All Topics', icon: Icons.grid_view_rounded),
    _CategoryFilter(id: 'favorites', label: 'Starred', icon: Icons.star_rounded),
    _CategoryFilter(id: 'fees', label: 'Fees & Dues', icon: Icons.account_balance_wallet_outlined),
    _CategoryFilter(id: 'academics', label: 'Academics & CBSE', icon: Icons.menu_book_outlined),
    _CategoryFilter(id: 'attendance', label: 'Attendance', icon: Icons.event_available_outlined),
    _CategoryFilter(id: 'transport', label: 'Bus Transit', icon: Icons.directions_bus_outlined),
    _CategoryFilter(id: 'security', label: 'Digital ID & Safety', icon: Icons.badge_outlined),
    _CategoryFilter(id: 'library', label: 'Library', icon: Icons.local_library_outlined),
    _CategoryFilter(id: 'admin', label: 'Leadership', icon: Icons.admin_panel_settings_outlined),
    _CategoryFilter(id: 'general', label: 'Campus Info', icon: Icons.info_outline),
  ];

  @override
  void initState() {
    super.initState();
    _loadFaqs();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final auth = Provider.of<AuthState>(context, listen: true);
    if (_lastRole != auth.currentRole) {
      _lastRole = auth.currentRole;
      _loadFaqs();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  static String _roleKey(UserRole role) {
    switch (role) {
      case UserRole.parent:
        return 'parent';
      case UserRole.student:
        return 'student';
      case UserRole.classTeacher:
      case UserRole.subjectTeacher:
        return 'teacher';
      case UserRole.accountant:
        return 'accountant';
      case UserRole.librarian:
        return 'librarian';
      case UserRole.principal:
      case UserRole.vicePrincipal:
      case UserRole.superAdmin:
        return 'principal';
      case UserRole.receptionist:
        return 'receptionist';
    }
  }

  static IconData _roleIcon(UserRole role) {
    switch (role) {
      case UserRole.parent:
        return Icons.family_restroom;
      case UserRole.student:
        return Icons.school_outlined;
      case UserRole.classTeacher:
      case UserRole.subjectTeacher:
        return Icons.psychology_outlined;
      case UserRole.accountant:
        return Icons.account_balance_wallet_outlined;
      case UserRole.librarian:
        return Icons.local_library_outlined;
      case UserRole.principal:
      case UserRole.vicePrincipal:
      case UserRole.superAdmin:
        return Icons.admin_panel_settings_outlined;
      case UserRole.receptionist:
        return Icons.badge_outlined;
    }
  }

  Future<void> _loadFaqs() async {
    setState(() => _isLoading = true);

    try {
      final auth = context.read<AuthState>();
      final roleTag = _filterByRole ? _roleKey(auth.currentRole) : null;

      final faqs = await _repository.fetchFaqs(
        category: _selectedCategory == 'favorites' ? null : _selectedCategory,
        searchQuery: _searchController.text,
        role: roleTag,
        favoritesOnly: _favoritesOnly || _selectedCategory == 'favorites',
      );

      // Check voting status for items
      for (final item in faqs) {
        if (item.id != null) {
          final hasVoted = await _repository.hasVoted(item.id!);
          _votedMap[item.id!] = hasVoted;
        }
      }

      if (mounted) {
        setState(() {
          _faqs = faqs;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onCategorySelected(String categoryId) {
    setState(() {
      _selectedCategory = categoryId;
      _favoritesOnly = (categoryId == 'favorites');
    });
    _loadFaqs();
  }

  Future<void> _toggleFavorite(FaqItem item) async {
    if (item.id == null) return;
    final newFav = !item.isFavorite;

    await _repository.toggleFavorite(item.id!, newFav);

    // Update local state immediately for responsive feel
    setState(() {
      final index = _faqs.indexWhere((f) => f.id == item.id);
      if (index != -1) {
        _faqs[index] = item.copyWith(isFavorite: newFav);
      }
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          content: Text(
            newFav ? 'Added to Starred FAQs' : 'Removed from Starred FAQs',
            style: GoogleFonts.manrope(fontSize: 12),
          ),
          backgroundColor: AcademicColors.primaryDark,
        ),
      );
    }
  }

  Future<void> _vote(FaqItem item, bool helpful) async {
    if (item.id == null) return;

    final registered = await _repository.voteHelpful(item.id!, helpful);

    if (registered) {
      setState(() {
        _votedMap[item.id!] = true;
        final index = _faqs.indexWhere((f) => f.id == item.id);
        if (index != -1) {
          _faqs[index] = item.copyWith(
            helpfulVotes: helpful ? item.helpfulVotes + 1 : item.helpfulVotes,
            unhelpfulVotes: !helpful ? item.unhelpfulVotes + 1 : item.unhelpfulVotes,
          );
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 1),
            content: Text(
              'Thank you for your feedback!',
              style: GoogleFonts.manrope(fontSize: 12),
            ),
            backgroundColor: AcademicColors.success,
          ),
        );
      }
    }
  }

  void _toggleExpand(int id) {
    setState(() {
      if (_expandedIds.contains(id)) {
        _expandedIds.remove(id);
      } else {
        _expandedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: const AppTopBar(
        title: 'Help & FAQs',
        showBackButton: true,
      ),
      body: Column(
        children: [
          // 1. Search Bar & Header
          _buildSearchHeader(),

          // 2. Role Identity & Personalization Banner
          _buildRolePersonalizedBanner(auth),

          // 3. Horizontal Category Filter Chips
          _buildCategoryChips(),

          const Divider(height: 1, color: AcademicColors.border),

          // 4. Main Content List
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AcademicColors.primaryDark),
                    ),
                  )
                : _faqs.isEmpty
                    ? _buildEmptyState()
                    : _buildFaqList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRolePersonalizedBanner(AuthState auth) {
    final profile = AccountProfileSheet.getProfileForRole(auth.currentRole);
    final icon = _roleIcon(auth.currentRole);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AcademicColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AcademicColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AcademicColors.primaryDark,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(icon, size: 17, color: AcademicColors.accent),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        profile.fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.newsreader(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AcademicColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: AcademicColors.primaryDark.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        profile.roleTitle,
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AcademicColors.primaryDark,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  _filterByRole
                      ? 'Displaying questions tailored for ${profile.roleTitle}'
                      : 'Displaying all school-wide knowledge topics',
                  style: GoogleFonts.manrope(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: AcademicColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: () {
              setState(() => _filterByRole = !_filterByRole);
              _loadFaqs();
            },
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _filterByRole ? AcademicColors.primaryDark : AcademicColors.canvas,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _filterByRole ? AcademicColors.primaryDark : AcademicColors.border,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _filterByRole ? Icons.check_circle : Icons.radio_button_unchecked,
                    size: 12,
                    color: _filterByRole ? AcademicColors.accent : AcademicColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _filterByRole ? 'For Me' : 'All FAQs',
                    style: GoogleFonts.manrope(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: _filterByRole ? Colors.white : AcademicColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      color: AcademicColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: AcademicColors.canvas,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AcademicColors.border),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (_) => _loadFaqs(),
          style: GoogleFonts.manrope(
            fontSize: 13.5,
            color: AcademicColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'Search queries (e.g. fees, bus, marks)...',
            hintStyle: GoogleFonts.manrope(
              fontSize: 12.5,
              color: AcademicColors.textSecondary.withValues(alpha: 0.8),
            ),
            prefixIcon: const Icon(
              Icons.search,
              size: 20,
              color: AcademicColors.textSecondary,
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18, color: AcademicColors.textSecondary),
                    onPressed: () {
                      _searchController.clear();
                      _loadFaqs();
                    },
                  )
                : null,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Container(
      color: AcademicColors.surface,
      height: 46,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = _selectedCategory == cat.id;

          return InkWell(
            onTap: () => _onCategorySelected(cat.id),
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? AcademicColors.primaryDark : AcademicColors.canvas,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AcademicColors.primaryDark : AcademicColors.border,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    cat.icon,
                    size: 14,
                    color: isSelected ? AcademicColors.accent : AcademicColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    cat.label,
                    style: GoogleFonts.manrope(
                      fontSize: 11.5,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? Colors.white : AcademicColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFaqList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      itemCount: _faqs.length + 1, // +1 for Contact Assistance Footer
      itemBuilder: (context, index) {
        if (index == _faqs.length) {
          return _buildAssistanceFooter();
        }

        final faq = _faqs[index];
        final isExpanded = faq.id != null && _expandedIds.contains(faq.id);
        final hasVoted = faq.id != null && (_votedMap[faq.id!] == true);

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: InsetCard(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: InkWell(
              onTap: faq.id != null ? () => _toggleExpand(faq.id!) : null,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row: Category Badge + Star Favorite
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AcademicColors.canvas,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AcademicColors.border),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                faq.categoryIcon,
                                size: 12,
                                color: AcademicColors.primaryDark,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                faq.categoryTitle,
                                style: GoogleFonts.manrope(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AcademicColors.primaryDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(
                            faq.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                            size: 20,
                            color: faq.isFavorite ? const Color(0xFFD4AF37) : AcademicColors.textSecondary,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => _toggleFavorite(faq),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          size: 20,
                          color: AcademicColors.textSecondary,
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Question Title
                    Text(
                      faq.question,
                      style: GoogleFonts.newsreader(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: AcademicColors.textPrimary,
                        height: 1.25,
                      ),
                    ),

                    // Expanded Answer & Feedback
                    if (isExpanded) ...[
                      const SizedBox(height: 12),
                      const Divider(height: 1, color: AcademicColors.border),
                      const SizedBox(height: 12),
                      Text(
                        faq.answer,
                        style: GoogleFonts.manrope(
                          fontSize: 12.5,
                          height: 1.55,
                          color: AcademicColors.textPrimary.withValues(alpha: 0.88),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Helpful Voting Bar
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AcademicColors.canvas,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Text(
                              hasVoted ? 'Feedback recorded' : 'Was this helpful?',
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AcademicColors.textSecondary,
                              ),
                            ),
                            const Spacer(),
                            if (!hasVoted) ...[
                              InkWell(
                                onTap: () => _vote(faq, true),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.thumb_up_alt_outlined, size: 13, color: AcademicColors.success),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Yes (${faq.helpfulVotes})',
                                        style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w600, color: AcademicColors.success),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              InkWell(
                                onTap: () => _vote(faq, false),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.thumb_down_alt_outlined, size: 13, color: AcademicColors.danger),
                                      const SizedBox(width: 4),
                                      Text(
                                        'No (${faq.unhelpfulVotes})',
                                        style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w600, color: AcademicColors.danger),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ] else ...[
                              const Icon(Icons.check_circle, size: 13, color: AcademicColors.success),
                              const SizedBox(width: 4),
                              Text(
                                '${faq.helpfulVotes} found helpful',
                                style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w600, color: AcademicColors.success),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: AcademicColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AcademicColors.border),
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 26,
                color: AcademicColors.textSecondary,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'No FAQs Found',
              style: GoogleFonts.newsreader(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AcademicColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'No questions match "${_searchController.text}" in this topic.',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: AcademicColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                _searchController.clear();
                _onCategorySelected('all');
              },
              icon: const Icon(Icons.refresh, size: 15),
              label: const Text('Show All Topics'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AcademicColors.primaryDark,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssistanceFooter() {
    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AcademicColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AcademicColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.support_agent_rounded, size: 20, color: AcademicColors.primaryDark),
              const SizedBox(width: 8),
              Text(
                'Still need assistance?',
                style: GoogleFonts.newsreader(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AcademicColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Our administrative helpdesk is available Monday to Friday, 8:00 AM – 3:30 PM.',
            style: GoogleFonts.manrope(
              fontSize: 11.5,
              color: AcademicColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.phone_outlined, size: 14),
                label: const Text('+91 (522) 248-1200'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AcademicColors.primaryDark,
                  side: const BorderSide(color: AcademicColors.border),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.mail_outline, size: 14),
                label: const Text('helpdesk@onps.edu.in'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AcademicColors.primaryDark,
                  side: const BorderSide(color: AcademicColors.border),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryFilter {
  final String id;
  final String label;
  final IconData icon;

  const _CategoryFilter({
    required this.id,
    required this.label,
    required this.icon,
  });
}
