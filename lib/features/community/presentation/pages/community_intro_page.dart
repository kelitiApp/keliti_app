import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import 'community_identity_setup_page.dart';

class CommunityIntroPage extends StatelessWidget {
  const CommunityIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppResultView(
        tone: ResultTone.success,
        icon: Icons.favorite_border_rounded,
        title: 'مساحتك الآمنة',
        description:
            'مجتمع صغير من مرضى غسيل الكلى، يشاركوا تجاربهم ويدعموا بعض، ما إنت لحالك بهاي الرحلة.',
        summary: Column(
          children: const [
            _RuleRow(icon: Icons.person_off_outlined, text: 'اسمك الحقيقي ما بيظهر أبداً'),
            SizedBox(height: AppSpacing.sm),
            _RuleRow(icon: Icons.lock_outline_rounded, text: 'لا صور شخصية — أفاتار رمزي بس'),
            SizedBox(height: AppSpacing.sm),
            _RuleRow(icon: Icons.shield_outlined, text: 'بياناتك الطبية ما بتنشارك هون إطلاقاً'),
          ],
        ),
        primaryLabel: 'إنشاء هويتي المستعارة',
        onPrimary: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CommunityIdentitySetupPage())),
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  const _RuleRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: AppRadius.radiusMd),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(width: AppSpacing.xs),
          Expanded(child: Text(text, textAlign: TextAlign.right, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }
}
