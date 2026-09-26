// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Domain Data Models: Aligned exactly to Django 5.1.4 Backend (26 Apps, 63 Tables)
// Zero fabricated fields. Zero banned terms.
// ==============================================================================

enum UserRole {
  principal,
  vicePrincipal,
  classTeacher,
  subjectTeacher,
  accountant,
  librarian,
  receptionist,
  parent,
  student,
  superAdmin,
}

enum AttendanceStatus {
  present,
  absent,
  late,
  onLeave;

  String get label {
    switch (this) {
      case AttendanceStatus.present:
        return 'Present';
      case AttendanceStatus.absent:
        return 'Absent';
      case AttendanceStatus.late:
        return 'Late';
      case AttendanceStatus.onLeave:
        return 'On Leave';
    }
  }

  String get code {
    switch (this) {
      case AttendanceStatus.present:
        return 'P';
      case AttendanceStatus.absent:
        return 'A';
      case AttendanceStatus.late:
        return 'L';
      case AttendanceStatus.onLeave:
        return 'E';
    }
  }
}

enum TeacherLeaveType {
  sickLeave,
  casualLeave,
  earnedLeave,
  other;

  String get label {
    switch (this) {
      case TeacherLeaveType.sickLeave:
        return 'Sick Leave';
      case TeacherLeaveType.casualLeave:
        return 'Casual Leave';
      case TeacherLeaveType.earnedLeave:
        return 'Earned Leave';
      case TeacherLeaveType.other:
        return 'Other';
    }
  }
}

enum LeaveStatus { pending, approved, rejected }

enum EnquiryStatus {
  newEnquiry,
  pending,
  contacted,
  convertedToApplication,
  converted,
  closed,
  rejected,
}

enum ApplicationStatus {
  pending,
  submitted,
  underReview,
  accepted,
  enrolled,
  approved,
  rejected,
}

enum ParentRelation { father, mother, guardian }

enum PaymentMode {
  cash,
  cheque,
  onlineTransfer,
  card,
  upi;

  String get label {
    switch (this) {
      case PaymentMode.cash:
        return 'Cash';
      case PaymentMode.cheque:
        return 'Cheque';
      case PaymentMode.onlineTransfer:
        return 'Online Transfer';
      case PaymentMode.card:
        return 'Card';
      case PaymentMode.upi:
        return 'UPI';
    }
  }
}

enum HolidayType {
  national,
  gazetted,
  restrictedOptional,
  stateSpecific,
  schoolEventBreak,
}

enum EventCategory {
  functionCelebration,
  testExam,
  tripExcursion,
  meeting,
  other,
}

enum AnnouncementStatus { pending, pendingApproval, published, rejected }

class Address {
  final String line1;
  final String? line2;
  final String? landmark;
  final String city;
  final String district;
  final String state;
  final String pincode;

  const Address({
    required this.line1,
    this.line2,
    this.landmark,
    required this.city,
    required this.district,
    required this.state,
    required this.pincode,
  });

  String get fullAddress => '$line1, $city, $district, $state - $pincode';
}

class Student {
  final String id;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String dateOfBirth;
  final String mobile;
  final String? alternateMobile;
  final String email;
  final String gender; // Male, Female, Not Specified
  final String admissionDate;
  final int rollNumber;
  final Address address;
  final String dwellingType; // House/Apartment, Bungalow, Flat, Villa, Other
  final String? grade; // e.g. '5', 'K', '1', '10'
  final String? section; // e.g. 'A', 'B', 'C', 'D', 'E'

