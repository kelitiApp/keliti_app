import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubit/assistance_cubit.dart';
import 'request_sent_page.dart';

class SendingRequestPage extends StatefulWidget {
  const SendingRequestPage({super.key, required this.symptoms, required this.severity, required this.targetName});

  final List<String> symptoms;
  final int severity;
  final String targetName;

  @override
  State<SendingRequestPage> createState() => _SendingRequestPageState();
}

class _SendingRequestPageState extends State<SendingRequestPage> {
  bool _notified = false;

  @override
  void initState() {
    super.initState();
    _send();
  }

  Future<void> _send() async {
    final cubit = context.read<AssistanceCubit>();
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _notified = true);
    final request =
        await cubit.sendRequest(symptoms: widget.symptoms, severity: widget.severity, targetName: widget.targetName);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => RequestSentPage(requestId: request.id)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.md),
              Text('جار إرسال طلبك....', style: AppTextStyles.headlineSmall),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                      child: const Icon(Icons.send_rounded, color: AppColors.primary, size: 36),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'يرجى الانتظار بينما نبلغ الجهة المناسبة',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    AppCard(
                      child: Column(
                        children: [
                          _StepRow(label: 'تم استلام طلبك', done: true),
                          const SizedBox(height: AppSpacing.sm),
                          _StepRow(label: 'جار اشعار الجهة المناسبة', done: _notified, loading: !_notified),
                          const SizedBox(height: AppSpacing.sm),
                          const _StepRow(label: 'سيتم التواصل معك قريبا', done: false),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              AppButton(
                label: 'اتصال بالطوارئ',
                variant: AppButtonVariant.destructive,
                icon: Icons.phone_in_talk_rounded,
                onPressed: () {},
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.label, required this.done, this.loading = false});

  final String label;
  final bool done;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (loading)
          const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
        else
          Icon(
            done ? Icons.check_circle : Icons.radio_button_unchecked,
            color: done ? AppColors.primary : AppColors.textTertiary,
            size: 20,
          ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Text(label, textAlign: TextAlign.right, style: AppTextStyles.bodyMedium)),
      ],
    );
  }
}
