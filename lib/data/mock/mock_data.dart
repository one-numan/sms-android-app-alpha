// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Production-Grade In-Memory Static Mock Repositories & Fixtures
// 100% Aligned to Backend Models & Banned-Term Free
// ==============================================================================

import '../../models/models.dart';
import '../repositories/repositories.dart';

class MockData {
  static const String schoolName = 'One Numan Public School';
  static const String schoolAbbr = 'ONPS';
  static const String session = 'Session 2026-27';
  static const String campusAddress = 'Civil Lines Campus, New Delhi 110054';

  // --- 1. Students ---
  static final List<Student> students = [
    const Student(
      id: 'ADM-2024-0412',
      firstName: 'Diya',
      lastName: 'Sharma',
      dateOfBirth: '14 Aug 2015',
      mobile: '+91 98765 43210',
      email: 'diya.sharma@example.com',
      gender: 'Female',
      admissionDate: '01 Apr 2024',
      rollNumber: 14,
      grade: '5',
      section: 'A',
      address: Address(
        line1: 'Flat 402, Royal Palms',
        city: 'New Delhi',
        district: 'Central Delhi',
        state: 'Delhi',
        pincode: '110054',
      ),
      dwellingType: 'Flat',
    ),
    const Student(
      id: 'ADM-2026-0891',
      firstName: 'Aarav',
      lastName: 'Sharma',
      dateOfBirth: '05 May 2018',
      mobile: '+91 98765 43210',
      email: 'aarav.sharma@example.com',
      gender: 'Male',
      admissionDate: '01 Apr 2026',
      rollNumber: 3,
      grade: '2',
      section: 'B',
      address: Address(
        line1: 'Flat 402, Royal Palms',
        city: 'New Delhi',
        district: 'Central Delhi',
        state: 'Delhi',
        pincode: '110054',
      ),
      dwellingType: 'Flat',
    ),
    const Student(
      id: 'ADM-2023-0115',
      firstName: 'Rohan',
      lastName: 'Verma',
      dateOfBirth: '22 Mar 2015',
      mobile: '+91 98111 22334',
      email: 'rohan.verma@example.com',
      gender: 'Male',
      admissionDate: '01 Apr 2023',
      rollNumber: 21,
      grade: '5',
      section: 'A',
      address: Address(
        line1: '12-B Model Town',
        city: 'New Delhi',
        district: 'North Delhi',
        state: 'Delhi',
        pincode: '110009',
      ),
      dwellingType: 'House/Apartment',
    ),
    const Student(
      id: 'ADM-2024-0520',
      firstName: 'Aarav',
      lastName: 'Patel',
      dateOfBirth: '02 Feb 2015',
      mobile: '+91 98221 55678',
      email: 'a.patel@onps.edu.in',
      gender: 'Male',
      admissionDate: '05 Apr 2024',
      rollNumber: 1,
      grade: '5',
      section: 'A',
      address: Address(
        line1: '88 Civil Lines',
        city: 'New Delhi',
        district: 'North Delhi',
        state: 'Delhi',
        pincode: '110054',
      ),
      dwellingType: 'House/Apartment',
    ),
    const Student(
      id: 'ADM-2024-0633',
      firstName: 'Ananya',
      lastName: 'Sharma',
      dateOfBirth: '19 Nov 2015',
      mobile: '+91 98450 11223',
      email: 'ananya.s@example.com',
      gender: 'Female',
      admissionDate: '10 Apr 2024',
      rollNumber: 14,
      grade: '5',
      section: 'C',
      address: Address(
        line1: '24 Gulmohar Park',
        city: 'New Delhi',
        district: 'South Delhi',
        state: 'Delhi',
        pincode: '110049',
      ),
      dwellingType: 'House/Apartment',
    ),
    const Student(
      id: 'ADM-2024-0638',
      firstName: 'Vihaan',
      lastName: 'Gupta',
      dateOfBirth: '11 Jul 2015',
      mobile: '+91 98712 34567',
      email: 'vihaan.g@example.com',
      gender: 'Male',
      admissionDate: '10 Apr 2024',
      rollNumber: 18,
      grade: '5',
      section: 'C',
      address: Address(
        line1: '102 Hauz Khas',
        city: 'New Delhi',
        district: 'South Delhi',
        state: 'Delhi',
        pincode: '110016',
      ),
      dwellingType: 'Flat',
    ),
    const Student(
      id: 'ADM-2024-0642',
      firstName: 'Myra',
      lastName: 'Kapoor',
      dateOfBirth: '29 Aug 2015',
      mobile: '+91 98990 88776',
      email: 'myra.k@example.com',
      gender: 'Female',
      admissionDate: '12 Apr 2024',
      rollNumber: 21,
      grade: '5',
      section: 'C',
      address: Address(
        line1: '15 Vasant Vihar',
        city: 'New Delhi',
        district: 'South West Delhi',
        state: 'Delhi',
        pincode: '110057',
      ),
      dwellingType: 'House/Apartment',
    ),
    const Student(
      id: 'ADM-2022-0901',
      firstName: 'Kabir',
      lastName: 'Mehta',
      dateOfBirth: '03 Mar 2010',
      mobile: '+91 98100 44556',
      email: 'kabir.m@example.com',
      gender: 'Male',
      admissionDate: '01 Apr 2022',
      rollNumber: 12,
      grade: '10',
      section: 'A',
      address: Address(
        line1: '78 Greater Kailash',
        city: 'New Delhi',
        district: 'South Delhi',
        state: 'Delhi',
        pincode: '110048',
      ),
      dwellingType: 'House/Apartment',
    ),
    const Student(
      id: 'ADM-2020-0345',
      firstName: 'Riya',
      lastName: 'Sen',
      dateOfBirth: '14 Jan 2008',
      mobile: '+91 98188 77665',
      email: 'riya.sen@example.com',
      gender: 'Female',
      admissionDate: '01 Apr 2020',
      rollNumber: 8,
      grade: '12',
      section: 'A',
      address: Address(
        line1: '32 Defence Colony',
        city: 'New Delhi',
        district: 'South Delhi',
        state: 'Delhi',
        pincode: '110024',
      ),
      dwellingType: 'Flat',
    ),
    const Student(
      id: 'ADM-2025-0102',
      firstName: 'Ishaan',
      lastName: 'Patel',
      dateOfBirth: '09 Oct 2019',
      mobile: '+91 98234 56789',
      email: 'ishaan.p@example.com',
      gender: 'Male',
      admissionDate: '01 Apr 2025',
      rollNumber: 5,
      grade: '1',
      section: 'A',
      address: Address(
        line1: '54 Punjabi Bagh',
        city: 'New Delhi',
        district: 'West Delhi',
        state: 'Delhi',
        pincode: '110026',
      ),
      dwellingType: 'House/Apartment',
    ),
  ];

