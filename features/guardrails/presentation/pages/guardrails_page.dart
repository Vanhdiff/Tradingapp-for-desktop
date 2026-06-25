import 'package:fluent_ui/fluent_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../data/datasources/guardrails_remote_datasource.dart';

class GuardrailsPage extends StatefulWidget {
  const GuardrailsPage({super.key});

  @override
  State<GuardrailsPage> createState() => _GuardrailsPageState();
}

class _GuardrailsPageState extends State<GuardrailsPage> {
  static const int _accountId = 1;

  final _remote = GuardrailsRemoteDataSource();
  final _maxTradesController = TextEditingController(text: '5');
  final _maxDailyLossController = TextEditingController(text: '3000');
  final _maxDailyProfitController = TextEditingController(text: '5000');
  final _riskController = TextEditingController(text: '0.5');
  final _windowStartController = TextEditingController(text: '07:00');
  final _windowEndController = TextEditingController(text: '10:00');
  final _newsMinutesController = TextEditingController(text: '30');

  Map<String, dynamic>? _status;
  String _newsMode = 'Before and After';
  String _timeZone = 'UTC+7';
  bool _blockHighImpactNews = true;
  bool _loading = true;
  bool _saving = false;
  String? _notice;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  @override
  void dispose() {
    _maxTradesController.dispose();
    _maxDailyLossController.dispose();
    _maxDailyProfitController.dispose();
    _riskController.dispose();
    _windowStartController.dispose();
    _windowEndController.dispose();
    _newsMinutesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const horizontalPadding = 22.0;
        final contentWidth = constraints.maxWidth - horizontalPadding * 2;
        final pageWidth = contentWidth < 1120 ? 1120.0 : contentWidth;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            horizontalPadding,
            12,
            horizontalPadding,
            18,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: pageWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Header(
                    loading: _loading,
                    onRefresh: _loadStatus,
                    onReset: _resetDefaults,
                  ),
                  const SizedBox(height: 14),
                  _StatusStrip(status: _status),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 7, child: _buildSettingsPanel()),
                      const SizedBox(width: 14),
                      Expanded(flex: 5, child: _RulesPanel(status: _status)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsPanel() {
    return _Panel(
      title: 'Trade blocking rules',
      subtitle:
          'Local guardrails watch your trading behavior. Blocking execution remains disabled until a later phase.',
      child: Column(
        children: [
          _SettingRow(
            icon: FluentIcons.number_field,
            title: 'Max trades per day',
            description: 'Stop overtrading by limiting completed trades.',
            control: _Field(controller: _maxTradesController, suffix: 'trades'),
          ),
          _SettingRow(
            icon: FluentIcons.money,
            title: 'Max daily loss',
            description: 'Uses realized PnL from normalized trades.',
            control: _Field(controller: _maxDailyLossController, prefix: r'$'),
          ),
          _SettingRow(
            icon: FluentIcons.savings,
            title: 'Max daily profit',
            description: 'Locks in discipline after target is reached.',
            control: _Field(
              controller: _maxDailyProfitController,
              prefix: r'$',
            ),
          ),
          _SettingRow(
            icon: FluentIcons.speed_high,
            title: 'Fixed risk per trade',
            description: 'Stored for later position sizing and risk warnings.',
            control: _Field(controller: _riskController, suffix: '%'),
          ),
          _SettingRow(
            icon: FluentIcons.clock,
            title: 'Trading window',
            description: 'Used for local warnings outside planned sessions.',
            control: Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _Select(
                  value: _timeZone,
                  values: const ['UTC+7', 'SGT', 'GMT+0'],
                  width: 92,
                  onChanged: (value) => setState(() => _timeZone = value),
                ),
                _Field(controller: _windowStartController, width: 76),
                _Field(controller: _windowEndController, width: 76),
              ],
            ),
          ),
          _SettingRow(
            icon: FluentIcons.news,
            title: 'High-impact news block',
            description: 'Warns around high-impact economic events.',
            control: Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ToggleSwitch(
                  checked: _blockHighImpactNews,
                  onChanged: (value) =>
                      setState(() => _blockHighImpactNews = value),
                ),
                _Select(
                  value: _newsMode,
                  values: const [
                    'Before and After',
                    'Before only',
                    'After only',
                  ],
                  width: 188,
                  onChanged: (value) => setState(() => _newsMode = value),
                ),
                _Field(
                  controller: _newsMinutesController,
                  width: 68,
                  suffix: 'm',
                ),
              ],
            ),
          ),
          if (_notice != null) ...[
            const SizedBox(height: 12),
            _Notice(text: _notice!),
          ],
          const SizedBox(height: 18),
          Row(
            children: [
              _OutlineAction(label: 'Reset defaults', onTap: _resetDefaults),
              const Spacer(),
              _PrimaryAction(
                label: _saving ? 'Saving...' : 'Save guardrails',
                onTap: _saving ? null : _save,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _loadStatus() async {
    setState(() {
      _loading = true;
      _notice = null;
    });

    try {
      final status = await _remote.fetchStatus(accountId: _accountId);
      if (!mounted) return;
      setState(() {
        _status = status;
        _applySettings(status['settings'] as Map<String, dynamic>?);
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _notice = 'Backend offline - editing recommended local defaults.';
      });
    }
  }

  Future<void> _save() async {
    final maxTrades = int.tryParse(_maxTradesController.text.trim());
    final maxLoss = double.tryParse(_maxDailyLossController.text.trim());
    final maxProfit = double.tryParse(_maxDailyProfitController.text.trim());
    final fixedRisk = double.tryParse(_riskController.text.trim());
    final newsMinutes = int.tryParse(_newsMinutesController.text.trim());

    if (maxTrades == null ||
        maxLoss == null ||
        maxProfit == null ||
        fixedRisk == null ||
        newsMinutes == null) {
      setState(() => _notice = 'Please enter valid numeric guardrails.');
      return;
    }

    setState(() {
      _saving = true;
      _notice = null;
    });

    try {
      await _remote.saveSettings(
        accountId: _accountId,
        maxTradesPerDay: maxTrades,
        maxDailyLoss: maxLoss,
        maxDailyProfit: maxProfit,
        fixedRiskPercent: fixedRisk,
        tradingWindowStart: '$_timeZone ${_windowStartController.text.trim()}',
        tradingWindowEnd: '$_timeZone ${_windowEndController.text.trim()}',
        newsBlockMode: _newsMode,
        newsWindowMinutes: newsMinutes,
        blockHighImpactNews: _blockHighImpactNews,
      );
      await _loadStatus();
      if (!mounted) return;
      setState(() {
        _saving = false;
        _notice = 'Guardrails saved. Local trade blocking remains disabled.';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _notice = 'Could not save guardrails. Backend may be offline.';
      });
    }
  }

  void _resetDefaults() {
    setState(() {
      _maxTradesController.text = '5';
      _maxDailyLossController.text = '3000';
      _maxDailyProfitController.text = '5000';
      _riskController.text = '0.5';
      _windowStartController.text = '07:00';
      _windowEndController.text = '10:00';
      _newsMinutesController.text = '30';
      _newsMode = 'Before and After';
      _timeZone = 'UTC+7';
      _blockHighImpactNews = true;
      _notice = null;
    });
  }

  void _applySettings(Map<String, dynamic>? settings) {
    if (settings == null) return;
    _maxTradesController.text =
        '${(settings['max_trades_per_day'] as num?)?.toInt() ?? 5}';
    _maxDailyLossController.text =
        '${((settings['max_daily_loss'] ?? 3000) as num).toDouble().round()}';
    final nested = settings['settings'] as Map<String, dynamic>? ?? {};
    _maxDailyProfitController.text =
        '${((nested['max_daily_profit'] ?? 5000) as num).toDouble().round()}';
    _riskController.text =
        '${((nested['fixed_risk_percent'] ?? 0.5) as num).toDouble()}';
    _newsMinutesController.text =
        '${((nested['news_window_minutes_before'] ?? 30) as num).toInt()}';
    _newsMode = nested['news_block_mode'] as String? ?? _newsMode;
    _blockHighImpactNews = settings['block_high_impact_news'] as bool? ?? true;
    _parseWindow(settings['trading_window_start'] as String?, true);
    _parseWindow(settings['trading_window_end'] as String?, false);
  }

  void _parseWindow(String? value, bool start) {
    if (value == null || value.isEmpty) return;
    final parts = value.split(' ');
    if (parts.length >= 2) {
      _timeZone = parts.first;
      if (start) {
        _windowStartController.text = parts.last;
      } else {
        _windowEndController.text = parts.last;
      }
    }
  }
}

class _Header extends StatelessWidget {
  final bool loading;
  final VoidCallback onRefresh;
  final VoidCallback onReset;

  const _Header({
    required this.loading,
    required this.onRefresh,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Guardrails',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Read-only risk rules for discipline, news windows, and overtrading.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const Spacer(),
        _OutlineAction(label: 'Reset', onTap: onReset),
        const SizedBox(width: 10),
        _IconAction(
          icon: loading ? FluentIcons.sync : FluentIcons.refresh,
          onTap: onRefresh,
        ),
      ],
    );
  }
}

class _StatusStrip extends StatelessWidget {
  final Map<String, dynamic>? status;

  const _StatusStrip({required this.status});

  @override
  Widget build(BuildContext context) {
    final summary = status?['summary'] as Map<String, dynamic>? ?? {};
    final triggered = (summary['triggered_count'] as num?)?.toInt() ?? 0;
    final critical = (summary['critical_count'] as num?)?.toInt() ?? 0;
    final mode = status?['mode'] as String? ?? 'local_read_only';
    final blocking = status?['trade_blocking_enabled'] as bool? ?? false;

    return Row(
      children: [
        Expanded(
          child: _StatusCard(
            icon: FluentIcons.lock,
            label: 'Trade blocking',
            value: blocking ? 'Enabled' : 'Off',
            color: blocking ? AppColors.danger : AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatusCard(
            icon: FluentIcons.shield,
            label: 'Mode',
            value: mode.replaceAll('_', ' '),
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatusCard(
            icon: FluentIcons.warning,
            label: 'Triggered rules',
            value: '$triggered active',
            color: triggered > 0 ? AppColors.warning : AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatusCard(
            icon: FluentIcons.error_badge,
            label: 'Critical',
            value: '$critical critical',
            color: critical > 0 ? AppColors.danger : AppColors.success,
          ),
        ),
      ],
    );
  }
}

class _RulesPanel extends StatelessWidget {
  final Map<String, dynamic>? status;

  const _RulesPanel({required this.status});

  @override
  Widget build(BuildContext context) {
    final checks = status?['checks'] as List<dynamic>? ?? const [];

    return _Panel(
      title: 'Live rule checks',
      subtitle: 'These checks read local analytics and cached economic news.',
      child: checks.isEmpty
          ? _EmptyRules()
          : Column(
              children: checks.map((item) {
                final json = item as Map<String, dynamic>;
                return _RuleTile(
                  code: json['rule_code'] as String? ?? 'rule',
                  message: json['message'] as String? ?? '',
                  triggered: json['triggered'] as bool? ?? false,
                  severity: json['severity'] as String? ?? 'info',
                );
              }).toList(),
            ),
    );
  }
}

class _Panel extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _Panel({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Widget control;

  const _SettingRow({
    required this.icon,
    required this.title,
    required this.description,
    required this.control,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 620;
          final titleBlock = Row(
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 16, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleBlock,
                const SizedBox(height: 12),
                Align(alignment: Alignment.centerLeft, child: control),
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: titleBlock),
              const SizedBox(width: 18),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 380),
                child: Align(alignment: Alignment.centerRight, child: control),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String? prefix;
  final String? suffix;
  final double width;

  const _Field({
    required this.controller,
    this.prefix,
    this.suffix,
    this.width = 116,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 34,
      child: TextBox(
        controller: controller,
        prefix: prefix == null ? null : _FieldAffix(prefix!),
        suffix: suffix == null ? null : _FieldAffix(suffix!),
      ),
    );
  }
}

class _FieldAffix extends StatelessWidget {
  final String text;

  const _FieldAffix(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _Select extends StatelessWidget {
  final String value;
  final List<String> values;
  final ValueChanged<String> onChanged;
  final double width;

  const _Select({
    required this.value,
    required this.values,
    required this.onChanged,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 34,
      child: ComboBox<String>(
        value: value,
        items: values
            .map(
              (item) => ComboBoxItem(
                value: item,
                child: Text(item, overflow: TextOverflow.ellipsis),
              ),
            )
            .toList(),
        onChanged: (next) {
          if (next != null) onChanged(next);
        },
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatusCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 17, color: color),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
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

class _RuleTile extends StatelessWidget {
  final String code;
  final String message;
  final bool triggered;
  final String severity;

  const _RuleTile({
    required this.code,
    required this.message,
    required this.triggered,
    required this.severity,
  });

  @override
  Widget build(BuildContext context) {
    final color = triggered
        ? (severity == 'critical' ? AppColors.danger : AppColors.warning)
        : AppColors.success;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.16)),
      ),
      child: Row(
        children: [
          Icon(
            triggered ? FluentIcons.error_badge : FluentIcons.check_mark,
            size: 15,
            color: color,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  code.replaceAll('_', ' '),
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
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

class _EmptyRules extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        'No live checks loaded yet. Start the backend or refresh this page.',
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  final String text;

  const _Notice({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.warning,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _OutlineAction extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _OutlineAction({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _PrimaryAction extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _PrimaryAction({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: onTap == null
              ? AppColors.primary.withValues(alpha: 0.55)
              : AppColors.primary,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconAction({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, size: 15, color: AppColors.textSecondary),
      ),
    );
  }
}
