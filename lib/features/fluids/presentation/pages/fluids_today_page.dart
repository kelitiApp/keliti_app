import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubit/fluids_cubit.dart';
import 'add_fluid_page.dart';
import 'fluid_daily_limit_page.dart';
import 'fluid_limit_warning_page.dart';
import 'fluid_log_page.dart';

class FluidsTodayPage extends StatelessWidget {
  const FluidsTodayPage({super.key});

  Future<void> _quickAdd(BuildContext context, String label, int amount) async {
    final cubit = context.read<FluidsCubit>();
    cubit.addEntry(label: label, amountMl: amount);
    if (cubit.state.isNearLimit || cubit.state.isOverLimit) {
      if (!context.mounted) return;
      await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FluidLimitWarningPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: BlocBuilder<FluidsCubit, FluidsState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppPageHeader(
                title: 'السوائل اليوم',
                trailing: AppCircleIconButton(
                  icon: Icons.settings_outlined,
                  filled: false,
                  onPressed: () =>
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FluidDailyLimitPage())),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: SizedBox(
                  width: 180,
                  height: 180,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 180,
                        height: 180,
                        child: CircularProgressIndicator(
                          value: state.progress,
                          strokeWidth: 12,
                          backgroundColor: AppColors.surfaceMuted,
                          valueColor: AlwaysStoppedAnimation(
                            state.isOverLimit ? AppColors.error : AppColors.primary,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${state.todayTotalMl}', style: AppTextStyles.statValueLarge),
                          Text('من ${state.dailyLimitMl} مل', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Center(
                child: Text(
                  'باقيلك ${state.remainingMl} مل مسموحة اليوم',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('إضافة سريعة', style: AppTextStyles.titleMedium, textAlign: TextAlign.right),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: _QuickAddTile(
                      icon: Icons.add,
                      label: 'كمية أخرى',
                      sublabel: '',
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddFluidPage())),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _QuickAddTile(
                      icon: Icons.emoji_food_beverage_outlined,
                      label: 'كوب شاي',
                      sublabel: '150 مل',
                      onTap: () => _quickAdd(context, 'كوب شاي', 150),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _QuickAddTile(
                      icon: Icons.local_cafe_outlined,
                      label: 'كوب ماء',
                      sublabel: '200 مل',
                      onTap: () => _quickAdd(context, 'كوب ماء', 200),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FluidLogPage())),
                    child: const Text('السجل ›'),
                  ),
                  const Spacer(),
                  Text('اليوم', style: AppTextStyles.titleMedium),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              for (final entry in state.todayEntries.reversed) ...[
                AppCard(
                  child: Row(
                    children: [
                      Text('${entry.timeLabel} . ${entry.amountMl} مل', style: AppTextStyles.caption),
                      const Spacer(),
                      Text(entry.label, style: AppTextStyles.titleSmall),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _QuickAddTile extends StatelessWidget {
  const _QuickAddTile({required this.icon, required this.label, required this.sublabel, required this.onTap});

  final IconData icon;
  final String label;
  final String sublabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: 6),
          Text(label, style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
          if (sublabel.isNotEmpty) Text(sublabel, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
