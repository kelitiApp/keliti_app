import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/medication.dart';
import '../cubit/medications_cubit.dart';

const _defaultTimesByCount = {
  1: ['08:00 ص'],
  2: ['08:00 ص', '08:00 م'],
  3: ['08:00 ص', '02:00 م', '08:00 م'],
  4: ['08:00 ص', '12:00 م', '04:00 م', '08:00 م'],
};

class AddEditMedicationPage extends StatefulWidget {
  const AddEditMedicationPage({super.key, this.medication});

  final Medication? medication;

  bool get isEditing => medication != null;

  @override
  State<AddEditMedicationPage> createState() => _AddEditMedicationPageState();
}

class _AddEditMedicationPageState extends State<AddEditMedicationPage> {
  late final _nameController = TextEditingController(text: widget.medication?.name);
  late final _doseController = TextEditingController(text: widget.medication?.doseAmount);
  late final _notesController = TextEditingController(text: widget.medication?.notes);
  late MedicationForm _form = widget.medication?.form ?? MedicationForm.tablets;
  late String _doseUnit = widget.medication?.doseUnit ?? 'ملغ';
  late int _timesPerDay = widget.medication?.timesPerDay ?? 3;
  late List<String> _doseTimes = List.of(widget.medication?.doseTimes ?? _defaultTimesByCount[3]!);

  @override
  void dispose() {
    _nameController.dispose();
    _doseController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _setTimesPerDay(int count) {
    setState(() {
      _timesPerDay = count;
      _doseTimes = List.of(_defaultTimesByCount[count] ?? List.generate(count, (_) => '08:00 ص'));
    });
  }

  Future<void> _editTime(int index) async {
    final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked == null) return;
    setState(() => _doseTimes[index] = picked.format(context));
  }

  void _addTime() {
    setState(() {
      _doseTimes.add('08:00 ص');
      _timesPerDay = _doseTimes.length;
    });
  }

  bool get _canSave => _nameController.text.trim().isNotEmpty && _doseController.text.trim().isNotEmpty;

  Future<void> _confirmStop() async {
    final result = await showAppConfirmSheet(
      context,
      icon: Icons.medication_liquid_outlined,
      title: 'إيقاف دواء ${widget.medication!.name}؟',
      description:
          'سوف يتم إيقاف كل التذكيرات المرتبة بهذا الدواء. هذه الخطوة لا تحذف سجل الجرعات السابقة ويمكنك تفعيله مرة أخرى في أي وقت آخر',
      confirmLabel: 'نعم، إيقاف الدواء',
    );
    if (result == 'confirm' && mounted) {
      context.read<MedicationsCubit>().stopMedication(widget.medication!.id);
      Navigator.of(context)
        ..pop()
        ..pop();
    }
  }

  void _save() {
    final cubit = context.read<MedicationsCubit>();
    if (widget.isEditing) {
      cubit.updateMedication(widget.medication!.copyWith(
        name: _nameController.text,
        form: _form,
        doseAmount: _doseController.text,
        doseUnit: _doseUnit,
        timesPerDay: _timesPerDay,
        doseTimes: _doseTimes,
        notes: _notesController.text,
      ));
      Navigator.of(context).pop();
      return;
    }

    final added = cubit.addMedication(
      name: _nameController.text,
      form: _form,
      doseAmount: _doseController.text,
      doseUnit: _doseUnit,
      timesPerDay: _timesPerDay,
      doseTimes: _doseTimes,
      notes: _notesController.text,
    );

    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: AppResultView(
            title: 'تمت إضافة الدواء بنجاح',
            description: 'تمت إضافة "${added.name}" إلى خطة علاجك',
            summary: AppCard(
              child: Row(
                children: [
                  Text(_form.label, style: AppTextStyles.caption),
                  const Spacer(),
                  Text('${added.doseAmount} ${added.doseUnit} . ${added.timesPerDay} مرات / يوم . ${added.doseTimes.join(', ')}',
                      style: AppTextStyles.bodySmall, textAlign: TextAlign.right),
                ],
              ),
            ),
            primaryLabel: 'العودة إلى أدويتي',
            onPrimary: () => Navigator.of(dialogContext)
              ..pop()
              ..pop(),
            secondaryLabel: 'إضافة دواء اخر',
            onSecondary: () {
              Navigator.of(dialogContext).pop();
              setState(() {
                _nameController.clear();
                _doseController.clear();
                _notesController.clear();
                _form = MedicationForm.tablets;
                _setTimesPerDay(3);
              });
            },
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
          AppPageHeader(title: widget.isEditing ? 'تعديل الدواء' : 'إضافة دواء'),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(label: 'اسم الدواء', hint: 'مثال: كربونات الكالسيوم', controller: _nameController, textAlign: TextAlign.right, onChanged: (_) => setState(() {})),
          const SizedBox(height: AppSpacing.lg),
          Text('الشكل الدوائي', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              for (final form in MedicationForm.values) ...[
                Expanded(
                  child: SelectableChip(label: form.label, selected: _form == form, onTap: () => setState(() => _form = form)),
                ),
                if (form != MedicationForm.values.last) const SizedBox(width: AppSpacing.xs),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('الجرعة', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              SizedBox(
                width: 90,
                child: AppPickerField(
                  hint: 'ملغ',
                  value: _doseUnit,
                  onTap: () async {
                    final picked = await showAppSelectSheet<String>(
                      context,
                      title: 'وحدة الجرعة',
                      options: const ['ملغ', 'وحدة', 'مل'],
                      labelBuilder: (v) => v,
                      selected: _doseUnit,
                    );
                    if (picked != null) setState(() => _doseUnit = picked);
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppTextField(
                  hint: 'مثال : 800',
                  controller: _doseController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.right,
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('عدد المرات يوميا', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              for (final count in [4, 3, 2, 1]) ...[
                Expanded(
                  child: SelectableChip(label: '$count', selected: _timesPerDay == count, onTap: () => _setTimesPerDay(count)),
                ),
                if (count != 1) const SizedBox(width: AppSpacing.xs),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('أوقات الجرعة', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (int i = 0; i < _doseTimes.length; i++)
                OutlinedButton.icon(
                  onPressed: () => _editTime(i),
                  icon: const Icon(Icons.access_time, size: 16),
                  label: Text(_doseTimes[i]),
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.primary), foregroundColor: AppColors.primary),
                ),
              OutlinedButton.icon(
                onPressed: _addTime,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('إضافة وقت'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('ملاحظات (اختياري)', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(hint: '', controller: _notesController, maxLines: 3, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.xl),
          AppButton(label: widget.isEditing ? 'حفظ التعديلات' : 'حفظ الدواء', onPressed: _canSave ? _save : null),
          if (widget.isEditing) ...[
            const SizedBox(height: AppSpacing.sm),
            AppButton(label: 'إيقاف هذا الدواء', variant: AppButtonVariant.outlined, icon: Icons.delete_outline, onPressed: _confirmStop),
          ],
        ],
      ),
    );
  }
}
