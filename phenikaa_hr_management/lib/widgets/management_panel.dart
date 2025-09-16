import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/hr_provider.dart';
import '../models/university.dart';
import '../models/faculty.dart';
import '../models/department.dart';
import '../models/major.dart';
import '../models/lecturer.dart';

enum ManagementType { faculty, department, major, lecturer }

class ManagementPanel extends StatefulWidget {
  final ManagementType type;

  const ManagementPanel({Key? key, required this.type}) : super(key: key);

  @override
  State<ManagementPanel> createState() => _ManagementPanelState();
}

class _ManagementPanelState extends State<ManagementPanel> {
  final _uuid = const Uuid();
  String? selectedParentId;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HRProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _getTitle(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showAddDialog(context, provider),
                    icon: const Icon(Icons.add),
                    label: Text(_getAddButtonText()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (widget.type != ManagementType.faculty) ...[
                _buildParentSelector(provider),
                const SizedBox(height: 16),
              ],
              Expanded(
                child: _buildDataTable(provider),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getTitle() {
    switch (widget.type) {
      case ManagementType.faculty:
        return 'Quản lý Trường';
      case ManagementType.department:
        return 'Quản lý Khoa';
      case ManagementType.major:
        return 'Quản lý Ngành';
      case ManagementType.lecturer:
        return 'Quản lý Giảng viên';
    }
  }

  String _getAddButtonText() {
    switch (widget.type) {
      case ManagementType.faculty:
        return 'Thêm Trường';
      case ManagementType.department:
        return 'Thêm Khoa';
      case ManagementType.major:
        return 'Thêm Ngành';
      case ManagementType.lecturer:
        return 'Thêm Giảng viên';
    }
  }

  Widget _buildParentSelector(HRProvider provider) {
    return Row(
      children: [
        Text(
          _getParentSelectorLabel(),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownButton<String>(
            value: selectedParentId,
            hint: Text(_getParentSelectorHint()),
            isExpanded: true,
            onChanged: (String? newValue) {
              setState(() {
                selectedParentId = newValue;
              });
            },
            items: _getParentOptions(provider),
          ),
        ),
      ],
    );
  }

  String _getParentSelectorLabel() {
    switch (widget.type) {
      case ManagementType.department:
        return 'Chọn Trường:';
      case ManagementType.major:
        return 'Chọn Khoa:';
      case ManagementType.lecturer:
        return 'Chọn Ngành:';
      default:
        return '';
    }
  }

  String _getParentSelectorHint() {
    switch (widget.type) {
      case ManagementType.department:
        return 'Chọn trường';
      case ManagementType.major:
        return 'Chọn khoa';
      case ManagementType.lecturer:
        return 'Chọn ngành';
      default:
        return '';
    }
  }

  List<DropdownMenuItem<String>> _getParentOptions(HRProvider provider) {
    final items = <DropdownMenuItem<String>>[];
    
    switch (widget.type) {
      case ManagementType.department:
        // Get faculties from hierarchy
        provider.hierarchyData.forEach((uniId, uniData) {
          final faculties = uniData['faculties'] as Map<String, dynamic>;
          faculties.forEach((facId, facData) {
            final faculty = facData['data'] as Faculty;
            items.add(DropdownMenuItem<String>(
              value: faculty.id,
              child: Text(faculty.name),
            ));
          });
        });
        break;
      case ManagementType.major:
        // Get departments from hierarchy
        provider.hierarchyData.forEach((uniId, uniData) {
          final faculties = uniData['faculties'] as Map<String, dynamic>;
          faculties.forEach((facId, facData) {
            final departments = facData['departments'] as Map<String, dynamic>;
            departments.forEach((deptId, deptData) {
              final department = deptData['data'] as Department;
              items.add(DropdownMenuItem<String>(
                value: department.id,
                child: Text(department.name),
              ));
            });
          });
        });
        break;
      case ManagementType.lecturer:
        // Get majors from hierarchy
        provider.hierarchyData.forEach((uniId, uniData) {
          final faculties = uniData['faculties'] as Map<String, dynamic>;
          faculties.forEach((facId, facData) {
            final departments = facData['departments'] as Map<String, dynamic>;
            departments.forEach((deptId, deptData) {
              final majors = deptData['majors'] as Map<String, dynamic>;
              majors.forEach((majorId, majorData) {
                final major = majorData['data'] as Major;
                items.add(DropdownMenuItem<String>(
                  value: major.id,
                  child: Text(major.name),
                ));
              });
            });
          });
        });
        break;
      default:
        break;
    }
    
    return items;
  }

  Widget _buildDataTable(HRProvider provider) {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: _buildTable(provider),
        ),
      ),
    );
  }

