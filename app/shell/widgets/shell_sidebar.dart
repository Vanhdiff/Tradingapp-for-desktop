import 'package:fluent_ui/fluent_ui.dart';
import '../app_nav_item.dart';
import '../app_nav_items.dart';
import '../shell_theme.dart';

class ShellSidebar extends StatelessWidget {
  final String currentRoute;
  final bool isCollapsed;
  final AppThemePalette theme;
  final ValueChanged<String> onNavigate;
  final VoidCallback onPointerEnter;
  final VoidCallback onPointerExit;
  final VoidCallback onThemePressed;
  final VoidCallback onToggleCollapsed;

  const ShellSidebar({
    super.key,
    required this.currentRoute,
    required this.isCollapsed,
    required this.theme,
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
          color: theme.sidebar,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.border),
        ),
        child: isCollapsed
            ? _CollapsedSidebar(theme: theme, onTap: onToggleCollapsed)
            : Column(
                children: [
                  const SizedBox(height: 10),

                  /// logo
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: theme.primary,
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
                              theme: theme,
                              onTap: () => onNavigate(item.route),
                            ),
                          ),
                          const SizedBox(height: 4),
                          ...AppNavItems.utilities.map(
                            (item) => _SidebarIconButton(
                              item: item,
                              selected: false,
                              theme: theme,
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
                    decoration: BoxDecoration(
                      color: theme.hover,
                      shape: BoxShape.circle,
                      border: Border.all(color: theme.border),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'V',
                      style: TextStyle(
                        color: theme.textPrimary,
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
  final AppThemePalette theme;
  final VoidCallback onTap;

  const _CollapsedSidebar({required this.theme, required this.onTap});

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
                color: theme.hover,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: theme.border),
              ),
              child: Icon(
                FluentIcons.double_chevron_right,
                size: 14,
                color: theme.primary,
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
  final AppThemePalette theme;
  final VoidCallback onTap;

  const _SidebarIconButton({
    required this.item,
    required this.selected,
    required this.theme,
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
              color: selected ? theme.hover : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              item.icon,
              size: 18,
              color: selected ? theme.primary : theme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