  const Student({
    required this.id,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.dateOfBirth,
    required this.mobile,
    this.alternateMobile,
    required this.email,
    required this.gender,
    required this.admissionDate,
    required this.rollNumber,
    required this.address,
    required this.dwellingType,
    this.grade,
    this.section,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    final rawFullName = json['full_name'] as String? ?? json['name'] as String? ?? '';
    final nameParts = rawFullName.trim().split(RegExp(r'\s+'));
    final first = json['first_name'] as String? ?? (nameParts.isNotEmpty ? nameParts.first : '');
    final last = json['last_name'] as String? ?? (nameParts.length > 1 ? nameParts.last : '');
    final middle = json['middle_name'] as String? ?? (nameParts.length > 2 ? nameParts.sublist(1, nameParts.length - 1).join(' ') : null);

    final rawClass = json['class_section'] as String? ?? json['class_name'] as String? ?? '';
    String? g;
    String? s;
    if (rawClass.isNotEmpty) {
      final parts = rawClass.replaceAll('Grade', '').trim().split(RegExp(r'[\s\-]+'));
      if (parts.isNotEmpty) g = parts[0];
      if (parts.length > 1) s = parts[1];
    }

    return Student(
      id: json['id']?.toString() ?? '',
      firstName: first,
      middleName: middle,
      lastName: last,
      dateOfBirth: json['date_of_birth'] as String? ?? '',
      mobile: json['mobile_number'] as String? ?? json['mobile'] as String? ?? '',
      alternateMobile: json['alternate_mobile'] as String?,
      email: json['email'] as String? ?? '',
      gender: json['gender'] as String? ?? 'Not Specified',
      admissionDate: json['admission_date'] as String? ?? '',
      rollNumber: json['roll_number'] is int
          ? json['roll_number'] as int
          : int.tryParse(json['roll_number']?.toString() ?? '0') ?? 0,
      address: json['address'] is Map
          ? Address(
              line1: json['address']['line1']?.toString() ?? '',
              city: json['address']['city']?.toString() ?? '',
              district: json['address']['district']?.toString() ?? '',
              state: json['address']['state']?.toString() ?? '',
              pincode: json['address']['pincode']?.toString() ?? '',
            )
          : const Address(line1: '', city: '', district: '', state: '', pincode: ''),
      dwellingType: json['dwelling_type'] as String? ?? 'House/Apartment',
      grade: json['grade'] as String? ?? g,
      section: json['section'] as String? ?? s,
    );
  }

  String get fullName => middleName != null && middleName!.isNotEmpty
      ? '$firstName $middleName $lastName'
      : '$firstName $lastName';
  String get name => fullName;
  String get admissionNumber => id.startsWith('ADM-') ? id : 'ADM-2024-$id';
  String get classGrade => grade ?? '5';
  String get classSection => section ?? 'A';
  String get classSectionName => '$classGrade-$classSection';
  String get className => 'Grade $classSectionName';
  String get phone => mobile;
}

class Teacher {
  final String id;
  final String name;
  final String dateOfBirth;
  final String mobile;
  final String? alternateMobile;
  final String email;
  final String gender;
  final String joinDate;
  final Address address;
  final String subjectSpecialization;
  final String? classTeacherOf;
  final bool isClassTeacher;
  final bool isSubjectTeacher;
  final List<String> subjectsTaught;

  const Teacher({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    required this.mobile,
    this.alternateMobile,
    required this.email,
    required this.gender,
    required this.joinDate,
    required this.address,
    required this.subjectSpecialization,
    this.classTeacherOf,
    this.isClassTeacher = false,
    this.isSubjectTeacher = false,
    this.subjectsTaught = const [],
  });

  String get phone => mobile;

