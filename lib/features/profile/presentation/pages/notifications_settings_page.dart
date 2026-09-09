import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

const _reminderDelayOptions = [15, 10, 5];

class NotificationsSettingsPage extends StatefulWidget {
  const NotificationsSettingsPage({super.key});

  @override
  State<NotificationsSettingsPage> createState() => _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {
  bool _dosesEnabled = true;
  bool _sound = true;
  bool _vibration = false;
  int _reminderDelay = 10;
  bool _doubleMissAlert = true;

  bool _sessionReminders = true;
  bool _medicationReminders = true;
  bool _doctorNotifications = false;
  bool _generalUpdates = false;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppPageHeader(title: 'إعدادات التذكيرات'),
          const SizedBox(height: AppSpacing.lg),
          Text('عامة', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            child: Column(
              children: [
                AppToggleTile(title: 'تفعيل تذكيرات الجرعات', value: _dosesEnabled, onChanged: (v) => setState(() => _dosesEnabled = v)),
                const Divider(height: AppSpacing.lg),
                AppToggleTile(title: 'صوت التنبيه', value: _sound, onChanged: (v) => setState(() => _sound = v)),
                const Divider(height: AppSpacing.lg),
                AppToggleTile(title: 'الاهتزاز', value: _vibration, onChanged: (v) => setState(() => _vibration = v)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('عند عدم الاستجابة', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('إعادة التذكير كل', style: AppTextStyles.bodyMedium),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    for (final m in _reminderDelayOptions) ...[
                      Expanded(child: SelectableChip(label: '$m\nدقائق', selected: _reminderDelay == m, onTap: () => setState(() => _reminderDelay = m))),
                      if (m != _reminderDelayOptions.last) const SizedBox(width: AppSpacing.xs),
                    ],
                  ],
                ),
                const Divider(height: AppSpacing.xl),
                AppToggleTile(
                  title: 'تنبيه العائلة بعد تجاهل مزدوج',
                  description: 'لو تجاهلت نفس الجرعة مرتين متتاليين، بنوصل رسالة إلى جهة الاتصال المرتبطة بحسابك.',
                  value: _doubleMissAlert,
                  onChanged: (v) => setState(() => _doubleMissAlert = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('تنبيهاتك المهمة', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            child: Column(
              children: [
                AppToggleTile(title: 'تذكير بمواعيد الجلسات', description: 'قبل الجلسة بساعة', value: _sessionReminders, onChanged: (v) => setState(() => _sessionReminders = v)),
                const Divider(height: AppSpacing.lg),
                AppToggleTile(title: 'تذكير بمواعيد الأدوية', description: 'يوميا حسب الجدول', value: _medicationReminders, onChanged: (v) => setState(() => _medicationReminders = v)),
                const Divider(height: AppSpacing.lg),
                AppToggleTile(title: 'تنبيهات من الطبيب', description: 'ملاحظات ونتائج الفحوصات', value: _doctorNotifications, onChanged: (v) => setState(() => _doctorNotifications = v)),
                const Divider(height: AppSpacing.lg),
                AppToggleTile(title: 'تحديثات عامة من كليتي', description: 'أخبار ونصائح صحية', value: _generalUpdates, onChanged: (v) => setState(() => _generalUpdates = v)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(label: 'حفظ والانتقال للرئيسية', onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }
}
