import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/theme/theme.dart';
import 'package:twitter_clone/utils/files.dart';
import 'package:twitter_clone/widgets/loading_page.dart';
import 'package:twitter_clone/widgets/rounded_button.dart';

class CreateTweet extends ConsumerStatefulWidget {
  const CreateTweet({super.key});

  static MaterialPageRoute<CreateTweet> route() =>
      MaterialPageRoute(builder: (context) => const CreateTweet());

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateTweetState();
}

class _CreateTweetState extends ConsumerState<CreateTweet> {
  final tweetTextController = TextEditingController();
  List<File> images = [];

  handleImageSelection() async {
    final images = await pickImages();
    setState(() {
      this.images = images;
    });
  }

  handleCreateTweet(BuildContext context) {
    ref.read(tweetControllerProvider.notifier).createTweet(
          images: images,
          text: tweetTextController.text,
          context: context,
        );
  }

  @override
  void dispose() {
    super.dispose();
    tweetTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    final isLoading = ref.watch(tweetControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          iconSize: 30,
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: RoundedTextButton(
              loading: isLoading,
              onTap: () => handleCreateTweet(context),
              text: 'Tweet',
              padding: const EdgeInsets.symmetric(horizontal: 20),
              backgroundColor: Pallete.blueColor,
              textColor: Pallete.whiteColor,
            ),
          )
        ],
      ),
      body: isLoading || currentUser == null
          ? const Loader()
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(currentUser.profilePic),
                            radius: 30,
                          ),
                          const SizedBox(width: 40),
                          Expanded(
                            child: TextField(
                              controller: tweetTextController,
                              style: const TextStyle(fontSize: 22),
                              decoration: const InputDecoration(
                                hintText: 'What\'s happening?',
                                hintStyle: TextStyle(
                                  color: Pallete.greyColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                border: InputBorder.none,
                              ),
                              maxLines: null,
                            ),
                          )
                        ],
                      ),
                    ),
                    if (images.isNotEmpty)
                      CarouselSlider(
                        items: images
                            .map<Widget>((File file) => Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  child: Image.file(file),
                                ))
                            .toList(),
                        options: CarouselOptions(
                          height: 400,
                          enableInfiniteScroll: false,
                        ),
                      )
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 10),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Pallete.greyColor,
              width: 0.4,
            ),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(left: 15, right: 15),
              child: GestureDetector(
                onTap: handleImageSelection,
                child: SvgPicture.asset(AssetsConstants.galleryIcon),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(left: 15, right: 15),
              child: SvgPicture.asset(AssetsConstants.gifIcon),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(left: 15, right: 15),
              child: SvgPicture.asset(AssetsConstants.emojiIcon),
            ),
          ],
        ),
      ),
    );
  }
}
