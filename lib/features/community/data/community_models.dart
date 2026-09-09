import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CommunityCategory extends Equatable {
  const CommunityCategory({required this.id, required this.name, required this.icon, required this.postCount});

  final String id;
  final String name;
  final IconData icon;
  final int postCount;

  @override
  List<Object?> get props => [id, name, icon, postCount];
}

class CommunityComment extends Equatable {
  const CommunityComment({required this.id, required this.authorAlias, required this.text});

  final String id;
  final String authorAlias;
  final String text;

  @override
  List<Object?> get props => [id, authorAlias, text];
}

class CommunityPost extends Equatable {
  const CommunityPost({
    required this.id,
    required this.categoryId,
    required this.authorAlias,
    required this.avatarEmoji,
    required this.timeLabel,
    required this.text,
    required this.likeCount,
    required this.comments,
    this.isMine = false,
  });

  final String id;
  final String categoryId;
  final String authorAlias;
  final String avatarEmoji;
  final String timeLabel;
  final String text;
  final int likeCount;
  final List<CommunityComment> comments;
  final bool isMine;

  @override
  List<Object?> get props => [id, categoryId, authorAlias, avatarEmoji, timeLabel, text, likeCount, comments, isMine];
}
