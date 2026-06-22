import 'package:fluent_ui/fluent_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../data/notebook_sample_data.dart';

class NotebookTemplatesBoard extends StatefulWidget {
  final List<NotebookTemplate> templates;
  final String? selectedTemplateTitle;
  final ValueChanged<NotebookTemplate> onTemplateSelected;

  const NotebookTemplatesBoard({
    super.key,
    required this.templates,
    required this.selectedTemplateTitle,
    required this.onTemplateSelected,
  });

  @override
  State<NotebookTemplatesBoard> createState() => _NotebookTemplatesBoardState();
}

class _NotebookTemplatesBoardState extends State<NotebookTemplatesBoard> {
  bool _showPinned = true;
  final Set<String> _collapsedCategories = {};

  @override
  Widget build(BuildContext context) {
    final groupedTemplates = <String, List<NotebookTemplate>>{};
    for (final template in widget.templates) {
      groupedTemplates.putIfAbsent(template.category, () => []).add(template);
    }

    return Container(
      constraints: const BoxConstraints(minHeight: 820),
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Templates',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 18),
          _PinnedTemplateRow(
            expanded: _showPinned,
            onToggle: () => setState(() => _showPinned = !_showPinned),
          ),
          const SizedBox(height: 16),
          ...groupedTemplates.entries.map(
            (entry) => _TemplateSection(
              title: entry.key,
              templates: entry.value,
              expanded: !_collapsedCategories.contains(entry.key),
              onToggle: () {
                setState(() {
                  if (_collapsedCategories.contains(entry.key)) {
                    _collapsedCategories.remove(entry.key);
                  } else {
                    _collapsedCategories.add(entry.key);
                  }
                });
              },
              selectedTemplateTitle: widget.selectedTemplateTitle,
              onTemplateSelected: widget.onTemplateSelected,
            ),
          ),
        ],
      ),
    );
  }
}

class _PinnedTemplateRow extends StatelessWidget {
  final bool expanded;
  final VoidCallback onToggle;

  const _PinnedTemplateRow({required this.expanded, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onToggle,
      child: Row(
        children: [
          Icon(
            expanded
                ? FluentIcons.chevron_down_small
                : FluentIcons.chevron_right_small,
            size: 12,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 8),
          const Icon(FluentIcons.pin, size: 13, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          const Text(
            'Pinned Templates',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TemplateSection extends StatelessWidget {
  final String title;
  final List<NotebookTemplate> templates;
  final bool expanded;
  final VoidCallback onToggle;
  final String? selectedTemplateTitle;
  final ValueChanged<NotebookTemplate> onTemplateSelected;

  const _TemplateSection({
    required this.title,
    required this.templates,
    required this.expanded,
    required this.onToggle,
    required this.selectedTemplateTitle,
    required this.onTemplateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            title,
            templates.first.count,
            expanded: expanded,
            onToggle: onToggle,
          ),
          if (expanded) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: templates
                  .map(
                    (template) => _TemplateCard(
                      template: template,
                      selected: template.title == selectedTemplateTitle,
                      onTap: () => onTemplateSelected(template),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final int count;
  final bool expanded;
  final VoidCallback onToggle;

  const _SectionTitle(
    this.title,
    this.count, {
    required this.expanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onToggle,
      child: Row(
        children: [
          Icon(
            expanded
                ? FluentIcons.chevron_down_small
                : FluentIcons.chevron_right_small,
            size: 12,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 8),
          Text(
            '$title  $count',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  final NotebookTemplate template;
  final bool selected;
  final VoidCallback onTap;

  const _TemplateCard({
    required this.template,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
        height: 184,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primarySoft
              : Colors.white.withValues(alpha: 0.82),
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(template.icon, size: 14, color: template.accent),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    template.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const Icon(
                  FluentIcons.more,
                  size: 12,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(child: _DocumentPreview(accent: template.accent)),
          ],
        ),
      ),
    );
  }
}

class _DocumentPreview extends StatelessWidget {
  final Color accent;

  const _DocumentPreview({required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: AppColors.shellBg,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                const SizedBox(width: 8),
                Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const Spacer(),
                const _TinyDot(),
                const SizedBox(width: 4),
                const _TinyDot(),
                const SizedBox(width: 8),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const _PreviewLine(width: 0.74),
          const _PreviewLine(width: 0.92),
          const _PreviewLine(width: 0.56),
          const SizedBox(height: 8),
          const _PreviewLine(width: 0.84),
          const _PreviewLine(width: 0.64),
          const Spacer(),
          Row(
            children: const [
              _PreviewCheck(),
              SizedBox(width: 6),
              Expanded(child: _PreviewLine(width: 0.95)),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreviewLine extends StatelessWidget {
  final double width;

  const _PreviewLine({required this.width});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: width,
      child: Container(
        height: 4,
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFE9E3F5),
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}

class _PreviewCheck extends StatelessWidget {
  const _PreviewCheck();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFCFC6DD)),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _TinyDot extends StatelessWidget {
  const _TinyDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: 3,
      decoration: const BoxDecoration(
        color: Color(0xFFCFC6DD),
        shape: BoxShape.circle,
      ),
    );
  }
}
