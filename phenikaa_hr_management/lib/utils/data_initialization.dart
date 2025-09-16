import 'package:uuid/uuid.dart';
import '../database/database_helper.dart';
import '../models/department.dart';
import '../models/major.dart';

class DataInitialization {
  static const _uuid = Uuid();
  static final DatabaseHelper _dbHelper = DatabaseHelper();

  static Future<void> initializePhenikaaData() async {
    // Initialize departments and majors for each faculty based on the provided data
    
    // Trường Kỹ thuật
    await _initializeEngineeringFaculty();
    
    // Trường Công nghệ Thông tin
    await _initializeITFaculty();
    
    // Trường Y - Dược
    await _initializeMedicineFaculty();
    
    // Trường NN-KHXH
    await _initializeLanguageFaculty();
    
    // Trường Kinh tế
    await _initializeEconomicsFaculty();
  }

  static Future<void> _initializeEngineeringFaculty() async {
    final departments = [
      {
        'name': 'Khoa Công nghệ Sinh học, Hóa học và Kỹ thuật Môi trường',
        'majors': [
          {'name': 'Công nghệ sinh học', 'code': 'BT1'},
          {'name': 'Kỹ thuật hóa học', 'code': 'CH1'},
        ]
      },
      {
        'name': 'Khoa Điện – Điện tử',
        'majors': [
          {'name': 'Kỹ thuật điều khiển và tự động hóa', 'code': 'AU1'},
          {'name': 'Kỹ thuật y sinh (Điện tử y sinh)', 'code': 'BME1'},
          {'name': 'Kỹ thuật điện tử – viễn thông (hệ thống nhúng thông minh và IoT)', 'code': 'ET1'},
          {'name': 'Kỹ thuật điện tử – viễn thông (thiết kế vi mạch bán dẫn)', 'code': 'ET2'},
          {'name': 'Kỹ thuật điều khiển và tự động hóa (Robot và trí tuệ nhân tạo)', 'code': 'AU2'},
        ]
      },
      {
        'name': 'Khoa Cơ khí – Cơ điện tử',
        'majors': [
          {'name': 'Kỹ thuật cơ điện tử', 'code': 'ME1'},
          {'name': 'Kỹ thuật cơ khí', 'code': 'ME2'},
          {'name': 'Hệ thống cơ điện tử thông minh', 'code': 'SME1'},
        ]
      },
      {
        'name': 'Khoa Khoa học và Kỹ thuật Vật liệu',
        'majors': [
          {'name': 'Vật liệu tiên tiến và công nghệ nano', 'code': 'MS1'},
          {'name': 'Vật liệu thông minh và trí tuệ nhân tạo', 'code': 'MS2'},
          {'name': 'Chip bán dẫn và công nghệ đóng gói', 'code': 'SC1'},
        ]
      },
      {
        'name': 'Khoa Kỹ thuật Ô tô và Năng lượng',
        'majors': [
          {'name': 'Cơ điện tử ô tô', 'code': 'AME1'},
          {'name': 'Kỹ thuật ô tô', 'code': 'AE1'},
          {'name': 'Kỹ thuật phần mềm ô tô', 'code': 'ASE1'},
        ]
      },
    ];

    await _createDepartmentsAndMajors('engineering', departments);
  }

  static Future<void> _initializeITFaculty() async {
    final departments = [
      {
        'name': 'Khoa Khoa học máy tính',
        'majors': [
          {'name': 'Tài năng khoa học máy tính', 'code': 'CS1'},
        ]
      },
      {
        'name': 'Khoa Hệ thống thông tin',
        'majors': [
          {'name': 'Công nghệ thông tin Việt – Nhật', 'code': 'IT1'},
          {'name': 'Kỹ thuật phần mềm', 'code': 'SE1'},
          {'name': 'Công nghệ thông tin', 'code': 'IT2'},
          {'name': 'An toàn thông tin', 'code': 'IS1'},
        ]
      },
      {
        'name': 'Khoa Trí tuệ nhân tạo',
        'majors': [
          {'name': 'Khoa học máy tính (Trí tuệ nhân tạo và Khoa học dữ liệu)', 'code': 'CS2'},
          {'name': 'Trí tuệ nhân tạo', 'code': 'AI1'},
        ]
      },
    ];

    await _createDepartmentsAndMajors('it', departments);
  }

  static Future<void> _initializeMedicineFaculty() async {
    final departments = [
      {
        'name': 'Khoa Điều dưỡng',
        'majors': [
          {'name': 'Điều dưỡng', 'code': 'NUR1'},
          {'name': 'Hộ sinh', 'code': 'MIW'},
        ]
      },
      {
        'name': 'Khoa Dược',
        'majors': [
          {'name': 'Dược học', 'code': 'PHA1'},
        ]
      },
      {
        'name': 'Khoa Kỹ thuật Y học',
        'majors': [
          {'name': 'Kỹ thuật phục hồi chức năng', 'code': 'RET1'},
          {'name': 'Kỹ thuật xét nghiệm y học', 'code': 'MTT1'},
          {'name': 'Kỹ thuật hình ảnh y học', 'code': 'RTS1'},
        ]
      },
      {
        'name': 'Khoa Y',
        'majors': [
          {'name': 'Y khoa', 'code': 'MED1'},
          {'name': 'Quản lý bệnh viện', 'code': 'HM1'},
        ]
      },
      {
        'name': 'Khoa Răng – Hàm – Mặt',
        'majors': [
          {'name': 'Răng – Hàm – Mặt', 'code': 'DEN1'},
        ]
      },
      {
        'name': 'Khoa Y học cổ truyền',
        'majors': [
          {'name': 'Y học cổ truyền', 'code': 'FTME'},
        ]
      },
      {
        'name': 'Khoa Khoa học Y sinh',
        'majors': [
          {'name': 'Khoa học Y sinh', 'code': 'BMS'},
        ]
      },
      {
        'name': 'Khoa Y tế công cộng',
        'majors': [
          {'name': 'Y tế công cộng', 'code': 'PHE1'},
        ]
      },
    ];

    await _createDepartmentsAndMajors('medicine', departments);
  }

