import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

const _faqs = [
  ('كيف أضيف دواء جديد؟', 'من تاب "الأدوية" بأسفل الشاشة، اضغطي زر "+" العائم بأسفل يسار الشاشة، عبي اسم الدواء، الشكل الدوائي، الجرعة، وعدد المرات باليوم، وبتولّد التذكيرات تلقائياً بعد الحفظ.'),
  ('كيف أغيّر مركز الغسيل؟', 'من الملف الشخصي > الطبيب ومركز الغسيل > اضغطي "تغيير" جنب مركز الغسيل واختاري المركز الجديد.'),
  ('ليش ما توصلني الإشعارات؟', 'تأكدي من تفعيل الإشعارات من الملف الشخصي > الإشعارات والتذكيرات، وكمان من إعدادات الجهاز للتطبيق.'),
];

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppPageHeader(title: 'المساعدة والدعم'),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(hint: 'ابحث عن سؤالك...', prefixIcon: Icons.search, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.lg),
          Text('أسئلة شائعة', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.sm),
          for (final faq in _faqs) ...[
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMd, side: const BorderSide(color: AppColors.border)),
                collapsedShape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMd, side: const BorderSide(color: AppColors.border)),
                title: Text(faq.$1, textAlign: TextAlign.right, style: AppTextStyles.bodyLarge),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
                    child: Text(faq.$2, textAlign: TextAlign.right, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          const SizedBox(height: AppSpacing.lg),
          Text('تواصل معنا', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: AppCard(
                  onTap: () {},
                  child: Column(
                    children: [
                      const Icon(Icons.mail_outline_rounded, color: AppColors.primary),
                      const SizedBox(height: 6),
                      Text('راسلنا إيميل', style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppCard(
                  onTap: () {},
                  child: Column(
                    children: [
                      const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.primary),
                      const SizedBox(height: 6),
                      Text('محادثة مباشرة', style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
