import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/session/patient_cubit.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import 'edit_personal_info_page.dart';

class PersonalInfoPage extends StatelessWidget {
  const PersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final patient = context.watch<PatientCubit>().state;

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppPageHeader(
            title: 'المعلومات الشخصية',
            trailing: AppCircleIconButton(
              icon: Icons.edit_outlined,
              filled: false,
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EditPersonalInfoPage())),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primaryLight,
              child: Text(patient.fullName.substring(0, 1), style: AppTextStyles.displaySmall.copyWith(color: AppColors.primary)),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: Column(
              children: [
                _Row(label: 'الاسم الكامل', value: patient.fullName),
                const Divider(height: AppSpacing.lg),
                _Row(label: 'تاريخ الميلاد', value: patient.birthDate),
                const Divider(height: AppSpacing.lg),
                _Row(label: 'الجنس', value: patient.gender),
                const Divider(height: AppSpacing.lg),
                _Row(label: 'فصيلة الدم', value: patient.bloodType),
                const Divider(height: AppSpacing.lg),
                _Row(label: 'رقم الهاتف', value: patient.phone),
                const Divider(height: AppSpacing.lg),
                _Row(label: 'العنوان', value: patient.address),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(value, style: AppTextStyles.titleSmall),
        const Spacer(),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}
