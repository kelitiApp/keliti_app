import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import 'confirm_contact_page.dart';

const _symptoms = ['دوخة أو دوار', 'ألم في الصدر', 'ضيق في التنفس', 'غثيان', 'ألم في الرأس', 'ارتفاع في الحرارة', 'ارهاق شديد', 'أخرى'];
const _severityEmojis = ['😀', '🙂', '😐', '🤢', '☹️'];

class SymptomReportPage extends StatefulWidget {
  const SymptomReportPage({super.key});

  @override
  State<SymptomReportPage> createState() => _SymptomReportPageState();
}

class _SymptomReportPageState extends State<SymptomReportPage> {
  final Set<String> _selected = {'غثيان'};
  int _severity = 5;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppPageHeader(title: 'أشعر بتعب'),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
              child: const Icon(Icons.airline_seat_flat_rounded, color: AppColors.primary, size: 40),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('اختر الأعراض التي تشعر بها', style: AppTextStyles.titleMedium, textAlign: TextAlign.right),
          const SizedBox(height: 2),
          Text('يمكن اختيار أكثر من عرض', textAlign: TextAlign.right, style: AppTextStyles.caption),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final s in _symptoms)
                SelectableChip(
                  label: s,
                  selected: _selected.contains(s),
                  checkOnSelect: true,
                  onTap: () => setState(() => _selected.contains(s) ? _selected.remove(s) : _selected.add(s)),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          AppCard(
            child: Column(
              children: [
                Text('شدة التعب', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (int i = 0; i < 5; i++)
                      GestureDetector(
                        onTap: () => setState(() => _severity = i + 1),
                        child: Column(
                          children: [
                            Text(_severityEmojis[i], style: TextStyle(fontSize: _severity == i + 1 ? 28 : 22)),
                            const SizedBox(height: 4),
                            Text('${i + 1}', style: AppTextStyles.caption),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'التالي',
            onPressed: _selected.isEmpty
                ? null
                : () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ConfirmContactPage(requestTitle: 'اشعر بتعب', symptoms: _selected.toList(), severity: _severity),
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
