import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubit/family_cubit.dart';
import 'family_contact_edit_page.dart';
import 'invite_family_member_page.dart';

class FamilyContactsPage extends StatelessWidget {
  const FamilyContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      scrollable: false,
      bottomBar: SizedBox(
        width: 56,
        height: 56,
        child: FloatingActionButton(
          backgroundColor: AppColors.primary,
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const InviteFamilyMemberPage()),
          ),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.md),
          const AppPageHeader(title: 'جهات اتصال العائلة'),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: BlocBuilder<FamilyCubit, FamilyState>(
              builder: (context, state) {
                if (state.contacts.isEmpty) {
                  return const AppEmptyState(
                    icon: Icons.people_outline_rounded,
                    title: 'لا يوجد أفراد عائلة بعد',
                    description: 'ادعُ أحد أفراد أسرتك لمتابعة حالتك الصحية.',
                  );
                }
                return ListView.separated(
                  itemCount: state.contacts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final contact = state.contacts[index];
                    return AppCard(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => FamilyContactEditPage(contact: contact)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.chevron_left, color: AppColors.textTertiary),
                          const Spacer(),
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('${contact.name} — ${contact.relation}', style: AppTextStyles.titleSmall),
                                const SizedBox(height: 6),
                                contact.pending
                                    ? const StatusChip(label: 'بانتظار قبول الدعوة', tone: StatusTone.neutral)
                                    : StatusChip(
                                        label: contact.fullAccess ? 'عرض ومتابعة دائماً' : 'تنبيهات الطوارئ فقط',
                                        tone: contact.fullAccess ? StatusTone.primary : StatusTone.warning,
                                      ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: AppColors.primaryLight,
                            child: Text(
                              contact.name.substring(0, 1),
                              style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
