import 'package:fluent_ui/fluent_ui.dart';

import '../data/notebook_sample_data.dart';
import '../widgets/notebook_header.dart';
import '../widgets/notebook_sidebar.dart';
import '../widgets/notebook_templates_board.dart';

class NotebookPage extends StatefulWidget {
  const NotebookPage({super.key});

  @override
  State<NotebookPage> createState() => _NotebookPageState();
}

class _NotebookPageState extends State<NotebookPage> {
  String? _selectedTemplateTitle;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const horizontalPadding = 24.0;
        final contentWidth = constraints.maxWidth - horizontalPadding * 2;
        final targetWidth = contentWidth * 0.9;
        final pageWidth = targetWidth < 1090 ? 1090.0 : targetWidth;
        final scrollWidth = pageWidth > contentWidth ? pageWidth : contentWidth;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            horizontalPadding,
            14,
            horizontalPadding,
            20,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: scrollWidth,
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: pageWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NotebookHeader(),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NotebookSidebar(
                            pinnedNotes: NotebookSampleData.pinnedNotes,
                            recentNotes: NotebookSampleData.recentNotes,
                            folders: NotebookSampleData.folders,
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: NotebookTemplatesBoard(
                              templates: NotebookSampleData.templates,
                              selectedTemplateTitle: _selectedTemplateTitle,
                              onTemplateSelected: (template) {
                                setState(
                                  () => _selectedTemplateTitle = template.title,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
