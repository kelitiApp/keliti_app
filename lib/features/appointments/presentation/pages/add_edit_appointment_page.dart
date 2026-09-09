import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../core/session/patient_profile.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../onboarding/presentation/cubit/onboarding_cubit.dart' show mockDoctors;
import '../../data/appointment.dart';
import '../cubit/appointments_cubit.dart';
import 'appointments_page.dart';

const _weekdays = ['أحد', 'اثنين', 'ثلاثاء', 'أربعاء', 'خميس'];
const _labTestTypes = ['تحليل دم شامل', 'وظائف كلى', 'صورة دم'];
const _visitReasons = ['متابعة دورية', 'نتيجة تحليل'];
const _fastingOptions = [4, 8, 12];

class AddEditAppointmentPage extends StatefulWidget {
  const AddEditAppointmentPage({super.key, this.appointment});

  final Appointment? appointment;

  bool get isEditing => appointment != null;

  @override
  State<AddEditAppointmentPage> createState() => _AddEditAppointmentPageState();
}

class _AddEditAppointmentPageState extends State<AddEditAppointmentPage> {
  late AppointmentType _type = widget.appointment?.type ?? AppointmentType.dialysisSession;
  final _placeController = TextEditingController();
  final _labNameController = TextEditingController();
  final _notesController = TextEditingController();
  DoctorInfo? _doctor;
  String _labTestType = _labTestTypes.first;
  String _visitReason = _visitReasons.first;
  List<String> _selectedDays = ['أحد', 'ثلاثاء', 'خميس'];
  DateTime? _date;
  TimeOfDay _time = const TimeOfDay(hour: 7, minute: 0);
  bool _requiresFasting = true;
  int _fastingHours = 8;

  @override
  void initState() {
    super.initState();
    final a = widget.appointment;
    if (a != null) {
      _placeController.text = a.place;
      _labNameController.text = a.place;
      _notesController.text = a.notes;
      _selectedDays = List.of(a.repeatsWeeklyOn);
      _requiresFasting = a.requiresFasting;
      _fastingHours = a.fastingHours ?? 8;
    }
  }

