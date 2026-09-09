import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/routes.dart';
import '../../../../core/session/patient_profile.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubit/onboarding_cubit.dart';

class DialysisCenterPage extends StatefulWidget {
  const DialysisCenterPage({super.key});

  @override
  State<DialysisCenterPage> createState() => _DialysisCenterPageState();
}

class _DialysisCenterPageState extends State<DialysisCenterPage> {
  String _query = '';
  DialysisCenterInfo? _selected;

  @override
  Widget build(BuildContext context) {
    final results = mockDialysisCenters.where((c) => c.name.contains(_query)).toList();

    return AppScaffold(
      scrollable: false,
      bottomBar: AppButton(
        label: 'التالي',
        onPressed: _selected == null
            ? null
            : () {
                context.read<OnboardingCubit>().selectCenter(_selected!);
                Navigator.of(context).pushNamed(AppRoutes.onboardingDoctor);
              },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.md),
          const AppPageHeader(
            title: 'اختر مركز الغسيل',
            subtitle: 'اربط حسابك بالمركز الذي تتابع جلساتك فيه',
            stepProgress: [false, false, true, true, true],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            hint: 'ابحث عن مركز قريب منك',
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
                final center = results[index];
                final selected = center.id == _selected?.id;
                return AppCard(
                  onTap: () => setState(() => _selected = center),
                  borderColor: selected ? AppColors.primary : AppColors.border,
                  child: Row(
                    children: [
                      OutlinedButton(
                        onPressed: () => setState(() => _selected = center),
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
                      Text(center.name, style: AppTextStyles.titleSmall),
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