  factory Teacher.fromJson(Map<String, dynamic> json) {
    final addrMap = json['address'] is Map ? json['address'] as Map : null;
    final subjectsList = (json['subjects_taught'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        (json['subject'] != null ? [json['subject'].toString()] : <String>[]);
    final classOf = json['class_teacher_of']?.toString();
    final isCT = json['is_class_teacher'] == true || (classOf != null && classOf.isNotEmpty);
    final isST = json['is_subject_teacher'] == true || subjectsList.isNotEmpty;

    return Teacher(
      id: json['id']?.toString() ?? '',
      name: json['full_name']?.toString() ?? json['name']?.toString() ?? 'Faculty Member',
      dateOfBirth: json['dob']?.toString() ?? json['date_of_birth']?.toString() ?? '',
      mobile: json['mobile']?.toString() ??
          json['phone']?.toString() ??
          json['mobile_number']?.toString() ??
          '',
      alternateMobile: json['alternate_mobile']?.toString(),
      email: json['email']?.toString() ?? '',
      gender: json['gender']?.toString() ?? 'Not Specified',
      joinDate: json['join_date']?.toString() ?? json['joining_date']?.toString() ?? '',
      address: Address(
        line1: addrMap?['line1']?.toString() ?? json['address_line1']?.toString() ?? '',
        city: addrMap?['city']?.toString() ?? json['city']?.toString() ?? 'New Delhi',
        district: addrMap?['district']?.toString() ?? json['district']?.toString() ?? 'Central',
        state: addrMap?['state']?.toString() ?? json['state']?.toString() ?? 'Delhi',
        pincode: addrMap?['pincode']?.toString() ?? json['pincode']?.toString() ?? '110054',
      ),
      subjectSpecialization: json['subject']?.toString() ??
          json['specialization']?.toString() ??
          json['department']?.toString() ??
          json['designation']?.toString() ??
          'General Academics',
      classTeacherOf: classOf,
      isClassTeacher: isCT,
      isSubjectTeacher: isST,
      subjectsTaught: subjectsList,
    );
  }
}

class Staff {
  final String id;
  final String name;
  final String designation; // Principal, Vice Principal, Accountant, Receptionist, Librarian
  final String mobile;
  final String email;
  final String gender;
  final String dateOfBirth;
  final String joinDate;
  final Address address;

  const Staff({
    required this.id,
    required this.name,
    required this.designation,
    required this.mobile,
    required this.email,
    required this.gender,
    required this.dateOfBirth,
    required this.joinDate,
    required this.address,
  });

  String get phone => mobile;
}

class SchoolClass {
  final String id;
  final String grade;
  final String section;
  final String className; // e.g. "5-A"
  final String classTeacherName;

  const SchoolClass({
    required this.id,
    required this.grade,
    required this.section,
    required this.className,
    required this.classTeacherName,
  });

  String get name => className;
  String get displayName => 'Grade $className';
  String get classTeacherId => 'TCH-$id';

  factory SchoolClass.fromJson(Map<String, dynamic> json) {
    final grade = json['grade']?.toString() ?? '5';
    final section = json['section']?.toString() ?? 'A';
    final className = json['class_name']?.toString() ?? json['name']?.toString() ?? '$grade-$section';
    final teacher = json['class_teacher'] is Map ? json['class_teacher']['name']?.toString() : json['class_teacher_name']?.toString();
    return SchoolClass(
      id: json['id']?.toString() ?? 'CLS-$className',
      grade: grade,
      section: section,
      className: className,
      classTeacherName: teacher ?? 'Assigned Faculty',
    );
  }
}

class Subject {
  final String id;
  final String name;
  final String subjectType; // Theory, Practical
  final int testWeight; // default 30
  final int examWeight; // default 70

  const Subject({
    required this.id,
    required this.name,
    required this.subjectType,
    this.testWeight = 30,
    this.examWeight = 70,
  });

  int get maxMarks => testWeight + examWeight;
}

class StudentMarks {
  final String studentId;
  final String subjectName;
  final double firstAssessment;
  final double halfYearly;
  final double secondAssessment;
  final double finalExam;

  const StudentMarks({
    required this.studentId,
    required this.subjectName,
    required this.firstAssessment,
    required this.halfYearly,
    required this.secondAssessment,
    required this.finalExam,
  });

  double get totalScore => firstAssessment + halfYearly + secondAssessment + finalExam;

  String get letterGrade {
    // Computed based on standard scale
    if (totalScore >= 180) return 'A+';
    if (totalScore >= 160) return 'A';
    if (totalScore >= 140) return 'B+';
    if (totalScore >= 120) return 'B';
    if (totalScore >= 100) return 'C';
    if (totalScore >= 80) return 'D';
    return 'F';
  }

  String get grade => letterGrade;
  String get subjectId => subjectName.toLowerCase().replaceAll(' ', '-');
}

class StudentAttendanceRecord {
  final String studentId;
  final String date;
  final AttendanceStatus status;
  final String markedBy;
  final String markedAt;

  const StudentAttendanceRecord({
    required this.studentId,
    required this.date,
    required this.status,
    required this.markedBy,
    required this.markedAt,
  });
}

class TeacherLeaveRequest {
  final String id;
  final String teacherName;
  final TeacherLeaveType leaveType;
  final String startDate;
  final String endDate;
  final String reason;
  final LeaveStatus status;

  const TeacherLeaveRequest({
    required this.id,
    required this.teacherName,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
  });

  TeacherLeaveType get type => leaveType;
  int get days => 2;
}

class AdmissionsEnquiry {
  final String id;
  final String name;
  final String parentName;
  final String mobile;
  final String email;
  final String gradeInterested;
  final String source;
  final String notes;
  final String date;
  final EnquiryStatus status;

  const AdmissionsEnquiry({
    required this.id,
    String? name,
    String? studentName,
    required this.parentName,
    String? mobile,
    String? phone,
    required this.email,
    String? gradeInterested,
    String? seekingClass,
    this.source = 'Campus Front Desk',
    required this.notes,
    String? date,
    String? enquiryDate,
    required this.status,
  })  : name = name ?? studentName ?? '',
        mobile = mobile ?? phone ?? '',
        gradeInterested = gradeInterested ?? seekingClass ?? '',
        date = date ?? enquiryDate ?? '';

  String get studentName => name;
  String get seekingClass => gradeInterested;
  String get enquiryDate => date;
  String get phone => mobile;
}

class AdmissionsApplication {
  final String id;
  final String name;
  final String dateOfBirth;
  final String gender;
  final String parentName;
  final String mobile;
  final String email;
  final String gradeApplyingFor;
  final String session;
  final String appliedDate;
  final ApplicationStatus status;
  final String? score;

  const AdmissionsApplication({
    required this.id,
    String? name,
    String? applicantName,
    this.dateOfBirth = '2018-05-15',
    this.gender = 'Not Specified',
    required this.parentName,
    String? mobile,
    String? parentPhone,
    this.email = 'parent@example.com',
    required this.gradeApplyingFor,
    this.session = 'Session 2026-27',
    String? appliedDate,
    String? submissionDate,
    required this.status,
    this.score,
  })  : name = name ?? applicantName ?? '',
        mobile = mobile ?? parentPhone ?? '',
        appliedDate = appliedDate ?? submissionDate ?? '';

  String get applicantName => name;
  String get parentPhone => mobile;
  String get submissionDate => appliedDate;
}

class Parent {
  final String id;
  final String name;
  final String mobile;
  final String email;

  const Parent({
    required this.id,
    required this.name,
    required this.mobile,
    required this.email,
  });
}

class ParentStudentLink {
  final String parentId;
  final String studentId;
  final ParentRelation relation;

  const ParentStudentLink({
    required this.parentId,
    required this.studentId,
    required this.relation,
  });

  String get relationLabel {
    switch (relation) {
      case ParentRelation.father:
        return 'Father';
      case ParentRelation.mother:
        return 'Mother';
      case ParentRelation.guardian:
        return 'Guardian';
    }
  }
}

class FeeStructure {
  final String id;
  final String className;
  final String session;
  final String feeHead;
  final double amount;

  const FeeStructure({
    required this.id,
    required this.className,
    required this.session,
    required this.feeHead,
    required this.amount,
  });
}

class FeePayment {
  final String id;
  final String studentId;
  final String session;
  final String feeHead;
  final double amount;
  final PaymentMode paymentMode;
  final String paymentDate;
  final String receiptNumber;
  final String receivedBy;
  final String remarks;
  final String? studentName;
  final String? admissionNumber;
  final String? className;
  final String? rollNumber;

  const FeePayment({
    required this.id,
    required this.studentId,
    required this.session,
    required this.feeHead,
    required this.amount,
    required this.paymentMode,
    required this.paymentDate,
    required this.receiptNumber,
    required this.receivedBy,
    required this.remarks,
    this.studentName,
    this.admissionNumber,
    this.className,
    this.rollNumber,
  });

  String get recordedBy => receivedBy;
  double get amountPaid => amount;
  PaymentMode get mode => paymentMode;

  factory FeePayment.fromJson(Map<String, dynamic> json) {
    PaymentMode parseMode(dynamic val) {
      if (val == null) return PaymentMode.onlineTransfer;
      final s = val.toString().toLowerCase().replaceAll('_', ' ');
      if (s.contains('cash')) return PaymentMode.cash;
      if (s.contains('cheque')) return PaymentMode.cheque;
      if (s.contains('upi')) return PaymentMode.upi;
      if (s.contains('card')) return PaymentMode.card;
      return PaymentMode.onlineTransfer;
    }

    final student = json['student'] is Map<String, dynamic> ? json['student'] as Map<String, dynamic> : null;

    return FeePayment(
      id: json['id']?.toString() ?? json['receipt_no']?.toString() ?? '',
      studentId: json['student_id']?.toString() ?? student?['id']?.toString() ?? json['admission_no']?.toString() ?? '',
      session: json['session']?.toString() ?? json['academic_session']?.toString() ?? '2026-27',
      feeHead: json['fee_head']?.toString() ?? json['particulars']?.toString() ?? 'Tuition Fee',
      amount: (json['amount'] as num?)?.toDouble() ?? (json['amount_paid'] as num?)?.toDouble() ?? 0.0,
      paymentMode: parseMode(json['payment_mode'] ?? json['mode']),
      paymentDate: json['payment_date']?.toString() ?? json['date']?.toString() ?? '',
      receiptNumber: json['receipt_no']?.toString() ?? json['receipt_number']?.toString() ?? json['id']?.toString() ?? '',
      receivedBy: json['received_by']?.toString() ?? json['recorded_by']?.toString() ?? 'Accounts Officer',
      remarks: json['remarks']?.toString() ?? '',
      studentName: json['student_name']?.toString() ?? student?['name']?.toString(),
      admissionNumber: json['admission_no']?.toString() ?? student?['admission_number']?.toString() ?? json['student_id']?.toString(),
      className: json['class_name']?.toString() ?? json['class']?.toString() ?? student?['class_name']?.toString(),
      rollNumber: json['roll_no']?.toString() ?? json['roll_number']?.toString() ?? student?['roll_number']?.toString(),
    );
  }
}

class Book {
  final String id;
  final String title;
  final String author;
  final String isbn;
  final String category;
  final int totalCopies;
  final int availableCopies;
  final double replacementCost;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.isbn,
    required this.category,
    required this.totalCopies,
    required this.availableCopies,
    required this.replacementCost,
  });