  // --- 2. Teachers ---
  static final List<Teacher> teachers = [
    const Teacher(
      id: 'T-1',
      name: 'Anita Desai',
      dateOfBirth: '12 Jun 1984',
      mobile: '+91 98222 33445',
      email: 'anita.desai@onps.edu.in',
      gender: 'Female',
      joinDate: '15 Jul 2018',
      address: Address(
        line1: '45 Shakti Nagar',
        city: 'New Delhi',
        district: 'North Delhi',
        state: 'Delhi',
        pincode: '110007',
      ),
      subjectSpecialization: 'Mathematics',
    ),
    const Teacher(
      id: 'T-2',
      name: 'Robert Chen',
      dateOfBirth: '28 Sep 1980',
      mobile: '+91 98333 44556',
      email: 'robert.chen@onps.edu.in',
      gender: 'Male',
      joinDate: '10 Aug 2016',
      address: Address(
        line1: '88 Civil Lines',
        city: 'New Delhi',
        district: 'Central Delhi',
        state: 'Delhi',
        pincode: '110054',
      ),
      subjectSpecialization: 'Science',
    ),
    const Teacher(
      id: 'T-3',
      name: 'David Miller',
      dateOfBirth: '19 Nov 1988',
      mobile: '+91 98444 55667',
      email: 'david.miller@onps.edu.in',
      gender: 'Male',
      joinDate: '01 Nov 2020',
      address: Address(
        line1: '21 Mall Road',
        city: 'New Delhi',
        district: 'North Delhi',
        state: 'Delhi',
        pincode: '110007',
      ),
      subjectSpecialization: 'English',
    ),
    const Teacher(
      id: 'T-4',
      name: 'Neha Kapoor',
      dateOfBirth: '08 Mar 1986',
      mobile: '+91 98555 66778',
      email: 'neha.kapoor@onps.edu.in',
      gender: 'Female',
      joinDate: '12 Jul 2019',
      address: Address(
        line1: '34 Kamla Nagar',
        city: 'New Delhi',
        district: 'North Delhi',
        state: 'Delhi',
        pincode: '110007',
      ),
      subjectSpecialization: 'Hindi',
    ),
    const Teacher(
      id: 'T-5',
      name: 'Tarun Joshi',
      dateOfBirth: '14 Jan 1989',
      mobile: '+91 98666 77889',
      email: 'tarun.joshi@onps.edu.in',
      gender: 'Male',
      joinDate: '15 Jan 2021',
      address: Address(
        line1: '12 Model Town III',
        city: 'New Delhi',
        district: 'North Delhi',
        state: 'Delhi',
        pincode: '110009',
      ),
      subjectSpecialization: 'Computer Science',
    ),
    const Teacher(
      id: 'T-6',
      name: 'Suman Rao',
      dateOfBirth: '22 Apr 1983',
      mobile: '+91 98777 88990',
      email: 'suman.rao@onps.edu.in',
      gender: 'Female',
      joinDate: '05 Aug 2017',
      address: Address(
        line1: '78 Mukherjee Nagar',
        city: 'New Delhi',
        district: 'North Delhi',
        state: 'Delhi',
        pincode: '110009',
      ),
      subjectSpecialization: 'Social Studies',
    ),
    const Teacher(
      id: 'T-7',
      name: 'Pooja Saxena',
      dateOfBirth: '30 Jul 1987',
      mobile: '+91 98888 99001',
      email: 'pooja.saxena@onps.edu.in',
      gender: 'Female',
      joinDate: '01 Jul 2018',
      address: Address(
        line1: '19 Timarpur',
        city: 'New Delhi',
        district: 'North Delhi',
        state: 'Delhi',
        pincode: '110054',
      ),
      subjectSpecialization: 'Primary Education',
    ),
    const Teacher(
      id: 'T-8',
      name: 'Suresh Gupta',
      dateOfBirth: '05 Sep 1978',
      mobile: '+91 98999 00112',
      email: 'suresh.gupta@onps.edu.in',
      gender: 'Male',
      joinDate: '10 Jul 2015',
      address: Address(
        line1: '55 Roop Nagar',
        city: 'New Delhi',
        district: 'North Delhi',
        state: 'Delhi',
        pincode: '110007',
      ),
      subjectSpecialization: 'Social Studies',
    ),
    const Teacher(
      id: 'T-9',
      name: 'Meenakshi Sharma',
      dateOfBirth: '17 Dec 1985',
      mobile: '+91 98111 22334',
      email: 'meenakshi.sharma@onps.edu.in',
      gender: 'Female',
      joinDate: '15 Jul 2019',
      address: Address(
        line1: '62 Vijay Nagar',
        city: 'New Delhi',
        district: 'North Delhi',
        state: 'Delhi',
        pincode: '110009',
      ),
      subjectSpecialization: 'Hindi & Sanskrit',
    ),
    const Teacher(
      id: 'T-10',
      name: 'Vikram Batra',
      dateOfBirth: '25 May 1982',
      mobile: '+91 98222 33446',
      email: 'vikram.batra@onps.edu.in',
      gender: 'Male',
      joinDate: '20 Aug 2016',
      address: Address(
        line1: '14 Hudson Lane',
        city: 'New Delhi',
        district: 'North Delhi',
        state: 'Delhi',
        pincode: '110009',
      ),
      subjectSpecialization: 'Physics & Physical Education',
    ),
    const Teacher(
      id: 'T-11',
      name: 'Anjali Menon',
      dateOfBirth: '11 Oct 1988',
      mobile: '+91 98333 44557',
      email: 'anjali.menon@onps.edu.in',
      gender: 'Female',
      joinDate: '01 Nov 2020',
      address: Address(
        line1: '93 Kalyan Vihar',
        city: 'New Delhi',
        district: 'North Delhi',
        state: 'Delhi',
        pincode: '110009',
      ),
      subjectSpecialization: 'Mathematics',
    ),
    const Teacher(
      id: 'T-12',
      name: 'Sunita Mehra',
      dateOfBirth: '03 Feb 1985',
      mobile: '+91 98444 55668',
      email: 'sunita.mehra@onps.edu.in',
      gender: 'Female',
      joinDate: '15 Jul 2019',
      address: Address(
        line1: '27 Rana Pratap Bagh',
        city: 'New Delhi',
        district: 'North Delhi',
        state: 'Delhi',
        pincode: '110007',
      ),
      subjectSpecialization: 'Primary Education',
    ),
    const Teacher(
      id: 'T-13',
      name: 'Kavita Joshi',
      dateOfBirth: '19 Aug 1989',
      mobile: '+91 98555 66779',
      email: 'kavita.joshi@onps.edu.in',
      gender: 'Female',
      joinDate: '10 Jan 2021',
      address: Address(
        line1: '81 Gujranwala Town',
        city: 'New Delhi',
        district: 'North Delhi',
        state: 'Delhi',
        pincode: '110009',
      ),
      subjectSpecialization: 'Science',
    ),
  ];

