import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/university.dart';
import '../models/faculty.dart';
import '../models/department.dart';
import '../models/major.dart';
import '../models/lecturer.dart';

class HRProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  
  List<University> _universities = [];
  List<Faculty> _faculties = [];
  List<Department> _departments = [];
  List<Major> _majors = [];
  List<Lecturer> _lecturers = [];
  
  Map<String, dynamic> _hierarchyData = {};
  
  List<University> get universities => _universities;
  List<Faculty> get faculties => _faculties;
  List<Department> get departments => _departments;
  List<Major> get majors => _majors;
  List<Lecturer> get lecturers => _lecturers;
  Map<String, dynamic> get hierarchyData => _hierarchyData;

  // Load all data
  Future<void> loadAllData() async {
    _universities = await _dbHelper.getAllUniversities();
    _hierarchyData = await _dbHelper.getFullHierarchy();
    notifyListeners();
  }

  // University operations
  Future<void> addUniversity(University university) async {
    await _dbHelper.insertUniversity(university);
    await loadAllData();
  }

  // Faculty operations
  Future<void> addFaculty(Faculty faculty) async {
    await _dbHelper.insertFaculty(faculty);
    await loadAllData();
  }

  Future<void> updateFaculty(Faculty faculty) async {
    await _dbHelper.updateFaculty(faculty);
    await loadAllData();
  }

  Future<void> deleteFaculty(String id) async {
    await _dbHelper.deleteFaculty(id);
    await loadAllData();
  }

  Future<List<Faculty>> getFacultiesByUniversity(String universityId) async {
    return await _dbHelper.getFacultiesByUniversity(universityId);
  }

  // Department operations
  Future<void> addDepartment(Department department) async {
    await _dbHelper.insertDepartment(department);
    await loadAllData();
  }

  Future<void> updateDepartment(Department department) async {
    await _dbHelper.updateDepartment(department);
    await loadAllData();
  }

  Future<void> deleteDepartment(String id) async {
    await _dbHelper.deleteDepartment(id);
    await loadAllData();
  }

  Future<List<Department>> getDepartmentsByFaculty(String facultyId) async {
    return await _dbHelper.getDepartmentsByFaculty(facultyId);
  }

  // Major operations
  Future<void> addMajor(Major major) async {
    await _dbHelper.insertMajor(major);
    await loadAllData();
  }

  Future<void> updateMajor(Major major) async {
    await _dbHelper.updateMajor(major);
    await loadAllData();
  }

  Future<void> deleteMajor(String id) async {
    await _dbHelper.deleteMajor(id);
    await loadAllData();
  }

  Future<List<Major>> getMajorsByDepartment(String departmentId) async {
    return await _dbHelper.getMajorsByDepartment(departmentId);
  }

  // Lecturer operations
  Future<void> addLecturer(Lecturer lecturer) async {
    await _dbHelper.insertLecturer(lecturer);
    await loadAllData();
  }

  Future<void> updateLecturer(Lecturer lecturer) async {
    await _dbHelper.updateLecturer(lecturer);
    await loadAllData();
  }

  Future<void> deleteLecturer(String id) async {
    await _dbHelper.deleteLecturer(id);
    await loadAllData();
  }

  Future<List<Lecturer>> getLecturersByMajor(String majorId) async {
    return await _dbHelper.getLecturersByMajor(majorId);
  }
}