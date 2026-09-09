import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubit/community_cubit.dart';
import 'community_identity_setup_page.dart';
import 'community_principles_page.dart';

class CommunitySettingsPage extends StatefulWidget {
  const CommunitySettingsPage({super.key});

  @override
  State<CommunitySettingsPage> createState() => _CommunitySettingsPageState();
}

class _CommunitySettingsPageState extends State<CommunitySettingsPage> {
  bool _repliesToMyComments = true;
  bool _newPostsInFavorites = false;

  Future<void> _leave() async {
    final result = await showAppConfirmSheet(
      context,
      icon: Icons.eco_outlined,
      title: 'مغادرة المجتمع؟',
      description: 'هوية "${context.read<CommunityCubit>().state.alias}" ومنشوراتك وتعليقاتك بتختفي نهائياً. تقدري ترجعي لاحقاً بهوية جديدة من الصفر.',
      confirmLabel: 'نعم، مغادرة نهائياً',
    );
    if (result == 'confirm' && mounted) {
      context.read<CommunityCubit>().leaveCommunity();
      Navigator.of(context).popUntil((r) => r.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CommunityCubit>().state;

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppPageHeader(title: 'إعدادات المجتمع'),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CommunityIdentitySetupPage())),
                  child: const Text('تغيير'),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(state.alias, style: AppTextStyles.titleSmall),
                    Text('هويتك المستعارة', style: AppTextStyles.caption),
                  ],
                ),
                const SizedBox(width: AppSpacing.sm),
                CircleAvatar(radius: 20, backgroundColor: AppColors.accentPinkLight, child: Text(state.avatarEmoji)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('الإشعارات', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            child: Column(
              children: [
                AppToggleTile(title: 'رد على تعليقي', value: _repliesToMyComments, onChanged: (v) => setState(() => _repliesToMyComments = v)),
                const Divider(height: AppSpacing.lg),
                AppToggleTile(title: 'منشورات جديدة بفئاتي المفضّلة', value: _newPostsInFavorites, onChanged: (v) => setState(() => _newPostsInFavorites = v)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CommunityPrinciplesPage())),
            child: Row(
              children: [
                const Icon(Icons.chevron_left, color: AppColors.textTertiary),
                const Spacer(),
                Text('مبادئ المجتمع', style: AppTextStyles.bodyLarge),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(label: 'مغادرة المجتمع', variant: AppButtonVariant.outlined, icon: Icons.logout_rounded, onPressed: _leave),
        ],
      ),
    );
  }
}
