import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import '../router/route_names.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme_palette.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/journal/presentation/pages/journal_page.dart';
import '../../features/plan/presentation/pages/plan_page.dart';
import '../../features/notebook/presentation/pages/notebook_page.dart';
import '../../features/news/presentation/pages/news_page.dart';
import 'widgets/shell_sidebar.dart';
import 'widgets/shell_topbar.dart';
import 'widgets/theme_picker_bar.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  String currentRoute = RouteNames.dashboard;
  bool sidebarCollapsed = false;
  bool _showThemePicker = false;
  AppThemePalette _selectedTheme = AppThemePalettes.light;
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

    _sidebarAutoCollapseTimer = Timer(Duration(seconds: 5), () {
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
        return DashboardPage();
      case RouteNames.journal:
        return JournalPage();
      case RouteNames.plan:
        return PlanPage();
      case RouteNames.notebook:
        return NotebookPage();
      case RouteNames.news:
        return NewsPage();
      default:
        return DashboardPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      content: DefaultTextStyle(
        style: TextStyle(color: _selectedTheme.textPrimary),
        child: IconTheme(
          data: IconThemeData(color: _selectedTheme.textSecondary),
          child: Stack(
            children: [
              Container(
                color: _selectedTheme.bg,
                child: Row(
                  children: [
                    ShellSidebar(
                      currentRoute: currentRoute,
                      isCollapsed: sidebarCollapsed,
                      theme: _selectedTheme,
                      onNavigate: navigateTo,
                      onPointerEnter: _handleSidebarEnter,
                      onPointerExit: _handleSidebarExit,
                      onThemePressed: _toggleThemePicker,
                      onToggleCollapsed: _toggleSidebarCollapsed,
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 14, 14, 14),
                        decoration: BoxDecoration(
                          color: _selectedTheme.shellBg,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          children: [
                            ShellTopbar(
                              title: pageTitle,
                              theme: _selectedTheme,
                            ),
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
                    presets: AppThemePalettes.all,
                    selected: _selectedTheme,
                    onSelected: (theme) {
                      setState(() {
                        _selectedTheme = theme;
                        AppColors.use(theme);
                      });
                    },
                    onClose: () {
                      setState(() => _showThemePicker = false);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
