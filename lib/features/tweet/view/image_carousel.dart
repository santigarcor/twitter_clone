import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import 'package:twitter_clone/theme/theme.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> imageLinks;
  const ImageCarousel({super.key, required this.imageLinks});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            CarouselSlider(
              items: widget.imageLinks
                  .map<Widget>((String link) => Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25)),
                        margin: const EdgeInsets.all(10),
                        child: Image.network(
                          link,
                          fit: BoxFit.contain,
                        ),
                      ))
                  .toList(),
              options: CarouselOptions(
                viewportFraction: 1,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) => setState(
                  () => _current = index,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.imageLinks
                  .asMap()
                  .entries
                  .map(
                    (e) => Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Pallete.whiteColor.withOpacity(
                          _current == e.key ? 0.9 : 0.4,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            )
          ],
        )
      ],
    );
  }
}
