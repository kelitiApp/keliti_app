import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/routes.dart';
import '../../../../core/session/patient_profile.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubit/onboarding_cubit.dart';

class DoctorSelectPage extends StatefulWidget {
  const DoctorSelectPage({super.key});

  @override
  State<DoctorSelectPage> createState() => _DoctorSelectPageState();
}

class _DoctorSelectPageState extends State<DoctorSelectPage> {
  String _query = '';
  DoctorInfo? _selected;

  @override
  Widget build(BuildContext context) {
    final results = mockDoctors.where((d) => d.name.contains(_query)).toList();

    return AppScaffold(
      scrollable: false,
      bottomBar: AppButton(
        label: 'التالي',
        onPressed: _selected == null
            ? null
            : () {
                context.read<OnboardingCubit>().selectDoctor(_selected!);
                Navigator.of(context).pushNamed(AppRoutes.familyInvite);
              },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.md),
          const AppPageHeader(
            title: 'اختر طبيبك المتابع',
            subtitle: 'الأطباء المتاحون في المركز الذي اخترته',
            stepProgress: [false, false, false, true, true],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            hint: 'ابحث باسم الطبيب',
            textAlign: TextAlign.right,
            prefixIcon: Icons.search,
            onChanged: (v) => setState(() => _query = v),
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: ListView.separated(
              itemCount: results.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final doctor = results[index];
                final selected = doctor.id == _selected?.id;
                return AppCard(
                  onTap: () => setState(() => _selected = doctor),
                  borderColor: selected ? AppColors.primary : AppColors.border,
                  child: Row(
                    children: [
                      OutlinedButton(
                        onPressed: () => setState(() => _selected = doctor),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 36),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          backgroundColor: selected ? AppColors.primary : Colors.transparent,
                          side: BorderSide(color: selected ? AppColors.primary : AppColors.border),
                        ),
                        child: Text(
                          'اختيار',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: selected ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(doctor.name, style: AppTextStyles.titleSmall),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
