import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

class RateAppPage extends StatefulWidget {
  const RateAppPage({super.key});

  @override
  State<RateAppPage> createState() => _RateAppPageState();
}

class _RateAppPageState extends State<RateAppPage> {
  int _rating = 0;
  final _feedbackController = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return Scaffold(
        body: AppResultView(
          title: 'شكراً لك!',
          description: 'وصلنا تقييمك، وبيساعدنا نطوّر "كليتي" أكثر.',
          primaryLabel: 'العودة إلى الملف الشخصي',
          onPrimary: () => Navigator.of(context).pop(),
        ),
      );
    }

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppPageHeader(title: 'قيّم تجربتك'),
          const SizedBox(height: AppSpacing.xl),
          Center(
            child: Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
              child: const Icon(Icons.star_border_rounded, color: AppColors.primary, size: 36),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('كيف كانت تجربتك مع "كليتي"؟', textAlign: TextAlign.center, style: AppTextStyles.titleLarge),
          const SizedBox(height: 4),
          Text('رأيك يساعدنا نحسّن التطبيق', textAlign: TextAlign.center, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 1; i <= 5; i++)
                IconButton(
                  onPressed: () => setState(() => _rating = i),
                  icon: Icon(
                    i <= _rating ? Icons.star_rounded : Icons.star_border_rounded,
                    color: AppColors.accentAmberDeep,
                    size: 32,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(hint: 'شاركنا رأيك (اختياري)...', controller: _feedbackController, maxLines: 4, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.xl),
          AppButton(label: 'إرسال التقييم', onPressed: _rating == 0 ? null : () => setState(() => _submitted = true)),
        ],
      ),
    );
  }
}
