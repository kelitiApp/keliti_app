import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/assistance_request.dart';
import '../cubit/assistance_cubit.dart';
import 'confirm_contact_page.dart';
import 'my_requests_page.dart';
import 'request_detail_page.dart';
import 'symptom_report_page.dart';

class _HubOption {
  const _HubOption(this.icon, this.label);
  final IconData icon;
  final String label;
}

const _options = [
  _HubOption(Icons.error_outline_rounded, 'مشكلة في الجلسة'),
  _HubOption(Icons.sick_outlined, 'اشعر بالتعب'),
  _HubOption(Icons.medical_services_outlined, 'تواصل مع طبيب'),
  _HubOption(Icons.medication_outlined, 'استفسار عن دواء'),
  _HubOption(Icons.chat_bubble_outline_rounded, 'استفسار عام'),
  _HubOption(Icons.group_outlined, 'طلب أحد أفراد العائلة'),
];

class AssistanceHubPage extends StatelessWidget {
  const AssistanceHubPage({super.key});

  void _openOption(BuildContext context, String label) {
    if (label == 'اشعر بالتعب') {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SymptomReportPage()));
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => ConfirmContactPage(requestTitle: label)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final requests = context.watch<AssistanceCubit>().state.requests;

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                  child: const Icon(Icons.favorite_border_rounded, color: AppColors.primary, size: 32),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text('نحن هنا لمساعدتك', style: AppTextStyles.titleLarge),
                const SizedBox(height: 4),
                Text(
                  'اختر ما يناسب حالتك الآن وسنوجهك لجهة التواصل المناسبة',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _options.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
              childAspectRatio: 1.5,
            ),
            itemBuilder: (context, index) {
              final option = _options[index];
              return AppCard(
                onTap: () => _openOption(context, option.label),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(option.icon, color: AppColors.primary, size: 26),
                    const SizedBox(height: 8),
                    Text(option.label, textAlign: TextAlign.center, style: AppTextStyles.bodySmall),
                  ],
                ),
              );
            },
          ),
          if (requests.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MyRequestsPage())),
                  child: const Text('عرض الكل'),
                ),
                const Spacer(),
                Text('طلباتك الاخيرة', style: AppTextStyles.titleMedium),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            for (final r in requests.take(2)) ...[
              AppCard(
                onTap: () =>
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => RequestDetailPage(requestId: r.id))),
                child: Row(
                  children: [
                    StatusChip(
                      label: r.status == RequestStatus.sent ? 'قيد المتابعة' : 'تم الرد',
                      tone: r.status == RequestStatus.sent ? StatusTone.warning : StatusTone.primary,
                    ),
                    const Spacer(),
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(r.symptoms.join('، '), style: AppTextStyles.titleSmall),
                          Text('${r.dateLabel}، ${r.timeLabel}', style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ],
        ],
      ),
    );
  }
}
