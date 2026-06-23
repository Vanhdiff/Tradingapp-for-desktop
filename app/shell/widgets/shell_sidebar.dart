import 'package:fluent_ui/fluent_ui.dart';
import '../../../app/theme/app_colors.dart';
import '../app_nav_item.dart';
import '../app_nav_items.dart';

class ShellSidebar extends StatelessWidget {
  final String currentRoute;
  final bool isCollapsed;
  final ValueChanged<String> onNavigate;
  final VoidCallback onPointerEnter;
  final VoidCallback onPointerExit;
  final VoidCallback onThemePressed;
  final VoidCallback onToggleCollapsed;

  const ShellSidebar({
    super.key,
    required this.currentRoute,
    required this.isCollapsed,
    required this.onNavigate,
    required this.onPointerEnter,
    required this.onPointerExit,
    required this.onThemePressed,
    required this.onToggleCollapsed,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => onPointerEnter(),
      onExit: (_) => onPointerExit(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        width: isCollapsed ? 28 : 48,
        margin: const EdgeInsets.fromLTRB(8, 8, 6, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: isCollapsed
            ? _CollapsedSidebar(onTap: onToggleCollapsed)
            : Column(
                children: [
                  const SizedBox(height: 10),

                  /// logo
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      FluentIcons.cube_shape,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// nav icons
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Column(
                        children: [
                          ...AppNavItems.main.map(
                            (item) => _SidebarIconButton(
                              item: item,
                              selected: currentRoute == item.route,
                              onTap: () => onNavigate(item.route),
                            ),
                          ),
                          const SizedBox(height: 4),
                          ...AppNavItems.utilities.map(
                            (item) => _SidebarIconButton(
                              item: item,
                              selected: false,
                              onTap: switch (item.key) {
                                'collapse' => onToggleCollapsed,
                                'theme' => onThemePressed,
                                _ => () {},
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),

                  /// avatar
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2D2D2D),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'V',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                ],
              ),
      ),
    );
  }
}

class _CollapsedSidebar extends StatelessWidget {
  final VoidCallback onTap;

  const _CollapsedSidebar({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Tooltip(
          message: 'Expand',
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              width: 22,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                FluentIcons.double_chevron_right,
                size: 14,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

class _SidebarIconButton extends StatelessWidget {
  final AppNavItem item;
  final bool selected;
  final VoidCallback onTap;

  const _SidebarIconButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Tooltip(
        message: item.label,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: selected ? AppColors.primarySoft : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              item.icon,
              size: 18,
              color: selected ? AppColors.primary : const Color(0xFF5F5F68),
            ),
          ),
        ),
      ),
    );
  }
}
