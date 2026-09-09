import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/medication.dart';
import '../cubit/medications_cubit.dart';
import 'medications_page.dart';

class DoseConfirmPage extends StatelessWidget {
  const DoseConfirmPage({super.key, required this.medicationId, required this.time});

  final String medicationId;
  final String time;

  @override
  Widget build(BuildContext context) {
    final medication = context.read<MedicationsCubit>().byId(medicationId);
    if (medication == null) return const SizedBox.shrink();

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: AppPageHeader(title: ''),
          ),
          Expanded(
            child: AppResultView(
              tone: ResultTone.info,
              icon: Icons.medication_liquid_rounded,
              title: 'هل تم أخذ الجرعة الآن؟',
              description: 'يرجى تأكيد أخذ جرعتك في الوقت المحدد لضمان استقرار العلاج.',
              summary: AppCard(
                child: Row(
                  children: [
                    AppIconBadge(icon: formIcon(medication.form)),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(medication.name, style: AppTextStyles.titleSmall),
                          Text(
                            '${medication.doseAmount} ${medication.doseUnit} - ${medication.form.label}',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('موعد الجرعة', style: AppTextStyles.caption),
                        Text(time, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary)),
                      ],
                    ),
                  ],
                ),
              ),
              primaryLabel: 'نعم، تم الأخذ',
              onPrimary: () {
                context.read<MedicationsCubit>().markDoseTaken(medicationId, time);
                Navigator.of(context).pop();
              },
              secondaryLabel: 'لا، ليس بعد',
              onSecondary: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
