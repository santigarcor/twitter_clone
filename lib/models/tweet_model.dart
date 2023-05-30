// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import 'package:twitter_clone/enums/tweet_type.dart';

class TweetModel {
  final String text;
  final List<String> hashTags;
  final List<String> links;
  final List<String> imageLinks;
  final TweetType tweetType;
  final DateTime createdAt;
  final List<String> likes;
  final List<String> commentIds;
  final String uid;
  final String id;
  final int shareCount;

  TweetModel({
    required this.text,
    required this.hashTags,
    required this.links,
    required this.imageLinks,
    required this.tweetType,
    required this.createdAt,
    required this.likes,
    required this.commentIds,
    required this.id,
    required this.uid,
    required this.shareCount,
  });

  TweetModel copyWith({
    String? text,
    List<String>? hashTags,
    List<String>? links,
    List<String>? imageLinks,
    TweetType? tweetType,
    DateTime? createdAt,
    List<String>? likes,
    List<String>? commentIds,
    String? id,
    String? uid,
    int? shareCount,
  }) {
    return TweetModel(
      text: text ?? this.text,
      hashTags: hashTags ?? this.hashTags,
      links: links ?? this.links,
      imageLinks: imageLinks ?? this.imageLinks,
      tweetType: tweetType ?? this.tweetType,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      commentIds: commentIds ?? this.commentIds,
      id: id ?? this.id,
      uid: uid ?? this.uid,
      shareCount: shareCount ?? this.shareCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'hashTags': hashTags,
      'links': links,
      'imageLinks': imageLinks,
      'tweetType': tweetType.type,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'likes': likes,
      'commentIds': commentIds,
      'shareCount': shareCount,
      'uid': uid,
    };
  }

  factory TweetModel.fromMap(Map<String, dynamic> map) {
    return TweetModel(
      text: map['text'] as String,
      hashTags: List<String>.from(map['hashTags'] as List<String>),
      links: List<String>.from(map['links'] as List<String>),
      imageLinks: List<String>.from(map['imageLinks'] as List<String>),
      tweetType: TweetType.fromString(map['tweetType']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      likes: List<String>.from(map['likes'] as List<String>),
      commentIds: List<String>.from(map['commentIds'] as List<String>),
      id: map['\$id'] ?? '',
      uid: map['uid'] as String,
      shareCount: map['shareCount'] as int,
    );
  }

  @override
  String toString() {
    return 'Tweet(text: $text, hashTags: $hashTags, links: $links, imageLinks: $imageLinks, tweetType: $tweetType, createdAt: $createdAt, likes: $likes, commentIds: $commentIds, id: $id, uid: $uid, shareCount: $shareCount)';
  }

  @override
  bool operator ==(covariant TweetModel other) {
    if (identical(this, other)) return true;

    return other.text == text &&
        listEquals(other.hashTags, hashTags) &&
        listEquals(other.links, links) &&
        listEquals(other.imageLinks, imageLinks) &&
        other.tweetType == tweetType &&
        other.createdAt == createdAt &&
        listEquals(other.likes, likes) &&
        listEquals(other.commentIds, commentIds) &&
        other.id == id &&
        other.uid == uid &&
        other.shareCount == shareCount;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        hashTags.hashCode ^
        links.hashCode ^
        imageLinks.hashCode ^
        tweetType.hashCode ^
        createdAt.hashCode ^
        likes.hashCode ^
        commentIds.hashCode ^
        uid.hashCode ^
        id.hashCode ^
        shareCount.hashCode;
  }
}
