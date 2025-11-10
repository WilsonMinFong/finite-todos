import 'package:finite_todos/screens/done_today_page.dart';
import 'package:finite_todos/screens/in_progress_page.dart';
import 'package:finite_todos/screens/inbox_page.dart';
import 'package:flutter/material.dart';

// Page configuration class to keep all page info together
class PageConfig {
  final String Function() titleBuilder;
  final String navigationLabel;
  final IconData icon;
  final IconData selectedIcon;
  final Widget page;

  const PageConfig({
    required this.titleBuilder,
    required this.navigationLabel,
    required this.icon,
    required this.selectedIcon,
    required this.page,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  // Centralized page configurations
  late final List<PageConfig> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      PageConfig(
        titleBuilder: _formatTodayTitle,
        navigationLabel: 'Today',
        icon: Icons.today_outlined,
        selectedIcon: Icons.today,
        page: const DoneTodayPage(),
      ),
      PageConfig(
        titleBuilder: () => 'In Progress',
        navigationLabel: 'In Progress',
        icon: Icons.autorenew_outlined,
        selectedIcon: Icons.autorenew,
        page: const InProgressPage(),
      ),
      PageConfig(
        titleBuilder: () => 'Inbox',
        navigationLabel: 'Inbox',
        icon: Icons.inbox_outlined,
        selectedIcon: Icons.inbox,
        page: const InboxPage(),
      ),
    ];
  }

  String _formatTodayTitle() {
    final now = DateTime.now();
    final weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final months = ['January', 'February', 'March', 'April', 'May', 'June',
                   'July', 'August', 'September', 'October', 'November', 'December'];
    
    final weekday = weekdays[now.weekday - 1];
    final month = months[now.month - 1];
    final day = now.day;
    
    return '$weekday, $month $day';
  }

  void _setCurrentPageIndex(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = _pages[currentPageIndex];
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentPage.titleBuilder(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _setCurrentPageIndex,
        selectedIndex: currentPageIndex,
        destinations: _pages.map((pageConfig) => NavigationDestination(
          icon: Icon(pageConfig.icon),
          selectedIcon: Icon(pageConfig.selectedIcon),
          label: pageConfig.navigationLabel,
        )).toList(),
      ),
      body: currentPage.page,
    );
  }
}
