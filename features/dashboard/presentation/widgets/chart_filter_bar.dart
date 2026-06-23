import 'package:fluent_ui/fluent_ui.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/entities/chart_metric_mode.dart';
import '../../domain/entities/chart_range.dart';

class ChartFilterBar extends StatelessWidget {
  final ChartRange selectedRange;
  final ChartMetricMode selectedMode;
  final ValueChanged<ChartRange> onRangeChanged;
  final ValueChanged<ChartMetricMode> onModeChanged;

  const ChartFilterBar({
    super.key,
    required this.selectedRange,
    required this.selectedMode,
    required this.onRangeChanged,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _RangeChip(
          label: '7D',
          selected: selectedRange == ChartRange.d7,
          onTap: () => onRangeChanged(ChartRange.d7),
        ),
        SizedBox(width: 4),
        _RangeChip(
          label: '30D',
          selected: selectedRange == ChartRange.d30,
          onTap: () => onRangeChanged(ChartRange.d30),
        ),
        SizedBox(width: 4),
        _RangeChip(
          label: '90D',
          selected: selectedRange == ChartRange.d90,
          onTap: () => onRangeChanged(ChartRange.d90),
        ),
        SizedBox(width: 4),
        _RangeChip(
          label: '180D',
          selected: selectedRange == ChartRange.d180,
          onTap: () => onRangeChanged(ChartRange.d180),
        ),
        SizedBox(width: 4),
        _RangeChip(
          label: '1Y',
          selected: selectedRange == ChartRange.y1,
          onTap: () => onRangeChanged(ChartRange.y1),
        ),
        SizedBox(width: 4),
        _RangeChip(
          label: 'All',
          selected: selectedRange == ChartRange.all,
          onTap: () => onRangeChanged(ChartRange.all),
        ),
        SizedBox(width: 6),
        _MiniChip(
          label: r'$',
          selected: selectedMode == ChartMetricMode.currency,
          onTap: () => onModeChanged(ChartMetricMode.currency),
        ),
        SizedBox(width: 4),
        _MiniChip(
          label: 'R',
          selected: selectedMode == ChartMetricMode.rMultiple,
          onTap: () => onModeChanged(ChartMetricMode.rMultiple),
        ),
        SizedBox(width: 4),
        _MiniChip(
          label: '%',
          selected: selectedMode == ChartMetricMode.percent,
          onTap: () => onModeChanged(ChartMetricMode.percent),
        ),
      ],
    );
  }
}

class _RangeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _RangeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _MiniChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 20,
        height: 20,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primarySoft : AppColors.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: selected ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
