import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/routes.dart';
import '../../../../core/session/patient_cubit.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubit/onboarding_cubit.dart';

class OnboardingCompletePage extends StatefulWidget {
  const OnboardingCompletePage({super.key});

  @override
  State<OnboardingCompletePage> createState() => _OnboardingCompletePageState();
}

class _OnboardingCompletePageState extends State<OnboardingCompletePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _commitToProfile());
  }

  void _commitToProfile() {
    final onboarding = context.read<OnboardingCubit>().state;
    final patientCubit = context.read<PatientCubit>();
    patientCubit.updatePersonalInfo(
      birthDate: onboarding.birthDate,
      gender: onboarding.gender,
      bloodType: onboarding.bloodType,
    );
    if (onboarding.doctor != null) patientCubit.updateDoctor(onboarding.doctor!);
    if (onboarding.center != null) patientCubit.updateCenter(onboarding.center!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppResultView(
        title: 'أهلاً فيك بـ"كليتي"، أحمد',
        description: 'حسابك جاهز بالكامل، تم حفظ بياناتك الطبية، مركز الغسيل، طبيبك المتابع، ودعوة عائلتك.',
        summary: Column(
          children: const [
            _ChecklistRow(label: 'مركز الأمل لغسيل الكلى'),
            SizedBox(height: AppSpacing.sm),
            _ChecklistRow(label: 'د. أحمد خليل — طبيب متابع'),
            SizedBox(height: AppSpacing.sm),
            _ChecklistRow(label: 'دعوة عائلية بانتظار القبول'),
          ],
        ),
        primaryLabel: 'الانتقال إلى الرئيسية',
        onPrimary: () => Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.mainShell, (route) => false),
      ),
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  const _ChecklistRow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: AppRadius.radiusMd,
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
          const SizedBox(width: AppSpacing.xs),
          Expanded(child: Text(label, textAlign: TextAlign.right, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }
}
