import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/widgets.dart';
import '../cubit/fluids_cubit.dart';

class FluidLimitWarningPage extends StatelessWidget {
  const FluidLimitWarningPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FluidsCubit>().state;
    return Scaffold(
      body: AppResultView(
        tone: state.isOverLimit ? ResultTone.error : ResultTone.warning,
        title: state.isOverLimit ? 'تجاوزت حدك اليومي' : 'اقتربت من حدك اليومي',
        description:
            'وصلت ${state.todayTotalMl} من ${state.dailyLimitMl} مل، تجاوز الحد يزيد الضغط على جسمك بين جلسات الغسيل.',
        primaryLabel: 'فهمت، أكمل',
        onPrimary: () => Navigator.of(context).pop(),
      ),
    );
  }
}
