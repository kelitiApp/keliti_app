import 'package:flutter/material.dart';

import '../../../../core/session/patient_profile.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import 'sending_request_page.dart';

/// "جهة التواصل المناسبة" — shared confirm-and-send step for every
/// assistance option (symptom report, general inquiry, contact doctor,
/// medication question, session issue, request a family member).
class ConfirmContactPage extends StatefulWidget {
  const ConfirmContactPage({super.key, required this.requestTitle, this.symptoms = const [], this.severity});

  final String requestTitle;
  final List<String> symptoms;
  final int? severity;

  @override
  State<ConfirmContactPage> createState() => _ConfirmContactPageState();
}

class _ConfirmContactPageState extends State<ConfirmContactPage> {
  String _contactMethod = 'اتصال هاتفي';
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const center = DialysisCenterInfo(id: 'c1', name: 'مركز الأمل لغسيل الكلى', subtitle: 'المركز الرئيسي');

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppPageHeader(title: 'جهة التواصل المناسبة'),
          Text('سيتم اشعار الجهة التالية فورا', textAlign: TextAlign.right, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    const AppIconBadge(icon: Icons.local_hospital_outlined),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(center.name, style: AppTextStyles.titleSmall),
                          Text(center.subtitle, style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _ContactMethodIcon(icon: Icons.phone_outlined, label: 'اتصال هاتفي', selected: _contactMethod == 'اتصال هاتفي', onTap: () => setState(() => _contactMethod = 'اتصال هاتفي')),
                    _ContactMethodIcon(icon: Icons.sms_outlined, label: 'رسالة نصية', selected: _contactMethod == 'رسالة نصية', onTap: () => setState(() => _contactMethod = 'رسالة نصية')),
                    _ContactMethodIcon(icon: Icons.notifications_active_outlined, label: 'إشعار في التطبيق', selected: _contactMethod == 'إشعار في التطبيق', onTap: () => setState(() => _contactMethod = 'إشعار في التطبيق')),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('يمكنك إضافة ملاحظات (اختياري)', textAlign: TextAlign.right, style: AppTextStyles.titleSmall),
          const SizedBox(height: AppSpacing.xs),
          AppTextField(hint: 'اكتب ملاحظاتك هنا..', controller: _notesController, maxLines: 3, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'إرسال الطلب',
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => SendingRequestPage(
                  symptoms: widget.symptoms.isEmpty ? [widget.requestTitle] : widget.symptoms,
                  severity: widget.severity ?? 1,
                  targetName: center.name,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactMethodIcon extends StatelessWidget {
  const _ContactMethodIcon({required this.icon, required this.label, required this.selected, required this.onTap});

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : AppColors.surfaceAlt,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: selected ? Colors.white : AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
