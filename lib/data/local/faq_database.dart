// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Local SQLite Database Helper for FAQs
// Design System: Espresso Heritage Academic
// ==============================================================================

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import '../../models/faq_model.dart';

class FaqDatabaseHelper {
  static const String _databaseName = 'onps_faqs.db';
  static const int _databaseVersion = 2;
  static const String tableName = 'faqs';

  // Singleton instance
  FaqDatabaseHelper._privateConstructor();
  static final FaqDatabaseHelper instance =
      FaqDatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question TEXT NOT NULL,
        answer TEXT NOT NULL,
        category TEXT NOT NULL,
        target_roles TEXT NOT NULL DEFAULT 'all',
        display_order INTEGER NOT NULL DEFAULT 0,
        is_favorite INTEGER NOT NULL DEFAULT 0,
        helpful_votes INTEGER NOT NULL DEFAULT 0,
        unhelpful_votes INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('CREATE INDEX idx_faqs_category ON $tableName (category)');
    await db.execute(
        'CREATE INDEX idx_faqs_target_roles ON $tableName (target_roles)');
    await db.execute(
        'CREATE INDEX idx_faqs_favorite ON $tableName (is_favorite)');

    // Seed default institutional knowledge base
    for (final faq in _seedFaqs) {
      await db.insert(tableName, faq.toMap());
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      for (final faq in _seedFaqs) {
        final existing = await db.query(
          tableName,
          where: 'question = ?',
          whereArgs: [faq.question],
        );
        if (existing.isEmpty) {
          await db.insert(tableName, faq.toMap());
        } else {
          await db.update(
            tableName,
            {
              'category': faq.category,
              'target_roles': faq.targetRoles,
              'display_order': faq.displayOrder,
              'answer': faq.answer,
            },
            where: 'question = ?',
            whereArgs: [faq.question],
          );
        }
      }
    }
  }

  // Query FAQs with optional filters
  Future<List<FaqItem>> getFaqs({
    String? category,
    String? searchQuery,
    String? role,
    bool? favoritesOnly,
  }) async {
    final db = await database;
    final whereClauses = <String>[];
    final whereArgs = <dynamic>[];

    if (category != null && category.isNotEmpty && category.toLowerCase() != 'all') {
      whereClauses.add('category = ?');
      whereArgs.add(category.toLowerCase());
    }

    if (favoritesOnly == true) {
      whereClauses.add('is_favorite = 1');
    }

    if (role != null && role.isNotEmpty && role.toLowerCase() != 'all') {
      final r = role.toLowerCase();
      whereClauses.add("(target_roles = 'all' OR LOWER(target_roles) LIKE ?)");
      whereArgs.add('%$r%');
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = '%${searchQuery.trim().toLowerCase()}%';
      whereClauses.add('(LOWER(question) LIKE ? OR LOWER(answer) LIKE ?)');
      whereArgs.add(q);
      whereArgs.add(q);
    }

    final whereString =
        whereClauses.isNotEmpty ? whereClauses.join(' AND ') : null;

    final results = await db.query(
      tableName,
      where: whereString,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      orderBy: 'is_favorite DESC, display_order ASC, id ASC',
    );

    return results.map((map) => FaqItem.fromMap(map)).toList();
  }

  // Toggle favorite
  Future<int> toggleFavorite(int id, bool isFavorite) async {
    final db = await database;
    return await db.update(
      tableName,
      {'is_favorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Vote helpful / unhelpful
  Future<int> voteHelpful(int id, bool helpful) async {
    final db = await database;
    final field = helpful ? 'helpful_votes' : 'unhelpful_votes';
    return await db.rawUpdate(
      'UPDATE $tableName SET $field = $field + 1 WHERE id = ?',
      [id],
    );
  }

  // Get distinct categories
  Future<List<String>> getCategories() async {
    final db = await database;
    final results = await db.rawQuery(
      'SELECT DISTINCT category FROM $tableName ORDER BY category ASC',
    );
    return results
        .map((r) => r['category'] as String? ?? '')
        .where((c) => c.isNotEmpty)
        .toList();
  }

  // Reset database for tests / resets
  Future<void> clearAndReseed() async {
    final db = await database;
    await db.delete(tableName);
    for (final faq in _seedFaqs) {
      await db.insert(tableName, faq.toMap());
    }
  }

  // Comprehensive Institutional FAQs categorized for each user role
  static final List<FaqItem> _seedFaqs = [
    // --- PARENT & GENERAL BILLING ---
    const FaqItem(
      question: 'How do I pay school tuition fees online?',
      answer:
          'Go to the Fees tab from the bottom navigation bar or dashboard, tap "View Itemized Fees & Pay", select your pending term installment (Term 1, Term 2, or Annual), choose UPI, Net Banking, or Card, and confirm payment. Instant digital acknowledgment is generated upon success.',
      category: 'fees',
      targetRoles: 'all,parent',
      displayOrder: 1,
    ),
    const FaqItem(
      question: 'Where can I download official fee receipts for income tax (80C)?',
      answer:
          'Navigate to Fees → Fee Ledger, tap any completed transaction, and select "Download PDF Receipt". All generated receipts carry the official ONPS crest, affiliation seal (No. 2130842), and verified Accounts Desk authorization for tax submission.',
      category: 'fees',
      targetRoles: 'all,parent,accountant',
      displayOrder: 2,
    ),
    const FaqItem(
      question: 'What is the late fee policy and grace period?',
      answer:
          'Term fees are due by the 15th of the billing month. A grace period of 7 calendar days is provided. A nominal late fee of ₹50/day applies thereafter up to a maximum cap of ₹1,000 before term examinations.',
      category: 'fees',
      targetRoles: 'parent,accountant',
      displayOrder: 3,
    ),
    const FaqItem(
      question: 'How do parents apply for student leave?',
      answer:
          'Open Attendance from your dashboard, tap "Apply for Leave", select start and end dates, choose the reason (Medical, Family, Emergency), attach supporting medical prescriptions if leave exceeds 2 days, and submit for Class Teacher approval.',
      category: 'attendance',
      targetRoles: 'parent,all',
      displayOrder: 4,
    ),
    const FaqItem(
      question: 'How can I track my child’s school bus live?',
      answer:
          'Navigate to More → Bus Transit. If enrolled in school transport, you will see real-time GPS tracking, vehicle registration number (e.g. UP-32-AB-1234), route stop timings, and direct click-to-call for the assigned bus driver and marshal.',
      category: 'transport',
      targetRoles: 'parent,student,all',
      displayOrder: 5,
    ),
    const FaqItem(
      question: 'How do I change my assigned bus stop or route?',
      answer:
          'Transit stop modifications require an official request submitted via Transit Desk → Request Stop Change at least 5 business days prior to the billing month to allow route reallocation.',
      category: 'transport',
      targetRoles: 'parent',
      displayOrder: 6,
    ),
    const FaqItem(
      question: 'How do I book a Parent-Teacher Meeting (PTM)?',
      answer:
          'Scheduled PTM dates are announced via the Notice Board. For urgent academic consultations between terms, parents can request a 15-minute slot during faculty office hours through the teacher contact profile.',
      category: 'general',
      targetRoles: 'parent,teacher',
      displayOrder: 7,
    ),
    const FaqItem(
      question: 'How do I switch between multiple children in the parent portal?',
      answer:
          'Tap your child\'s name badge or avatar in the dashboard header. A selector popup appears allowing 1-tap switching between siblings enrolled at ONPS with separate academic dossiers and fee ledgers.',
      category: 'general',
      targetRoles: 'parent',
      displayOrder: 8,
    ),

    // --- ACADEMICS & CBSE ---
    const FaqItem(
      question: 'When and how are Term Report Cards published?',
      answer:
          'Academic report cards are published within 7 business days of evaluation completion. Parents and students can view them via Academics → Report Card to review scholastic scores, percentiles, faculty observations, and CBSE 9-point scale grading.',
      category: 'academics',
      targetRoles: 'all,parent,student',
      displayOrder: 9,
    ),
    const FaqItem(
      question: 'What is the CBSE passing criteria and grading system?',
      answer:
          'Students must secure a minimum of 33% marks in each subject (theory and practical/internal assessments separately) and aggregate 33% overall. Grades follow the CBSE scale from A1 (top 1/8th) down to E (needs improvement).',
      category: 'academics',
      targetRoles: 'all,parent,student',
      displayOrder: 10,
    ),
    const FaqItem(
      question: 'What is the mandatory attendance threshold for CBSE board exams?',
      answer:
          'CBSE strictly mandates a minimum of 75% aggregate attendance throughout the academic session to be eligible for board examinations. Automated SMS and push notifications are triggered if attendance drops below 80%.',
      category: 'attendance',
      targetRoles: 'all,parent,student,teacher',
      displayOrder: 11,
    ),

    // --- STUDENT FOCUS ---
    const FaqItem(
      question: 'How does the Digital Student ID Card work?',
      answer:
          'The Digital ID is accessible from your student profile or card quick action. It contains a high-security encrypted QR code for campus turnstile entry, library book issue, and emergency blood group metadata.',
      category: 'security',
      targetRoles: 'all,student,parent',
      displayOrder: 12,
    ),
    const FaqItem(
      question: 'What should I do if a student’s physical RFID badge is lost?',
      answer:
          'Report it immediately under Digital ID → Report Lost Badge. The RFID is deactivated immediately to prevent unauthorized gate entry. A replacement card can be issued at the Reception Desk for a nominal fee of ₹150.',
      category: 'security',
      targetRoles: 'all,student,parent',
      displayOrder: 13,
    ),
    const FaqItem(
      question: 'What is the book borrowing limit and loan period for students?',
      answer:
          'Middle and Senior wing students can borrow up to 2 books simultaneously for a duration of 14 calendar days. Renewals can be requested once at the Library Circulation Desk if no hold exists.',
      category: 'library',
      targetRoles: 'student,librarian',
      displayOrder: 14,
    ),
    const FaqItem(
      question: 'Where can I view my daily class timetable and subject room numbers?',
      answer:
          'Open your Student Hub dashboard and tap "Class Timetable". You will see real-time period allocations, subject teacher names, and designated laboratory/classroom room numbers.',
      category: 'academics',
      targetRoles: 'student',
      displayOrder: 15,
    ),

    // --- TEACHER / FACULTY FOCUS ---
    const FaqItem(
      question: 'How do teachers submit marks into the system?',
      answer:
          'Faculty members open the Marks Entry Desk from their portal, select their allocated Class and Subject, enter scores student-by-student with automatic grade calculation, and submit for Class Teacher / Principal sign-off.',
      category: 'academics',
      targetRoles: 'teacher,principal',
      displayOrder: 16,
    ),
    const FaqItem(
      question: 'How does a Class Teacher review and approve student leave requests?',
      answer:
          'Open Attendance → Leave Applications from the teacher portal. Review the attached parent notes and doctor prescriptions, tap Approve or Reject with optional feedback comments.',
      category: 'attendance',
      targetRoles: 'teacher',
      displayOrder: 17,
    ),
    const FaqItem(
      question: 'How do teachers take daily roll call on mobile or offline?',
      answer:
          'Navigate to Roll Call from the teacher home screen. Tap Present, Absent, or Late for each student. If connectivity is down, the roll call is cached locally in SQLite and syncs automatically when Wi-Fi reconnects.',
      category: 'attendance',
      targetRoles: 'teacher',
      displayOrder: 18,
    ),
    const FaqItem(
      question: 'Where can faculty submit casual, sick, or earned leave applications?',
      answer:
          'Faculty can access Faculty Leave Desk under Quick Actions. Select leave category (Casual, Sick, Duty), specify dates and substitution arrangements, and submit for Vice Principal validation.',
      category: 'attendance',
      targetRoles: 'teacher,principal',
      displayOrder: 19,
    ),
    const FaqItem(
      question: 'Can teachers reserve reference books for classroom projects?',
      answer:
          'Yes, teachers can place a 3-day class reserve on reference encyclopedias, lab manuals, and journals through the Library Desk or by contacting the Librarian directly.',
      category: 'library',
      targetRoles: 'teacher,librarian',
      displayOrder: 20,
    ),

    // --- ACCOUNTANT FOCUS ---
    const FaqItem(
      question: 'How do accountants reconcile daily UPI and bank settlement ledgers?',
      answer:
          'Open the Accounts Desk → Daily Settlements. Match incoming gateway reference numbers (UTR) against student enrollment numbers, mark cleared transactions, and export the end-of-day bank deposit summary.',
      category: 'fees',
      targetRoles: 'accountant',
      displayOrder: 21,
    ),
    const FaqItem(
      question: 'How are automatic late fee fines computed and waived?',
      answer:
          'The system applies ₹50/day automatically after the 7-day grace period. Accountants can issue a discretionary waiver for valid medical or administrative exemptions with Principal approval.',
      category: 'fees',
      targetRoles: 'accountant,principal',
      displayOrder: 22,
    ),
    const FaqItem(
      question: 'How do I reissue a lost fee receipt or update 80C PAN details?',
      answer:
          'Under Fee Ledger, search the student admission number, select the relevant installment, update guardian PAN if required, and click "Regenerate Certified Receipt".',
      category: 'fees',
      targetRoles: 'accountant',
      displayOrder: 23,
    ),

    // --- PRINCIPAL & LEADERSHIP FOCUS ---
    const FaqItem(
      question: 'How do administrators review and publish school-wide notice board circulars?',
      answer:
          'Leadership can open Announcement Approval Desk from the Principal portal, review drafted notices submitted by faculty, approve attachments, and broadcast immediately to parents, students, or staff.',
      category: 'admin',
      targetRoles: 'principal,teacher',
      displayOrder: 24,
    ),
    const FaqItem(
      question: 'Where can leadership inspect class-wise attendance deficit warnings (<75%)?',
      answer:
          'Navigate to Attendance Matrix from the Principal Dashboard. The system highlights high-risk students in amber/red and allows 1-tap dispatch of formal warning notices to parents.',
      category: 'admin',
      targetRoles: 'principal',
      displayOrder: 25,
    ),
    const FaqItem(
      question: 'What is the approval workflow for student fee concessions and scholarships?',
      answer:
          'Concession applications submitted by parents are queued under Principal → Approvals → Concessions. Principals can sanction 25%, 50%, or 100% tuition waivers under EWS/Merit schemes.',
      category: 'fees',
      targetRoles: 'principal,accountant',
      displayOrder: 26,
    ),

    // --- LIBRARIAN FOCUS ---
    const FaqItem(
      question: 'How do librarians process barcode returns and track overdue fines?',
      answer:
          'Open Library Circulation Desk, scan the accession barcode or student RFID badge. The system calculates overdue fines at ₹5/day after 14 days and logs returns directly into the inventory ledger.',
      category: 'library',
      targetRoles: 'librarian',
      displayOrder: 27,
    ),

    // --- GENERAL & HELP DESK ---
    const FaqItem(
      question: 'What are the official school operating hours?',
      answer:
          'Summer Timings: 07:30 AM – 01:45 PM. Winter Timings: 08:00 AM – 02:15 PM. Administrative and Accounts desks remain operational until 03:30 PM on weekdays and 01:00 PM on working Saturdays.',
      category: 'general',
      targetRoles: 'all',
      displayOrder: 28,
    ),
    const FaqItem(
      question: 'Who do I contact for emergency school security or medical assistance?',
      answer:
          'For urgent campus emergencies, dial the School Infirmary at +91 98000 11224 or Security Turnstile Gate 1 at +91 98000 11225. Both stations are staffed 24/7 during school terms.',
      category: 'general',
      targetRoles: 'all',
      displayOrder: 29,
    ),
  ];
}

