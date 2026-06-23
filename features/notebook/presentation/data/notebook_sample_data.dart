import 'package:fluent_ui/fluent_ui.dart';

import '../../../../app/theme/app_colors.dart';

class NotebookNote {
  final String title;
  final String preview;
  final String date;
  final IconData icon;
  final Color color;

  const NotebookNote({
    required this.title,
    required this.preview,
    required this.date,
    required this.icon,
    required this.color,
  });
}

class NotebookFolder {
  final String title;
  final int count;

  const NotebookFolder({required this.title, required this.count});
}

class NotebookTemplate {
  final String title;
  final String category;
  final int count;
  final Color accent;
  final IconData icon;

  NotebookTemplate({
    required this.title,
    required this.category,
    required this.count,
    Color? accent,
    this.icon = FluentIcons.edit_note,
  }) : accent = accent ?? AppColors.primary;
}

abstract final class NotebookSampleData {
  static List<NotebookNote> get pinnedNotes => [
    NotebookNote(
      title: '2026 goals',
      preview: '200 A+ trades; max daily loss 2R; weekly review.',
      date: '2025/12/31',
      icon: FluentIcons.pin,
      color: AppColors.danger,
    ),
  ];

  static List<NotebookNote> get recentNotes => [
    NotebookNote(
      title: 'Process',
      preview: 'New rule: write thesis pre-open, no intra-session edits.',
      date: '2h ago',
      icon: FluentIcons.edit_note,
      color: AppColors.primary,
    ),
    NotebookNote(
      title: 'AAPL earnings plan',
      preview: 'No trades first 10 minutes. Let range set.',
      date: '1d ago',
      icon: FluentIcons.lightbulb,
      color: AppColors.warning,
    ),
    NotebookNote(
      title: '2026 goals',
      preview: '200 A+ trades; max daily loss 2R; weekly review.',
      date: '2025/12/31',
      icon: FluentIcons.pin,
      color: AppColors.danger,
    ),
  ];

  static const folders = [
    NotebookFolder(title: 'Ideas', count: 12),
    NotebookFolder(title: 'Drafts', count: 2),
  ];

  static List<NotebookTemplate> get templates => [
    NotebookTemplate(
      title: 'Pre-Market Thesis',
      category: 'My Templates',
      count: 1,
      accent: AppColors.warning,
      icon: FluentIcons.lightbulb,
    ),
    NotebookTemplate(
      title: 'Trade Review',
      category: 'Playbook',
      count: 2,
      accent: AppColors.warning,
      icon: FluentIcons.task_manager,
    ),
    NotebookTemplate(
      title: 'Entry Model',
      category: 'Playbook',
      count: 2,
      accent: AppColors.danger,
      icon: FluentIcons.edit_note,
    ),
    NotebookTemplate(
      title: 'Emotional Mapping Journal',
      category: 'Mindset',
      count: 4,
      accent: AppColors.success,
      icon: FluentIcons.heart,
    ),
    NotebookTemplate(
      title: 'Pre-Market Mental Prep',
      category: 'Mindset',
      count: 4,
      accent: AppColors.danger,
      icon: FluentIcons.heart_fill,
    ),
  ];
}
