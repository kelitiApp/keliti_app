import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubit/community_cubit.dart';
import 'create_post_page.dart';
import 'post_detail_page.dart';

class CategoryFeedPage extends StatelessWidget {
  const CategoryFeedPage({super.key, required this.categoryId});

  final String categoryId;

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CommunityCubit>();
    final category = cubit.state.categories.firstWhere((c) => c.id == categoryId);
    final posts = cubit.postsForCategory(categoryId);

    return AppScaffold(
      scrollable: false,
      bottomBar: SizedBox(
        width: 56,
        height: 56,
        child: FloatingActionButton(
          backgroundColor: AppColors.primary,
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => CreatePostPage(initialCategoryId: categoryId))),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.md),
          AppPageHeader(title: category.name),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: posts.isEmpty
                ? const AppEmptyState(icon: Icons.forum_outlined, title: 'لا توجد منشورات هون بعد', description: 'كوني أول من يشارك بهذا القسم.')
                : ListView.separated(
                    padding: const EdgeInsets.only(bottom: 90),
                    itemCount: posts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return AppCard(
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PostDetailPage(postId: post.id))),
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
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
