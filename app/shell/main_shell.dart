import 'package:fluent_ui/fluent_ui.dart';
import '../router/route_names.dart';
import '../theme/app_colors.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/journal/presentation/pages/journal_page.dart';
import '../../features/plan/presentation/pages/plan_page.dart';
import '../../features/notebook/presentation/pages/notebook_page.dart';
import '../../features/news/presentation/pages/news_page.dart';
import 'widgets/shell_sidebar.dart';
import 'widgets/shell_topbar.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  String currentRoute = RouteNames.dashboard;

  void navigateTo(String route) {
    setState(() {
      currentRoute = route;
    });
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
      content: Container(
        color: AppColors.bg,
        child: Row(
          children: [
            ShellSidebar(currentRoute: currentRoute, onNavigate: navigateTo),
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 14, 14, 14),
                decoration: BoxDecoration(
                  color: AppColors.shellBg,
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
    );
  }
}
