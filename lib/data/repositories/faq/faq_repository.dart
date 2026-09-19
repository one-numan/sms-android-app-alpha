// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// FAQ Repository — Clean Data Access Layer with Vote Deduplication
// Design System: Espresso Heritage Academic
// ==============================================================================

import 'package:shared_preferences/shared_preferences.dart';
import '../../local/faq_database.dart';
import '../../../models/faq_model.dart';

class FaqRepository {
  final FaqDatabaseHelper _dbHelper;

  FaqRepository({FaqDatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? FaqDatabaseHelper.instance;

  Future<List<FaqItem>> fetchFaqs({
    String? category,
    String? searchQuery,
    String? role,
    bool? favoritesOnly,
  }) async {
    return await _dbHelper.getFaqs(
      category: category,
      searchQuery: searchQuery,
      role: role,
      favoritesOnly: favoritesOnly,
    );
  }

  Future<void> toggleFavorite(int id, bool isFavorite) async {
    await _dbHelper.toggleFavorite(id, isFavorite);
  }

  // Returns true if vote was registered, false if already voted
  Future<bool> voteHelpful(int id, bool helpful) async {
    final prefs = await SharedPreferences.getInstance();
    final votedKey = 'faq_voted_$id';

    if (prefs.getBool(votedKey) == true) {
      return false; // Already voted on this device
    }

    await _dbHelper.voteHelpful(id, helpful);
    await prefs.setBool(votedKey, true);
    return true;
  }

  Future<bool> hasVoted(int id) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('faq_voted_$id') ?? false;
  }

  Future<List<String>> fetchCategories() async {
    return await _dbHelper.getCategories();
  }
}