  // --- 3. Staff ---
  static final List<Staff> staffMembers = [
    const Staff(
      id: 'S-1',
      name: 'Numan Khan',
      designation: 'Principal',
      mobile: '+91 98000 11223',
      email: 'principal@onps.edu.in',
      gender: 'Male',
      dateOfBirth: '15 Mar 1975',
      joinDate: '01 Jan 2015',
      address: Address(
        line1: 'Principal Residence, ONPS Campus',
        city: 'New Delhi',
        district: 'Central Delhi',
        state: 'Delhi',
        pincode: '110054',
      ),
    ),
    const Staff(
      id: 'S-2',
      name: 'Priya Nair',
      designation: 'Vice Principal',
      mobile: '+91 98000 22334',
      email: 'vp@onps.edu.in',
      gender: 'Female',
      dateOfBirth: '20 Aug 1978',
      joinDate: '15 Jul 2017',
      address: Address(
        line1: '14 Alipur Road',
        city: 'New Delhi',
        district: 'Central Delhi',
        state: 'Delhi',
        pincode: '110054',
      ),
    ),
    const Staff(
      id: 'S-3',
      name: 'Rajesh Verma',
      designation: 'Accountant',
      mobile: '+91 98000 33445',
      email: 'accounts@onps.edu.in',
      gender: 'Male',
      dateOfBirth: '08 Oct 1982',
      joinDate: '01 Apr 2019',
      address: Address(
        line1: '62 Rajpur Road',
        city: 'New Delhi',
        district: 'North Delhi',
        state: 'Delhi',
        pincode: '110007',
      ),
    ),
    const Staff(
      id: 'S-4',
      name: 'Sunita Mehra',
      designation: 'Librarian',
      mobile: '+91 98000 44556',
      email: 'library@onps.edu.in',
      gender: 'Female',
      dateOfBirth: '14 Feb 1985',
      joinDate: '12 Aug 2019',
      address: Address(
        line1: '33 Timarpur',
        city: 'New Delhi',
        district: 'North Delhi',
        state: 'Delhi',
        pincode: '110054',
      ),
    ),
    const Staff(
      id: 'S-5',
      name: 'Kavita Joshi',
      designation: 'Receptionist',
      mobile: '+91 98000 55667',
      email: 'reception@onps.edu.in',
      gender: 'Female',
      dateOfBirth: '05 May 1992',
      joinDate: '01 Feb 2021',
      address: Address(
        line1: '19 Maurice Nagar',
        city: 'New Delhi',
        district: 'North Delhi',
        state: 'Delhi',
        pincode: '110007',
      ),
    ),
  ];