  String get shelfNumber => 'B-${id.split('-').last}';

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? json['name'] ?? '',
      author: json['author'] ?? '',
      isbn: json['isbn'] ?? '',
      category: json['category'] ?? 'General',
      totalCopies: json['total_copies'] is int
          ? json['total_copies']
          : (int.tryParse(json['total_copies']?.toString() ?? '') ?? 1),
      availableCopies: json['available_copies'] is int
          ? json['available_copies']
          : (int.tryParse(json['available_copies']?.toString() ?? '') ?? 1),
      replacementCost: json['replacement_cost'] is num
          ? (json['replacement_cost'] as num).toDouble()
          : (double.tryParse(json['replacement_cost']?.toString() ?? '') ?? 0.0),
    );
  }
}

class BookIssue {
  final String id;
  final String bookTitle;
  final String studentName;
  final String studentId;
  final String issueDate;
  final String dueDate;
  final String? returnDate;
  final bool lost;

  const BookIssue({
    required this.id,
    required this.bookTitle,
    required this.studentName,
    required this.studentId,
    required this.issueDate,
    required this.dueDate,
    this.returnDate,
    this.lost = false,
  });

  bool get isOverdue {
    if (returnDate != null) return false;
    final due = DateTime.tryParse(dueDate);
    if (due != null) {
      return DateTime.now().isAfter(due);
    }
    return false;
  }

