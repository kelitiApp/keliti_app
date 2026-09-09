import 'package:flutter/material.dart';

import '../../core/widgets/widgets.dart';
import '../appointments/presentation/pages/appointments_page.dart';
import '../home/presentation/pages/home_page.dart';
import '../medications/presentation/pages/medications_page.dart';
import '../profile/presentation/pages/profile_page.dart';
import '../reports/presentation/pages/reports_page.dart';

/// Bottom-nav container for the 5 primary tabs. Reading order (RTL,
/// rightmost first): الرئيسية، الأدوية، المواعيد، التقارير، الملف.
class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _index = 0;

  static const _pages = [
    HomePage(),
    MedicationsPage(),
    AppointmentsPage(),
    ReportsPage(),
    ProfilePage(),
  ];

  static const _items = [
    AppNavItem(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'الرئيسية'),
    AppNavItem(icon: Icons.medication_outlined, activeIcon: Icons.medication_rounded, label: 'الأدوية'),
    AppNavItem(icon: Icons.event_outlined, activeIcon: Icons.event_rounded, label: 'المواعيد'),
    AppNavItem(icon: Icons.description_outlined, activeIcon: Icons.description_rounded, label: 'التقارير'),
    AppNavItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: 'الملف'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // `fit: expand` forces tight constraints on every child — without it,
      // IndexedStack only gives its children loose constraints, which
      // breaks pages that use Expanded/Flexible internally (they'd get an
      // unbounded height and silently fail to lay out).
      body: IndexedStack(index: _index, sizing: StackFit.expand, children: _pages),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _index,
        items: _items,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}
