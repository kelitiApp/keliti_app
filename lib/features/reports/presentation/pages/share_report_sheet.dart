import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

const _shareOptions = [
  'نتائج الفحوصات (آخر 4 أشهر)',
  'سجل جلسات الغسيل',
  'المؤشرات الحيوية',
  'تقرير الالتزام',
];

/// "اختاري ما تريدين مشاركته" bottom sheet used from both the reports hub
/// and the adherence report to export/share a combined PDF with the doctor.
void showShareReportSheet(BuildContext context) {
  final selected = <String>{_shareOptions[0], _shareOptions[1]};

  showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl))),
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageHorizontal,
                AppSpacing.md,
                AppSpacing.pageHorizontal,
                AppSpacing.xl,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(color: AppColors.borderStrong, borderRadius: AppRadius.radiusPill),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text('اختاري ما تريدين مشاركته', style: AppTextStyles.titleLarge, textAlign: TextAlign.right),
                  const SizedBox(height: AppSpacing.sm),
                  for (final option in _shareOptions)
                    CheckboxListTile(
                      value: selected.contains(option),
                      onChanged: (v) => setState(() => v == true ? selected.add(option) : selected.remove(option)),
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: AppColors.primary,
                      title: Text(option, textAlign: TextAlign.right, style: AppTextStyles.bodyLarge),
                    ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    label: 'تصدير كملف PDF',
                    icon: Icons.picture_as_pdf_outlined,
                    onPressed: selected.isEmpty
                        ? null
                        : () {
                            Navigator.of(sheetContext).pop();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(content: Text('جاري تجهيز الملف...')));
                          },
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  AppButton(label: 'إلغاء', variant: AppButtonVariant.text, onPressed: () => Navigator.of(sheetContext).pop()),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
