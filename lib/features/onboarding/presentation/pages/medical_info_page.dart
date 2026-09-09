import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubit/onboarding_cubit.dart';

const _dialysisTypes = ['غسيل دموي', 'غسيل بريتوني'];
const _sessionsOptions = [2, 3, 4];

class MedicalInfoPage extends StatefulWidget {
  const MedicalInfoPage({super.key});

  @override
  State<MedicalInfoPage> createState() => _MedicalInfoPageState();
}

class _MedicalInfoPageState extends State<MedicalInfoPage> {
  String? _dialysisType = 'غسيل دموي';
  int? _sessions = 3;
  DateTime? _startDate = DateTime(2024, 1, 10);

  Future<void> _pickDialysisType() async {
    final picked = await showAppSelectSheet<String>(
      context,
      title: 'نوع الغسيل الكلوي',
      options: _dialysisTypes,
      labelBuilder: (v) => v,
      selected: _dialysisType,
    );
    if (picked != null) setState(() => _dialysisType = picked);
  }

  Future<void> _pickSessions() async {
    final picked = await showAppSelectSheet<int>(
      context,
      title: 'عدد الجلسات أسبوعيا',
      options: _sessionsOptions,
      labelBuilder: (v) => '$v جلسات',
      selected: _sessions,
    );
    if (picked != null) setState(() => _sessions = picked);
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  bool get _canContinue => _dialysisType != null && _sessions != null && _startDate != null;

  void _submit(BuildContext context) {
    final formatted = '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}';
    context.read<OnboardingCubit>().setMedicalInfo(
          dialysisType: _dialysisType!,
          sessionsPerWeek: _sessions!,
          treatmentStartDate: formatted,
        );
    Navigator.of(context).pushNamed(AppRoutes.onboardingDialysisCenter);
  }

  @override
  Widget build(BuildContext context) {
    final formattedStart =
        _startDate == null ? null : '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}';

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppPageHeader(
            title: 'معلوماتك الطبية',
            subtitle: 'لتخصيص جدول الجلسات والتنبيهات المناسبة لحالتك',
            stepProgress: [true, true, true, true, false],
          ),
          const SizedBox(height: AppSpacing.xl),
          AppPickerField(
            label: 'نوع الغسيل الكلوي',
            hint: 'اختر نوع الغسيل',
            value: _dialysisType,
            onTap: _pickDialysisType,
          ),
          const SizedBox(height: AppSpacing.md),
          AppPickerField(
            label: 'عدد الجلسات أسبوعيا',
            hint: 'اختر عدد الجلسات',
            value: _sessions == null ? null : '$_sessions جلسات',
            onTap: _pickSessions,
          ),
          const SizedBox(height: AppSpacing.md),
          AppPickerField(
            label: 'تاريخ بدء العلاج',
            hint: 'اختر التاريخ',
            value: formattedStart,
            icon: Icons.calendar_today_outlined,
            onTap: _pickStartDate,
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(label: 'التالي', onPressed: _canContinue ? () => _submit(context) : null),
        ],
      ),
    );
  }
}
