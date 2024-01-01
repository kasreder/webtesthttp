// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CommentP.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentP _$CommentPFromJson(Map<String, dynamic> json) => CommentP(
      comment_content: json['comment_content'] as String,
      comment_id: json['comment_id'] as int,
      comment_author_nickname: json['comment_author_nickname'] as String,
      comment_created_at: json['comment_created_at'] as String,
    );

Map<String, dynamic> _$CommentPToJson(CommentP instance) => <String, dynamic>{
      'comment_content': instance.comment_content,
      'comment_created_at': instance.comment_created_at,
      'comment_author_nickname': instance.comment_author_nickname,
      'comment_id': instance.comment_id,
    };
