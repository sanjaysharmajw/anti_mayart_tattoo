import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'about_screen.dart';
import 'portfolio_screen.dart';
import 'tattoo_screen.dart';
import 'contact_screen.dart';
import '../widgets/sidebar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _isCollapsed = false;

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return DashboardScreen(onNavigate: (i) => setState(() => _selectedIndex = i));
      case 1:
        return const AboutScreen();
      case 2:
        return const PortfolioScreen();
      case 3:
        return const TattooScreen();
      case 4:
        return const ContactScreen();
      default:
        return DashboardScreen(onNavigate: (i) => setState(() => _selectedIndex = i));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            currentIndex: _selectedIndex,
            isCollapsed: _isCollapsed,
            onToggleCollapse: () {
              setState(() {
                _isCollapsed = !_isCollapsed;
              });
            },
            onSelect: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [0, 1, 2, 3, 4].map((i) => _buildScreen(i)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