  Widget _buildTable(HRProvider provider) {
    switch (widget.type) {
      case ManagementType.faculty:
        return _buildFacultyTable(provider);
      case ManagementType.department:
        return _buildDepartmentTable(provider);
      case ManagementType.major:
        return _buildMajorTable(provider);
      case ManagementType.lecturer:
        return _buildLecturerTable(provider);
    }
  }

  Widget _buildFacultyTable(HRProvider provider) {
    final faculties = <Faculty>[];
    provider.hierarchyData.forEach((uniId, uniData) {
      final facultyMap = uniData['faculties'] as Map<String, dynamic>;
      facultyMap.forEach((facId, facData) {
        faculties.add(facData['data'] as Faculty);
      });
    });

    return DataTable(
      columns: const [
        DataColumn(label: Text('Tên Trường')),
        DataColumn(label: Text('Mô tả')),
        DataColumn(label: Text('Ngày tạo')),
        DataColumn(label: Text('Thao tác')),
      ],
      rows: faculties.map((faculty) {
        return DataRow(cells: [
          DataCell(Text(faculty.name)),
          DataCell(Text(faculty.description ?? '')),
          DataCell(Text(_formatDate(faculty.createdAt))),
          DataCell(Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _showEditDialog(context, provider, faculty),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmDelete(context, provider, faculty.id, faculty.name),
              ),
            ],
          )),
        ]);
      }).toList(),
    );
  }

  Widget _buildDepartmentTable(HRProvider provider) {
    final departments = <Department>[];
    provider.hierarchyData.forEach((uniId, uniData) {
      final faculties = uniData['faculties'] as Map<String, dynamic>;
      faculties.forEach((facId, facData) {
        final departmentMap = facData['departments'] as Map<String, dynamic>;
        departmentMap.forEach((deptId, deptData) {
          final dept = deptData['data'] as Department;
          if (selectedParentId == null || dept.facultyId == selectedParentId) {
            departments.add(dept);
          }
        });
      });
    });

    return DataTable(
      columns: const [
        DataColumn(label: Text('Tên Khoa')),
        DataColumn(label: Text('Mô tả')),
        DataColumn(label: Text('Ngày tạo')),
        DataColumn(label: Text('Thao tác')),
      ],
      rows: departments.map((department) {
        return DataRow(cells: [
          DataCell(Text(department.name)),
          DataCell(Text(department.description ?? '')),
          DataCell(Text(_formatDate(department.createdAt))),
          DataCell(Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _showEditDialog(context, provider, department),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmDelete(context, provider, department.id, department.name),
              ),
            ],
          )),
        ]);
      }).toList(),
    );
  }

  Widget _buildMajorTable(HRProvider provider) {
    final majors = <Major>[];
    provider.hierarchyData.forEach((uniId, uniData) {
      final faculties = uniData['faculties'] as Map<String, dynamic>;
      faculties.forEach((facId, facData) {
        final departments = facData['departments'] as Map<String, dynamic>;
        departments.forEach((deptId, deptData) {
          final majorMap = deptData['majors'] as Map<String, dynamic>;
          majorMap.forEach((majorId, majorData) {
            final major = majorData['data'] as Major;
            if (selectedParentId == null || major.departmentId == selectedParentId) {
              majors.add(major);
            }
          });
        });
      });
    });

    return DataTable(
      columns: const [
        DataColumn(label: Text('Tên Ngành')),
        DataColumn(label: Text('Mã ngành')),
        DataColumn(label: Text('Mô tả')),
        DataColumn(label: Text('Ngày tạo')),
        DataColumn(label: Text('Thao tác')),
      ],
      rows: majors.map((major) {
        return DataRow(cells: [
          DataCell(Text(major.name)),
          DataCell(Text(major.code ?? '')),
          DataCell(Text(major.description ?? '')),
          DataCell(Text(_formatDate(major.createdAt))),
          DataCell(Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _showEditDialog(context, provider, major),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmDelete(context, provider, major.id, major.name),
              ),
            ],
          )),
        ]);
      }).toList(),
    );
  }

  Widget _buildLecturerTable(HRProvider provider) {
    final lecturers = <Lecturer>[];
    provider.hierarchyData.forEach((uniId, uniData) {
      final faculties = uniData['faculties'] as Map<String, dynamic>;
      faculties.forEach((facId, facData) {
        final departments = facData['departments'] as Map<String, dynamic>;
        departments.forEach((deptId, deptData) {
          final majors = deptData['majors'] as Map<String, dynamic>;
          majors.forEach((majorId, majorData) {
            final lecturerList = majorData['lecturers'] as List<Lecturer>;
            for (var lecturer in lecturerList) {
              if (selectedParentId == null || lecturer.majorId == selectedParentId) {
                lecturers.add(lecturer);
              }
            }
          });
        });
      });
    });

    return DataTable(
      columns: const [
        DataColumn(label: Text('Tên Giảng viên')),
        DataColumn(label: Text('Email')),
        DataColumn(label: Text('Điện thoại')),
        DataColumn(label: Text('Chức vụ')),
        DataColumn(label: Text('Ngày tạo')),
        DataColumn(label: Text('Thao tác')),
      ],
      rows: lecturers.map((lecturer) {
        return DataRow(cells: [
          DataCell(Text(lecturer.name)),
          DataCell(Text(lecturer.email ?? '')),
          DataCell(Text(lecturer.phone ?? '')),
          DataCell(Text(lecturer.position ?? '')),
          DataCell(Text(_formatDate(lecturer.createdAt))),
          DataCell(Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _showEditDialog(context, provider, lecturer),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmDelete(context, provider, lecturer.id, lecturer.name),
              ),
            ],
          )),
        ]);
      }).toList(),
    );
  }

  void _showAddDialog(BuildContext context, HRProvider provider) {
    switch (widget.type) {
      case ManagementType.faculty:
        _showFacultyDialog(context, provider);
        break;
      case ManagementType.department:
        _showDepartmentDialog(context, provider);
        break;
      case ManagementType.major:
        _showMajorDialog(context, provider);
        break;
      case ManagementType.lecturer:
        _showLecturerDialog(context, provider);
        break;
    }
  }

  void _showEditDialog(BuildContext context, HRProvider provider, dynamic item) {
    switch (widget.type) {
      case ManagementType.faculty:
        _showFacultyDialog(context, provider, faculty: item as Faculty);
        break;
      case ManagementType.department:
        _showDepartmentDialog(context, provider, department: item as Department);
        break;
      case ManagementType.major:
        _showMajorDialog(context, provider, major: item as Major);
        break;
      case ManagementType.lecturer:
        _showLecturerDialog(context, provider, lecturer: item as Lecturer);
        break;
    }
  }

  void _showFacultyDialog(BuildContext context, HRProvider provider, {Faculty? faculty}) {
    final nameController = TextEditingController(text: faculty?.name ?? '');
    final descriptionController = TextEditingController(text: faculty?.description ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(faculty == null ? 'Thêm Trường mới' : 'Sửa Trường'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Tên Trường',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Mô tả',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isEmpty) return;

              if (faculty == null) {
                final newFaculty = Faculty(
                  id: _uuid.v4(),
                  name: nameController.text.trim(),
                  universityId: 'phenikaa-uni',
                  description: descriptionController.text.trim(),
                  createdAt: DateTime.now(),
                );
                await provider.addFaculty(newFaculty);
              } else {
                final updatedFaculty = faculty.copyWith(
                  name: nameController.text.trim(),
                  description: descriptionController.text.trim(),
                );
                await provider.updateFaculty(updatedFaculty);
              }

              Navigator.pop(context);
            },
            child: Text(faculty == null ? 'Thêm' : 'Cập nhật'),
          ),
        ],
      ),
    );
  }

  void _showDepartmentDialog(BuildContext context, HRProvider provider, {Department? department}) {
    final nameController = TextEditingController(text: department?.name ?? '');
    final descriptionController = TextEditingController(text: department?.description ?? '');
    String? selectedFacultyId = department?.facultyId ?? selectedParentId;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(department == null ? 'Thêm Khoa mới' : 'Sửa Khoa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedFacultyId,
                decoration: const InputDecoration(
                  labelText: 'Chọn Trường',
                  border: OutlineInputBorder(),
                ),
                items: _getParentOptions(provider),
                onChanged: (value) => setState(() => selectedFacultyId = value),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Tên Khoa',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Mô tả',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty || selectedFacultyId == null) return;

                if (department == null) {
                  final newDepartment = Department(
                    id: _uuid.v4(),
                    name: nameController.text.trim(),
                    facultyId: selectedFacultyId!,
                    description: descriptionController.text.trim(),
                    createdAt: DateTime.now(),
                  );
                  await provider.addDepartment(newDepartment);
                } else {
                  final updatedDepartment = department.copyWith(
                    name: nameController.text.trim(),
                    facultyId: selectedFacultyId!,
                    description: descriptionController.text.trim(),
                  );
                  await provider.updateDepartment(updatedDepartment);
                }

                Navigator.pop(context);
              },
              child: Text(department == null ? 'Thêm' : 'Cập nhật'),
            ),
          ],
        ),
      ),
    );
  }

  void _showMajorDialog(BuildContext context, HRProvider provider, {Major? major}) {
    final nameController = TextEditingController(text: major?.name ?? '');
    final codeController = TextEditingController(text: major?.code ?? '');
    final descriptionController = TextEditingController(text: major?.description ?? '');
    String? selectedDepartmentId = major?.departmentId ?? selectedParentId;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(major == null ? 'Thêm Ngành mới' : 'Sửa Ngành'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedDepartmentId,
                decoration: const InputDecoration(
                  labelText: 'Chọn Khoa',
                  border: OutlineInputBorder(),
                ),
                items: _getParentOptions(provider),
                onChanged: (value) => setState(() => selectedDepartmentId = value),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Tên Ngành',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: codeController,
                decoration: const InputDecoration(
                  labelText: 'Mã ngành',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Mô tả',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty || selectedDepartmentId == null) return;

                if (major == null) {
                  final newMajor = Major(
                    id: _uuid.v4(),
                    name: nameController.text.trim(),
                    code: codeController.text.trim().isEmpty ? null : codeController.text.trim(),
                    departmentId: selectedDepartmentId!,
                    description: descriptionController.text.trim(),
                    createdAt: DateTime.now(),
                  );
                  await provider.addMajor(newMajor);
                } else {
                  final updatedMajor = major.copyWith(
                    name: nameController.text.trim(),
                    code: codeController.text.trim().isEmpty ? null : codeController.text.trim(),
                    departmentId: selectedDepartmentId!,
                    description: descriptionController.text.trim(),
                  );
                  await provider.updateMajor(updatedMajor);
                }

                Navigator.pop(context);
              },
              child: Text(major == null ? 'Thêm' : 'Cập nhật'),
            ),
          ],
        ),
      ),
    );
  }

  void _showLecturerDialog(BuildContext context, HRProvider provider, {Lecturer? lecturer}) {
    final nameController = TextEditingController(text: lecturer?.name ?? '');
    final emailController = TextEditingController(text: lecturer?.email ?? '');
    final phoneController = TextEditingController(text: lecturer?.phone ?? '');
    final positionController = TextEditingController(text: lecturer?.position ?? '');
    String? selectedMajorId = lecturer?.majorId ?? selectedParentId;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(lecturer == null ? 'Thêm Giảng viên mới' : 'Sửa Giảng viên'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedMajorId,
                  decoration: const InputDecoration(
                    labelText: 'Chọn Ngành',
                    border: OutlineInputBorder(),
                  ),
                  items: _getParentOptions(provider),
                  onChanged: (value) => setState(() => selectedMajorId = value),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Tên Giảng viên',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Điện thoại',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: positionController,
                  decoration: const InputDecoration(
                    labelText: 'Chức vụ',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty || selectedMajorId == null) return;

                if (lecturer == null) {
                  final newLecturer = Lecturer(
                    id: _uuid.v4(),
                    name: nameController.text.trim(),
                    email: emailController.text.trim().isEmpty ? null : emailController.text.trim(),
                    phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
                    position: positionController.text.trim().isEmpty ? null : positionController.text.trim(),
                    majorId: selectedMajorId!,
                    createdAt: DateTime.now(),
                  );
                  await provider.addLecturer(newLecturer);
                } else {
                  final updatedLecturer = lecturer.copyWith(
                    name: nameController.text.trim(),
                    email: emailController.text.trim().isEmpty ? null : emailController.text.trim(),
                    phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
                    position: positionController.text.trim().isEmpty ? null : positionController.text.trim(),
                    majorId: selectedMajorId!,
                  );
                  await provider.updateLecturer(updatedLecturer);
                }

                Navigator.pop(context);
              },
              child: Text(lecturer == null ? 'Thêm' : 'Cập nhật'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, HRProvider provider, String id, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa "$name"?\nThao tác này không thể hoàn tác.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              switch (widget.type) {
                case ManagementType.faculty:
                  await provider.deleteFaculty(id);
                  break;
                case ManagementType.department:
                  await provider.deleteDepartment(id);
                  break;
                case ManagementType.major:
                  await provider.deleteMajor(id);
                  break;
                case ManagementType.lecturer:
                  await provider.deleteLecturer(id);
                  break;
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}