  static Future<void> _initializeLanguageFaculty() async {
    final departments = [
      {
        'name': 'Khoa Ngôn ngữ Anh',
        'majors': [
          {'name': 'Ngôn ngữ Anh', 'code': 'FLE1'},
        ]
      },
      {
        'name': 'Khoa Ngôn ngữ Pháp',
        'majors': [
          {'name': 'Ngôn ngữ Pháp', 'code': 'FLF1'},
        ]
      },
      {
        'name': 'Khoa Ngôn ngữ Trung Quốc',
        'majors': [
          {'name': 'Ngôn ngữ Trung Quốc', 'code': 'FLC1'},
        ]
      },
      {
        'name': 'Khoa Ngôn ngữ Hàn Quốc',
        'majors': [
          {'name': 'Ngôn ngữ Hàn Quốc', 'code': 'FLK1'},
        ]
      },
      {
        'name': 'Khoa Ngôn ngữ Nhật Bản',
        'majors': [
          {'name': 'Ngôn ngữ Nhật', 'code': 'FLJ1'},
        ]
      },
      {
        'name': 'Khoa Đông phương học',
        'majors': [
          {'name': 'Đông phương học', 'code': 'FOS1'},
        ]
      },
    ];

    await _createDepartmentsAndMajors('language', departments);
  }

  static Future<void> _initializeEconomicsFaculty() async {
    final departments = [
      {
        'name': 'Khoa Quản trị Kinh doanh',
        'majors': [
          {'name': 'Quản trị kinh doanh', 'code': 'FBE1'},
          {'name': 'Quản trị nhân lực', 'code': 'FBE4'},
          {'name': 'Marketing', 'code': 'FBE8'},
        ]
      },
      {
        'name': 'Khoa Tài chính – Kế toán',
        'majors': [
          {'name': 'Kế toán', 'code': 'FBE2'},
          {'name': 'Tài chính – Ngân hàng', 'code': 'FBE3'},
          {'name': 'Kiểm toán', 'code': 'FBE5'},
        ]
      },
      {
        'name': 'Khoa Kinh tế & Kinh doanh quốc tế',
        'majors': [
          {'name': 'Kinh doanh quốc tế', 'code': 'FBE6'},
          {'name': 'Logistics & Quản lý chuỗi cung ứng', 'code': 'FBE7'},
        ]
      },
      {
        'name': 'Khoa Du lịch – Khách sạn',
        'majors': [
          {'name': 'Du lịch (định hướng Quản trị du lịch)', 'code': 'FTS1'},
          {'name': 'Quản trị khách sạn', 'code': 'FTS2'},
          {'name': 'Kinh doanh du lịch số', 'code': 'FTS3'},
          {'name': 'Hướng dẫn du lịch quốc tế', 'code': 'FTS4'},
        ]
      },
      {
        'name': 'Khoa Luật',
        'majors': [
          {'name': 'Luật kinh tế', 'code': 'FOL1'},
          {'name': 'Luật kinh doanh', 'code': 'FOL2'},
          {'name': 'Luật', 'code': 'FOL3'},
          {'name': 'Luật quốc tế', 'code': 'FOL4'},
          {'name': 'Luật thương mại quốc tế', 'code': 'FOL5'},
        ]
      },
      {
        'name': 'Khoa Công nghệ số liên ngành',
        'majors': [
          {'name': 'Kinh tế số', 'code': 'FIDT1'},
          {'name': 'Quản trị kinh doanh (Kinh doanh số)', 'code': 'FIDT2'},
          {'name': 'Thương mại điện tử', 'code': 'FIDT3'},
          {'name': 'Logistics số', 'code': 'FIDT4'},
          {'name': 'Marketing (Công nghệ Marketing)', 'code': 'FIDT5'},
          {'name': 'Truyền thông đa phương tiện', 'code': 'FIDT6'},
          {'name': 'Công nghệ tài chính', 'code': 'FIDT7'},
        ]
      },
    ];

    await _createDepartmentsAndMajors('economics', departments);
  }

  static Future<void> _createDepartmentsAndMajors(String facultyId, List<Map<String, dynamic>> departments) async {
    for (var deptData in departments) {
      // Create department
      final department = Department(
        id: _uuid.v4(),
        name: deptData['name'] as String,
        facultyId: facultyId,
        description: 'Khoa thuộc ${_getFacultyName(facultyId)}',
        createdAt: DateTime.now(),
      );
      
      await _dbHelper.insertDepartment(department);

      // Create majors for this department
      final majors = deptData['majors'] as List<Map<String, dynamic>>;
      for (var majorData in majors) {
        final major = Major(
          id: _uuid.v4(),
          name: majorData['name'] as String,
          code: majorData['code'] as String?,
          departmentId: department.id,
          description: 'Ngành thuộc ${department.name}',
          createdAt: DateTime.now(),
        );
        
        await _dbHelper.insertMajor(major);
      }
    }
  }

  static String _getFacultyName(String facultyId) {
    switch (facultyId) {
      case 'engineering':
        return 'Trường Kỹ thuật';
      case 'it':
        return 'Trường Công Nghệ Thông Tin';
      case 'medicine':
        return 'Trường Y - Dược';
      case 'language':
        return 'Trường NN-KHXH';
      case 'economics':
        return 'Trường Kinh Tế';
      default:
        return 'Trường';
    }
  }
}