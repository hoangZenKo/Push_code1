import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hr_provider.dart';
import '../widgets/hierarchy_tree_widget.dart';
import '../widgets/management_panel.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HRProvider>().loadAllData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hệ thống Quản lý Nhân sự - Đại học Phenikaa',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),

      // ✅ Nội dung chính thay đổi theo tab
      body: _buildSelectedContent(),

      // ✅ Menu điều hướng ở dưới thay cho NavigationRail
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed, // hiện đủ 5 item
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_tree),
            label: 'Sơ đồ Tổ chức',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Quản lý Trường',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Quản lý Khoa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Quản lý Ngành',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Quản lý GV',
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedContent() {
    switch (_selectedIndex) {
      case 0:
        return const HierarchyTreeWidget();
      case 1:
        return const ManagementPanel(type: ManagementType.faculty);
      case 2:
        return const ManagementPanel(type: ManagementType.department);
      case 3:
        return const ManagementPanel(type: ManagementType.major);
      case 4:
        return const ManagementPanel(type: ManagementType.lecturer);
      default:
        return const HierarchyTreeWidget();
    }
  }
}
