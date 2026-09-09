import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubit/family_cubit.dart';

const _relations = ['زوج / زوجة', 'ابن / ابنة', 'أخ / أخت', 'أخرى'];

/// Used both from onboarding (post doctor-selection step) and from
/// Profile → "جهات اتصال العائلة" → add.
class InviteFamilyMemberPage extends StatefulWidget {
  const InviteFamilyMemberPage({super.key, this.isOnboardingStep = false});

  final bool isOnboardingStep;

  @override
  State<InviteFamilyMemberPage> createState() => _InviteFamilyMemberPageState();
}

class _InviteFamilyMemberPageState extends State<InviteFamilyMemberPage> {
  final _phoneController = TextEditingController();
  String _relation = 'أخ / أخت';
  bool _fullAccess = true;
  bool _sending = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    setState(() => _sending = true);
    final contact = await context.read<FamilyCubit>().invite(
          phone: _phoneController.text,
          relation: _relation,
          fullAccess: _fullAccess,
        );
    if (!mounted) return;
    setState(() => _sending = false);

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: AppResultView(
            title: 'تم إرسال الدعوة بنجاح',
            description: 'بانتظار قبول ${contact.relation} للدعوة',
            primaryLabel: 'متابعة',
            onPrimary: () {
              Navigator.of(dialogContext).pop();
              if (widget.isOnboardingStep) {
                Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.onboardingComplete, (route) => false);
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
      ),
    );
  }

  void _skip() {
    if (widget.isOnboardingStep) {
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.onboardingComplete, (route) => false);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppPageHeader(
            title: 'دعوة أحد أفراد أسرتك',
            stepProgress: widget.isOnboardingStep ? const [false, false, false, false, true] : null,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('ادخل رقم جوال قريبك', textAlign: TextAlign.right, style: AppTextStyles.titleSmall),
          const SizedBox(height: AppSpacing.xs),
          AppTextField(hint: '05xxxxxxxx', controller: _phoneController, keyboardType: TextInputType.phone, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.lg),
          Text('صلة القرابة', textAlign: TextAlign.right, style: AppTextStyles.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final relation in _relations)
                SelectableChip(
                  label: relation,
                  selected: _relation == relation,
                  onTap: () => setState(() => _relation = relation),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('مستوى الصلاحية', textAlign: TextAlign.right, style: AppTextStyles.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          _PermissionOption(
            title: 'عرض ومتابعة دائماً',
            description: 'يرى الحالة والتقارير ويستقبل تنبيهات',
            selected: _fullAccess,
            onTap: () => setState(() => _fullAccess = true),
          ),
          const SizedBox(height: AppSpacing.sm),
          _PermissionOption(
            title: 'تنبيهات الطوارئ فقط',
            description: 'يستقبل اشعارات SOS والحالات الحرجة فقط',
            selected: !_fullAccess,
            onTap: () => setState(() => _fullAccess = false),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'إرسال دعوة',
            isLoading: _sending,
            onPressed: _phoneController.text.trim().isEmpty || _sending ? null : _send,
          ),
          if (widget.isOnboardingStep) ...[
            const SizedBox(height: AppSpacing.sm),
            AppButton(label: 'تخطي', variant: AppButtonVariant.text, onPressed: _skip),
          ],
        ],
      ),
    );
  }
}

class _PermissionOption extends StatelessWidget {
  const _PermissionOption({
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      borderColor: selected ? AppColors.primary : AppColors.border,
      child: Row(
        children: [
          Radio<bool>(value: true, groupValue: selected, onChanged: (_) => onTap(), activeColor: AppColors.primary),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(title, textAlign: TextAlign.right, style: AppTextStyles.titleSmall),
                const SizedBox(height: 2),
                Text(description, textAlign: TextAlign.right, style: AppTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
