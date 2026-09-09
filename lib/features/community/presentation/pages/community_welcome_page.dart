import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import 'community_hub_page.dart';

class CommunityWelcomePage extends StatelessWidget {
  const CommunityWelcomePage({super.key, required this.alias, required this.avatarEmoji});

  final String alias;
  final String avatarEmoji;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: const BoxDecoration(color: AppColors.accentPinkLight, shape: BoxShape.circle),
                  child: Center(child: Text(avatarEmoji, style: const TextStyle(fontSize: 40))),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('أهلاً فيك، $alias', style: AppTextStyles.titleLarge, textAlign: TextAlign.center),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'صرت جزء من مجتمع صغير يفهم رحلتك تماماً. خذي وقتك، واقرأي ما شاركي، إذا ما بديتي حبيتي.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.xl),
                AppButton(
                  label: 'دخول المجتمع',
                  onPressed: () => Navigator.of(context)
                      .pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const CommunityHubPage()), (r) => r.isFirst),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
