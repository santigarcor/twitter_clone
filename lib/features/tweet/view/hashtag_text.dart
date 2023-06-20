import 'package:flutter/widgets.dart';
import 'package:twitter_clone/theme/theme.dart';

class HashTagText extends StatelessWidget {
  final String text;
  const HashTagText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textSpans = text.split(' ').map((word) {
      if (word.startsWith('#')) {
        return TextSpan(
          text: '$word ',
          style: const TextStyle(
            color: Pallete.blueColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        );
      }

      if (word.startsWith('www.') || word.startsWith('https://')) {
        return TextSpan(
          text: '$word ',
          style: const TextStyle(
            color: Pallete.blueColor,
            fontSize: 18,
          ),
        );
      }

      return TextSpan(
        text: '$word ',
        style: const TextStyle(fontSize: 18),
      );
    }).toList();

    return RichText(text: TextSpan(children: textSpans));
  }
}
