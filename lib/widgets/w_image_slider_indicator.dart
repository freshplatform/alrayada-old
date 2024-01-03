import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SliderImageWithPageIndicator extends StatefulWidget {
  const SliderImageWithPageIndicator({
    required this.itemCount, required this.itemBuilder, required this.semanticsLabelWidget, required this.semanticsLabelSliderWidgets, super.key,
    this.autoPlay = true,
  });

  @override
  State<SliderImageWithPageIndicator> createState() =>
      _SliderImageWithPageIndicatorState();

  final int itemCount;
  final ExtendedIndexedWidgetBuilder itemBuilder;
  final bool autoPlay;
  final String semanticsLabelWidget;
  final String semanticsLabelSliderWidgets;
}

class _SliderImageWithPageIndicatorState
    extends State<SliderImageWithPageIndicator> {
  var _activeIndex = 0;

  bool get autoPlay {
    if (widget.itemCount == 1) {
      return false;
    }
    return widget.autoPlay;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticsLabelWidget,
      child: Column(
        children: [
          Semantics(
            label: widget.semanticsLabelSliderWidgets,
            child: CarouselSlider.builder(
              itemCount: widget.itemCount,
              options: CarouselOptions(
                onPageChanged: (newIndex, reason) =>
                    setState(() => _activeIndex = newIndex),
                height: 300,
                enlargeCenterPage: true,
                viewportFraction: 1,
                aspectRatio: 2.0,
                reverse: true,
                autoPlay: autoPlay,
              ),
              itemBuilder: widget.itemBuilder,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: AnimatedSmoothIndicator(
              activeIndex: _activeIndex,
              count: widget.itemCount,
              onDotClicked: (newIndex) =>
                  setState(() => _activeIndex = newIndex),
              effect: ExpandingDotsEffect(
                dotWidth: 20,
                dotHeight: 20,
                activeDotColor: isCupertino(context)
                    ? CupertinoColors.systemBlue
                    : Colors.blue,
              ),
            ),
          )
        ],
      ),
    );
  }
}
