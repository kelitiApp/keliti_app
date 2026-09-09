import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubit/onboarding_cubit.dart';

const _genders = ['ذكر', 'أنثى'];
const _bloodTypes = ['+O', '-O', '+A', '-A', '+B', '-B', '+AB', '-AB'];

class BasicInfoPage extends StatefulWidget {
  const BasicInfoPage({super.key});

  @override
  State<BasicInfoPage> createState() => _BasicInfoPageState();
}

class _BasicInfoPageState extends State<BasicInfoPage> {
  DateTime? _birthDate;
  String? _gender;
  String? _bloodType;

  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990, 11, 15),
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  Future<void> _pickGender() async {
    final picked = await showAppSelectSheet<String>(
      context,
      title: 'الجنس',
      options: _genders,
      labelBuilder: (v) => v,
      selected: _gender,
    );
    if (picked != null) setState(() => _gender = picked);
  }

  Future<void> _pickBloodType() async {
    final picked = await showAppSelectSheet<String>(
      context,
      title: 'فصيلة الدم',
      options: _bloodTypes,
      labelBuilder: (v) => v,
      selected: _bloodType,
    );
    if (picked != null) setState(() => _bloodType = picked);
  }

  bool get _canContinue => _birthDate != null && _gender != null && _bloodType != null;

  void _submit(BuildContext context) {
    final formatted =
        '${_birthDate!.day.toString().padLeft(2, '0')}/${_birthDate!.month.toString().padLeft(2, '0')}/${_birthDate!.year}';
    context.read<OnboardingCubit>().setBasicInfo(birthDate: formatted, gender: _gender!, bloodType: _bloodType!);
    Navigator.of(context).pushNamed(AppRoutes.onboardingMedicalInfo);
  }

  @override
  Widget build(BuildContext context) {
    final formatted = _birthDate == null
        ? null
        : '${_birthDate!.day.toString().padLeft(2, '0')}/${_birthDate!.month.toString().padLeft(2, '0')}/${_birthDate!.year}';

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppPageHeader(
            title: 'بياناتك الأساسية',
            subtitle: 'هذه المعلومات تساعد طبيبك والمركز على متابعتك بدقة',
            stepProgress: [true, true, true, false, false],
          ),
          const SizedBox(height: AppSpacing.xl),
          AppPickerField(
            label: 'تاريخ الميلاد',
            hint: 'اختر تاريخ الميلاد',
            value: formatted,
            icon: Icons.calendar_today_outlined,
            onTap: _pickBirthDate,
          ),
          const SizedBox(height: AppSpacing.md),
          AppPickerField(label: 'الجنس', hint: 'اختر الجنس', value: _gender, onTap: _pickGender),
          const SizedBox(height: AppSpacing.md),
          AppPickerField(
            label: 'فصيلة الدم',
            hint: 'مثال: +O',
            value: _bloodType,
            onTap: _pickBloodType,
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(label: 'التالي', onPressed: _canContinue ? () => _submit(context) : null),
        ],
      ),
    );
  }
}
