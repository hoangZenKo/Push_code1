import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hr_provider.dart';
import '../models/university.dart';
import '../models/faculty.dart';
import '../models/department.dart';
import '../models/major.dart';
import '../models/lecturer.dart';

class HierarchyTreeWidget extends StatefulWidget {
   const HierarchyTreeWidget({super.key}); 

  @override
  State<HierarchyTreeWidget> createState() => _HierarchyTreeWidgetState();
}

class _HierarchyTreeWidgetState extends State<HierarchyTreeWidget> {
  final Map<String, bool> _expandedNodes = {};

  @override
  Widget build(BuildContext context) {
    return Consumer<HRProvider>(
      builder: (context, provider, child) {
        if (provider.hierarchyData.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sơ đồ Tổ chức Đại học Phenikaa',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: _buildHierarchyTree(provider.hierarchyData),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHierarchyTree(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.entries.map((universityEntry) {
        final universityData = universityEntry.value;
        final university = universityData['data'] as University;
        final faculties = universityData['faculties'] as Map<String, dynamic>;

        return _buildUniversityNode(university, faculties);
      }).toList(),
    );
  }

  Widget _buildUniversityNode(University university, Map<String, dynamic> faculties) {
    final isExpanded = _expandedNodes[university.id] ?? true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _expandedNodes[university.id] = !isExpanded;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              border: Border.all(color: Colors.blue[200]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  isExpanded ? Icons.expand_more : Icons.chevron_right,
                  color: Colors.blue[800],
                ),
                const SizedBox(width: 8),
                Icon(Icons.account_balance, color: Colors.blue[800]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    university.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isExpanded) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Column(
              children: faculties.entries.map((facultyEntry) {
                final facultyData = facultyEntry.value;
                final faculty = facultyData['data'] as Faculty;
                final departments = facultyData['departments'] as Map<String, dynamic>;

                return _buildFacultyNode(faculty, departments);
              }).toList(),
            ),
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFacultyNode(Faculty faculty, Map<String, dynamic> departments) {
    final isExpanded = _expandedNodes[faculty.id] ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _expandedNodes[faculty.id] = !isExpanded;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: Colors.green[50],
              border: Border.all(color: Colors.green[200]!),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Icon(
                  isExpanded ? Icons.expand_more : Icons.chevron_right,
                  color: Colors.green[700],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Icon(Icons.business, color: Colors.green[700], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    faculty.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.green[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isExpanded) ...[
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              children: departments.entries.map((departmentEntry) {
                final departmentData = departmentEntry.value;
                final department = departmentData['data'] as Department;
                final majors = departmentData['majors'] as Map<String, dynamic>;

                return _buildDepartmentNode(department, majors);
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDepartmentNode(Department department, Map<String, dynamic> majors) {
    final isExpanded = _expandedNodes[department.id] ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _expandedNodes[department.id] = !isExpanded;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              border: Border.all(color: Colors.orange[200]!),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Icon(
                  isExpanded ? Icons.expand_more : Icons.chevron_right,
                  color: Colors.orange[700],
                  size: 18,
                ),
                const SizedBox(width: 6),
                Icon(Icons.school, color: Colors.orange[700], size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    department.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Colors.orange[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isExpanded) ...[
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              children: majors.entries.map((majorEntry) {
                final majorData = majorEntry.value;
                final major = majorData['data'] as Major;
                final lecturers = majorData['lecturers'] as List<Lecturer>;

                return _buildMajorNode(major, lecturers);
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMajorNode(Major major, List<Lecturer> lecturers) {
    final isExpanded = _expandedNodes[major.id] ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _expandedNodes[major.id] = !isExpanded;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: Colors.purple[50],
              border: Border.all(color: Colors.purple[200]!),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Icon(
                  isExpanded ? Icons.expand_more : Icons.chevron_right,
                  color: Colors.purple[700],
                  size: 16,
                ),
                const SizedBox(width: 6),
                Icon(Icons.category, color: Colors.purple[700], size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${major.name}${major.code != null ? ' (${major.code})' : ''}',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Colors.purple[700],
                    ),
                  ),
                ),
                Text(
                  '${lecturers.length} GV',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.purple[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isExpanded) ...[
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Column(
              children: lecturers.map((lecturer) {
                return Container(
                  padding: const EdgeInsets.all(6),
                  margin: const EdgeInsets.only(bottom: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.person, color: Colors.grey[600], size: 14),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          lecturer.name,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      if (lecturer.position != null)
                        Text(
                          lecturer.position!,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }
}