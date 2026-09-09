import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubit/community_cubit.dart';
import 'category_feed_page.dart';
import 'community_intro_page.dart';
import 'community_settings_page.dart';

class CommunityHubPage extends StatelessWidget {
  const CommunityHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CommunityCubit>().state;

    if (!state.joined) return const CommunityIntroPage();

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppPageHeader(
            title: 'مجتمع الدعم',
            trailing: AppCircleIconButton(
              icon: Icons.settings_outlined,
              filled: false,
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CommunitySettingsPage())),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(hint: 'ابحثي بالمجتمع...', prefixIcon: Icons.search, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.lg),
          for (final category in state.categories) ...[
            AppCard(
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => CategoryFeedPage(categoryId: category.id))),
              child: Row(
                children: [
                  Text('${category.postCount} منشور', style: AppTextStyles.caption),
                  const Spacer(),
                  Text(category.name, style: AppTextStyles.titleMedium),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}