  // --- 4. Classes & Subjects (K-12 Full Registry: 13 Grades, 58 Sections) ---
  static final List<SchoolClass> classes = [
    // Kindergarten
    const SchoolClass(id: 'C-KA', grade: 'K', section: 'A', className: 'K-A', classTeacherName: 'Pooja Saxena'),
    const SchoolClass(id: 'C-KB', grade: 'K', section: 'B', className: 'K-B', classTeacherName: 'Anjali Menon'),
    const SchoolClass(id: 'C-KC', grade: 'K', section: 'C', className: 'K-C', classTeacherName: 'Kavita Joshi'),
    const SchoolClass(id: 'C-KD', grade: 'K', section: 'D', className: 'K-D', classTeacherName: 'Sunita Mehra'),

    // Grade 1
    const SchoolClass(id: 'C-1A', grade: '1', section: 'A', className: '1-A', classTeacherName: 'Neha Kapoor'),
    const SchoolClass(id: 'C-1B', grade: '1', section: 'B', className: '1-B', classTeacherName: 'Tarun Joshi'),
    const SchoolClass(id: 'C-1C', grade: '1', section: 'C', className: '1-C', classTeacherName: 'Suman Rao'),
    const SchoolClass(id: 'C-1D', grade: '1', section: 'D', className: '1-D', classTeacherName: 'David Miller'),
    const SchoolClass(id: 'C-1E', grade: '1', section: 'E', className: '1-E', classTeacherName: 'Pooja Saxena'),

    // Grade 2
    const SchoolClass(id: 'C-2A', grade: '2', section: 'A', className: '2-A', classTeacherName: 'Suresh Gupta'),
    const SchoolClass(id: 'C-2B', grade: '2', section: 'B', className: '2-B', classTeacherName: 'Meenakshi Sharma'),
    const SchoolClass(id: 'C-2C', grade: '2', section: 'C', className: '2-C', classTeacherName: 'Vikram Batra'),
    const SchoolClass(id: 'C-2D', grade: '2', section: 'D', className: '2-D', classTeacherName: 'Robert Chen'),
    const SchoolClass(id: 'C-2E', grade: '2', section: 'E', className: '2-E', classTeacherName: 'Neha Kapoor'),

    // Grade 3
    const SchoolClass(id: 'C-3A', grade: '3', section: 'A', className: '3-A', classTeacherName: 'Anjali Menon'),
    const SchoolClass(id: 'C-3B', grade: '3', section: 'B', className: '3-B', classTeacherName: 'David Miller'),
    const SchoolClass(id: 'C-3C', grade: '3', section: 'C', className: '3-C', classTeacherName: 'Sunita Mehra'),
    const SchoolClass(id: 'C-3D', grade: '3', section: 'D', className: '3-D', classTeacherName: 'Tarun Joshi'),
    const SchoolClass(id: 'C-3E', grade: '3', section: 'E', className: '3-E', classTeacherName: 'Meenakshi Sharma'),

    // Grade 4
    const SchoolClass(id: 'C-4A', grade: '4', section: 'A', className: '4-A', classTeacherName: 'Robert Chen'),
    const SchoolClass(id: 'C-4B', grade: '4', section: 'B', className: '4-B', classTeacherName: 'Vikram Batra'),
    const SchoolClass(id: 'C-4C', grade: '4', section: 'C', className: '4-C', classTeacherName: 'Suresh Gupta'),
    const SchoolClass(id: 'C-4D', grade: '4', section: 'D', className: '4-D', classTeacherName: 'Pooja Saxena'),
    const SchoolClass(id: 'C-4E', grade: '4', section: 'E', className: '4-E', classTeacherName: 'Anjali Menon'),

    // Grade 5
    const SchoolClass(id: 'C-5A', grade: '5', section: 'A', className: '5-A', classTeacherName: 'Anita Desai'),
    const SchoolClass(id: 'C-5B', grade: '5', section: 'B', className: '5-B', classTeacherName: 'David Miller'),
    const SchoolClass(id: 'C-5C', grade: '5', section: 'C', className: '5-C', classTeacherName: 'Robert Chen'),
    const SchoolClass(id: 'C-5D', grade: '5', section: 'D', className: '5-D', classTeacherName: 'Meenakshi Sharma'),
    const SchoolClass(id: 'C-5E', grade: '5', section: 'E', className: '5-E', classTeacherName: 'Neha Kapoor'),

    // Grade 6
    const SchoolClass(id: 'C-6A', grade: '6', section: 'A', className: '6-A', classTeacherName: 'Suresh Gupta'),
    const SchoolClass(id: 'C-6B', grade: '6', section: 'B', className: '6-B', classTeacherName: 'Pooja Saxena'),
    const SchoolClass(id: 'C-6C', grade: '6', section: 'C', className: '6-C', classTeacherName: 'Vikram Batra'),
    const SchoolClass(id: 'C-6D', grade: '6', section: 'D', className: '6-D', classTeacherName: 'Anjali Menon'),
    const SchoolClass(id: 'C-6E', grade: '6', section: 'E', className: '6-E', classTeacherName: 'Tarun Joshi'),

    // Grade 7
    const SchoolClass(id: 'C-7A', grade: '7', section: 'A', className: '7-A', classTeacherName: 'David Miller'),
    const SchoolClass(id: 'C-7B', grade: '7', section: 'B', className: '7-B', classTeacherName: 'Kavita Joshi'),
    const SchoolClass(id: 'C-7C', grade: '7', section: 'C', className: '7-C', classTeacherName: 'Robert Chen'),
    const SchoolClass(id: 'C-7D', grade: '7', section: 'D', className: '7-D', classTeacherName: 'Meenakshi Sharma'),
    const SchoolClass(id: 'C-7E', grade: '7', section: 'E', className: '7-E', classTeacherName: 'Suresh Gupta'),

    // Grade 8
    const SchoolClass(id: 'C-8A', grade: '8', section: 'A', className: '8-A', classTeacherName: 'Neha Kapoor'),
    const SchoolClass(id: 'C-8B', grade: '8', section: 'B', className: '8-B', classTeacherName: 'Vikram Batra'),
    const SchoolClass(id: 'C-8C', grade: '8', section: 'C', className: '8-C', classTeacherName: 'Pooja Saxena'),
    const SchoolClass(id: 'C-8D', grade: '8', section: 'D', className: '8-D', classTeacherName: 'Tarun Joshi'),
    const SchoolClass(id: 'C-8E', grade: '8', section: 'E', className: '8-E', classTeacherName: 'Anjali Menon'),

    // Grade 9
    const SchoolClass(id: 'C-9A', grade: '9', section: 'A', className: '9-A', classTeacherName: 'Pooja Saxena'),
    const SchoolClass(id: 'C-9B', grade: '9', section: 'B', className: '9-B', classTeacherName: 'Robert Chen'),
    const SchoolClass(id: 'C-9C', grade: '9', section: 'C', className: '9-C', classTeacherName: 'David Miller'),
    const SchoolClass(id: 'C-9D', grade: '9', section: 'D', className: '9-D', classTeacherName: 'Suresh Gupta'),
    const SchoolClass(id: 'C-9E', grade: '9', section: 'E', className: '9-E', classTeacherName: 'Meenakshi Sharma'),

    // Grade 10
    const SchoolClass(id: 'C-10A', grade: '10', section: 'A', className: '10-A', classTeacherName: 'Vikram Batra'),
    const SchoolClass(id: 'C-10B', grade: '10', section: 'B', className: '10-B', classTeacherName: 'Neha Kapoor'),
    const SchoolClass(id: 'C-10C', grade: '10', section: 'C', className: '10-C', classTeacherName: 'Pooja Saxena'),
    const SchoolClass(id: 'C-10D', grade: '10', section: 'D', className: '10-D', classTeacherName: 'Anjali Menon'),

    // Grade 11
    const SchoolClass(id: 'C-11A', grade: '11', section: 'A', className: '11-A', classTeacherName: 'Robert Chen'),
    const SchoolClass(id: 'C-11B', grade: '11', section: 'B', className: '11-B', classTeacherName: 'David Miller'),
    const SchoolClass(id: 'C-11C', grade: '11', section: 'C', className: '11-C', classTeacherName: 'Kavita Joshi'),
    const SchoolClass(id: 'C-11D', grade: '11', section: 'D', className: '11-D', classTeacherName: 'Suresh Gupta'),

    // Grade 12
    const SchoolClass(id: 'C-12A', grade: '12', section: 'A', className: '12-A', classTeacherName: 'Vikram Batra'),
    const SchoolClass(id: 'C-12B', grade: '12', section: 'B', className: '12-B', classTeacherName: 'Neha Kapoor'),
    const SchoolClass(id: 'C-12C', grade: '12', section: 'C', className: '12-C', classTeacherName: 'Meenakshi Sharma'),
    const SchoolClass(id: 'C-12D', grade: '12', section: 'D', className: '12-D', classTeacherName: 'Tarun Joshi'),
  ];