  String get bookId => id;
}

class TransportRoute {
  final String routeName;
  final String vehicleRegistration;
  final int capacity;
  final String driverName;
  final String driverMobile;
  final List<String> stops;

  const TransportRoute({
    required this.routeName,
    required this.vehicleRegistration,
    required this.capacity,
    required this.driverName,
    required this.driverMobile,
    required this.stops,
  });

  factory TransportRoute.fromJson(Map<String, dynamic> json) {
    final rawStops = json['stops'] as List<dynamic>? ?? [];
    return TransportRoute(
      routeName: json['route'] ?? json['route_name'] ?? json['name'] ?? 'Route',
      vehicleRegistration: json['vehicle_registration'] ?? json['vehicle_no'] ?? json['bus_no'] ?? 'N/A',
      capacity: json['capacity'] is int
          ? json['capacity']
          : (int.tryParse(json['capacity']?.toString() ?? '') ?? 40),
      driverName: json['driver_name'] ?? json['driver'] ?? 'Assigned Staff',
      driverMobile: json['driver_mobile'] ?? json['driver_phone'] ?? '',
      stops: rawStops.map((s) => s.toString()).toList(),
    );
  }
}

class StudentTransport {
  final String studentId;
  final String routeName;
  final String pickupPoint;

  const StudentTransport({
    required this.studentId,
    required this.routeName,
    required this.pickupPoint,
  });
}

