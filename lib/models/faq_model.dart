// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// FAQ Model — SQLite Backed Institutional Knowledge Base
// Design System: Espresso Heritage Academic
// ==============================================================================

import 'package:flutter/material.dart';

class FaqItem {
  final int? id;
  final String question;
  final String answer;
  final String category;
  final String targetRoles;
  final int displayOrder;
  final bool isFavorite;
  final int helpfulVotes;
  final int unhelpfulVotes;

  const FaqItem({
    this.id,
    required this.question,
    required this.answer,
    required this.category,
    this.targetRoles = 'all',
    this.displayOrder = 0,
    this.isFavorite = false,
    this.helpfulVotes = 0,
    this.unhelpfulVotes = 0,
  });

  String get categoryTitle {
    switch (category.toLowerCase()) {
      case 'fees':
        return 'Fees & Billing';
      case 'academics':
        return 'Academics & CBSE';
      case 'attendance':
        return 'Attendance & Leave';
      case 'transport':
        return 'Bus Transit';
      case 'security':
        return 'Digital ID & Safety';
      case 'library':
        return 'Library & Media';
      case 'admin':
        return 'Admin & Leadership';
      case 'general':
      default:
        return 'General & Campus';
    }
  }

  IconData get categoryIcon {
    switch (category.toLowerCase()) {
      case 'fees':
        return Icons.account_balance_wallet_outlined;
      case 'academics':
        return Icons.menu_book_outlined;
      case 'attendance':
        return Icons.event_available_outlined;
      case 'transport':
        return Icons.directions_bus_outlined;
      case 'security':
        return Icons.badge_outlined;
      case 'library':
        return Icons.local_library_outlined;
      case 'admin':
        return Icons.admin_panel_settings_outlined;
      case 'general':
      default:
        return Icons.info_outline;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'question': question,
      'answer': answer,
      'category': category,
      'target_roles': targetRoles,
      'display_order': displayOrder,
      'is_favorite': isFavorite ? 1 : 0,
      'helpful_votes': helpfulVotes,
      'unhelpful_votes': unhelpfulVotes,
    };
  }

  factory FaqItem.fromMap(Map<String, dynamic> map) {
    return FaqItem(
      id: map['id'] as int?,
      question: map['question'] as String? ?? '',
      answer: map['answer'] as String? ?? '',
      category: map['category'] as String? ?? 'general',
      targetRoles: map['target_roles'] as String? ?? 'all',
      displayOrder: map['display_order'] as int? ?? 0,
      isFavorite: (map['is_favorite'] as int? ?? 0) == 1,
      helpfulVotes: map['helpful_votes'] as int? ?? 0,
      unhelpfulVotes: map['unhelpful_votes'] as int? ?? 0,
    );
  }

  FaqItem copyWith({
    int? id,
    String? question,
    String? answer,
    String? category,
    String? targetRoles,
    int? displayOrder,
    bool? isFavorite,
    int? helpfulVotes,
    int? unhelpfulVotes,
  }) {
    return FaqItem(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      category: category ?? this.category,
      targetRoles: targetRoles ?? this.targetRoles,
      displayOrder: displayOrder ?? this.displayOrder,
      isFavorite: isFavorite ?? this.isFavorite,
      helpfulVotes: helpfulVotes ?? this.helpfulVotes,
      unhelpfulVotes: unhelpfulVotes ?? this.unhelpfulVotes,
    );
  }
}
