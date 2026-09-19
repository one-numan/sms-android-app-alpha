// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Role-Aware Authentication State Manager
// Supports seamless 1-tap role switching across all institutional personas
// Multi-child selection management for Parent role
// ==============================================================================

import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../services/auth_api_service.dart';
import 'mock_data.dart';

class AuthState extends ChangeNotifier {
  UserRole _currentRole = UserRole.parent;
  String _currentUsername = 'rajesh.sharma';
  bool _isAuthenticated = true;
  int _selectedChildIndex = 0;

  UserRole get currentRole => _currentRole;
  String get currentUsername => _currentUsername;
  bool get isAuthenticated => _isAuthenticated;
  int get selectedChildIndex => _selectedChildIndex;

  Student get selectedChild {
    if (MockData.students.isEmpty) {
      return const Student(
        id: 'ADM-2024-0412',
        firstName: 'Diya',
        lastName: 'Sharma',
        dateOfBirth: '14 Aug 2015',
        mobile: '+91 98765 43210',
        email: 'diya.sharma@example.com',
        gender: 'Female',
        admissionDate: '01 Apr 2024',
        rollNumber: 14,
        address: Address(
          line1: 'Flat 402, Royal Palms',
          city: 'New Delhi',
          district: 'Central Delhi',
          state: 'Delhi',
          pincode: '110054',
        ),
        dwellingType: 'Flat',
      );
    }
    final index = _selectedChildIndex.clamp(0, MockData.students.length - 1);
    return MockData.students[index];
  }

  void selectChild(int index) {
    if (_selectedChildIndex != index) {
      _selectedChildIndex = index;
      notifyListeners();
    }
  }

  Future<bool> login({required UserRole role, required String username, String? password}) async {
    _currentRole = role;
    _currentUsername = username;
    _isAuthenticated = true;
    notifyListeners();

    try {
      final authService = AuthApiService();
      final pwd = (password != null && password.isNotEmpty) ? password : 'demo12345';
      final response = await authService.login(
        username: username,
        password: pwd,
        role: role.name,
      );
      if (response.containsKey('access')) {
        debugPrint('Successfully authenticated with backend server for $username');
        return true;
      }
    } catch (e) {
      debugPrint('Backend auth connection note: $e (using local persona)');
    }
    return true;
  }

  void switchRole(UserRole role) {
    _currentRole = role;
    notifyListeners();
  }

  void signOut() {
    _isAuthenticated = false;
    notifyListeners();
  }

  static String roleTitle(UserRole role) {
    switch (role) {
      case UserRole.principal:
        return 'Principal';
      case UserRole.vicePrincipal:
        return 'Vice Principal';
      case UserRole.classTeacher:
        return 'Class Teacher';
      case UserRole.subjectTeacher:
        return 'Subject Teacher';
      case UserRole.accountant:
        return 'Accountant';
      case UserRole.librarian:
        return 'Librarian';
      case UserRole.receptionist:
        return 'Receptionist';
      case UserRole.parent:
        return 'Parent';
      case UserRole.student:
        return 'Student';
      case UserRole.superAdmin:
        return 'Super Admin';
    }
  }
}
