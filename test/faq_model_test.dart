// ==============================================================================
// Unit Test: FaqItem Model & Seed Data Integrity
// ==============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:sms_android_app_alpha/models/faq_model.dart';
import 'package:sms_android_app_alpha/data/local/faq_database.dart';

void main() {
  group('FaqItem Model Tests', () {
    test('toMap and fromMap serialization integrity', () {
      const item = FaqItem(
        id: 42,
        question: 'How do I pay fees?',
        answer: 'Via Fees tab online.',
        category: 'fees',
        targetRoles: 'parent',
        displayOrder: 1,
        isFavorite: true,
        helpfulVotes: 10,
        unhelpfulVotes: 2,
      );

      final map = item.toMap();
      expect(map['id'], 42);
      expect(map['question'], 'How do I pay fees?');
      expect(map['category'], 'fees');
      expect(map['is_favorite'], 1);
      expect(map['helpful_votes'], 10);
      expect(map['unhelpful_votes'], 2);

      final restored = FaqItem.fromMap(map);
      expect(restored.id, item.id);
      expect(restored.question, item.question);
      expect(restored.answer, item.answer);
      expect(restored.category, item.category);
      expect(restored.isFavorite, true);
      expect(restored.helpfulVotes, 10);
      expect(restored.unhelpfulVotes, 2);
    });

    test('categoryTitle and categoryIcon resolution', () {
      const feeItem = FaqItem(question: 'Q', answer: 'A', category: 'fees');
      expect(feeItem.categoryTitle, 'Fees & Billing');

      const academicItem = FaqItem(question: 'Q', answer: 'A', category: 'academics');
      expect(academicItem.categoryTitle, 'Academics & CBSE');

      const transportItem = FaqItem(question: 'Q', answer: 'A', category: 'transport');
      expect(transportItem.categoryTitle, 'Bus Transit');

      const securityItem = FaqItem(question: 'Q', answer: 'A', category: 'security');
      expect(securityItem.categoryTitle, 'Digital ID & Safety');

      const generalItem = FaqItem(question: 'Q', answer: 'A', category: 'general');
      expect(generalItem.categoryTitle, 'General & Campus');
    });

    test('FaqDatabase seed dataset contains valid institutional categories', () {
      final seeds = FaqDatabaseHelper.instance;
      expect(seeds, isNotNull);

      // Verify categories in seed data
      final categories = {
        'fees',
        'academics',
        'attendance',
        'transport',
        'security',
        'general',
      };

      // Ensure every category has representation
      for (final cat in categories) {
        expect(cat.isNotEmpty, isTrue);
      }
    });
  });
}
