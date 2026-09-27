import 'package:flutter_test/flutter_test.dart';
import 'package:sms_android_app_alpha/core/utils/class_section_formatter.dart';

void main() {
  group('ClassSectionFormatter', () {
    test('formats standard grade and section correctly', () {
      expect(ClassSectionFormatter.formatCompact('Grade 2 F'), '2 - F');
      expect(ClassSectionFormatter.formatFull('Grade 2 F'), 'Class 2 - F');
      expect(ClassSectionFormatter.formatCompact('Class 2 F'), '2 - F');
      expect(ClassSectionFormatter.formatFull('Class 2 F'), 'Class 2 - F');
      expect(ClassSectionFormatter.formatCompact('Grade 10 E'), '10 - E');
      expect(ClassSectionFormatter.formatFull('Grade 10 E'), 'Class 10 - E');
    });

    test('formats nursery, lkg, ukg correctly', () {
      expect(ClassSectionFormatter.formatCompact('Nursery A'), 'N - A');
      expect(ClassSectionFormatter.formatFull('Nursery A'), 'Class N - A');
      expect(ClassSectionFormatter.formatCompact('Class Nursery B'), 'N - B');
      expect(ClassSectionFormatter.formatFull('Class Nursery B'), 'Class N - B');
      expect(ClassSectionFormatter.formatCompact('LKG C'), 'L - C');
      expect(ClassSectionFormatter.formatFull('LKG C'), 'Class L - C');
      expect(ClassSectionFormatter.formatCompact('UKG D'), 'U - D');
      expect(ClassSectionFormatter.formatFull('UKG D'), 'Class U - D');
    });

    test('extracts section cleanly', () {
      expect(ClassSectionFormatter.extractSection('Grade 2 F'), 'F');
      expect(ClassSectionFormatter.extractSection('Nursery B'), 'B');
      expect(ClassSectionFormatter.extractSection('10 E'), 'E');
      expect(ClassSectionFormatter.extractSection('Class 5-A'), 'A');
    });
  });
}
