import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HorizontalList extends StatefulWidget {
  final List<Widget> cards;
  const HorizontalList({super.key, required this.cards});

  @override
  State<StatefulWidget> createState() => _HorizontalList();
}

class _HorizontalList extends State<HorizontalList> {
  final controller = PageController(viewportFraction: .8, keepPage: true);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 16),
          SizedBox(
            height: screenSize.width *
                .8, // height: screenSize.width * .8 // screenSize.height * .55
            child: PageView.builder(
              itemCount: widget.cards.length,
              // controller: PageController(
              //   viewportFraction: isSmallScreen(context) ? .8 : .3,
              // ),
              controller: controller,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: widget.cards[index],
                );
              },
            ),
          ),
          SmoothPageIndicator(
            controller: controller,
            count: widget.cards.length,
            effect: const ScrollingDotsEffect(
              dotWidth: 5.0,
              dotHeight: 5.0,
              activeDotScale: 2,
              activeDotColor: Color(
                0xFF6DD075,
              ),
            ),
            onDotClicked: (index) => controller.animateToPage(
              index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease,
            ),
          )
        ],
      ),
    );
  }
}