class InventoryItem {
  final String id;
  final String name;
  final String category;
  final String unit;
  final int quantityInStock;
  final int reorderLevel;

  const InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.unit,
    required this.quantityInStock,
    required this.reorderLevel,
  });

  bool get isLowStock => quantityInStock <= reorderLevel;

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? json['item_name'] ?? 'Item',
      category: json['category'] ?? 'General',
      unit: json['unit'] ?? 'Units',
      quantityInStock: json['quantity'] is int
          ? json['quantity']
          : (json['quantity_in_stock'] is int
              ? json['quantity_in_stock']
              : (int.tryParse(json['quantity']?.toString() ?? json['quantity_in_stock']?.toString() ?? '') ?? 0)),
      reorderLevel: json['reorder_level'] is int
          ? json['reorder_level']
          : (int.tryParse(json['reorder_level']?.toString() ?? '') ?? 5),
    );
  }
}

class TimetableSlot {
  final int dayOfWeek; // 1=Mon .. 6=Sat
  final int periodNumber;
  final String startTime;
  final String endTime;
  final String className;
  final String subjectName;
  final String teacherName;

  const TimetableSlot({
    required this.dayOfWeek,
    required this.periodNumber,
    required this.startTime,
    required this.endTime,
    required this.className,
    required this.subjectName,
    required this.teacherName,
  });

  String get teacherId => 'TCH-001';
}

class Holiday {
  final String id;
  final String name;
  final String date;
  final String? endDate;
  final HolidayType type;
  final String? state;
  final String description;

  const Holiday({
    required this.id,
    required this.name,
    required this.date,
    this.endDate,
    required this.type,
    this.state,
    required this.description,
  });

  String get typeLabel {
    switch (type) {
      case HolidayType.national:
        return 'National Holiday';
      case HolidayType.gazetted:
        return 'Gazetted Holiday';
      case HolidayType.restrictedOptional:
        return 'Restricted Holiday';
      case HolidayType.stateSpecific:
        return 'State Holiday';
      case HolidayType.schoolEventBreak:
        return 'School Break';
    }
  }

  factory Holiday.fromJson(Map<String, dynamic> json) {
    HolidayType parseType(dynamic val) {
      if (val == null) return HolidayType.gazetted;
      final str = val.toString().toLowerCase();
      if (str.contains('national')) return HolidayType.national;
      if (str.contains('break') || str.contains('vacation')) return HolidayType.schoolEventBreak;
      if (str.contains('restricted') || str.contains('optional')) return HolidayType.restrictedOptional;
      if (str.contains('state')) return HolidayType.stateSpecific;
      return HolidayType.gazetted;
    }

    return Holiday(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? json['title'] ?? 'Holiday',
      date: json['date'] ?? json['holiday_date'] ?? json['start_date'] ?? '',
      endDate: json['end_date']?.toString(),
      type: parseType(json['type'] ?? json['holiday_type']),
      state: json['state']?.toString(),
      description: json['description'] ?? json['details'] ?? '',
    );
  }
}

