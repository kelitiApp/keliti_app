import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/session/patient_profile.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubit/family_cubit.dart';

class FamilyContactEditPage extends StatefulWidget {
  const FamilyContactEditPage({super.key, required this.contact});

  final FamilyContact contact;

  @override
  State<FamilyContactEditPage> createState() => _FamilyContactEditPageState();
}

class _FamilyContactEditPageState extends State<FamilyContactEditPage> {
  late bool _fullAccess = widget.contact.fullAccess;

  Future<void> _remove() async {
    final result = await showAppConfirmSheet(
      context,
      icon: Icons.person_off_outlined,
      title: 'إزالة ${widget.contact.name}؟',
      description: 'سوف تتوقف عنها كل التنبيهات والوصول لحالتك الصحية فوراً.',
      confirmLabel: 'نعم، إزالة',
    );
    if (result == 'confirm' && mounted) {
      context.read<FamilyCubit>().remove(widget.contact.id);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.md),
          AppPageHeader(title: widget.contact.name),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                    widget.contact.name.substring(0, 1),
                    style: AppTextStyles.headlineSmall.copyWith(color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '${widget.contact.relation} — ${widget.contact.phone}',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('مستوى الصلاحية', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            child: Row(
              children: [
                Radio<bool>(value: true, groupValue: _fullAccess, activeColor: AppColors.primary, onChanged: (_) => setState(() => _fullAccess = true)),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('عرض ومتابعة دائماً', textAlign: TextAlign.right, style: AppTextStyles.titleSmall),
                      Text('يرى الحالة والتقارير ويستقبل تنبيهات', textAlign: TextAlign.right, style: AppTextStyles.caption),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            child: Row(
              children: [
                Radio<bool>(value: false, groupValue: _fullAccess, activeColor: AppColors.primary, onChanged: (_) => setState(() => _fullAccess = false)),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('تنبيهات الطوارئ فقط', textAlign: TextAlign.right, style: AppTextStyles.titleSmall),
                      Text('يستقبل اشعارات SOS والحالات الحرجة فقط', textAlign: TextAlign.right, style: AppTextStyles.caption),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'حفظ التغييرات',
            onPressed: () {
              context.read<FamilyCubit>().updateAccess(widget.contact.id, fullAccess: _fullAccess);
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(label: 'إزالة من القائمة', variant: AppButtonVariant.outlined, onPressed: _remove),
        ],
      ),
    );
  }
}
