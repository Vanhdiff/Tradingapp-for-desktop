import 'package:fluent_ui/fluent_ui.dart';

import '../../../../app/theme/app_colors.dart';

class NewsHeader extends StatelessWidget {
  final NewsViewMode selectedMode;
  final ValueChanged<NewsViewMode> onModeChanged;

  const NewsHeader({
    super.key,
    required this.selectedMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'News',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Text(
            'Key market events and data releases at your fingertips.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _HeaderActions(
          selectedMode: selectedMode,
          onModeChanged: onModeChanged,
        ),
      ],
    );
  }
}

enum NewsViewMode { list, calendar }

class _HeaderActions extends StatelessWidget {
  final NewsViewMode selectedMode;
  final ValueChanged<NewsViewMode> onModeChanged;

  const _HeaderActions({
    required this.selectedMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ModeButton(
          icon: FluentIcons.list,
          label: 'List',
          selected: selectedMode == NewsViewMode.list,
          onTap: () => onModeChanged(NewsViewMode.list),
        ),
        const SizedBox(width: 8),
        _ModeButton(
          icon: FluentIcons.calendar,
          label: 'Calendar',
          selected: selectedMode == NewsViewMode.calendar,
          onTap: () => onModeChanged(NewsViewMode.calendar),
        ),
        const SizedBox(width: 8),
        const _ModeButton(
          icon: FluentIcons.lock,
          label: 'Block Trading Settings',
        ),
        const SizedBox(width: 8),
        const _IconButton(FluentIcons.refresh),
      ],
    );
  }
}

class _ModeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _ModeButton({
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFE8E3F3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: selected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;

  const _IconButton(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: const Color(0xFFE8E3F3)),
      ),
      child: Icon(icon, size: 15, color: AppColors.textSecondary),
    );
  }
}
