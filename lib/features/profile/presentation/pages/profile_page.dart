import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/routes.dart';
import '../../../../core/session/patient_cubit.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../community/presentation/pages/community_hub_page.dart';
import '../../../family/presentation/pages/family_contacts_page.dart';
import '../../../fluids/presentation/pages/fluids_today_page.dart';
import '../../../food_assistant/presentation/pages/food_assistant_home_page.dart';
import 'delete_account_page.dart';
import 'doctor_center_page.dart';
import 'help_support_page.dart';
import 'language_page.dart';
import 'medical_card_page.dart';
import 'notifications_settings_page.dart';
import 'personal_info_page.dart';
import 'rate_app_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final patient = context.watch<PatientCubit>().state;

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTopBar(title: 'الملف الشخصي', onNotificationsTap: () => Navigator.of(context).pushNamed(AppRoutes.notifications)),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: Row(
              children: [
                const Icon(Icons.chevron_left, color: AppColors.textTertiary),
                const Spacer(),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(patient.fullName, style: AppTextStyles.titleMedium),
                      const SizedBox(height: 2),
                      Text('مريض غسيل كلي . العضو منذ يناير 2025', style: AppTextStyles.caption),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.primaryLight,
                  child: Text(patient.fullName.substring(0, 1), style: AppTextStyles.titleLarge.copyWith(color: AppColors.primary)),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _SectionLabel('الحساب'),
          _MenuTile(icon: Icons.call, label: 'بطاقتي الطبية الطارئة', destructive: true, onTap: () => _push(context, const MedicalCardPage())),
          _MenuTile(icon: Icons.water_drop_outlined, label: 'تتبع السوائل', onTap: () => _push(context, const FluidsTodayPage())),
          _MenuTile(icon: Icons.auto_awesome_outlined, label: 'المساعد الغذائي الذكي', onTap: () => _push(context, const FoodAssistantHomePage())),
          _MenuTile(icon: Icons.favorite_border_rounded, label: 'مجتمع الدعم', onTap: () => _push(context, const CommunityHubPage())),
          _MenuTile(icon: Icons.person_outline_rounded, label: 'المعلومات الشخصية', onTap: () => _push(context, const PersonalInfoPage())),
          _MenuTile(icon: Icons.people_alt_outlined, label: 'جهات اتصال العائلة', onTap: () => _push(context, const FamilyContactsPage())),
          _MenuTile(icon: Icons.water_drop_outlined, label: 'الطبيب ومركز الغسيل', onTap: () => _push(context, const DoctorCenterPage())),
          const SizedBox(height: AppSpacing.lg),
          _SectionLabel('التطبيق'),
          _MenuTile(icon: Icons.notifications_none_rounded, label: 'الإشعارات والتذكيرات', onTap: () => _push(context, const NotificationsSettingsPage())),
          _MenuTile(icon: Icons.language_rounded, label: 'اللغة', trailingText: 'العربية', onTap: () => _push(context, const LanguagePage())),
          _MenuTile(icon: Icons.history_rounded, label: 'قيّم تجربتك معنا', onTap: () => _push(context, const RateAppPage())),
          _MenuTile(icon: Icons.help_outline_rounded, label: 'المساعدة والدعم', onTap: () => _push(context, const HelpSupportPage())),
          const SizedBox(height: AppSpacing.lg),
          _SectionLabel('قانوني'),
          _MenuTile(icon: Icons.description_outlined, label: 'سياسة الخصوصية والشروط', onTap: () {}),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'تسجيل الخروج',
            variant: AppButtonVariant.destructive,
            onPressed: () async {
              final result = await showAppConfirmSheet(
                context,
                icon: Icons.logout_rounded,
                title: 'تسجيل الخروج؟',
                description: 'سوف تحتاج تسجل دخول مرة ثانية للوصول لحسابك.',
                confirmLabel: 'تسجيل الخروج',
              );
              if (result == 'confirm' && context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
              }
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: TextButton(
              onPressed: () => _push(context, const DeleteAccountPage()),
              child: Text('حذف الحساب نهائياً', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error)),
            ),
          ),
        ],
      ),
    );
  }

  void _push(BuildContext context, Widget page) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Text(label, textAlign: TextAlign.right, style: AppTextStyles.overline),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.icon, required this.label, required this.onTap, this.destructive = false, this.trailingText});

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;
  final String? trailingText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        onTap: onTap,
        borderColor: destructive ? AppColors.error : AppColors.border,
        child: Row(
          children: [
            const Icon(Icons.chevron_left, color: AppColors.textTertiary, size: 18),
            const Spacer(),
            if (trailingText != null) ...[
              Text(trailingText!, style: AppTextStyles.caption),
              const SizedBox(width: AppSpacing.xs),
            ],
            Text(label, style: AppTextStyles.bodyLarge.copyWith(color: destructive ? AppColors.error : AppColors.textPrimary)),
            const SizedBox(width: AppSpacing.sm),
            Icon(icon, color: destructive ? AppColors.error : AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}
