import 'package:fluent_ui/fluent_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../data/notebook_sample_data.dart';

class NotebookSidebar extends StatefulWidget {
  final List<NotebookNote> pinnedNotes;
  final List<NotebookNote> recentNotes;
  final List<NotebookFolder> folders;

  const NotebookSidebar({
    super.key,
    required this.pinnedNotes,
    required this.recentNotes,
    required this.folders,
  });

  @override
  State<NotebookSidebar> createState() => _NotebookSidebarState();
}

class _NotebookSidebarState extends State<NotebookSidebar> {
  bool _showPinned = true;
  bool _showRecent = true;
  bool _showFolders = true;
  bool _showAllNotes = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 312,
      constraints: const BoxConstraints(minHeight: 820),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
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
          const _SearchBox(),
          const SizedBox(height: 20),
          _SectionHeader(
            'PINNED NOTES',
            count: widget.pinnedNotes.length,
            expanded: _showPinned,
            onToggle: () => setState(() => _showPinned = !_showPinned),
          ),
          if (_showPinned) ...[
            const SizedBox(height: 12),
            ...widget.pinnedNotes.map((note) => _NoteTile(note)),
          ],
          const SizedBox(height: 22),
          _SectionHeader(
            'RECENT NOTES',
            expanded: _showRecent,
            onToggle: () => setState(() => _showRecent = !_showRecent),
          ),
          if (_showRecent) ...[
            const SizedBox(height: 12),
            ...widget.recentNotes.take(2).map((note) => _NoteTile(note)),
          ],
          const SizedBox(height: 22),
          _SectionHeader(
            'FOLDERS',
            expanded: _showFolders,
            onToggle: () => setState(() => _showFolders = !_showFolders),
          ),
          if (_showFolders) ...[
            const SizedBox(height: 12),
            ...widget.folders.map((folder) => _FolderTile(folder)),
          ],
          const SizedBox(height: 22),
          _SectionHeader(
            'ALL NOTES',
            count: 32,
            expanded: _showAllNotes,
            onToggle: () => setState(() => _showAllNotes = !_showAllNotes),
          ),
          if (_showAllNotes) ...[
            const SizedBox(height: 12),
            ...widget.recentNotes.map((note) => _NoteTile(note, compact: true)),
          ],
        ],
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.shellBg,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: AppColors.border),
            ),
            child: const Row(
              children: [
                Icon(
                  FluentIcons.search,
                  size: 15,
                  color: AppColors.textSecondary,
                ),
                SizedBox(width: 10),
                Text(
                  'Search in notes',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 40,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.shellBg,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: AppColors.border),
          ),
          child: const Icon(
            FluentIcons.collapse_content,
            size: 15,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int? count;
  final bool expanded;
  final VoidCallback onToggle;

  const _SectionHeader(
    this.title, {
    this.count,
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
          Text(
            count == null ? title : '$title  $count',
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF6E6779),
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          Icon(
            expanded
                ? FluentIcons.chevron_down_small
                : FluentIcons.chevron_right_small,
            size: 14,
            color: const Color(0xFF8E879B),
          ),
        ],
      ),
    );
  }
}

class _NoteTile extends StatelessWidget {
  final NotebookNote note;
  final bool compact;

  const _NoteTile(this.note, {this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: compact ? 10 : 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(note.icon, size: 16, color: note.color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  note.preview,
                  maxLines: compact ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7A7485),
                    fontWeight: FontWeight.w500,
                    height: 1.32,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  note.date,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFFB6AEC5),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FolderTile extends StatelessWidget {
  final NotebookFolder folder;

  const _FolderTile(this.folder);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        children: [
          const Icon(FluentIcons.folder, size: 16, color: AppColors.success),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              folder.title,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            '${folder.count}',
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
