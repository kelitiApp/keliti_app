import 'package:flutter/material.dart';

import '../../../../core/routes/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canDelete = _controller.text.trim() == 'حذف';

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppPageHeader(title: 'حذف الحساب'),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(color: AppColors.errorLight, shape: BoxShape.circle),
              child: const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 36),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(color: AppColors.errorLight, borderRadius: AppRadius.radiusMd),
            child: Text(
              'سيتم حذف: بياناتك الشخصية، سجل الأدوية والمواعيد، كل التقارير والقياسات، وقطع الوصول عن جهات اتصال عائلتك — بشكل نهائي لا يمكن التراجع عنه.',
              textAlign: TextAlign.right,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('اكتبي "حذف" للتأكيد', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(hint: 'حذف', controller: _controller, textAlign: TextAlign.right, onChanged: (_) => setState(() {})),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'حذف الحساب نهائياً',
            variant: AppButtonVariant.destructive,
            onPressed: canDelete
                ? () => Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false)
                : null,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(label: 'تراجع', variant: AppButtonVariant.text, onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }
}
