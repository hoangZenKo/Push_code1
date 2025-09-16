import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/university.dart';
import '../models/faculty.dart';
import '../models/department.dart';
import '../models/major.dart';
import '../models/lecturer.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'phenikaa_hr.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    // Bảng University
    await db.execute('''
      CREATE TABLE universities(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        address TEXT,
        phone TEXT,
        email TEXT,
        createdAt TEXT NOT NULL
      )
    ''');

    // Bảng Faculty (Trường)
    await db.execute('''
      CREATE TABLE faculties(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        universityId TEXT NOT NULL,
        description TEXT,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (universityId) REFERENCES universities (id) ON DELETE CASCADE
      )
    ''');

    // Bảng Department (Khoa)
    await db.execute('''
      CREATE TABLE departments(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        facultyId TEXT NOT NULL,
        description TEXT,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (facultyId) REFERENCES faculties (id) ON DELETE CASCADE
      )
    ''');

    // Bảng Major (Ngành)
    await db.execute('''
      CREATE TABLE majors(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        code TEXT,
        departmentId TEXT NOT NULL,
        description TEXT,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (departmentId) REFERENCES departments (id) ON DELETE CASCADE
      )
    ''');

    // Bảng Lecturer (Giảng viên)
    await db.execute('''
      CREATE TABLE lecturers(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT,
        phone TEXT,
        position TEXT,
        majorId TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (majorId) REFERENCES majors (id) ON DELETE CASCADE
      )
    ''');

    // Chèn dữ liệu mẫu
    await _insertSampleData(db);
  }

  Future<void> _insertSampleData(Database db) async {
    // Thêm Đại học Phenikaa
    await db.insert('universities', {
      'id': 'phenikaa-uni',
      'name': 'Đại học Phenikaa',
      'address': 'Yên Nghĩa, Hà Đông, Hà Nội',
      'phone': '024 6291 8888',
      'email': 'info@phenikaa-uni.edu.vn',
      'createdAt': DateTime.now().toIso8601String(),
    });

    // Thêm các trường
    final faculties = [
      {'id': 'engineering', 'name': 'Trường Kỹ thuật'},
      {'id': 'it', 'name': 'Trường Công Nghệ Thông Tin'},
      {'id': 'medicine', 'name': 'Trường Y - Dược'},
      {'id': 'language', 'name': 'Trường NN-KHXH'},
      {'id': 'economics', 'name': 'Trường Kinh Tế'},
    ];

    for (var faculty in faculties) {
      await db.insert('faculties', {
        'id': faculty['id'],
        'name': faculty['name'],
        'universityId': 'phenikaa-uni',
        'createdAt': DateTime.now().toIso8601String(),
      });
    }
  }

  // CRUD operations for University
  Future<int> insertUniversity(University university) async {
    final db = await database;
    return await db.insert('universities', university.toMap());
  }

  Future<List<University>> getAllUniversities() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('universities');
    return List.generate(maps.length, (i) => University.fromMap(maps[i]));
  }

  // CRUD operations for Faculty
  Future<int> insertFaculty(Faculty faculty) async {
    final db = await database;
    return await db.insert('faculties', faculty.toMap());
  }

  Future<List<Faculty>> getFacultiesByUniversity(String universityId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'faculties',
      where: 'universityId = ?',
      whereArgs: [universityId],
    );
    return List.generate(maps.length, (i) => Faculty.fromMap(maps[i]));
  }

  Future<int> updateFaculty(Faculty faculty) async {
    final db = await database;
    return await db.update(
      'faculties',
      faculty.toMap(),
      where: 'id = ?',
      whereArgs: [faculty.id],
    );
  }

  Future<int> deleteFaculty(String id) async {
    final db = await database;
    return await db.delete('faculties', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD operations for Department
  Future<int> insertDepartment(Department department) async {
    final db = await database;
    return await db.insert('departments', department.toMap());
  }

  Future<List<Department>> getDepartmentsByFaculty(String facultyId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'departments',
      where: 'facultyId = ?',
      whereArgs: [facultyId],
    );
    return List.generate(maps.length, (i) => Department.fromMap(maps[i]));
  }

  Future<int> updateDepartment(Department department) async {
    final db = await database;
    return await db.update(
      'departments',
      department.toMap(),
      where: 'id = ?',
      whereArgs: [department.id],
    );
  }

  Future<int> deleteDepartment(String id) async {
    final db = await database;
    return await db.delete('departments', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD operations for Major
  Future<int> insertMajor(Major major) async {
    final db = await database;
    return await db.insert('majors', major.toMap());
  }

  Future<List<Major>> getMajorsByDepartment(String departmentId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'majors',
      where: 'departmentId = ?',
      whereArgs: [departmentId],
    );
    return List.generate(maps.length, (i) => Major.fromMap(maps[i]));
  }

  Future<int> updateMajor(Major major) async {
    final db = await database;
    return await db.update(
      'majors',
      major.toMap(),
      where: 'id = ?',
      whereArgs: [major.id],
    );
  }

  Future<int> deleteMajor(String id) async {
    final db = await database;
    return await db.delete('majors', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD operations for Lecturer
  Future<int> insertLecturer(Lecturer lecturer) async {
    final db = await database;
    return await db.insert('lecturers', lecturer.toMap());
  }

  Future<List<Lecturer>> getLecturersByMajor(String majorId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'lecturers',
      where: 'majorId = ?',
      whereArgs: [majorId],
    );
    return List.generate(maps.length, (i) => Lecturer.fromMap(maps[i]));
  }

  Future<int> updateLecturer(Lecturer lecturer) async {
    final db = await database;
    return await db.update(
      'lecturers',
      lecturer.toMap(),
      where: 'id = ?',
      whereArgs: [lecturer.id],
    );
  }

  Future<int> deleteLecturer(String id) async {
    final db = await database;
    return await db.delete('lecturers', where: 'id = ?', whereArgs: [id]);
  }

  // Get full hierarchy data for tree view
  Future<Map<String, dynamic>> getFullHierarchy() async {
    final universities = await getAllUniversities();
    final result = <String, dynamic>{};
    
    for (var university in universities) {
      final faculties = await getFacultiesByUniversity(university.id);
      final facultyData = <String, dynamic>{};
      
      for (var faculty in faculties) {
        final departments = await getDepartmentsByFaculty(faculty.id);
        final departmentData = <String, dynamic>{};
        
        for (var department in departments) {
          final majors = await getMajorsByDepartment(department.id);
          final majorData = <String, dynamic>{};
          
          for (var major in majors) {
            final lecturers = await getLecturersByMajor(major.id);
            majorData[major.id] = {
              'data': major,
              'lecturers': lecturers,
            };
          }
          
          departmentData[department.id] = {
            'data': department,
            'majors': majorData,
          };
        }
        
        facultyData[faculty.id] = {
          'data': faculty,
          'departments': departmentData,
        };
      }
      
      result[university.id] = {
        'data': university,
        'faculties': facultyData,
      };
    }
    
    return result;
  }
}