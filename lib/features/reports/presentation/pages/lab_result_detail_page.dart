import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubit/reports_cubit.dart';

class LabResultDetailPage extends StatelessWidget {
  const LabResultDetailPage({super.key, required this.resultId});

  final String resultId;

  @override
  Widget build(BuildContext context) {
    final result = context.read<ReportsCubit>().labResultById(resultId);
    if (result == null) return const SizedBox.shrink();

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppPageHeader(
            title: result.name,
            trailing: AppCircleIconButton(
              icon: Icons.ios_share_rounded,
              filled: false,
              onPressed: () => ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('تمت مشاركة الملف'))),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text('${result.dateLabel} . ${result.labName}', textAlign: TextAlign.right, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.lg),
          Text('القيم', style: AppTextStyles.titleMedium, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.sm),
          for (final v in result.values) ...[
            AppCard(
              borderColor: v.abnormal ? AppColors.error : AppColors.border,
              child: Row(
                children: [
                  Text(
                    v.value,
                    style: AppTextStyles.titleLarge.copyWith(color: v.abnormal ? AppColors.error : AppColors.textPrimary),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(v.label, style: AppTextStyles.titleSmall),
                      Text(v.range, style: AppTextStyles.caption),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          if (result.doctorNote != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(color: AppColors.warningLight, borderRadius: AppRadius.radiusMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('ملاحظة الطبيب', style: AppTextStyles.titleSmall.copyWith(color: AppColors.accentAmberDeep)),
                  const SizedBox(height: 4),
                  Text(result.doctorNote!, textAlign: TextAlign.right, style: AppTextStyles.bodySmall.copyWith(color: AppColors.accentAmberDeep)),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          AppButton(label: 'مشاركة كملف PDF', variant: AppButtonVariant.outlined, icon: Icons.ios_share_rounded, onPressed: () {}),
        ],
      ),
    );
  }
}
