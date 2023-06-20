import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/enums/tweet_type.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/view/tweet_icon_button.dart';
import 'package:twitter_clone/models/tweet_model.dart';
import 'package:twitter_clone/theme/theme.dart';
import 'package:twitter_clone/widgets/error_page.dart';
import 'package:twitter_clone/widgets/loading_page.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'hashtag_text.dart';
import 'image_carousel.dart';

class TweetCard extends ConsumerWidget {
  final TweetModel tweet;
  const TweetCard({super.key, required this.tweet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currenUser = ref.watch(currentUserDetailsProvider).value;
    return currenUser == null
        ? const SizedBox()
        : ref.watch(userDetailsProvider(tweet.uid)).when(
              data: (user) => Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(user.profilePic),
                          radius: 30,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //retweet
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  child: Text(
                                    user.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19,
                                    ),
                                  ),
                                ),
                                Text(
                                  '@${user.name} ${timeago.format(tweet.createdAt, locale: 'en_short')}',
                                  style: const TextStyle(
                                    color: Pallete.greyColor,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                            // replied to
                            HashTagText(
                              text: tweet.text,
                            ),
                            if (tweet.tweetType == TweetType.image)
                              ImageCarousel(
                                imageLinks: tweet.imageLinks,
                              ),
                            if (tweet.links.isNotEmpty) ...[
                              const SizedBox(
                                height: 4,
                              ),
                              ...tweet.links.map(
                                (link) => AnyLinkPreview(
                                  displayDirection:
                                      UIDirection.uiDirectionHorizontal,
                                  link: link,
                                  errorTitle: 'error',
                                  errorBody: 'Paila',
                                ),
                              ),
                            ],
                            Container(
                              margin: const EdgeInsets.only(top: 10, right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TweetIconButton(
                                    path: AssetsConstants.viewsIcon,
                                    text: (tweet.commentIds.length +
                                            tweet.shareCount +
                                            tweet.likes.length)
                                        .toString(),
                                    onTap: () {},
                                  ),
                                  TweetIconButton(
                                    path: AssetsConstants.commentIcon,
                                    text: tweet.commentIds.length.toString(),
                                    onTap: () {},
                                  ),
                                  TweetIconButton(
                                    path: AssetsConstants.retweetIcon,
                                    text: tweet.shareCount.toString(),
                                    onTap: () {},
                                  ),
                                  LikeButton(
                                    size: 25,
                                    onTap: (isLiked) async {
                                      final failed = await ref
                                          .read(
                                              tweetControllerProvider.notifier)
                                          .likeTweet(
                                            tweet: tweet,
                                            user: currenUser,
                                            context: context,
                                          );
                                      return failed ? isLiked : !isLiked;
                                    },
                                    likeBuilder: (isLiked) {
                                      return isLiked
                                          ? SvgPicture.asset(
                                              AssetsConstants.likeFilledIcon,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                Pallete.redColor,
                                                BlendMode.srcIn,
                                              ),
                                            )
                                          : SvgPicture.asset(
                                              AssetsConstants.likeOutlinedIcon,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                Pallete.greyColor,
                                                BlendMode.srcIn,
                                              ),
                                            );
                                    },
                                    countBuilder: (likeCount, isLiked, text) {
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 2),
                                        child: Text(
                                          text,
                                          style: TextStyle(
                                            color: isLiked
                                                ? Pallete.redColor
                                                : Pallete.whiteColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                      );
                                    },
                                    likeCount: tweet.likes.length,
                                    isLiked: tweet.likes.isNotEmpty,
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.share,
                                      size: 25,
                                      color: Pallete.greyColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 1)
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Pallete.greyColor)
                ],
              ),
              error: (e, stck) => ErrorText(error: e.toString()),
              loading: () => const Loader(),
            );
  }
}