  static final List<Subject> subjects = [
    const Subject(id: 'SUB-1', name: 'Mathematics', subjectType: 'Theory', testWeight: 50, examWeight: 150),
    const Subject(id: 'SUB-2', name: 'Science', subjectType: 'Theory', testWeight: 50, examWeight: 150),
    const Subject(id: 'SUB-3', name: 'English', subjectType: 'Theory', testWeight: 50, examWeight: 150),
    const Subject(id: 'SUB-4', name: 'Social Studies', subjectType: 'Theory', testWeight: 50, examWeight: 150),
    const Subject(id: 'SUB-5', name: 'Hindi', subjectType: 'Theory', testWeight: 50, examWeight: 150),
  ];

  // --- 5. Marks (Exactly 4 fields: First Assessment, Half Yearly, Second Assessment, Final Exam) ---
  static final List<StudentMarks> studentMarks = [
    // Diya Sharma (Grade 5-A)
    const StudentMarks(
      studentId: 'ADM-2024-0412',
      subjectName: 'Mathematics',
      firstAssessment: 23,
      halfYearly: 71,
      secondAssessment: 24,
      finalExam: 72,
    ),
    const StudentMarks(
      studentId: 'ADM-2024-0412',
      subjectName: 'Science',
      firstAssessment: 22,
      halfYearly: 69,
      secondAssessment: 23,
      finalExam: 70,
    ),
    const StudentMarks(
      studentId: 'ADM-2024-0412',
      subjectName: 'English',
      firstAssessment: 21,
      halfYearly: 68,
      secondAssessment: 23,
      finalExam: 70,
    ),
    const StudentMarks(
      studentId: 'ADM-2024-0412',
      subjectName: 'Social Studies',
      firstAssessment: 24,
      halfYearly: 70,
      secondAssessment: 22,
      finalExam: 71,
    ),
    const StudentMarks(
      studentId: 'ADM-2024-0412',
      subjectName: 'Hindi',
      firstAssessment: 20,
      halfYearly: 66,
      secondAssessment: 22,
      finalExam: 68,
    ),
    // Aarav Sharma (Grade 2-B)
    const StudentMarks(
      studentId: 'ADM-2026-0891',
      subjectName: 'Mathematics',
      firstAssessment: 24,
      halfYearly: 73,
      secondAssessment: 25,
      finalExam: 74,
    ),
    const StudentMarks(
      studentId: 'ADM-2026-0891',
      subjectName: 'English',
      firstAssessment: 23,
      halfYearly: 70,
      secondAssessment: 24,
      finalExam: 72,
    ),
    const StudentMarks(
      studentId: 'ADM-2026-0891',
      subjectName: 'Environmental Studies',
      firstAssessment: 25,
      halfYearly: 74,
      secondAssessment: 24,
      finalExam: 75,
    ),
    const StudentMarks(
      studentId: 'ADM-2026-0891',
      subjectName: 'Hindi',
      firstAssessment: 22,
      halfYearly: 68,
      secondAssessment: 23,
      finalExam: 70,
    ),
  ];

  // --- 6. Student Attendance Records ---
  // Diya Sharma: 25 recorded days (20 Present, 3 Absent, 2 Late = 80%)
  static final List<StudentAttendanceRecord> attendanceRecords = [
    // Diya Sharma
    const StudentAttendanceRecord(studentId: 'ADM-2024-0412', date: '2026-10-25', status: AttendanceStatus.present, markedBy: 'Anita Desai', markedAt: '07:48 AM'),
    const StudentAttendanceRecord(studentId: 'ADM-2024-0412', date: '2026-10-24', status: AttendanceStatus.present, markedBy: 'Anita Desai', markedAt: '07:52 AM'),
    const StudentAttendanceRecord(studentId: 'ADM-2024-0412', date: '2026-10-23', status: AttendanceStatus.late, markedBy: 'Anita Desai', markedAt: '08:18 AM'),
    const StudentAttendanceRecord(studentId: 'ADM-2024-0412', date: '2026-10-22', status: AttendanceStatus.absent, markedBy: 'Anita Desai', markedAt: '08:30 AM'),
    const StudentAttendanceRecord(studentId: 'ADM-2024-0412', date: '2026-10-21', status: AttendanceStatus.present, markedBy: 'Anita Desai', markedAt: '07:44 AM'),
    const StudentAttendanceRecord(studentId: 'ADM-2024-0412', date: '2026-10-20', status: AttendanceStatus.present, markedBy: 'Anita Desai', markedAt: '07:50 AM'),
    const StudentAttendanceRecord(studentId: 'ADM-2024-0412', date: '2026-10-19', status: AttendanceStatus.present, markedBy: 'Anita Desai', markedAt: '07:46 AM'),
    const StudentAttendanceRecord(studentId: 'ADM-2024-0412', date: '2026-10-18', status: AttendanceStatus.present, markedBy: 'Anita Desai', markedAt: '07:55 AM'),
    const StudentAttendanceRecord(studentId: 'ADM-2024-0412', date: '2026-10-17', status: AttendanceStatus.present, markedBy: 'Anita Desai', markedAt: '07:48 AM'),
    const StudentAttendanceRecord(studentId: 'ADM-2024-0412', date: '2026-10-16', status: AttendanceStatus.late, markedBy: 'Anita Desai', markedAt: '08:15 AM'),
    const StudentAttendanceRecord(studentId: 'ADM-2024-0412', date: '2026-10-15', status: AttendanceStatus.present, markedBy: 'Anita Desai', markedAt: '07:51 AM'),
    const StudentAttendanceRecord(studentId: 'ADM-2024-0412', date: '2026-10-14', status: AttendanceStatus.present, markedBy: 'Anita Desai', markedAt: '07:47 AM'),
    const StudentAttendanceRecord(studentId: 'ADM-2024-0412', date: '2026-10-13', status: AttendanceStatus.absent, markedBy: 'Anita Desai', markedAt: '08:30 AM'),
    const StudentAttendanceRecord(studentId: 'ADM-2024-0412', date: '2026-10-11', status: AttendanceStatus.present, markedBy: 'Anita Desai', markedAt: '07:49 AM'),
    const StudentAttendanceRecord(studentId: 'ADM-2024-0412', date: '2026-10-10', status: AttendanceStatus.present, markedBy: 'Anita Desai', markedAt: '07:53 AM'),
    const StudentAttendanceRecord(studentId: 'ADM-2024-0412', date: '2026-10-09', status: AttendanceStatus.present, markedBy: 'Anita Desai', markedAt: '07:45 AM'),
    const StudentAttendanceRecord(studentId: 'ADM-2024-0412', date: '2026-10-08', status: AttendanceStatus.present, markedBy: 'Anita Desai', markedAt: '07:50 AM'),
    const StudentAttendanceRecord(studentId: 'ADM-2024-0412', date: '2026-10-07', status: AttendanceStatus.present, markedBy: 'Anita Desai', markedAt: '07:42 AM'),
    const StudentAttendanceRecord(studentId: 'ADM-2024-0412', date: '2026-10-06', status: AttendanceStatus.present, markedBy: 'Anita Desai', markedAt: '07:56 AM'),
    const StudentAttendanceRecord(studentId: 'ADM-2024-0412', date: '2026-10-05', status: AttendanceStatus.absent, markedBy: 'Anita Desai', markedAt: '08:30 AM'),
    const StudentAttendanceRecord(studentId: 'ADM-2024-0412', date: '2026-10-04', status: AttendanceStatus.present, markedBy: 'Anita Desai', markedAt: '07:48 AM'),
    const StudentAttendanceRecord(studentId: 'ADM-2024-0412', date: '2026-10-03', status: AttendanceStatus.present, markedBy: 'Anita Desai', markedAt: '07:50 AM'),
    const StudentAttendanceRecord(studentId: 'ADM-2024-0412', date: '2026-10-01', status: AttendanceStatus.present, markedBy: 'Anita Desai', markedAt: '07:45 AM'),
    const StudentAttendanceRecord(studentId: 'ADM-2024-0412', date: '2026-09-30', status: AttendanceStatus.present, markedBy: 'Anita Desai', markedAt: '07:52 AM'),
    const StudentAttendanceRecord(studentId: 'ADM-2024-0412', date: '2026-09-29', status: AttendanceStatus.present, markedBy: 'Anita Desai', markedAt: '07:49 AM'),

    // Aarav Sharma
    const StudentAttendanceRecord(studentId: 'ADM-2026-0891', date: '2026-10-25', status: AttendanceStatus.present, markedBy: 'Meenakshi Sharma', markedAt: '07:45 AM'),
    const StudentAttendanceRecord(studentId: 'ADM-2026-0891', date: '2026-10-24', status: AttendanceStatus.present, markedBy: 'Meenakshi Sharma', markedAt: '07:48 AM'),
    const StudentAttendanceRecord(studentId: 'ADM-2026-0891', date: '2026-10-23', status: AttendanceStatus.present, markedBy: 'Meenakshi Sharma', markedAt: '07:50 AM'),
    const StudentAttendanceRecord(studentId: 'ADM-2026-0891', date: '2026-10-22', status: AttendanceStatus.present, markedBy: 'Meenakshi Sharma', markedAt: '07:46 AM'),
    const StudentAttendanceRecord(studentId: 'ADM-2026-0891', date: '2026-10-21', status: AttendanceStatus.present, markedBy: 'Meenakshi Sharma', markedAt: '07:52 AM'),
  ];