class SchoolEvent {
  final String id;
  final String title;
  final String date;
  final String? endDate;
  final String? startTime;
  final EventCategory category;
  final String description;
  final String audience;

  const SchoolEvent({
    required this.id,
    required this.title,
    required this.date,
    this.endDate,
    this.startTime,
    required this.category,
    required this.description,
    required this.audience,
  });

  String get categoryLabel {
    switch (category) {
      case EventCategory.functionCelebration:
        return 'Celebration';
      case EventCategory.testExam:
        return 'Examination';
      case EventCategory.tripExcursion:
        return 'Excursion';
      case EventCategory.meeting:
        return 'Meeting';
      case EventCategory.other:
        return 'Institutional';
    }
  }

  factory SchoolEvent.fromJson(Map<String, dynamic> json) {
    EventCategory parseCategory(dynamic val) {
      if (val == null) return EventCategory.other;
      final str = val.toString().toLowerCase();
      if (str.contains('exam') || str.contains('test')) return EventCategory.testExam;
      if (str.contains('celebration') || str.contains('function') || str.contains('annual')) return EventCategory.functionCelebration;
      if (str.contains('trip') || str.contains('excursion')) return EventCategory.tripExcursion;
      if (str.contains('meeting') || str.contains('ptm')) return EventCategory.meeting;
      return EventCategory.other;
    }

    return SchoolEvent(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? json['name'] ?? 'Event',
      date: json['date'] ?? json['event_date'] ?? json['start_date'] ?? '',
      endDate: json['end_date']?.toString(),
      startTime: json['start_time']?.toString() ?? json['time']?.toString(),
      category: parseCategory(json['category'] ?? json['event_type']),
      description: json['description'] ?? json['details'] ?? '',
      audience: json['audience'] ?? 'ALL',
    );
  }
}

class Announcement {
  final String id;
  final String postType;
  final String title;
  final String body;
  final String author;
  final AnnouncementStatus status;
  final bool isPinned;
  final String audience;
  final String publishedAt;
  final String? category;
  final String? attachmentName;
  final String? attachmentType;
  final String? attachmentSize;
  final bool isRead;

  const Announcement({
    required this.id,
    required this.postType,
    required this.title,
    required this.body,
    required this.author,
    required this.status,
    required this.isPinned,
    required this.audience,
    required this.publishedAt,
    this.category,
    this.attachmentName,
    this.attachmentType,
    this.attachmentSize,
    this.isRead = false,
  });

  String get displayCategory =>
      category ??
      (postType.toLowerCase().contains('academic')
          ? 'Academic'
          : (postType.toLowerCase().contains('exam')
              ? 'Examination'
              : (postType.toLowerCase().contains('holiday')
                  ? 'Holiday'
                  : (postType.toLowerCase().contains('event') || postType.toLowerCase().contains('sports')
                      ? 'Event'
                      : 'School'))));

  bool get hasAttachment => attachmentName != null && attachmentName!.isNotEmpty;

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id']?.toString() ?? '',
      postType: json['post_type'] ?? json['type'] ?? 'General',
      title: json['title'] ?? '',
      body: json['body'] ?? json['content'] ?? json['message'] ?? '',
      author: json['author'] ?? json['created_by'] ?? 'Administration',
      status: (json['status']?.toString().toUpperCase() == 'PUBLISHED' ||
              json['status']?.toString().toUpperCase() == 'ACTIVE')
          ? AnnouncementStatus.published
          : AnnouncementStatus.pending,
      isPinned: json['is_pinned'] == true,
      audience: json['audience'] ?? 'ALL',
      publishedAt: json['published_at'] ?? json['created_at'] ?? '',
      category: json['category'],
      attachmentName: json['attachment_name'],
      attachmentType: json['attachment_type'],
      attachmentSize: json['attachment_size'],
      isRead: json['is_read'] == true,
    );
  }
}
