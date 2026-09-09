import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubit/assistance_cubit.dart';
import 'my_requests_page.dart';

class RequestSentPage extends StatelessWidget {
  const RequestSentPage({super.key, required this.requestId});

  final String requestId;

  @override
  Widget build(BuildContext context) {
    final request = context.read<AssistanceCubit>().byId(requestId);
    if (request == null) return const SizedBox.shrink();

    return Scaffold(
      body: AppResultView(
        title: 'تم إرسال طلبك بنجاح',
        description: 'لقد تم إشعار الجهة المناسبة ستتواصل معك قريبا',
        summary: AppCard(
          child: Column(
            children: [
              Row(
                children: [
                  const AppIconBadge(icon: Icons.local_hospital_outlined),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('الجهة التي تم التواصل معها', style: AppTextStyles.caption),
                        Text(request.targetName, style: AppTextStyles.titleSmall),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: AppSpacing.lg),
              Row(
                children: [
                  Icon(Icons.phone_outlined, color: AppColors.primary, size: 18),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('طريقة التواصل', style: AppTextStyles.caption),
                        Text(request.contactMethod, style: AppTextStyles.titleSmall),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        primaryLabel: 'العودة للرئيسية',
        onPrimary: () => Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.mainShell, (route) => false),
        secondaryLabel: 'عرض طلباتي',
        onSecondary: () => Navigator.of(context)
            .pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const MyRequestsPage()), (route) => route.isFirst),
      ),
    );
  }
}
