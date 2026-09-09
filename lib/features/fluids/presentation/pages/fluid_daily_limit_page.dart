import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubit/fluids_cubit.dart';

class FluidDailyLimitPage extends StatefulWidget {
  const FluidDailyLimitPage({super.key});

  @override
  State<FluidDailyLimitPage> createState() => _FluidDailyLimitPageState();
}

class _FluidDailyLimitPageState extends State<FluidDailyLimitPage> {
  late final _controller = TextEditingController(text: '${context.read<FluidsCubit>().state.dailyLimitMl}');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppPageHeader(title: 'الحد اليومي'),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(color: AppColors.warningLight, borderRadius: AppRadius.radiusMd),
            child: Text(
              'حدد هذا الرقم حسب توصية طبيبك المتابع',
              textAlign: TextAlign.right,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.accentAmberDeep),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            label: 'الحد الأقصى اليومي (مل)',
            controller: _controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'حفظ',
            onPressed: () {
              final value = int.tryParse(_controller.text);
              if (value != null && value > 0) {
                context.read<FluidsCubit>().setDailyLimit(value);
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }
}
