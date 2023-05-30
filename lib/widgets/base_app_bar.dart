import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/theme/theme.dart';

class BaseAppBar extends AppBar {
  BaseAppBar({super.key})
      : super(
          title: SvgPicture.asset(
            AssetsConstants.twitterLogo,
            colorFilter: const ColorFilter.mode(
              Pallete.blueColor,
              BlendMode.srcIn,
            ),
          ),
          centerTitle: true,
        );
}
