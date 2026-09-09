import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubit/community_cubit.dart';
import 'community_welcome_page.dart';

const _suggestedAliases = ['ورقة الزيتون', 'نجمة الصبر', 'قوس الأمل'];

class CommunityIdentitySetupPage extends StatefulWidget {
  const CommunityIdentitySetupPage({super.key});

  @override
  State<CommunityIdentitySetupPage> createState() => _CommunityIdentitySetupPageState();
}

class _CommunityIdentitySetupPageState extends State<CommunityIdentitySetupPage> {
  late String _alias = _suggestedAliases.first;
  late String _avatar = CommunityCubit.avatarOptions.first;

  void _shuffleAlias() {
    final others = _suggestedAliases.where((a) => a != _alias).toList();
    setState(() => _alias = (others..shuffle()).first);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppPageHeader(title: 'هويتك بالمجتمع'),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(color: AppColors.accentPinkLight, shape: BoxShape.circle),
              child: Center(child: Text(_avatar, style: const TextStyle(fontSize: 36))),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              TextButton.icon(
                onPressed: _shuffleAlias,
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: const Text('اقترح اسم آخر'),
              ),
              const Spacer(),
              Text('الاسم المستعار', style: AppTextStyles.titleSmall),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final alias in _suggestedAliases) ...[
            _OptionTile(label: alias, selected: _alias == alias, onTap: () => setState(() => _alias = alias)),
            const SizedBox(height: AppSpacing.xs),
          ],
          const SizedBox(height: AppSpacing.lg),
          Text('اختاري أفاتار', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final emoji in CommunityCubit.avatarOptions) ...[
                GestureDetector(
                  onTap: () => setState(() => _avatar = emoji),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceAlt,
                      shape: BoxShape.circle,
                      border: Border.all(color: _avatar == emoji ? AppColors.primary : Colors.transparent, width: 2),
                    ),
                    child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: AppRadius.radiusMd),
            child: Text(
              'هاي الهوية بس اللي بيشوفها باقي أعضاء المجتمع، وتقدري تغيّريها بأي وقت',
              textAlign: TextAlign.right,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryDark),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'متابعة',
            onPressed: () {
              context.read<CommunityCubit>().setIdentity(alias: _alias, avatarEmoji: _avatar);
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => CommunityWelcomePage(alias: _alias, avatarEmoji: _avatar)));
            },
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      borderColor: selected ? AppColors.primary : AppColors.border,
      color: selected ? AppColors.primaryLight : AppColors.surface,
      child: Text(label, textAlign: TextAlign.right, style: AppTextStyles.bodyLarge),
    );
  }
}
