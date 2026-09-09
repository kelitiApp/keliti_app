import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubit/community_cubit.dart';
import 'report_content_page.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({super.key, required this.postId});

  final String postId;

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _handleMenu(String action, String postId) async {
    if (action == 'report') {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => ReportContentPage(postId: postId)));
      return;
    }
    if (action == 'delete') {
      final result = await showAppConfirmSheet(
        context,
        icon: Icons.delete_outline_rounded,
        title: 'حذف هذا المنشور؟',
        description: 'كل التعليقات المرتبطة فيه بتنحذف كمان، وهاد الإجراء ما فيه رجعة.',
        confirmLabel: 'نعم، حذف',
      );
      if (result == 'confirm' && mounted) {
        context.read<CommunityCubit>().deletePost(postId);
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final post = context.watch<CommunityCubit>().byId(widget.postId);
    if (post == null) return const SizedBox.shrink();

    return AppScaffold(
      scrollable: false,
      bottomBar: SafeArea(
        top: false,
        child: Row(
          children: [
            IconButton(
              onPressed: _commentController.text.trim().isEmpty
                  ? null
                  : () {
                      context.read<CommunityCubit>().addComment(post.id, _commentController.text);
                      _commentController.clear();
                      setState(() {});
                    },
              icon: const Icon(Icons.send_rounded, color: AppColors.primary),
            ),
            Expanded(
              child: AppTextField(hint: 'أضيفي كلمة دعم...', controller: _commentController, textAlign: TextAlign.right, onChanged: (_) => setState(() {})),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: AppColors.textTertiary),
                onSelected: (action) => _handleMenu(action, post.id),
                itemBuilder: (context) => [
                  if (post.isMine)
                    const PopupMenuItem(value: 'delete', child: Text('حذف المنشور', style: TextStyle(color: AppColors.error)))
                  else
                    const PopupMenuItem(value: 'report', child: Text('الإبلاغ عن هذا المحتوى')),
                ],
              ),
              const Spacer(),
              Text('المنشور', style: AppTextStyles.headlineSmall),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: ListView(
              children: [
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(radius: 16, backgroundColor: AppColors.accentPinkLight, child: Text(post.avatarEmoji, style: const TextStyle(fontSize: 14))),
                          const SizedBox(width: AppSpacing.xs),
                          Text(post.timeLabel, style: AppTextStyles.caption),
                          const Spacer(),
                          Text(post.authorAlias, style: AppTextStyles.titleSmall),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(post.text, textAlign: TextAlign.right, style: AppTextStyles.bodyMedium),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Text('${post.comments.length}', style: AppTextStyles.caption),
                          const Icon(Icons.mode_comment_outlined, size: 14, color: AppColors.textTertiary),
                          const SizedBox(width: AppSpacing.sm),
                          Text('${post.likeCount}', style: AppTextStyles.caption),
                          const Icon(Icons.favorite_border_rounded, size: 14, color: AppColors.error),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('التعليقات', style: AppTextStyles.titleMedium, textAlign: TextAlign.right),
                const SizedBox(height: AppSpacing.sm),
                for (final comment in post.comments) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: AppRadius.radiusMd),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(comment.authorAlias, style: AppTextStyles.titleSmall.copyWith(color: AppColors.primary)),
                        const SizedBox(height: 2),
                        Text(comment.text, textAlign: TextAlign.right, style: AppTextStyles.bodyMedium),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
