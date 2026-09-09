import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubit/fluids_cubit.dart';
import 'fluid_limit_warning_page.dart';

const _presetAmounts = [500, 330, 250, 100];

class AddFluidPage extends StatefulWidget {
  const AddFluidPage({super.key});

  @override
  State<AddFluidPage> createState() => _AddFluidPageState();
}

class _AddFluidPageState extends State<AddFluidPage> {
  final _labelController = TextEditingController();
  final _customController = TextEditingController();
  int? _selectedAmount = 250;

  @override
  void dispose() {
    _labelController.dispose();
    _customController.dispose();
    super.dispose();
  }

  int? get _amount => _selectedAmount ?? int.tryParse(_customController.text);

  Future<void> _submit() async {
    final cubit = context.read<FluidsCubit>();
    cubit.addEntry(label: _labelController.text.trim().isEmpty ? 'سوائل' : _labelController.text, amountMl: _amount!);
    Navigator.of(context).pop();
    if (cubit.state.isNearLimit || cubit.state.isOverLimit) {
      if (!mounted) return;
      await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FluidLimitWarningPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppPageHeader(title: 'إضافة سوائل'),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(label: 'نوع المشروب', hint: 'مثال: قهوة، حساء...', controller: _labelController, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.lg),
          Text('الكمية (مل)', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              for (final amount in _presetAmounts) ...[
                Expanded(
                  child: SelectableChip(
                    label: '$amount',
                    selected: _selectedAmount == amount,
                    onTap: () => setState(() {
                      _selectedAmount = amount;
                      _customController.clear();
                    }),
                  ),
                ),
                if (amount != _presetAmounts.last) const SizedBox(width: AppSpacing.xs),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            hint: 'أو أدخلي كمية مخصصة',
            controller: _customController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.right,
            onChanged: (v) => setState(() => _selectedAmount = null),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(label: 'إضافة', onPressed: (_amount ?? 0) > 0 ? _submit : null),
        ],
      ),
    );
  }
}
