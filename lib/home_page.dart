import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentIndex = 0;
  final CarouselSliderController _carouselController =
  CarouselSliderController();


  final List<Map<String, String>> _images = [
    {
      'type': 'asset',
      'src': 'assets/images/cat.jpg', // LOCAL image from your assets folder
      'label': 'Local Asset Image',
    },
    {
      'type': 'network',
      'src': 'https://i.pinimg.com/1200x/23/9a/de/239ade5bbe055c25bc24e0c93f14286a.jpg', // NETWORK image #1
      'label': 'Network Image 1',
    },
    {
      'type': 'network',
      'src': 'https://i.pinimg.com/1200x/d0/f3/c9/d0f3c9c0351efd7799f1bc1a2d53aa47.jpg', // NETWORK image #2
      'label': 'Network Image 2',
    },
    {
      'type': 'network',
      'src': 'https://i.pinimg.com/736x/ea/4c/0b/ea4c0b55cdf65d93ae32f63f54463813.jpg', // NETWORK image #3
      'label': 'Network Image 3',
    },
  ];


  Widget _buildImage(Map<String, String> item) {
    if (item['type'] == 'asset') {
      // LOCAL ASSET image — loaded from assets/images/ folder
      return Image.asset(
        item['src']!,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('❌ Asset Error: $error'); // prints to Flutter console
          return _buildErrorPlaceholder('Asset not found:\n${item['src']}');
        },
      );
    } else {

      return Image.network(
        item['src']!,
        fit: BoxFit.cover,
        width: double.infinity,

        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
                  : null,
              color: Colors.deepPurple,
            ),
          );
        },

        errorBuilder: (context, error, stackTrace) {
          debugPrint('❌ Network Error: $error');
          return _buildErrorPlaceholder('Network image failed:\n${item['src']}');
        },
      );
    }
  }

  Widget _buildErrorPlaceholder(String message) {
    return Container(
      color: Colors.red.shade50,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.broken_image, size: 50, color: Colors.red),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignment 4 – Image Carousel'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),


            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Dynamic Image Carousel',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),

            const SizedBox(height: 16),


            CarouselSlider(
              carouselController: _carouselController,
              options: CarouselOptions(
                height: 250.0,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.easeInOut,
                enlargeCenterPage: true,
                viewportFraction: 0.92,
                onPageChanged: (index, reason) {
                  setState(() => _currentIndex = index);
                },
              ),
              items: _images.map((item) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [

                            _buildImage(item),

                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.6),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                                child: Text(
                                  item['label']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 16),


            AnimatedSmoothIndicator(
              activeIndex: _currentIndex,
              count: _images.length,
              effect: const WormEffect(
                dotHeight: 10,
                dotWidth: 10,
                activeDotColor: Colors.deepPurple,
                dotColor: Colors.grey,
              ),
              onDotClicked: (index) {
                _carouselController.animateToPage(index);
              },
            ),

            const SizedBox(height: 24),


            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _carouselController.previousPage(),
                  icon: const Icon(Icons.arrow_back_ios),
                  label: const Text('Prev'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () => _carouselController.nextPage(),
                  icon: const Icon(Icons.arrow_forward_ios),
                  label: const Text('Next'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

          ],
        ),
      ),
    );
  }
}