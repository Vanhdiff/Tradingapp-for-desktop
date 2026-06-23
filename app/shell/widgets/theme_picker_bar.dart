import 'package:fluent_ui/fluent_ui.dart';

import '../../theme/app_colors.dart';

class ShellThemePreset {
  final String name;
  final String description;
  final Color bg;
  final Color shellBg;
  final Color surface;
  final Color primary;
  final Color accent;

  const ShellThemePreset({
    required this.name,
    required this.description,
    required this.bg,
    required this.shellBg,
    required this.surface,
    required this.primary,
    required this.accent,
  });
}

class ThemePickerBar extends StatelessWidget {
  final List<ShellThemePreset> presets;
  final ShellThemePreset selected;
  final ValueChanged<ShellThemePreset> onSelected;
  final VoidCallback onClose;

  const ThemePickerBar({
    super.key,
    required this.presets,
    required this.selected,
    required this.onSelected,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.14),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Theme',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onClose,
                child: Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.shellBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(
                    FluentIcons.cancel,
                    size: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...presets.map(
            (preset) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _ThemePresetChip(
                preset: preset,
                selected: preset.name == selected.name,
                onTap: () => onSelected(preset),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemePresetChip extends StatelessWidget {
  final ShellThemePreset preset;
  final bool selected;
  final VoidCallback onTap;

  const _ThemePresetChip({
    required this.preset,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOutCubic,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: selected
              ? preset.primary.withValues(alpha: 0.09)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? preset.primary : const Color(0xFFE8E3F3),
            width: selected ? 1.3 : 1,
          ),
        ),
        child: Row(
          children: [
            _ThemeSwatches(preset: preset),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          preset.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      if (selected)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: preset.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    preset.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: selected
                          ? preset.primary
                          : AppColors.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeSwatches extends StatelessWidget {
  final ShellThemePreset preset;

  const _ThemeSwatches({required this.preset});

  @override
  Widget build(BuildContext context) {
    final swatches = [preset.bg, preset.shellBg, preset.primary, preset.accent];

    return SizedBox(
      width: 38,
      height: 28,
      child: Stack(
        children: [
          for (var index = 0; index < swatches.length; index++)
            Positioned(
              left: index * 8,
              child: Container(
                width: 18,
                height: 28,
                decoration: BoxDecoration(
                  color: swatches[index],
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
