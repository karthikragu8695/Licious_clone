import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OfferBanner extends StatefulWidget {
  const OfferBanner({super.key});

  @override
  State<OfferBanner> createState() => _OfferBannerState();
}

class _OfferBannerState extends State<OfferBanner> {
  final PageController _controller = PageController();
  final supabase = Supabase.instance.client;

  int _currentIndex = 0;
  Timer? _timer;

  List<String> banners = [];

  @override
  void initState() {
    super.initState();
    fetchBanners();
  }

  // 🔥 Fetch banners from Supabase
  Future<void> fetchBanners() async {
    try {
      final response = await supabase
          .from('banner') // ✅ correct table name
          .select();

      print("Supabase Data: $response");

      if (response.isNotEmpty) {
        List<String> temp = [];

        for (var item in response) {
          final url = item['images'];

          if (url != null && url.toString().startsWith('http')) {
            temp.add(url);
          } else {
            print("❌ Invalid URL: $url");
          }
        }

        setState(() {
          banners = temp;
        });

        startAutoSlide();
      } else {
        print("❌ No data found");
      }
    } catch (e) {
      print("🔥 Error fetching banners: $e");
    }
  }

  // 🔥 Auto slide
  void startAutoSlide() {
    if (banners.isEmpty) return;

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;

      _currentIndex = (_currentIndex + 1) % banners.length;

      _controller.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 🔥 Loading state
    if (banners.isEmpty) {
      return const SizedBox(
        height: 160,
        child: Center(child: CircularProgressIndicator()),
      );
    }

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
                  child: Image.network(
                    banners[index],
                    fit: BoxFit.cover,

                    // 🔥 loading indicator
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },

                    // 🔥 error handling
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Text("Image load error"),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 8),

        // 🔥 Indicator dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentIndex == index ? 12 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _currentIndex == index
                    ? Colors.red
                    : Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}