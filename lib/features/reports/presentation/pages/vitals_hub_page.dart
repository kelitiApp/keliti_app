import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/report_models.dart';
import '../cubit/reports_cubit.dart';
import 'add_measurement_page.dart';

class VitalsHubPage extends StatefulWidget {
  const VitalsHubPage({super.key});

  @override
  State<VitalsHubPage> createState() => _VitalsHubPageState();
}

class _VitalsHubPageState extends State<VitalsHubPage> {
  int _tab = 1; // 0 = blood pressure, 1 = weight

  static const _weightTrend = [72.5, 71.8, 72.0, 71.5, 71.2, 71.4, 71.0];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ReportsCubit>().state;
    final list = _tab == 1 ? state.weightMeasurements : state.bpMeasurements;

    return AppScaffold(
      scrollable: false,
      bottomBar: SizedBox(
        width: 56,
        height: 56,
        child: FloatingActionButton(
          backgroundColor: AppColors.primary,
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddMeasurementPage())),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.md),
          const AppPageHeader(title: 'المؤشرات الحيوية'),
          const SizedBox(height: AppSpacing.md),
          SegmentedTabs(labels: const ['ضغط الدم', 'الوزن'], selectedIndex: _tab, onChanged: (i) => setState(() => _tab = i)),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 90),
              children: [
                if (_tab == 1) ...[
                  Text('آخر 7 جلسات (كغ)', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
                  const SizedBox(height: AppSpacing.sm),
                  SizedBox(
                    height: 140,
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: const FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineTouchData: const LineTouchData(enabled: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: [for (int i = 0; i < _weightTrend.length; i++) FlSpot(i.toDouble(), _weightTrend[i])],
                            isCurved: true,
                            color: AppColors.primary,
                            barWidth: 3,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(show: true, color: AppColors.primaryLight),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      Expanded(child: _StatBox(label: 'متوسط الزيادة بين الجلسات', value: '2.1 كغ')),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: _StatBox(label: 'الوزن الجاف المستهدف', value: '69.5 كغ')),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
                Text('القياسات اليدوية', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
                const SizedBox(height: AppSpacing.sm),
                for (final m in list.reversed) ...[
                  AppCard(
                    child: Row(
                      children: [
                        Text('${m.dateLabel}، ${m.timeLabel}', style: AppTextStyles.caption),
                        const Spacer(),
                        Text(
                          m.type == MeasurementType.weight ? '${m.weightKg} كغ' : '${m.systolic}/${m.diastolic}',
                          style: AppTextStyles.titleSmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Text(label, style: AppTextStyles.caption, textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text(value, style: AppTextStyles.titleMedium),
        ],
      ),
    );
  }
}
