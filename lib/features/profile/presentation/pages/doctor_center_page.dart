import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/session/patient_cubit.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../onboarding/presentation/cubit/onboarding_cubit.dart' show mockDialysisCenters, mockDoctors;

class DoctorCenterPage extends StatelessWidget {
  const DoctorCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final patient = context.watch<PatientCubit>().state;

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppPageHeader(title: 'الطبيب والمركز'),
          const SizedBox(height: AppSpacing.lg),
          Text('طبيبك المتابع', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            child: Row(
              children: [
                TextButton(
                  onPressed: () async {
                    final picked = await showAppSelectSheet(
                      context,
                      title: 'اختر الطبيب',
                      options: mockDoctors,
                      labelBuilder: (d) => d.name,
                      selected: patient.doctor,
                    );
                    if (picked != null && context.mounted) context.read<PatientCubit>().updateDoctor(picked);
                  },
                  child: const Text('تغيير'),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(patient.doctor.name, style: AppTextStyles.titleSmall),
                    Text(patient.doctor.specialty, style: AppTextStyles.caption),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('مركز الغسيل', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            child: Row(
              children: [
                TextButton(
                  onPressed: () async {
                    final picked = await showAppSelectSheet(
                      context,
                      title: 'اختر المركز',
                      options: mockDialysisCenters,
                      labelBuilder: (c) => c.name,
                      selected: patient.center,
                    );
                    if (picked != null && context.mounted) context.read<PatientCubit>().updateCenter(picked);
                  },
                  child: const Text('تغيير'),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(patient.center.name, style: AppTextStyles.titleSmall),
                    Text(patient.center.subtitle, style: AppTextStyles.caption),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(color: AppColors.warningLight, borderRadius: AppRadius.radiusMd),
            child: Text(
              '"تغيير" بيتودك لنفس شاشات الاختيار الي عبيتها بالتسجيل الأول',
              textAlign: TextAlign.right,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.accentAmberDeep),
            ),
          ),
        ],
      ),
    );
  }
}
