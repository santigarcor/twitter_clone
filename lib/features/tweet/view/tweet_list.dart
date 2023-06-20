import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/view/tweet_card.dart';
import 'package:twitter_clone/models/tweet_model.dart';
import 'package:twitter_clone/widgets/error_page.dart';
import 'package:twitter_clone/widgets/loading_page.dart';

class TweetList extends ConsumerWidget {
  const TweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(tweetsListProvider).when(
          data: (tweets) {
            restDataBuiler() => ListView.builder(
                  itemCount: tweets.length,
                  itemBuilder: (BuildContext context, int index) =>
                      TweetCard(tweet: tweets[index]),
                );

            return ref.watch(getLatestTweetProvider).when(
                  data: (data) {
                    if (data.events.contains(
                        'databases.*.collections.${AppWriteConstants.tweetsCollectionId}.documents.*.create')) {
                      tweets.insert(0, TweetModel.fromMap(data.payload));
                    }
                    return restDataBuiler();
                  },
                  error: (e, stck) => ErrorText(error: e.toString()),
                  loading: restDataBuiler,
                );
          },
          error: (e, stck) => ErrorText(error: e.toString()),
          loading: () => const Loader(),
        );
  }
}
