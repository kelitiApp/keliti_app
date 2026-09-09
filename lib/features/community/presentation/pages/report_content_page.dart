import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

const _reasons = ['محتوى مسيء أو غير محترم', 'معلومة طبية خاطئة أو خطرة', 'انتحال هوية / احتيال', 'أخرى'];

class ReportContentPage extends StatefulWidget {
  const ReportContentPage({super.key, required this.postId});

  final String postId;

  @override
  State<ReportContentPage> createState() => _ReportContentPageState();
}

class _ReportContentPageState extends State<ReportContentPage> {
  String _reason = _reasons.first;
  final _detailsController = TextEditingController();

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppPageHeader(title: 'الإبلاغ عن هذا المحتوى'),
          Text('بلاغك سري تماماً، وما رح يعرف صاحب المنشور مين بلّغ', textAlign: TextAlign.right, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.lg),
          Text('سبب البلاغ', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.sm),
          for (final r in _reasons) ...[
            _ReasonTile(label: r, selected: _reason == r, onTap: () => setState(() => _reason = r)),
            const SizedBox(height: AppSpacing.xs),
          ],
          const SizedBox(height: AppSpacing.lg),
          Text('تفاصيل إضافية (اختياري)', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.xs),
          AppTextField(controller: _detailsController, maxLines: 3, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'إرسال البلاغ',
            variant: AppButtonVariant.destructive,
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (dialogContext) => Dialog(
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusLg),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: AppResultView(
                      title: 'شكراً، وصلنا بلاغك',
                      description: 'فريقنا بيراجع المحتوى خلال 24 ساعة. بلاغك ساعد يخلي المجتمع مساحة أأمن للجميع.',
                      primaryLabel: 'العودة للمجتمع',
                      onPrimary: () => Navigator.of(dialogContext)
                        ..pop()
                        ..pop(),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ReasonTile extends StatelessWidget {
  const _ReasonTile({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      borderColor: selected ? AppColors.error : AppColors.border,
      color: selected ? AppColors.errorLight : AppColors.surface,
      child: Text(label, textAlign: TextAlign.right, style: AppTextStyles.bodyMedium.copyWith(color: selected ? AppColors.error : AppColors.textPrimary)),
    );
  }
}