  // --- 7. Teacher Leave Requests (Only 4 types: Sick Leave, Casual Leave, Earned Leave, Other) ---
  static final List<TeacherLeaveRequest> leaveRequests = [
    const TeacherLeaveRequest(
      id: 'LR-1',
      teacherName: 'Anita Desai',
      leaveType: TeacherLeaveType.casualLeave,
      startDate: '2026-11-04',
      endDate: '2026-11-05',
      reason: 'Attending family function out of town.',
      status: LeaveStatus.approved,
    ),
    const TeacherLeaveRequest(
      id: 'LR-2',
      teacherName: 'David Miller',
      leaveType: TeacherLeaveType.sickLeave,
      startDate: '2026-10-28',
      endDate: '2026-10-29',
      reason: 'Doctor advised rest due to throat infection.',
      status: LeaveStatus.pending,
    ),
  ];

  // --- 8. Admissions Enquiries & Applications ---
  static final List<AdmissionsEnquiry> enquiries = [
    const AdmissionsEnquiry(
      id: 'ENQ-101',
      name: 'Reyansh Kapoor',
      parentName: 'Vikram Kapoor',
      mobile: '+91 98111 22334',
      email: 'vikram.kapoor@example.com',
      gradeInterested: 'Grade 1',
      source: 'Website Referral',
      notes: 'Parent interested in primary curriculum and bus transport facilities.',
      date: '2026-10-24',
      status: EnquiryStatus.newEnquiry,
    ),
    const AdmissionsEnquiry(
      id: 'ENQ-102',
      name: 'Meera Sen',
      parentName: 'Alok Sen',
      mobile: '+91 98222 33445',
      email: 'alok.sen@example.com',
      gradeInterested: 'Grade 6',
      source: 'Walk-In Enquiry',
      notes: 'Moving from Pune campus. Requested school syllabus details.',
      date: '2026-10-22',
      status: EnquiryStatus.contacted,
    ),
  ];

  static final List<AdmissionsApplication> applications = [
    const AdmissionsApplication(
      id: 'APP-201',
      name: 'Vihaan Malhotra',
      dateOfBirth: '10 Jan 2017',
      gender: 'Male',
      parentName: 'Sanjay Malhotra',
      mobile: '+91 98333 44556',
      email: 'sanjay.m@example.com',
      gradeApplyingFor: 'Grade 3',
      session: 'Session 2026-27',
      appliedDate: '2026-10-18',
      status: ApplicationStatus.underReview,
    ),
    const AdmissionsApplication(
      id: 'APP-202',
      name: 'Tara Singhania',
      dateOfBirth: '25 Jun 2018',
      gender: 'Female',
      parentName: 'Gaurav Singhania',
      mobile: '+91 98444 55667',
      email: 'gaurav.s@example.com',
      gradeApplyingFor: 'Grade 2',
      session: 'Session 2026-27',
      appliedDate: '2026-10-15',
      status: ApplicationStatus.approved,
    ),
  ];

