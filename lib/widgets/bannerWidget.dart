import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../controllers/bannersController.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final PageController _pageController = PageController(viewportFraction: 1);
  final BannerController bannerController = Get.put(BannerController());
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) => _autoScroll());
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  void _autoScroll() {
  if (_pageController.page == bannerController.bannerUrls.length - 1) {
    _pageController.jumpToPage(0); // Jump to the first slide
  } else {
    _pageController.nextPage(
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }
}

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    return SizedBox(
      height: 200.0, // Set a fixed height (adjust as needed)
      child: Column(
        mainAxisSize: MainAxisSize.min, // Allow Column to shrink-wrap
        children: [
          Expanded(
            child: Obx(() {
              final bannerUrls = bannerController.bannerUrls; //list of urls
              if (bannerUrls.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return PageView.builder(
                controller: _pageController,
                itemCount: bannerUrls.length,
                
                itemBuilder: (context, index) {
                  
                  return Padding(
                    padding: Vx.m8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: CachedNetworkImage(
                        imageUrl: bannerUrls[index],
                        fit: BoxFit.cover,
                        
                        width: Get.width - 10, // Adjust width if needed
                        placeholder: (context, url) => const ColoredBox(
                          color: Colors.grey,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          SmoothPageIndicator(
            controller: _pageController,
            count: bannerController.bannerUrls.length,
            effect: ExpandingDotsEffect(
              activeDotColor: currentTheme.colorScheme.onPrimary,
              dotColor: currentTheme.cardColor,
            ),
          ),
        ],
      ),
    );
  }
}
