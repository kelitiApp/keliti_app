import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubit/reports_cubit.dart';

class AddMeasurementPage extends StatefulWidget {
  const AddMeasurementPage({super.key});

  @override
  State<AddMeasurementPage> createState() => _AddMeasurementPageState();
}

class _AddMeasurementPageState extends State<AddMeasurementPage> {
  bool _isWeight = true;
  final _weightController = TextEditingController(text: '71.0');
  final _systolicController = TextEditingController(text: '128');
  final _diastolicController = TextEditingController(text: '84');
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    _systolicController.dispose();
    _diastolicController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _save() {
    final cubit = context.read<ReportsCubit>();
    if (_isWeight) {
      final value = double.tryParse(_weightController.text);
      if (value == null) return;
      cubit.addWeightMeasurement(value);
    } else {
      final s = int.tryParse(_systolicController.text);
      final d = int.tryParse(_diastolicController.text);
      if (s == null || d == null) return;
      cubit.addBloodPressureMeasurement(s, d);
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: AppResultView(
            tone: _isWeight ? ResultTone.success : ResultTone.error,
            title: _isWeight ? 'تم حفظ القياس بنجاح' : 'تم حفظ قياس الضغط',
            description: 'تمت إضافة قياس ${_isWeight ? 'الوزن' : 'ضغط الدم'} للرسم البياني، وسيظهر ضمن سجلّك.',
            summary: AppCard(
              child: Row(
                children: [
                  Text(
                    _isWeight ? '${_weightController.text} كغ' : '${_systolicController.text}/${_diastolicController.text}',
                    style: AppTextStyles.titleMedium.copyWith(color: _isWeight ? AppColors.primary : AppColors.error),
                  ),
                  const Spacer(),
                  Text(_isWeight ? 'الوزن' : 'ضغط الدم', style: AppTextStyles.caption),
                ],
              ),
            ),
            primaryLabel: 'العودة إلى المؤشرات',
            onPrimary: () => Navigator.of(dialogContext)
              ..pop()
              ..pop(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppPageHeader(title: 'إضافة قياس'),
          const SizedBox(height: AppSpacing.lg),
          Text('نوع القياس', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(child: SelectableChip(label: 'ضغط الدم', selected: !_isWeight, onTap: () => setState(() => _isWeight = false))),
              const SizedBox(width: AppSpacing.xs),
              Expanded(child: SelectableChip(label: 'الوزن', selected: _isWeight, onTap: () => setState(() => _isWeight = true))),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          if (_isWeight) ...[
            Text('القيمة', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const SizedBox(width: 80, child: _UnitBox(label: 'كغ')),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: AppTextField(controller: _weightController, keyboardType: const TextInputType.numberWithOptions(decimal: true), textAlign: TextAlign.right)),
              ],
            ),
          ] else ...[
            Text('القراءة', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      AppTextField(controller: _diastolicController, keyboardType: TextInputType.number, textAlign: TextAlign.center),
                      const SizedBox(height: 4),
                      Text('الانبساطي (Diastolic)', style: AppTextStyles.caption),
                    ],
                  ),
                ),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text('/', style: AppTextStyles.titleLarge)),
                Expanded(
                  child: Column(
                    children: [
                      AppTextField(controller: _systolicController, keyboardType: TextInputType.number, textAlign: TextAlign.center),
                      const SizedBox(height: 4),
                      Text('الانقباضي (Systolic)', style: AppTextStyles.caption),
                    ],
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          Text('التاريخ والوقت', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(child: AppPickerField(hint: 'الوقت', value: 'الآن', icon: Icons.access_time, onTap: () {})),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: AppPickerField(hint: 'اليوم', value: 'اليوم', icon: Icons.calendar_today_outlined, onTap: () {})),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('ملاحظات (اختياري)', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(controller: _notesController, maxLines: 2, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'حفظ القياس',
            variant: _isWeight ? AppButtonVariant.primary : AppButtonVariant.destructive,
            onPressed: _save,
          ),
        ],
      ),
    );
  }
}

class _UnitBox extends StatelessWidget {
  const _UnitBox({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.inputHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: AppRadius.radiusMd, border: Border.all(color: AppColors.border)),
      child: Text(label, style: AppTextStyles.bodyLarge),
    );
  }
}
