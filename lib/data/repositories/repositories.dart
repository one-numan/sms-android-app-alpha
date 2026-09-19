// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Abstract Repository Interfaces: Data Layer Contracts
// Swappable between static mock fixtures and live REST APIs without UI changes
// ==============================================================================

import '../../models/models.dart';

abstract class IAuthRepository {
  Future<UserRole> login(String username, String password);
  Future<bool> verifyOtp(String code);
  Future<bool> requestPasswordReset(String usernameOrMobile);
}

abstract class IStudentRepository {
  Future<List<Student>> getAllStudents();
  Future<Student?> getStudentById(String id);
  Future<List<StudentMarks>> getMarksForStudent(String studentId);
  Future<List<StudentAttendanceRecord>> getAttendanceForStudent(String studentId);
}

abstract class IFacultyRepository {
  Future<List<Teacher>> getAllTeachers();
  Future<List<Staff>> getAllStaff();
  Future<List<SchoolClass>> getAllClasses();
  Future<List<Subject>> getAllSubjects();
  Future<List<TimetableSlot>> getTimetableForClass(String className);
  Future<List<TimetableSlot>> getTimetableForTeacher(String teacherName);
  Future<List<TeacherLeaveRequest>> getFacultyLeaveRequests();
  Future<void> submitLeaveRequest(TeacherLeaveRequest request);
}

abstract class IFeeRepository {
  Future<List<FeeStructure>> getFeeStructures();
  Future<List<FeePayment>> getPaymentsForStudent(String studentId);
}

abstract class IOperationsRepository {
  Future<List<Book>> getLibraryCatalog();
  Future<List<BookIssue>> getBookCirculations();
  Future<List<TransportRoute>> getTransportRoutes();
  Future<StudentTransport?> getTransportForStudent(String studentId);
  Future<List<InventoryItem>> getInventoryItems();
}

abstract class ICommunicationsRepository {
  Future<List<Holiday>> getHolidays();
  Future<List<SchoolEvent>> getEvents();
  Future<List<Announcement>> getAnnouncements();
  Future<List<AdmissionsEnquiry>> getEnquiries();
  Future<List<AdmissionsApplication>> getApplications();
}
