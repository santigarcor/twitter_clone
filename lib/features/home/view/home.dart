import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/tweet/view/create_tweet.dart';
import 'package:twitter_clone/features/tweet/view/tweet_list.dart';
import 'package:twitter_clone/theme/theme.dart';
import 'package:twitter_clone/widgets/base_app_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();

  static MaterialPageRoute<Home> route() =>
      MaterialPageRoute(builder: (context) => const Home());
}

class _HomeState extends State<Home> {
  int _page = 0;

  handlePageChange(int index) {
    setState(() => _page = index);
  }

  handleCreateTweetNavigation() {
    Navigator.push(context, CreateTweet.route());
  }

  @override
  Widget build(BuildContext context) {
    const inactiveColorFilter = ColorFilter.mode(
      Pallete.whiteColor,
      BlendMode.srcIn,
    );
    const activeColorFilter = ColorFilter.mode(
      Pallete.blueColor,
      BlendMode.srcIn,
    );

    return Scaffold(
      appBar: BaseAppBar(),
      body: IndexedStack(
        index: _page,
        children: const [
          TweetList(),
          Text('Search'),
          Text('notifications'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: handleCreateTweetNavigation,
        child: const Icon(
          Icons.add,
          color: Pallete.whiteColor,
          size: 32,
        ),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _page,
        onTap: handlePageChange,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _page == 0
                  ? AssetsConstants.homeFilledIcon
                  : AssetsConstants.homeOutlinedIcon,
              colorFilter: _page == 0 ? activeColorFilter : inactiveColorFilter,
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AssetsConstants.searchIcon,
              colorFilter: _page == 1 ? activeColorFilter : inactiveColorFilter,
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _page == 2
                  ? AssetsConstants.notifFilledIcon
                  : AssetsConstants.notifOutlinedIcon,
              colorFilter: _page == 2 ? activeColorFilter : inactiveColorFilter,
            ),
          ),
        ],
      ),
    );
  }
}
