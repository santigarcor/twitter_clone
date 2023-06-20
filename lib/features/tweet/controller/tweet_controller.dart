import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/apis/storage_api.dart';
import 'package:twitter_clone/apis/tweet_api.dart';
import 'package:twitter_clone/enums/tweet_type.dart';
import 'package:twitter_clone/extensions/appwrite_extensions.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/models/tweet_model.dart';
import 'package:twitter_clone/models/user.dart';
import 'package:twitter_clone/utils/snackbar.dart';

final tweetControllerProvider =
    StateNotifierProvider<TweetController, bool>((ref) {
  return TweetController(ref: ref);
});

final tweetsListProvider = FutureProvider<List<TweetModel>>((ref) {
  return ref.watch(tweetControllerProvider.notifier).getTweets();
});

final getLatestTweetProvider = StreamProvider<RealtimeMessage>((ref) {
  final tweetApi = ref.watch(tweetApiProvider);
  return tweetApi.getLatestTweet();
});

class TweetController extends StateNotifier<bool> {
  final Ref _ref;

  TweetController({required ref})
      : _ref = ref,
        super(false);

  Future<List<TweetModel>> getTweets() async {
    return (await _ref.read(tweetApiProvider).getTweets())
        .map((document) => TweetModel.fromMap(document.data))
        .toList();
  }

  void createTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
  }) {
    if (text.isEmpty) {
      return showSnackBar(context, 'Please enter text');
    }

    if (images.isNotEmpty) {
      _createTweetWithImages(images, text, context);
    } else {
      _createTextTweet(text, context);
    }
    _ref.invalidate(tweetsListProvider);
    Navigator.pop(context);
  }

  _createTweetWithImages(
    List<File> images,
    String text,
    BuildContext context,
  ) async {
    state = true;
    final imageLinks = await _ref.read(storageApiProvider).uploadFiles(images);

    final tweetModel = _getBaseTweet(text, TweetType.image);
    tweetModel.imageLinks.addAll(imageLinks);

    final (:exception, :data) =
        await _ref.read(tweetApiProvider).createTweet(tweetModel);
    state = false;

    if (!mounted) return;

    if (exception.code != null || data.isEmpty) {
      showSnackBar(context, exception.toString());
    }
  }

  _createTextTweet(
    String text,
    BuildContext context,
  ) async {
    state = true;
    final tweetModel = _getBaseTweet(text, TweetType.text);

    final (:exception, :data) =
        await _ref.read(tweetApiProvider).createTweet(tweetModel);
    state = false;

    if (!mounted) return;

    if (exception.code != null || data.isEmpty) {
      showSnackBar(context, exception.toString());
    }
  }

  TweetModel _getBaseTweet(String text, TweetType type) {
    final user = _ref.read(currentUserDetailsProvider).value!;
    return TweetModel(
      text: text,
      hashTags: _getHashTagsFromText(text),
      links: _getLinkFromText(text),
      imageLinks: [],
      tweetType: type,
      createdAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      id: '',
      uid: user.uid,
      shareCount: 0,
    );
  }

  List<String> _getLinkFromText(String text) {
    return text
        .split(' ')
        .filter(
          (word) => word.startsWith('https://') || word.startsWith('www.'),
        )
        .toList();
  }

  List<String> _getHashTagsFromText(String text) {
    return text.split(' ').filter((word) => word.startsWith('#')).toList();
  }

  Future<bool> likeTweet({
    required TweetModel tweet,
    required UserModel user,
    required BuildContext context,
  }) async {
    List<String> likes = tweet.likes;

    if (likes.contains(user.uid)) {
      likes.remove(user.uid);
    } else {
      likes.add(user.uid);
    }

    final (:exception, :data) = await _ref
        .read(tweetApiProvider)
        .likeTweet(tweet.copyWith(likes: likes));

    final failed = exception.code != null || data.isEmpty;

    if (!mounted) return failed;

    if (exception.code != null || data.isEmpty) {
      showSnackBar(context, exception.toString());
    }

    return !failed;
  }
}
