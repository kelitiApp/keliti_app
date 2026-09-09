import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubit/community_cubit.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key, required this.initialCategoryId});

  final String initialCategoryId;

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  late String _categoryId = widget.initialCategoryId;
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CommunityCubit>().state;

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppPageHeader(title: 'منشور جديد'),
          const SizedBox(height: AppSpacing.lg),
          Text('الفئة', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final c in state.categories)
                SelectableChip(label: c.name, icon: c.icon, selected: _categoryId == c.id, onTap: () => setState(() => _categoryId = c.id)),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('شاركي ما بخاطرك', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            hint: 'اكتبي بحرية... أنت بمساحة آمنة',
            controller: _textController,
            maxLines: 6,
            textAlign: TextAlign.right,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: AppRadius.radiusMd),
            child: Text(
              'هينشر باسم "${state.alias}" — بدون بياناتك الحقيقية',
              textAlign: TextAlign.right,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryDark),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'نشر',
            onPressed: _textController.text.trim().isEmpty
                ? null
                : () {
                    context.read<CommunityCubit>().addPost(categoryId: _categoryId, text: _textController.text);
                    showDialog<void>(
                      context: context,
                      builder: (dialogContext) => Dialog(
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusLg),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: AppResultView(
                            title: 'تم نشر كلامك',
                            description: 'مجتمعك هلق بيقدر يشاركك ويدعمك، خذي وقتك بالرد على التعليقات.',
                            primaryLabel: 'عرض منشوري',
                            onPrimary: () => Navigator.of(dialogContext)
                              ..pop()
                              ..pop(),
                            secondaryLabel: 'العودة للمجتمع',
                            onSecondary: () => Navigator.of(dialogContext)
                              ..pop()
                              ..pop(),
                          ),
                        ),
                      ),
                    );
                  },
          ),
        ],
      ),
    );
  }
}
