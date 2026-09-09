import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/community_models.dart';

const _avatarEmojis = ['🌸', '🌤️', '🌿', '🌻', '🌙'];

class CommunityState {
  const CommunityState({
    required this.categories,
    required this.posts,
    this.joined = false,
    this.alias = 'ورقة الزيتون',
    this.avatarEmoji = '🌸',
  });

  final List<CommunityCategory> categories;
  final List<CommunityPost> posts;
  final bool joined;
  final String alias;
  final String avatarEmoji;

  static CommunityState seed() => CommunityState(
        categories: const [
          CommunityCategory(id: 'support', name: 'دعم نفسي', icon: Icons.chat_bubble_outline_rounded, postCount: 34),
          CommunityCategory(id: 'food', name: 'نصائح غذائية', icon: Icons.restaurant_outlined, postCount: 21),
          CommunityCategory(id: 'dialysis', name: 'تجارب الغسيل', icon: Icons.water_drop_outlined, postCount: 18),
          CommunityCategory(id: 'hope', name: 'قصص أمل', icon: Icons.eco_outlined, postCount: 12),
          CommunityCategory(id: 'beginners', name: 'أسئلة للمبتدئين', icon: Icons.help_outline_rounded, postCount: 9),
        ],
        posts: const [
          CommunityPost(
            id: 'p1',
            categoryId: 'support',
            authorAlias: 'قوس الأمل',
            avatarEmoji: '🌤️',
            timeLabel: 'قبل 3 ساعات',
            text: 'حسيت اليوم بتعب نفسي أكثر من العادة قبل الجلسة... أي واحد فيكم يمر بنفس الشي؟',
            likeCount: 14,
            comments: [
              CommunityComment(id: 'c1', authorAlias: 'ورقة الزيتون', text: 'هاي حسة طبيعية كتير، أنا بمر فيها خصوصاً قبل جلسات الشتاء. خذي وقتك ❤️'),
              CommunityComment(id: 'c2', authorAlias: 'نجمة الصبر', text: 'جربي تسمعي شي هادي بالطريق للمركز، ساعدني كتير.'),
            ],
          ),
          CommunityPost(
            id: 'p2',
            categoryId: 'support',
            authorAlias: 'ورقة الزيتون',
            avatarEmoji: '🌸',
            timeLabel: 'أمس',
            text: 'أول مرة أحاول أتقبل الوضع، حابة أسمع كيف تعاملتوا معه بالأول.',
            likeCount: 22,
            comments: [
              CommunityComment(id: 'c3', authorAlias: 'قوس الأمل', text: 'الوقت بساعد كتير، ومجتمعنا هون معاك بكل خطوة 🌱'),
            ],
            isMine: true,
          ),
        ],
      );

  CommunityState copyWith({List<CommunityPost>? posts, bool? joined, String? alias, String? avatarEmoji}) {
    return CommunityState(
      categories: categories,
      posts: posts ?? this.posts,
      joined: joined ?? this.joined,
      alias: alias ?? this.alias,
      avatarEmoji: avatarEmoji ?? this.avatarEmoji,
    );
  }
}

class CommunityCubit extends Cubit<CommunityState> {
  CommunityCubit() : super(CommunityState.seed());

  static const avatarOptions = _avatarEmojis;

  void setIdentity({required String alias, required String avatarEmoji}) {
    emit(state.copyWith(alias: alias, avatarEmoji: avatarEmoji, joined: true));
  }

  void addPost({required String categoryId, required String text}) {
    final post = CommunityPost(
      id: 'p${state.posts.length + 1}',
      categoryId: categoryId,
      authorAlias: state.alias,
      avatarEmoji: state.avatarEmoji,
      timeLabel: 'الآن',
      text: text,
      likeCount: 0,
      comments: const [],
      isMine: true,
    );
    emit(state.copyWith(posts: [post, ...state.posts]));
  }

  void addComment(String postId, String text) {
    emit(state.copyWith(
      posts: [
        for (final p in state.posts)
          if (p.id == postId)
            CommunityPost(
              id: p.id,
              categoryId: p.categoryId,
              authorAlias: p.authorAlias,
              avatarEmoji: p.avatarEmoji,
              timeLabel: p.timeLabel,
              text: p.text,
              likeCount: p.likeCount,
              comments: [...p.comments, CommunityComment(id: 'c${p.comments.length + 1}', authorAlias: state.alias, text: text)],
              isMine: p.isMine,
            )
          else
            p,
      ],
    ));
  }

  void deletePost(String postId) {
    emit(state.copyWith(posts: state.posts.where((p) => p.id != postId).toList()));
  }

  void leaveCommunity() => emit(state.copyWith(joined: false));

  List<CommunityPost> postsForCategory(String categoryId) => state.posts.where((p) => p.categoryId == categoryId).toList();

  CommunityPost? byId(String id) {
    for (final p in state.posts) {
      if (p.id == id) return p;
    }
    return null;
  }
}
