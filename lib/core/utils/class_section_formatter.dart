// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Class & Section Academic Formatter Utility
// Converts various raw representations into compact ("2 - F", "N - A")
// and standardized full representations ("Class 2 - F", "Class N - A").
// ==============================================================================

class ClassSectionFormatter {
  static final RegExp _pattern = RegExp(
    r'(?:Class|Grade)?\s*(Nursery|LKG|UKG|N|L|U|\d+)\s*(?:[-–•·/]?\s*(?:Section\s*)?([A-Z]))?',
    caseSensitive: false,
  );

  /// Compact representation for thumbnails & badges, e.g. "2 - F", "N - A", "U - C", "10 - E".
  static String formatCompact(String? raw) {
    if (raw == null || raw.trim().isEmpty) return '';
    final match = _pattern.firstMatch(raw.trim());
    if (match == null) return raw.trim();
    final grade = match.group(1) ?? '';
    final section = match.group(2) ?? '';
    final compactGrade = _compactGradePrefix(grade);
    if (section.isNotEmpty) {
      return '$compactGrade - ${section.toUpperCase()}';
    }
    return compactGrade;
  }

  /// Full standardized representation, e.g. "Class 2 - F", "Class N - A".
  static String formatFull(String? raw) {
    final compact = formatCompact(raw);
    if (compact.isEmpty) return 'Class';
    if (compact.toLowerCase().startsWith('class ')) return compact;
    return 'Class $compact';
  }

  /// Extracts section letter if present, e.g. "F", "A", "C".
  static String? extractSection(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final match = _pattern.firstMatch(raw.trim());
    return match?.group(2)?.toUpperCase();
  }

  static String _compactGradePrefix(String grade) {
    final upper = grade.toUpperCase().trim();
    if (upper == 'NURSERY' || upper == 'N') return 'N';
    if (upper == 'LKG' || upper == 'L') return 'L';
    if (upper == 'UKG' || upper == 'U') return 'U';
    return upper;
  }
}
