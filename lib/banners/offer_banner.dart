import 'dart:async';

import 'package:flutter/material.dart';

class offerBanner extends StatefulWidget {
  const offerBanner({super.key});
  @override
  _offerBannerState createState() => _offerBannerState();
}

class _offerBannerState extends State<offerBanner> {
  final PageController _controller = PageController();
  int _currentIndex = 0;
  final List<String> banners = [
    "assets/images/20c81e0c-377d-410d-b152-41bddb7bbf2a.webp",
    "assets/images/restaurant-promotion-background-mexican-food-260nw-2497579947.webp",
    "assets/images/black-bar-be-cue-food-banner-template-9ffhfd5e8ddb36.webp"
    
  ];

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentIndex < banners.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      _controller.animateToPage(_currentIndex,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _controller,
            itemCount: banners.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    banners[index],
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),

        //Dots Indicator
        const SizedBox(
          height: 8,
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                banners.length,
                (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentIndex == index ? 10 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                          color:
                              _currentIndex == index ? Colors.red : Colors.grey,
                          borderRadius: BorderRadius.circular(10)),
                    )))
      ],
    );
  }
}
