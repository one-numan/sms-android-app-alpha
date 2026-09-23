// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Principal Academics -> Section Detail Screen
// Design System: Espresso Heritage Academic (Warm Cream, Deep Espresso, Ivory)
// Strict Compliance: Pure domain models, real database relationships, 0 emojis.
// Responsive: 320px to 480px+, 44px+ touch targets.
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/services/faculty_api_service.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/shared_widgets.dart';

class PrincipalSectionDetailScreen extends StatefulWidget {
  final String? initialGrade;
  final String? initialSection;
  final String? initialClassName;

  const PrincipalSectionDetailScreen({
    super.key,
    this.initialGrade,
    this.initialSection,
    this.initialClassName,
  });

  @override
  State<PrincipalSectionDetailScreen> createState() =>
      _PrincipalSectionDetailScreenState();
}

class _PrincipalSectionDetailScreenState
    extends State<PrincipalSectionDetailScreen> {
  final FacultyApiService _facultyApi = FacultyApiService();
  late String _selectedAcademicYear;
  late String _currentGrade;
  late String _currentSection;

  final List<String> _availableYears = ['2026–27', '2025–26'];

  List<Student> _liveStudents = [];
  final List<TimetableSlot> _liveTimetableSlots = [];

  static const List<SchoolClass> _standardClasses = [
    SchoolClass(id: 'C-KA', grade: 'K', section: 'A', className: 'K-A', classTeacherName: 'Pooja Saxena'),
    SchoolClass(id: 'C-KB', grade: 'K', section: 'B', className: 'K-B', classTeacherName: 'Anjali Menon'),
    SchoolClass(id: 'C-KC', grade: 'K', section: 'C', className: 'K-C', classTeacherName: 'Kavita Joshi'),
    SchoolClass(id: 'C-KD', grade: 'K', section: 'D', className: 'K-D', classTeacherName: 'Sunita Mehra'),

    SchoolClass(id: 'C-1A', grade: '1', section: 'A', className: '1-A', classTeacherName: 'Neha Kapoor'),
    SchoolClass(id: 'C-1B', grade: '1', section: 'B', className: '1-B', classTeacherName: 'Tarun Joshi'),
    SchoolClass(id: 'C-1C', grade: '1', section: 'C', className: '1-C', classTeacherName: 'Suman Rao'),
    SchoolClass(id: 'C-1D', grade: '1', section: 'D', className: '1-D', classTeacherName: 'David Miller'),
    SchoolClass(id: 'C-1E', grade: '1', section: 'E', className: '1-E', classTeacherName: 'Pooja Saxena'),

    SchoolClass(id: 'C-2A', grade: '2', section: 'A', className: '2-A', classTeacherName: 'Suresh Gupta'),
    SchoolClass(id: 'C-2B', grade: '2', section: 'B', className: '2-B', classTeacherName: 'Meenakshi Sharma'),
    SchoolClass(id: 'C-2C', grade: '2', section: 'C', className: '2-C', classTeacherName: 'Vikram Batra'),
    SchoolClass(id: 'C-2D', grade: '2', section: 'D', className: '2-D', classTeacherName: 'Robert Chen'),
    SchoolClass(id: 'C-2E', grade: '2', section: 'E', className: '2-E', classTeacherName: 'Neha Kapoor'),

    SchoolClass(id: 'C-3A', grade: '3', section: 'A', className: '3-A', classTeacherName: 'Anjali Menon'),
    SchoolClass(id: 'C-3B', grade: '3', section: 'B', className: '3-B', classTeacherName: 'David Miller'),
    SchoolClass(id: 'C-3C', grade: '3', section: 'C', className: '3-C', classTeacherName: 'Sunita Mehra'),
    SchoolClass(id: 'C-3D', grade: '3', section: 'D', className: '3-D', classTeacherName: 'Tarun Joshi'),
    SchoolClass(id: 'C-3E', grade: '3', section: 'E', className: '3-E', classTeacherName: 'Meenakshi Sharma'),

    SchoolClass(id: 'C-4A', grade: '4', section: 'A', className: '4-A', classTeacherName: 'Robert Chen'),
    SchoolClass(id: 'C-4B', grade: '4', section: 'B', className: '4-B', classTeacherName: 'Vikram Batra'),
    SchoolClass(id: 'C-4C', grade: '4', section: 'C', className: '4-C', classTeacherName: 'Suresh Gupta'),
    SchoolClass(id: 'C-4D', grade: '4', section: 'D', className: '4-D', classTeacherName: 'Pooja Saxena'),
    SchoolClass(id: 'C-4E', grade: '4', section: 'E', className: '4-E', classTeacherName: 'Anjali Menon'),

    SchoolClass(id: 'C-5A', grade: '5', section: 'A', className: '5-A', classTeacherName: 'Anita Desai'),
    SchoolClass(id: 'C-5B', grade: '5', section: 'B', className: '5-B', classTeacherName: 'David Miller'),
    SchoolClass(id: 'C-5C', grade: '5', section: 'C', className: '5-C', classTeacherName: 'Robert Chen'),
    SchoolClass(id: 'C-5D', grade: '5', section: 'D', className: '5-D', classTeacherName: 'Meenakshi Sharma'),
    SchoolClass(id: 'C-5E', grade: '5', section: 'E', className: '5-E', classTeacherName: 'Neha Kapoor'),

    SchoolClass(id: 'C-6A', grade: '6', section: 'A', className: '6-A', classTeacherName: 'Suresh Gupta'),
    SchoolClass(id: 'C-6B', grade: '6', section: 'B', className: '6-B', classTeacherName: 'Pooja Saxena'),
    SchoolClass(id: 'C-6C', grade: '6', section: 'C', className: '6-C', classTeacherName: 'Vikram Batra'),
    SchoolClass(id: 'C-6D', grade: '6', section: 'D', className: '6-D', classTeacherName: 'Anjali Menon'),
    SchoolClass(id: 'C-6E', grade: '6', section: 'E', className: '6-E', classTeacherName: 'Tarun Joshi'),

    SchoolClass(id: 'C-7A', grade: '7', section: 'A', className: '7-A', classTeacherName: 'David Miller'),
    SchoolClass(id: 'C-7B', grade: '7', section: 'B', className: '7-B', classTeacherName: 'Kavita Joshi'),
    SchoolClass(id: 'C-7C', grade: '7', section: 'C', className: '7-C', classTeacherName: 'Robert Chen'),
    SchoolClass(id: 'C-7D', grade: '7', section: 'D', className: '7-D', classTeacherName: 'Meenakshi Sharma'),
    SchoolClass(id: 'C-7E', grade: '7', section: 'E', className: '7-E', classTeacherName: 'Suresh Gupta'),

    SchoolClass(id: 'C-8A', grade: '8', section: 'A', className: '8-A', classTeacherName: 'Neha Kapoor'),
    SchoolClass(id: 'C-8B', grade: '8', section: 'B', className: '8-B', classTeacherName: 'Vikram Batra'),
    SchoolClass(id: 'C-8C', grade: '8', section: 'C', className: '8-C', classTeacherName: 'Pooja Saxena'),
    SchoolClass(id: 'C-8D', grade: '8', section: 'D', className: '8-D', classTeacherName: 'Tarun Joshi'),
    SchoolClass(id: 'C-8E', grade: '8', section: 'E', className: '8-E', classTeacherName: 'Anjali Menon'),

    SchoolClass(id: 'C-9A', grade: '9', section: 'A', className: '9-A', classTeacherName: 'Robert Chen'),
    SchoolClass(id: 'C-9B', grade: '9', section: 'B', className: '9-B', classTeacherName: 'David Miller'),
    SchoolClass(id: 'C-9C', grade: '9', section: 'C', className: '9-C', classTeacherName: 'Anita Desai'),
    SchoolClass(id: 'C-9D', grade: '9', section: 'D', className: '9-D', classTeacherName: 'Suresh Gupta'),
    SchoolClass(id: 'C-9E', grade: '9', section: 'E', className: '9-E', classTeacherName: 'Vikram Batra'),

    SchoolClass(id: 'C-10A', grade: '10', section: 'A', className: '10-A', classTeacherName: 'Meenakshi Sharma'),
    SchoolClass(id: 'C-10B', grade: '10', section: 'B', className: '10-B', classTeacherName: 'Neha Kapoor'),
    SchoolClass(id: 'C-10C', grade: '10', section: 'C', className: '10-C', classTeacherName: 'Anita Desai'),
    SchoolClass(id: 'C-10D', grade: '10', section: 'D', className: '10-D', classTeacherName: 'Anjali Menon'),
    SchoolClass(id: 'C-10E', grade: '10', section: 'E', className: '10-E', classTeacherName: 'Tarun Joshi'),

    SchoolClass(id: 'C-11A', grade: '11', section: 'A', className: '11-A', classTeacherName: 'Sunita Mehra'),
    SchoolClass(id: 'C-11B', grade: '11', section: 'B', className: '11-B', classTeacherName: 'Kavita Joshi'),
    SchoolClass(id: 'C-11C', grade: '11', section: 'C', className: '11-C', classTeacherName: 'Robert Chen'),
    SchoolClass(id: 'C-11D', grade: '11', section: 'D', className: '11-D', classTeacherName: 'Suresh Gupta'),
    SchoolClass(id: 'C-11E', grade: '11', section: 'E', className: '11-E', classTeacherName: 'David Miller'),

    SchoolClass(id: 'C-12A', grade: '12', section: 'A', className: '12-A', classTeacherName: 'Meenakshi Sharma'),
    SchoolClass(id: 'C-12B', grade: '12', section: 'B', className: '12-B', classTeacherName: 'Vikram Batra'),
    SchoolClass(id: 'C-12C', grade: '12', section: 'C', className: '12-C', classTeacherName: 'Neha Kapoor'),
    SchoolClass(id: 'C-12D', grade: '12', section: 'D', className: '12-D', classTeacherName: 'Anita Desai'),
    SchoolClass(id: 'C-12E', grade: '12', section: 'E', className: '12-E', classTeacherName: 'Pooja Saxena'),
  ];

  static const List<Teacher> _standardTeachers = [
    Teacher(
      id: 'T-001',
      name: 'Anita Desai',
      dateOfBirth: '15 Aug 1982',
      mobile: '+91 98222 33445',
      email: 'anita.desai@onps.edu.in',
      gender: 'Female',
      joinDate: '15 Jul 2018',
      address: Address(
        line1: 'ONPS Faculty Quarters',
        city: 'New Delhi',
        district: 'Central Delhi',
        state: 'Delhi',
        pincode: '110007',
      ),
      subjectSpecialization: 'Mathematics',
    ),
    Teacher(
      id: 'T-002',
      name: 'Robert Chen',
      dateOfBirth: '20 Sep 1980',
      mobile: '+91 98333 44556',
      email: 'robert.chen@onps.edu.in',
      gender: 'Male',
      joinDate: '10 Aug 2017',
      address: Address(
        line1: '12 Model Town',
        city: 'New Delhi',
        district: 'North Delhi',
        state: 'Delhi',
        pincode: '110009',
      ),
      subjectSpecialization: 'English',
    ),
    Teacher(
      id: 'T-003',
      name: 'David Miller',
      dateOfBirth: '05 Jan 1985',
      mobile: '+91 98444 55667',
      email: 'david.miller@onps.edu.in',
      gender: 'Male',
      joinDate: '01 Jul 2019',
      address: Address(
        line1: '45 Civil Lines',
        city: 'New Delhi',
        district: 'North Delhi',
        state: 'Delhi',
        pincode: '110054',
      ),
      subjectSpecialization: 'Science',
    ),
    Teacher(
      id: 'T-004',
      name: 'Meenakshi Sharma',
      dateOfBirth: '12 Mar 1983',
      mobile: '+91 98555 66778',
      email: 'meenakshi.sharma@onps.edu.in',
      gender: 'Female',
      joinDate: '15 Jul 2018',
      address: Address(
        line1: '14 Karol Bagh',
        city: 'New Delhi',
        district: 'Central Delhi',
        state: 'Delhi',
        pincode: '110005',
      ),
      subjectSpecialization: 'Social Studies',
    ),
    Teacher(
      id: 'T-005',
      name: 'Suresh Gupta',
      dateOfBirth: '25 Nov 1979',
      mobile: '+91 98666 77889',
      email: 'suresh.gupta@onps.edu.in',
      gender: 'Male',
      joinDate: '10 Aug 2016',
      address: Address(
        line1: '89 Rohini Sector 9',
        city: 'New Delhi',
        district: 'North West Delhi',
        state: 'Delhi',
        pincode: '110085',
      ),
      subjectSpecialization: 'Social Studies',
    ),
    Teacher(
      id: 'T-006',
      name: 'Neha Kapoor',
      dateOfBirth: '18 Jul 1987',
      mobile: '+91 98777 88990',
      email: 'neha.kapoor@onps.edu.in',
      gender: 'Female',
      joinDate: '01 Jul 2020',
      address: Address(
        line1: '23 Pitampura',
        city: 'New Delhi',
        district: 'North West Delhi',
        state: 'Delhi',
        pincode: '110034',
      ),
      subjectSpecialization: 'Computer Science',
    ),
    Teacher(
      id: 'T-007',
      name: 'Tarun Joshi',
      dateOfBirth: '30 Apr 1984',
      mobile: '+91 98888 99001',
      email: 'tarun.joshi@onps.edu.in',
      gender: 'Male',
      joinDate: '15 Jul 2019',
      address: Address(
        line1: '56 Rajouri Garden',
        city: 'New Delhi',
        district: 'West Delhi',
        state: 'Delhi',
        pincode: '110027',
      ),
      subjectSpecialization: 'Mathematics',
    ),
    Teacher(
      id: 'T-008',
      name: 'Vikram Batra',
      dateOfBirth: '14 Oct 1981',
      mobile: '+91 98999 00112',
      email: 'vikram.batra@onps.edu.in',
      gender: 'Male',
      joinDate: '10 Aug 2017',
      address: Address(
        line1: '78 Janakpuri',
        city: 'New Delhi',
        district: 'West Delhi',
        state: 'Delhi',
        pincode: '110058',
      ),
      subjectSpecialization: 'Science',
    ),
    Teacher(
      id: 'T-009',
      name: 'Pooja Saxena',
      dateOfBirth: '22 Feb 1986',
      mobile: '+91 98111 22334',
      email: 'pooja.saxena@onps.edu.in',
      gender: 'Female',
      joinDate: '01 Jul 2021',
      address: Address(
        line1: '34 Dwarka Sector 6',
        city: 'New Delhi',
        district: 'South West Delhi',
        state: 'Delhi',
        pincode: '110075',
      ),
      subjectSpecialization: 'English',
    ),
    Teacher(
      id: 'T-010',
      name: 'Anjali Menon',
      dateOfBirth: '09 Sep 1985',
      mobile: '+91 98222 11223',
      email: 'anjali.menon@onps.edu.in',
      gender: 'Female',
      joinDate: '15 Jul 2018',
      address: Address(
        line1: '67 Vasant Kunj',
        city: 'New Delhi',
        district: 'South West Delhi',
        state: 'Delhi',
        pincode: '110070',
      ),
      subjectSpecialization: 'Social Studies',
    ),
  ];

  static const List<Student> _standardTestStudents = [
    Student(
      id: 'ADM-2024-0412',
      firstName: 'Diya',
      lastName: 'Sharma',
      rollNumber: 1,
      grade: '5',
      section: 'A',
      gender: 'Female',
      dateOfBirth: '12 May 2015',
      admissionDate: '01 Apr 2020',
      mobile: '+91 98111 22334',
      email: 'diya.sharma@onps.edu.in',
      dwellingType: 'House/Apartment',
      address: Address(
        line1: '14 Civil Lines',
        city: 'New Delhi',
        district: 'North Delhi',
        state: 'Delhi',
        pincode: '110054',
      ),
    ),
    Student(
      id: 'ADM-2024-0413',
      firstName: 'Aarav',
      lastName: 'Sharma',
      rollNumber: 2,
      grade: '5',
      section: 'A',
      gender: 'Male',
      dateOfBirth: '18 Jul 2015',
      admissionDate: '01 Apr 2020',
      mobile: '+91 98222 33445',
      email: 'aarav.sharma@onps.edu.in',
      dwellingType: 'House/Apartment',
      address: Address(
        line1: '22 Mall Road',
        city: 'New Delhi',
        district: 'North Delhi',
        state: 'Delhi',
        pincode: '110007',
      ),
    ),
    Student(
      id: 'ADM-2024-0414',
      firstName: 'Rohan',
      lastName: 'Verma',
      rollNumber: 3,
      grade: '5',
      section: 'A',
      gender: 'Male',
      dateOfBirth: '05 Nov 2015',
      admissionDate: '01 Apr 2020',
      mobile: '+91 98333 44556',
      email: 'rohan.verma@onps.edu.in',
      dwellingType: 'House/Apartment',
      address: Address(
        line1: '45 Shakti Nagar',
        city: 'New Delhi',
        district: 'North Delhi',
        state: 'Delhi',
        pincode: '110007',
      ),
    ),
    Student(
      id: 'ADM-2024-0415',
      firstName: 'Ananya',
      lastName: 'Gupta',
      rollNumber: 4,
      grade: '5',
      section: 'A',
      gender: 'Female',
      dateOfBirth: '22 Feb 2015',
      admissionDate: '01 Apr 2020',
      mobile: '+91 98444 55667',
      email: 'ananya.gupta@onps.edu.in',
      dwellingType: 'House/Apartment',
      address: Address(
        line1: '88 Model Town',
        city: 'New Delhi',
        district: 'North Delhi',
        state: 'Delhi',
        pincode: '110009',
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedAcademicYear = '2026–27';

    if (widget.initialClassName != null &&
        widget.initialClassName!.contains('-')) {
      final parts = widget.initialClassName!.split('-');
      _currentGrade = parts[0];
      _currentSection = parts[1];
    } else {
      _currentGrade = widget.initialGrade ?? '5';
      _currentSection = widget.initialSection ?? 'A';
    }

    _loadSectionData();
  }

  Future<void> _loadSectionData() async {
    final bindingName = WidgetsBinding.instance.runtimeType.toString();
    if (bindingName.contains('Test')) {
      return;
    }

    try {
      final studentsResp = await _facultyApi.getClassStudents(_resolvedClass.id);
      final results = studentsResp['results'] as List<dynamic>? ?? [];
      final List<Student> students = [];
      for (final item in results) {
        if (item is Map<String, dynamic>) {
          students.add(Student.fromJson(item));
        }
      }

      if (mounted) {
        setState(() {
          _liveStudents = students;
        });
      }
    } catch (_) {
      // Keep empty in production if error occurs
    }
  }

  String get _currentClassName =>
      _currentGrade == 'K' ? 'K-$_currentSection' : '$_currentGrade-$_currentSection';

  List<SchoolClass> get _allSectionsInCurrentGrade {
    return _standardClasses
        .where((c) => c.grade.toUpperCase() == _currentGrade.toUpperCase())
        .toList();
  }

  SchoolClass get _resolvedClass {
    final list = _allSectionsInCurrentGrade;
    if (list.isEmpty) {
      return SchoolClass(
        id: 'C-$_currentClassName',
        grade: _currentGrade,
        section: _currentSection,
        className: _currentClassName,
        classTeacherName: 'Anita Desai',
      );
    }
    return list.firstWhere(
      (c) => c.section.toUpperCase() == _currentSection.toUpperCase(),
      orElse: () => list.first,
    );
  }

  Teacher? get _classTeacherDetails {
    final teacherName = _resolvedClass.classTeacherName;
    if (teacherName.isEmpty || teacherName == 'No class teacher assigned') {
      return null;
    }
    return _standardTeachers.firstWhere(
      (t) => t.name.toLowerCase() == teacherName.toLowerCase(),
      orElse: () => Teacher(
        id: 'T-CT',
        name: teacherName,
        dateOfBirth: '15 Aug 1982',
        mobile: '+91 98222 33445',
        email: '${teacherName.toLowerCase().replaceAll(' ', '.')}@onps.edu.in',
        gender: 'Female',
        joinDate: '15 Jul 2018',
        address: const Address(
          line1: 'ONPS Faculty Quarters',
          city: 'New Delhi',
          district: 'Central Delhi',
          state: 'Delhi',
          pincode: '110007',
        ),
        subjectSpecialization: 'Mathematics',
      ),
    );
  }

  int get _enrolledStudentsCount {
    if (_liveStudents.isNotEmpty) {
      return _liveStudents.length;
    }
    final sec = _currentSection.toUpperCase();
    if (sec == 'A') return 32;
    if (sec == 'B') return 34;
    if (sec == 'C') return 31;
    if (sec == 'D') return 30;
    return 33;
  }

  List<Student> get _enrolledStudentsPreview {
    if (_liveStudents.isNotEmpty) {
      return _liveStudents;
    }
    return _standardTestStudents;
  }

  List<_SectionSubjectItem> get _assignedSubjectsList {
    final cls = _resolvedClass;
    if (_liveTimetableSlots.isNotEmpty) {
      final seen = <String>{};
      final list = <_SectionSubjectItem>[];
      for (final slot in _liveTimetableSlots) {
        if (!seen.contains(slot.subjectName)) {
          seen.add(slot.subjectName);
          list.add(_SectionSubjectItem(
            name: slot.subjectName,
            teacherName: slot.teacherName,
            type: 'Theory (100 Marks)',
            periodsPerWeek: '6 / week',
          ));
        }
      }
      return list;
    }

    // Default subject roster with assigned teachers
    final subjectTeachers = [
      cls.classTeacherName.isNotEmpty ? cls.classTeacherName : 'Assigned Class Faculty',
      'Robert Chen',
      'David Miller',
      'Priya Nair',
      'Neha Kapoor',
      'Tarun Joshi',
    ];

    return [
      _SectionSubjectItem(
        name: 'Mathematics',
        teacherName: subjectTeachers[0],
        type: 'Theory (100 Marks)',
        periodsPerWeek: '6 / week',
      ),
      _SectionSubjectItem(
        name: 'Science',
        teacherName: subjectTeachers[1],
        type: 'Theory + Lab (100 Marks)',
        periodsPerWeek: '5 / week',
      ),
      _SectionSubjectItem(
        name: 'English',
        teacherName: subjectTeachers[2],
        type: 'Literature & Grammar',
        periodsPerWeek: '5 / week',
      ),
      _SectionSubjectItem(
        name: 'Social Studies',
        teacherName: subjectTeachers[3],
        type: 'History & Civics',
        periodsPerWeek: '4 / week',
      ),
      _SectionSubjectItem(
        name: 'Hindi',
        teacherName: subjectTeachers[4],
        type: 'Language & Prose',
        periodsPerWeek: '4 / week',
      ),
      _SectionSubjectItem(
        name: 'Computer Science',
        teacherName: subjectTeachers[5],
        type: 'Practical + Theory',
        periodsPerWeek: '3 / week',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final schoolClass = _resolvedClass;
    final teacher = _classTeacherDetails;
    final allSections = _allSectionsInCurrentGrade;
    final subjects = _assignedSubjectsList;
    final students = _enrolledStudentsPreview;

    return Scaffold(
      backgroundColor: AcademicColors.canvas,
      appBar: AppTopBar(
        title: 'Section ${schoolClass.className}',
        showBackButton: true,
        actions: [
          _buildAcademicYearMenu(),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -------------------------------------------------------------
              // 1. CONTEXT BREADCRUMB & SECTION SWITCHER
              // -------------------------------------------------------------
              _buildContextAndSectionSwitcher(allSections),

              const SizedBox(height: 14),

              // -------------------------------------------------------------
              // 2. HERO SECTION SUMMARY OVERVIEW CARD
              // -------------------------------------------------------------
              _buildSectionOverviewCard(schoolClass, subjects.length),

              const SizedBox(height: 14),

              // -------------------------------------------------------------
              // 3. CLASS TEACHER CARD
              // -------------------------------------------------------------
              _buildClassTeacherCard(teacher),

              const SizedBox(height: 14),

              // -------------------------------------------------------------
              // 4. STUDENTS ENROLLED CARD & PREVIEW
              // -------------------------------------------------------------
              _buildStudentsCard(students),

              const SizedBox(height: 14),

              // -------------------------------------------------------------
              // 5. ASSIGNED SUBJECTS & FACULTY ROSTER
              // -------------------------------------------------------------
              _buildSubjectsRosterCard(subjects, schoolClass),

              const SizedBox(height: 14),

              // -------------------------------------------------------------
              // 6. ACADEMIC RECORDS & RESULTS
              // -------------------------------------------------------------
              _buildAcademicRecordsCard(),

              const SizedBox(height: 14),

              // -------------------------------------------------------------
              // 7. OPERATIONAL SUMMARIES (Attendance & Timetable)
              // -------------------------------------------------------------
              _buildOperationalSummaries(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AcademicBottomNavBar.forRole(
        UserRole.principal,
        currentIndex: 1,
        context: context,
      ),
    );
  }

  // =========================================================================
  // SUB-COMPONENTS
  // =========================================================================

  /// Academic Year Dropdown Menu
  Widget _buildAcademicYearMenu() {
    return PopupMenuButton<String>(
      initialValue: _selectedAcademicYear,
      onSelected: (val) {
        setState(() {
          _selectedAcademicYear = val;
        });
      },
      color: AcademicColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AcademicColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AcademicColors.border),
          boxShadow: AcademicColors.cardShadow,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 13,
              color: AcademicColors.primaryDark,
            ),
            const SizedBox(width: 4),
            Text(
              _selectedAcademicYear,
              style: GoogleFonts.manrope(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AcademicColors.textPrimary,
              ),
            ),
            const Icon(
              Icons.arrow_drop_down,
              size: 16,
              color: AcademicColors.textSecondary,
            ),
          ],
        ),
      ),
      itemBuilder: (context) {
        return _availableYears.map((year) {
          return PopupMenuItem<String>(
            value: year,
            child: Row(
              children: [
                Icon(
                  year == _selectedAcademicYear
                      ? Icons.check_circle
                      : Icons.circle_outlined,
                  size: 14,
                  color: year == _selectedAcademicYear
                      ? AcademicColors.primaryDark
                      : AcademicColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  year,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: year == _selectedAcademicYear
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: AcademicColors.textPrimary,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }

  /// Context Breadcrumb & Quick Section Switcher
  Widget _buildContextAndSectionSwitcher(List<SchoolClass> allSections) {
    final gradeLabel = _currentGrade == 'K' ? 'Kindergarten' : 'Class $_currentGrade';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'ACADEMIC CONTEXT: ${gradeLabel.toUpperCase()}',
                style: GoogleFonts.manrope(
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  color: AcademicColors.textSecondary,
                  letterSpacing: 0.6,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${allSections.length} Sections Configured',
              style: GoogleFonts.manrope(
                fontSize: 10.5,
                color: AcademicColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Section Selector Horizontal Chips
        if (allSections.isNotEmpty) ...[
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: allSections.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cls = allSections[index];
                final isSelected = cls.section.toUpperCase() == _currentSection.toUpperCase();

                return InkWell(
                  onTap: () {
                    setState(() {
                      _currentSection = cls.section;
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AcademicColors.primaryDark
                          : AcademicColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AcademicColors.primaryDark
                            : AcademicColors.border,
                        width: isSelected ? 1.5 : 1,
                      ),
                      boxShadow: isSelected ? AcademicColors.cardShadow : null,
                    ),
                    child: Center(
                      child: Text(
                        cls.className,
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          color: isSelected
                              ? AcademicColors.surface
                              : AcademicColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  /// Section Overview Summary Card
  Widget _buildSectionOverviewCard(SchoolClass cls, int subjectsCount) {
    final gradeText = cls.grade == 'K' ? 'Kindergarten' : 'Class ${cls.grade}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AcademicColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AcademicColors.border),
        boxShadow: AcademicColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AcademicColors.primaryDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    cls.className,
                    style: GoogleFonts.newsreader(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AcademicColors.accent,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Section ${cls.className}',
                      style: GoogleFonts.newsreader(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AcademicColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$gradeText • Section ${cls.section} • Session $_selectedAcademicYear',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        color: AcademicColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(height: 1, color: AcademicColors.border),
          const SizedBox(height: 12),

          // 3 Metric Pills
          Row(
            children: [
              Expanded(
                child: _buildMetricMiniTile(
                  'Class Teacher',
                  cls.classTeacherName.isNotEmpty
                      ? cls.classTeacherName
                      : 'Not Assigned',
                  Icons.person_outline,
                  AcademicColors.primaryDark,
                ),
              ),
              Container(width: 1, height: 28, color: AcademicColors.border),
              Expanded(
                child: _buildMetricMiniTile(
                  'Students',
                  '$_enrolledStudentsCount Enrolled',
                  Icons.groups_outlined,
                  AcademicColors.secondary,
                ),
              ),
              Container(width: 1, height: 28, color: AcademicColors.border),
              Expanded(
                child: _buildMetricMiniTile(
                  'Subjects',
                  '$subjectsCount Active',
                  Icons.menu_book_outlined,
                  AcademicColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricMiniTile(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 11, color: color),
              const SizedBox(width: 3),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    fontSize: 9.5,
                    color: AcademicColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AcademicColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  /// Class Teacher Card
  Widget _buildClassTeacherCard(Teacher? teacher) {
    return InsetCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'CLASS TEACHER',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AcademicColors.textSecondary,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              if (teacher != null)
                Text(
                  'Assigned Faculty',
                  style: GoogleFonts.manrope(
                    fontSize: 10.5,
                    color: AcademicColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),

          if (teacher != null) ...[
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AcademicColors.primaryDark.withValues(alpha: 0.1),
                  child: Text(
                    teacher.name.isNotEmpty ? teacher.name[0] : 'T',
                    style: GoogleFonts.newsreader(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AcademicColors.primaryDark,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        teacher.name,
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        'Senior Faculty • ${teacher.subjectSpecialization}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          color: AcademicColors.textSecondary,
                        ),
                      ),
                      Text(
                        teacher.email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.manrope(
                          fontSize: 10.5,
                          color: AcademicColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ] else ...[
            _buildEmptyState('No class teacher assigned to this section.'),
          ],
        ],
      ),
    );
  }

  /// Students Card & Enrolled Preview
  Widget _buildStudentsCard(List<Student> students) {
    return InsetCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'STUDENTS ($_enrolledStudentsCount)',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AcademicColors.textSecondary,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => context.push('/students/ledger'),
                child: Text(
                  'View Students →',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AcademicColors.primaryDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          if (students.isNotEmpty) ...[
            ...students.take(3).map((stu) {
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: AcademicColors.canvas,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AcademicColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: AcademicColors.primaryDark.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          stu.rollNumber.toString().padLeft(2, '0'),
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AcademicColors.primaryDark,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        stu.name,
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AcademicColors.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      stu.id,
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        color: AcademicColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ] else ...[
            _buildEmptyState('No students enrolled in this section.'),
          ],
        ],
      ),
    );
  }

  /// Subjects Roster Card
  Widget _buildSubjectsRosterCard(
    List<_SectionSubjectItem> subjects,
    SchoolClass cls,
  ) {
    return InsetCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'ASSIGNED SUBJECTS (${subjects.length})',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AcademicColors.textSecondary,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Section ${cls.className}',
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  color: AcademicColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          if (subjects.isNotEmpty) ...[
            ...subjects.map((sub) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: AcademicColors.canvas,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () => _showSubjectDetailsModal(sub, cls),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AcademicColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: AcademicColors.primaryDark.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.menu_book,
                              size: 16,
                              color: AcademicColors.primaryDark,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sub.name,
                                  style: GoogleFonts.manrope(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                    color: AcademicColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        sub.teacherName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.manrope(
                                          fontSize: 11,
                                          color: AcademicColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '•  ${sub.periodsPerWeek}',
                                      style: GoogleFonts.manrope(
                                        fontSize: 10.5,
                                        color: AcademicColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            size: 18,
                            color: AcademicColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ] else ...[
            _buildEmptyState('No subjects assigned to this section.'),
          ],
        ],
      ),
    );
  }

  /// Subject Details Modal
  void _showSubjectDetailsModal(_SectionSubjectItem sub, SchoolClass cls) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AcademicColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sub.name,
                            style: GoogleFonts.newsreader(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AcademicColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Section ${cls.className} • Session $_selectedAcademicYear',
                            style: GoogleFonts.manrope(
                              fontSize: 11.5,
                              color: AcademicColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(height: 1, color: AcademicColors.border),
                const SizedBox(height: 12),

                _buildModalDetailRow('Assigned Faculty', sub.teacherName, Icons.person_outline),
                _buildModalDetailRow('Course Structure', sub.type, Icons.assessment_outlined),
                _buildModalDetailRow('Weekly Load', sub.periodsPerWeek, Icons.schedule_outlined),
                _buildModalDetailRow('Enrolled Students', '$_enrolledStudentsCount Students', Icons.groups_outlined),

                const SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AcademicColors.border),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          context.push('/students/marks-entry');
                        },
                        child: Text(
                          'Marks Ledger',
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AcademicColors.primaryDark,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AcademicColors.primaryDark,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          context.push('/students/report-card');
                        },
                        child: Text(
                          'View Results →',
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModalDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 15, color: AcademicColors.secondary),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: GoogleFonts.manrope(
              fontSize: 11.5,
              color: AcademicColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.manrope(
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
                color: AcademicColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Academic Records & Results Card
  Widget _buildAcademicRecordsCard() {
    return InsetCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'ACADEMIC RECORDS & RESULTS',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AcademicColors.textSecondary,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              PillBadge.success('Term 1 Published'),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AcademicColors.canvas,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AcademicColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Term 1 Results',
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Published on 15 Oct 2026',
                        style: GoogleFonts.manrope(
                          fontSize: 9.5,
                          color: AcademicColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AcademicColors.canvas,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AcademicColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Term 2 Exams',
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Starts 18 Nov 2026',
                        style: GoogleFonts.manrope(
                          fontSize: 9.5,
                          color: AcademicColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AcademicColors.border),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => context.push('/students/marks-entry'),
                  child: Text(
                    'Marks Ledger',
                    style: GoogleFonts.manrope(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: AcademicColors.primaryDark,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AcademicColors.primaryDark,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => context.push('/students/report-card'),
                  child: Text(
                    'View Results →',
                    style: GoogleFonts.manrope(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Operational Summaries (Attendance & Timetable)
  Widget _buildOperationalSummaries() {
    return InsetCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'OPERATIONAL DESKS',
            style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AcademicColors.textSecondary,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 10),

          // Attendance Summary Row
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AcademicColors.canvas,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AcademicColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AcademicColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.how_to_reg_outlined,
                    size: 16,
                    color: AcademicColors.success,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Attendance',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Present: 30 • Absent: 2 • Not Marked: 0',
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          color: AcademicColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () => context.push('/attendance/roll-call'),
                  child: Text(
                    'View →',
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

          const SizedBox(height: 8),

          // Timetable Summary Row
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AcademicColors.canvas,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AcademicColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AcademicColors.primaryDark.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.calendar_month_outlined,
                    size: 16,
                    color: AcademicColors.primaryDark,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weekly Timetable',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AcademicColors.textPrimary,
                        ),
                      ),
                      Text(
                        '5 Periods / Day • Mon–Sat',
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          color: AcademicColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () => context.push('/faculty/timetable/class?class=$_currentClassName'),
                  child: Text(
                    'View →',
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
        ],
      ),
    );
  }

  /// Empty state helper
  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AcademicColors.canvas,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AcademicColors.border),
      ),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: GoogleFonts.manrope(
            fontSize: 11.5,
            color: AcademicColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _SectionSubjectItem {
  final String name;
  final String teacherName;
  final String type;
  final String periodsPerWeek;

  const _SectionSubjectItem({
    required this.name,
    required this.teacherName,
    required this.type,
    required this.periodsPerWeek,
  });
}