  // --- 9. Fees (Read-Only Ledger & Official Receipts) ---
  static final List<FeeStructure> feeStructures = [
    // Grade 5-A (Diya Sharma)
    const FeeStructure(id: 'FS-1', className: '5-A', session: 'Session 2026-27', feeHead: 'Tuition Fee', amount: 8500),
    const FeeStructure(id: 'FS-2', className: '5-A', session: 'Session 2026-27', feeHead: 'Laboratory Fee', amount: 1500),
    const FeeStructure(id: 'FS-3', className: '5-A', session: 'Session 2026-27', feeHead: 'Transport Fee (Route 12)', amount: 2000),
    const FeeStructure(id: 'FS-4', className: '5-A', session: 'Session 2026-27', feeHead: 'Annual Activity Fund', amount: 450),
    // Grade 2-B (Aarav Sharma)
    const FeeStructure(id: 'FS-5', className: '2-B', session: 'Session 2026-27', feeHead: 'Tuition Fee', amount: 6500),
    const FeeStructure(id: 'FS-6', className: '2-B', session: 'Session 2026-27', feeHead: 'Transport Fee (Route 12)', amount: 2000),
    const FeeStructure(id: 'FS-7', className: '2-B', session: 'Session 2026-27', feeHead: 'Annual Activity Fund', amount: 450),
  ];

  static final List<FeePayment> feePayments = [
    // Diya Sharma
    const FeePayment(
      id: 'FP-1',
      studentId: 'ADM-2024-0412',
      session: 'Session 2026-27',
      feeHead: 'Tuition & Composite Fee',
      amount: 14200,
      paymentMode: PaymentMode.upi,
      paymentDate: '10 Jun 2026',
      receiptNumber: 'REC-2026-0891',
      receivedBy: 'Rajesh Verma (Accountant)',
      remarks: 'Term 1 full clearance receipt.',
    ),
    const FeePayment(
      id: 'FP-2',
      studentId: 'ADM-2024-0412',
      session: 'Session 2025-26',
      feeHead: 'Annual Tuition Fee',
      amount: 13800,
      paymentMode: PaymentMode.cheque,
      paymentDate: '15 Dec 2025',
      receiptNumber: 'REC-2025-0422',
      receivedBy: 'Rajesh Verma (Accountant)',
      remarks: 'Cheque clearance verification confirmed.',
    ),
    // Aarav Sharma
    const FeePayment(
      id: 'FP-3',
      studentId: 'ADM-2026-0891',
      session: 'Session 2026-27',
      feeHead: 'Term 1 Tuition Fee',
      amount: 8950,
      paymentMode: PaymentMode.upi,
      paymentDate: '12 Apr 2026',
      receiptNumber: 'REC-2026-0419',
      receivedBy: 'Rajesh Verma (Accountant)',
      remarks: 'Term 1 full clearance receipt.',
    ),
  ];

  // --- 10. Library ---
  static final List<Book> books = [
    const Book(
      id: 'B-1',
      title: 'A Brief History of Time',
      author: 'Stephen Hawking',
      isbn: '978-0553380163',
      category: 'Science',
      totalCopies: 5,
      availableCopies: 3,
      replacementCost: 450,
    ),
    const Book(
      id: 'B-2',
      title: 'Harry Potter and the Prisoner of Azkaban',
      author: 'J.K. Rowling',
      isbn: '978-0439136365',
      category: 'Fiction',
      totalCopies: 8,
      availableCopies: 2,
      replacementCost: 350,
    ),
    const Book(
      id: 'B-3',
      title: 'Wings of Fire',
      author: 'A.P.J. Abdul Kalam',
      isbn: '978-8173711463',
      category: 'Biography',
      totalCopies: 6,
      availableCopies: 4,
      replacementCost: 299,
    ),
  ];

  static final List<BookIssue> bookIssues = [
    const BookIssue(
      id: 'BI-1',
      bookTitle: 'A Brief History of Time',
      studentName: 'Diya Sharma',
      studentId: 'ADM-2024-0412',
      issueDate: '10 Oct 2026',
      dueDate: '24 Oct 2026',
      lost: false,
    ),
    const BookIssue(
      id: 'BI-2',
      bookTitle: 'Harry Potter and the Prisoner of Azkaban',
      studentName: 'Diya Sharma',
      studentId: 'ADM-2024-0412',
      issueDate: '04 Oct 2026',
      dueDate: '18 Oct 2026',
      lost: false,
    ),
  ];

  // --- 11. Transport (Route stops, driver contact - NO fake GPS) ---
  static final List<TransportRoute> routes = [
    const TransportRoute(
      routeName: 'Route 12',
      vehicleRegistration: 'UP-32-AB-1234',
      capacity: 42,
      driverName: 'Ramesh Singh',
      driverMobile: '+91 98765 43210',
      stops: [
        'Civil Lines Bus Stand (07:15 AM)',
        'Subhash Chowk Circle (07:25 AM)',
        'University Gate (07:35 AM)',
        'ONPS Campus (07:55 AM)',
      ],
    ),
    const TransportRoute(
      routeName: 'Route 5',
      vehicleRegistration: 'UP-32-CD-5678',
      capacity: 35,
      driverName: 'Suresh Yadav',
      driverMobile: '+91 98111 55667',
      stops: [
        'Model Town Metro (07:10 AM)',
        'Kingsway Camp (07:25 AM)',
        'ONPS Campus (07:50 AM)',
      ],
    ),
  ];

  static const StudentTransport studentTransport = StudentTransport(
    studentId: 'ADM-2024-0412',
    routeName: 'Route 12',
    pickupPoint: 'Subhash Chowk Circle',
  );

  // --- 12. Inventory ---
  static final List<InventoryItem> inventory = [
    const InventoryItem(id: 'INV-1', name: 'A4 Printing Paper Reams', category: 'Stationery', unit: 'Reams', quantityInStock: 45, reorderLevel: 20),
    const InventoryItem(id: 'INV-2', name: 'Whiteboard Marker Pens (Black)', category: 'Stationery', unit: 'Boxes', quantityInStock: 8, reorderLevel: 15),
    const InventoryItem(id: 'INV-3', name: 'Footballs (Size 5)', category: 'Sports', unit: 'Pieces', quantityInStock: 12, reorderLevel: 5),
    const InventoryItem(id: 'INV-4', name: 'Microscope Glass Slides', category: 'Laboratory', unit: 'Packs', quantityInStock: 5, reorderLevel: 10),
  ];