  @override
  void dispose() {
    _placeController.dispose();
    _labNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) setState(() => _time = picked);
  }

  Future<void> _pickDoctor() async {
    final picked = await showAppSelectSheet<DoctorInfo>(
      context,
      title: 'الطبيب',
      options: mockDoctors,
      labelBuilder: (d) => d.name,
      selected: _doctor,
    );
    if (picked != null) setState(() => _doctor = picked);
  }

  bool get _canSave {
    return switch (_type) {
      AppointmentType.dialysisSession => _selectedDays.isNotEmpty && _placeController.text.trim().isNotEmpty,
      AppointmentType.labTest => _date != null && _labNameController.text.trim().isNotEmpty,
      AppointmentType.doctorVisit => _date != null && _placeController.text.trim().isNotEmpty,
    };
  }

  void _save() {
    final cubit = context.read<AppointmentsCubit>();
    final timeLabel = _time.format(context);
    final dateLabel = _date == null ? 'أسبوعياً' : intl.DateFormat('EEEE d MMM', 'ar').format(_date!);

    final title = switch (_type) {
      AppointmentType.dialysisSession => 'جلسة غسيل الكلى',
      AppointmentType.labTest => _labTestType,
      AppointmentType.doctorVisit => 'زيارة ${_doctor?.name ?? 'الطبيب'}',
    };
    final place = switch (_type) {
      AppointmentType.dialysisSession => _placeController.text,
      AppointmentType.labTest => _labNameController.text,
      AppointmentType.doctorVisit => _placeController.text,
    };

    late final Appointment result;
    if (widget.isEditing) {
      result = widget.appointment!.copyWith(
        title: title,
        dateLabel: dateLabel,
        timeLabel: timeLabel,
        place: place,
        notes: _notesController.text,
        repeatsWeeklyOn: _selectedDays,
        requiresFasting: _requiresFasting,
        fastingHours: _fastingHours,
      );
      cubit.update(result);
    } else {
      result = cubit.add(
        type: _type,
        title: title,
        dateLabel: dateLabel,
        timeLabel: timeLabel,
        place: place,
        notes: _notesController.text,
        repeatsWeeklyOn: _type == AppointmentType.dialysisSession ? _selectedDays : const [],
        requiresFasting: _requiresFasting,
        fastingHours: _fastingHours,
      );
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: AppResultView(
            title: widget.isEditing ? 'تمت جدولة الموعد بنجاح' : 'تمت إضافة الموعد بنجاح',
            description: 'راح توصلك تذكيرات قبل الموعد.',
            banner: _requiresFasting && _type == AppointmentType.labTest
                ? 'لا تنسَ: صيام $_fastingHours ساعات قبل الموعد'
                : null,
            summary: AppCard(
              child: Row(
                children: [
                  Icon(appointmentIcon(_type), color: AppColors.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(result.title, style: AppTextStyles.titleSmall),
                        Text('$dateLabel . $timeLabel', style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            primaryLabel: 'العودة إلى المواعيد',
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
          AppPageHeader(title: widget.isEditing ? 'تعديل الموعد' : 'إضافة موعد'),
          const SizedBox(height: AppSpacing.lg),
          if (!widget.isEditing) ...[
            Text('نوع الموعد', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                for (final t in AppointmentType.values) ...[
                  Expanded(
                    child: SelectableChip(label: t.label, selected: _type == t, onTap: () => setState(() => _type = t)),
                  ),
                  if (t != AppointmentType.values.last) const SizedBox(width: AppSpacing.xs),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          if (_type == AppointmentType.dialysisSession) ..._buildDialysisFields(),
          if (_type == AppointmentType.labTest) ..._buildLabFields(),
          if (_type == AppointmentType.doctorVisit) ..._buildDoctorVisitFields(),
          Text('ملاحظات (اختياري)', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(hint: '', controller: _notesController, maxLines: 3, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.xl),
          AppButton(label: 'حفظ الموعد', onPressed: _canSave ? _save : null),
        ],
      ),
    );
  }

  List<Widget> _buildDialysisFields() {
    return [
      Text('التكرار الأسبوعي', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
      const SizedBox(height: AppSpacing.sm),
      Wrap(
        alignment: WrapAlignment.end,
        spacing: AppSpacing.xs,
        runSpacing: AppSpacing.xs,
        children: [
          for (final day in _weekdays)
            SelectableChip(
              label: day,
              selected: _selectedDays.contains(day),
              onTap: () => setState(() {
                _selectedDays.contains(day) ? _selectedDays.remove(day) : _selectedDays.add(day);
              }),
            ),
        ],
      ),
      const SizedBox(height: AppSpacing.lg),
      Text('وقت الجلسة', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
      const SizedBox(height: AppSpacing.sm),
      AppPickerField(hint: 'اختر الوقت', value: _time.format(context), icon: Icons.access_time, onTap: _pickTime),
      const SizedBox(height: AppSpacing.lg),
      Text('مكان الجلسة / المركز', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
      const SizedBox(height: AppSpacing.sm),
      AppTextField(hint: 'مثال: مركز الأمل لغسيل الكلى', controller: _placeController, textAlign: TextAlign.right, onChanged: (_) => setState(() {})),
      const SizedBox(height: AppSpacing.lg),
    ];
  }

  List<Widget> _buildLabFields() {
    return [
      Text('نوع الفحص', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
      const SizedBox(height: AppSpacing.sm),
      Row(
        children: [
          for (final t in _labTestTypes) ...[
            Expanded(child: SelectableChip(label: t, selected: _labTestType == t, onTap: () => setState(() => _labTestType = t))),
            if (t != _labTestTypes.last) const SizedBox(width: AppSpacing.xs),
          ],
        ],
      ),
      const SizedBox(height: AppSpacing.lg),
      Text('المختبر', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
      const SizedBox(height: AppSpacing.sm),
      AppTextField(hint: 'مثال: مختبر النور', controller: _labNameController, textAlign: TextAlign.right, onChanged: (_) => setState(() {})),
      const SizedBox(height: AppSpacing.lg),
      Text('التاريخ والوقت', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
      const SizedBox(height: AppSpacing.sm),
      Row(
        children: [
          Expanded(child: AppPickerField(hint: 'الوقت', value: _time.format(context), icon: Icons.access_time, onTap: _pickTime)),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: AppPickerField(hint: 'اختر التاريخ', value: _date == null ? null : intl.DateFormat('d/M/yyyy').format(_date!), icon: Icons.calendar_today_outlined, onTap: _pickDate)),
        ],
      ),
      const SizedBox(height: AppSpacing.lg),
      AppToggleTile(
        title: 'يتطلب صيام؟',
        value: _requiresFasting,
        onChanged: (v) => setState(() => _requiresFasting = v),
      ),
      if (_requiresFasting) ...[
        const SizedBox(height: AppSpacing.sm),
        Text('عدد ساعات الصيام', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            for (final h in _fastingOptions) ...[
              Expanded(child: SelectableChip(label: '$h س', selected: _fastingHours == h, onTap: () => setState(() => _fastingHours = h))),
              if (h != _fastingOptions.last) const SizedBox(width: AppSpacing.xs),
            ],
          ],
        ),
      ],
      const SizedBox(height: AppSpacing.lg),
    ];
  }

  List<Widget> _buildDoctorVisitFields() {
    return [
      Text('الطبيب', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
      const SizedBox(height: AppSpacing.sm),
      AppPickerField(hint: 'اختر الطبيب', value: _doctor?.name, onTap: _pickDoctor),
      const SizedBox(height: AppSpacing.lg),
      Text('التاريخ والوقت', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
      const SizedBox(height: AppSpacing.sm),
      Row(
        children: [
          Expanded(child: AppPickerField(hint: 'الوقت', value: _time.format(context), icon: Icons.access_time, onTap: _pickTime)),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: AppPickerField(hint: 'اختر التاريخ', value: _date == null ? null : intl.DateFormat('d/M/yyyy').format(_date!), icon: Icons.calendar_today_outlined, onTap: _pickDate)),
        ],
      ),
      const SizedBox(height: AppSpacing.lg),
      Text('العيادة / المكان', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
      const SizedBox(height: AppSpacing.sm),
      AppTextField(hint: 'مثال: مجمع الشفاء الطبي', controller: _placeController, textAlign: TextAlign.right, onChanged: (_) => setState(() {})),
      const SizedBox(height: AppSpacing.lg),
      Text('سبب الزيارة', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
      const SizedBox(height: AppSpacing.sm),
      Row(
        children: [
          for (final r in _visitReasons) ...[
            Expanded(child: SelectableChip(label: r, selected: _visitReason == r, onTap: () => setState(() => _visitReason = r))),
            if (r != _visitReasons.last) const SizedBox(width: AppSpacing.xs),
          ],
        ],
      ),
      const SizedBox(height: AppSpacing.lg),
    ];
  }
}
