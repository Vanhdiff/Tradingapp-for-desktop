import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import '../router/route_names.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/journal/presentation/pages/journal_page.dart';
import '../../features/plan/presentation/pages/plan_page.dart';
import '../../features/notebook/presentation/pages/notebook_page.dart';
import '../../features/news/presentation/pages/news_page.dart';
import 'widgets/shell_sidebar.dart';
import 'widgets/shell_topbar.dart';
import 'widgets/theme_picker_bar.dart';

const _themePresets = [
  ShellThemePreset(
    name: 'Trắng',
    description: 'Light mode',
    bg: Color(0xFFF3E8FF),
    shellBg: Color(0xFFF7F3FF),
    surface: Color(0xFFFFFFFF),
    primary: Color(0xFF8B6CFF),
    accent: Color(0xFF1FA971),
  ),
  ShellThemePreset(
    name: 'Đen',
    description: 'Dark mode',
    bg: Color(0xFF10131A),
    shellBg: Color(0xFF171B24),
    surface: Color(0xFF202635),
    primary: Color(0xFF9B7BFF),
    accent: Color(0xFF26D39A),
  ),
];

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  String currentRoute = RouteNames.dashboard;
  bool sidebarCollapsed = false;
  bool _showThemePicker = false;
  ShellThemePreset _selectedTheme = _themePresets.first;
  bool _isSidebarPointerInside = false;
  Timer? _sidebarAutoCollapseTimer;

  @override
  void initState() {
    super.initState();
    _scheduleSidebarAutoCollapse();
  }

  @override
  void dispose() {
    _sidebarAutoCollapseTimer?.cancel();
    super.dispose();
  }

  void navigateTo(String route) {
    setState(() {
      currentRoute = route;
    });
  }

  void _scheduleSidebarAutoCollapse() {
    _sidebarAutoCollapseTimer?.cancel();
    if (sidebarCollapsed) return;

    _sidebarAutoCollapseTimer = Timer(const Duration(seconds: 5), () {
      if (!mounted || _isSidebarPointerInside || sidebarCollapsed) return;
      setState(() => sidebarCollapsed = true);
    });
  }

  void _handleSidebarEnter() {
    _isSidebarPointerInside = true;
    _sidebarAutoCollapseTimer?.cancel();
    if (sidebarCollapsed) {
      setState(() => sidebarCollapsed = false);
    }
  }

  void _handleSidebarExit() {
    _isSidebarPointerInside = false;
    _scheduleSidebarAutoCollapse();
  }

  void _toggleSidebarCollapsed() {
    setState(() => sidebarCollapsed = !sidebarCollapsed);
    if (!sidebarCollapsed) {
      _scheduleSidebarAutoCollapse();
    } else {
      _sidebarAutoCollapseTimer?.cancel();
    }
  }

  void _toggleThemePicker() {
    setState(() => _showThemePicker = !_showThemePicker);
    _scheduleSidebarAutoCollapse();
  }

  String get pageTitle {
    switch (currentRoute) {
      case RouteNames.dashboard:
        return 'Dashboard';
      case RouteNames.journal:
        return 'Journal';
      case RouteNames.plan:
        return 'Plan';
      case RouteNames.notebook:
        return 'Notebook';
      case RouteNames.news:
        return 'News';
      default:
        return 'Trading Desk';
    }
  }

  Widget get currentPage {
    switch (currentRoute) {
      case RouteNames.dashboard:
        return const DashboardPage();
      case RouteNames.journal:
        return const JournalPage();
      case RouteNames.plan:
        return const PlanPage();
      case RouteNames.notebook:
        return const NotebookPage();
      case RouteNames.news:
        return const NewsPage();
      default:
        return const DashboardPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      content: Stack(
        children: [
          Container(
            color: _selectedTheme.bg,
            child: Row(
              children: [
                ShellSidebar(
                  currentRoute: currentRoute,
                  isCollapsed: sidebarCollapsed,
                  onNavigate: navigateTo,
                  onPointerEnter: _handleSidebarEnter,
                  onPointerExit: _handleSidebarExit,
                  onThemePressed: _toggleThemePicker,
                  onToggleCollapsed: _toggleSidebarCollapsed,
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 14, 14, 14),
                    decoration: BoxDecoration(
                      color: _selectedTheme.shellBg,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        ShellTopbar(title: pageTitle),
                        Expanded(child: currentPage),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_showThemePicker)
            Positioned(
              top: 286,
              left: sidebarCollapsed ? 46 : 66,
              width: 236,
              child: ThemePickerBar(
                presets: _themePresets,
                selected: _selectedTheme,
                onSelected: (theme) {
                  setState(() => _selectedTheme = theme);
                },
                onClose: () {
                  setState(() => _showThemePicker = false);
                },
              ),
            ),
        ],
      ),
    );
  }
}
