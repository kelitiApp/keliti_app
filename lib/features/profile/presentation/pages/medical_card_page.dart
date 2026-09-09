import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/session/patient_cubit.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import 'edit_medical_card_page.dart';

class MedicalCardPage extends StatelessWidget {
  const MedicalCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final patient = context.watch<PatientCubit>().state;
    final incomplete = patient.allergies.isEmpty;

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppPageHeader(
            title: 'بطاقتي الطبية',
            trailing: AppCircleIconButton(
              icon: Icons.edit_outlined,
              filled: false,
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EditMedicalCardPage())),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.error, borderRadius: AppRadius.radiusLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    const Icon(Icons.call, color: Colors.white, size: 18),
                    const Spacer(),
                    Text('بطاقة طوارئ طبية', style: AppTextStyles.titleSmall.copyWith(color: Colors.white)),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(patient.fullName, style: AppTextStyles.titleLarge.copyWith(color: Colors.white)),
                Text('مريض غسيل كلي — منذ يناير 2025', style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: _CardStat(
                        label: 'جدول الغسيل',
                        value: patient.showDialysisScheduleOnCard ? 'أحد، ثلاثاء، خميس' : '—',
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: _CardStat(label: 'فصيلة الدم', value: patient.bloodType)),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                _CardStat(label: 'حساسية من', value: patient.allergies.isEmpty ? 'لا يوجد' : patient.allergies),
                const SizedBox(height: AppSpacing.md),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: AppRadius.radiusMd),
                  child: Column(
                    children: [
                      const Icon(Icons.qr_code_2_rounded, size: 48, color: AppColors.textPrimary),
                      const SizedBox(height: 4),
                      Text('امسح الكود لعرض البطاقة', style: AppTextStyles.caption),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: 'نسخ رابط البطاقة',
            variant: AppButtonVariant.outlined,
            icon: Icons.link_rounded,
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم نسخ الرابط'))),
          ),
          const SizedBox(height: AppSpacing.md),
          if (incomplete)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: AppRadius.radiusMd),
              child: Text(
                'فعّل "Medical ID" من إعدادات الموبايل عشان تظهر البطاقة من شاشة القفل مباشرة',
                textAlign: TextAlign.right,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryDark),
              ),
            ),
        ],
      ),
    );
  }
}

class _CardStat extends StatelessWidget {
  const _CardStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: AppRadius.radiusSm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(label, style: AppTextStyles.caption.copyWith(color: Colors.white70)),
          Text(value, style: AppTextStyles.titleSmall.copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}