  // --- 13. Timetable Slots (Class + Subject + Teacher, NO room) ---
  static final List<TimetableSlot> timetable = [
    const TimetableSlot(dayOfWeek: 2, periodNumber: 1, startTime: '08:30 AM', endTime: '09:15 AM', className: '5-A', subjectName: 'Mathematics', teacherName: 'Anita Desai'),
    const TimetableSlot(dayOfWeek: 2, periodNumber: 2, startTime: '09:15 AM', endTime: '10:00 AM', className: '5-A', subjectName: 'English', teacherName: 'David Miller'),
    const TimetableSlot(dayOfWeek: 2, periodNumber: 3, startTime: '10:20 AM', endTime: '11:05 AM', className: '5-A', subjectName: 'Science', teacherName: 'Robert Chen'),
    const TimetableSlot(dayOfWeek: 2, periodNumber: 4, startTime: '11:05 AM', endTime: '11:50 AM', className: '5-A', subjectName: 'Social Studies', teacherName: 'Priya Nair'),
    const TimetableSlot(dayOfWeek: 2, periodNumber: 5, startTime: '12:30 PM', endTime: '01:15 PM', className: '5-A', subjectName: 'Hindi', teacherName: 'Anita Desai'),
  ];

  // --- 14. Holidays (Gazetted & National) ---
  static final List<Holiday> holidays = [
    const Holiday(
      id: 'H-1',
      name: 'Mahatma Gandhi Jayanti',
      date: '2026-10-02',
      type: HolidayType.national,
      description: 'National holiday observing the birth anniversary of Mahatma Gandhi.',
    ),
    const Holiday(
      id: 'H-2',
      name: 'Dussehra (Vijay Dashami)',
      date: '2026-10-12',
      type: HolidayType.gazetted,
      description: 'Gazetted holiday celebrating the triumph of good over evil.',
    ),
    const Holiday(
      id: 'H-3',
      name: 'Diwali & Deepavali Break',
      date: '2026-10-31',
      endDate: '2026-11-02',
      type: HolidayType.gazetted,
      description: 'School remains closed for 3 days for the festival of lights.',
    ),
    const Holiday(
      id: 'H-4',
      name: 'Guru Nanak Jayanti',
      date: '2026-11-15',
      type: HolidayType.gazetted,
      description: 'Gazetted holiday observing the birth anniversary of Guru Nanak Dev Ji.',
    ),
  ];

  // --- 15. Events ---
  static final List<SchoolEvent> events = [
    const SchoolEvent(
      id: 'EV-1',
      title: 'Annual Sports Meet 2026',
      date: '2026-11-20',
      category: EventCategory.functionCelebration,
      description: 'Track and field athletics events for primary and secondary wings.',
      audience: 'All Students & Parents',
    ),
    const SchoolEvent(
      id: 'EV-2',
      title: 'Second Assessment Commences',
      date: '2026-11-25',
      endDate: '2026-12-02',
      category: EventCategory.testExam,
      description: 'Second Assessment examinations scheduled across all subjects.',
      audience: 'Grades 1 through 12',
    ),
  ];

  // --- 16. Announcements ---
  static final List<Announcement> announcements = [
    const Announcement(
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
    const Announcement(
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
    const Announcement(
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
    const Announcement(
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
    const Announcement(
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

  static List<TeacherLeaveRequest> get teacherLeaves => leaveRequests;
  static List<TimetableSlot> get timetableSlots => timetable;
}

// --- Concrete Mock Repositories ---

class MockAuthRepository implements IAuthRepository {
  @override
  Future<UserRole> login(String username, String password) async {
    return UserRole.parent;
  }

  @override
  Future<bool> verifyOtp(String code) async {
    return true;
  }

  @override
  Future<bool> requestPasswordReset(String usernameOrMobile) async {
    return true;
  }
}

class MockStudentRepository implements IStudentRepository {
  @override
  Future<List<Student>> getAllStudents() async => MockData.students;

  @override
  Future<Student?> getStudentById(String id) async {
    return MockData.students.firstWhere(
      (s) => s.id == id,
      orElse: () => MockData.students.first,
    );
  }

  @override
  Future<List<StudentMarks>> getMarksForStudent(String studentId) async {
    return MockData.studentMarks.where((m) => m.studentId == studentId).toList();
  }

  @override
  Future<List<StudentAttendanceRecord>> getAttendanceForStudent(String studentId) async {
    return MockData.attendanceRecords.where((a) => a.studentId == studentId).toList();
  }
}

class MockFacultyRepository implements IFacultyRepository {
  @override
  Future<List<Teacher>> getAllTeachers() async => MockData.teachers;

  @override
  Future<List<Staff>> getAllStaff() async => MockData.staffMembers;

  @override
  Future<List<SchoolClass>> getAllClasses() async => MockData.classes;

  @override
  Future<List<Subject>> getAllSubjects() async => MockData.subjects;

  @override
  Future<List<TimetableSlot>> getTimetableForClass(String className) async {
    return MockData.timetable.where((t) => t.className == className).toList();
  }

  @override
  Future<List<TimetableSlot>> getTimetableForTeacher(String teacherName) async {
    return MockData.timetable.where((t) => t.teacherName == teacherName).toList();
  }

  @override
  Future<List<TeacherLeaveRequest>> getFacultyLeaveRequests() async {
    return MockData.leaveRequests;
  }

  @override
  Future<void> submitLeaveRequest(TeacherLeaveRequest request) async {
    MockData.leaveRequests.insert(0, request);
  }
}

class MockFeeRepository implements IFeeRepository {
  @override
  Future<List<FeeStructure>> getFeeStructures() async => MockData.feeStructures;

  @override
  Future<List<FeePayment>> getPaymentsForStudent(String studentId) async {
    return MockData.feePayments.where((p) => p.studentId == studentId).toList();
  }
}

class MockOperationsRepository implements IOperationsRepository {
  @override
  Future<List<Book>> getLibraryCatalog() async => MockData.books;

  @override
  Future<List<BookIssue>> getBookCirculations() async => MockData.bookIssues;

  @override
  Future<List<TransportRoute>> getTransportRoutes() async => MockData.routes;

  @override
  Future<StudentTransport?> getTransportForStudent(String studentId) async {
    return MockData.studentTransport;
  }

  @override
  Future<List<InventoryItem>> getInventoryItems() async => MockData.inventory;
}

class MockCommunicationsRepository implements ICommunicationsRepository {
  @override
  Future<List<Holiday>> getHolidays() async => MockData.holidays;

  @override
  Future<List<SchoolEvent>> getEvents() async => MockData.events;

  @override
  Future<List<Announcement>> getAnnouncements() async => MockData.announcements;

  @override
  Future<List<AdmissionsEnquiry>> getEnquiries() async => MockData.enquiries;

  @override
  Future<List<AdmissionsApplication>> getApplications() async => MockData.applications;
}
