import 'package:flutter/material.dart';
import 'package:twitter_clone/theme/theme.dart';

class RoundedTextButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final bool loading;
  final EdgeInsets padding;
  final double fontSize;

  const RoundedTextButton({
    super.key,
    required this.onTap,
    required this.text,
    this.backgroundColor = Pallete.whiteColor,
    this.textColor = Pallete.backgroundColor,
    this.loading = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    this.fontSize = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => loading ? null : onTap(),
      style: TextButton.styleFrom(
        foregroundColor: textColor,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        padding: padding,
      ),
      child: Center(
        child: loading
            ? SizedBox(
                height: fontSize,
                width: fontSize,
                child: CircularProgressIndicator(
                  color: textColor,
                ),
              )
            : Text(
                text,
                style: TextStyle(color: textColor, fontSize: fontSize),
              ),
      ),
    );
  }
}
