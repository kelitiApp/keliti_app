import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/medication.dart';
import '../cubit/medications_cubit.dart';
import 'add_edit_medication_page.dart';
import 'dose_confirm_page.dart';
import 'medications_page.dart';

class MedicationDetailPage extends StatelessWidget {
  const MedicationDetailPage({super.key, required this.medicationId});

  final String medicationId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicationsCubit, MedicationsState>(
      builder: (context, state) {
        final medication = context.read<MedicationsCubit>().byId(medicationId);
        if (medication == null) return const SizedBox.shrink();

        return AppScaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.md),
              const AppPageHeader(title: 'تفاصيل الدواء'),
              const SizedBox(height: AppSpacing.lg),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: AppRadius.radiusLg,
                ),
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StatusChip(
                      label: medication.active ? 'نشط' : 'متوقف',
                      tone: medication.active ? StatusTone.primary : StatusTone.neutral,
                      icon: medication.active ? Icons.check_circle : null,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(medication.name,
                        style: AppTextStyles.headlineSmall.copyWith(color: Colors.white)),
                    const SizedBox(height: 4),
                    Text(
                      '${medication.doseAmount} ${medication.doseUnit} - ${medication.form.label}',
                      style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: _StatBox(icon: Icons.repeat_rounded, label: 'التكرار', value: '${medication.timesPerDay} مرات/يوم'),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _StatBox(icon: formIcon(medication.form), label: 'الجرعة', value: '1 ${medication.form == MedicationForm.injection ? 'حقنة' : 'قرص'}'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('التعليمات', style: AppTextStyles.titleMedium, textAlign: TextAlign.right),
              const SizedBox(height: AppSpacing.sm),
              for (final instruction in medication.instructions) ...[
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(instruction.$1, style: AppTextStyles.titleSmall),
                      const SizedBox(height: 4),
                      Text(instruction.$2, style: AppTextStyles.bodySmall, textAlign: TextAlign.right),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              const SizedBox(height: AppSpacing.sm),
              Text('التفاصيل الطبية', style: AppTextStyles.titleMedium, textAlign: TextAlign.right),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                child: Column(
                  children: [
                    _KeyValueRow(label: 'مدة العلاج', value: medication.treatmentEndDate),
                    const Divider(height: AppSpacing.lg),
                    _KeyValueRow(label: 'الطبيب المعالج', value: medication.doctorName, icon: Icons.medical_services_outlined),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              if (medication.active)
                AppButton(
                  label: 'سجل الجرعة الحالية',
                  icon: Icons.check_circle_outline,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DoseConfirmPage(medicationId: medication.id, time: medication.doseTimes.first),
                    ),
                  ),
                )
              else
                AppButton(
                  label: 'تعديل الدواء',
                  variant: AppButtonVariant.outlined,
                  onPressed: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => AddEditMedicationPage(medication: medication))),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Icon(icon, color: AppColors.textSecondary),
          const SizedBox(height: 6),
          Text(label, style: AppTextStyles.caption),
          const SizedBox(height: 2),
          Text(value, style: AppTextStyles.titleSmall),
        ],
      ),
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  const _KeyValueRow({required this.label, required this.value, this.icon});

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: AppTextStyles.caption),
        const Spacer(),
        if (icon != null) ...[
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 4),
        ],
        Text(value, style: AppTextStyles.titleSmall),
      ],
    );
  }
}
