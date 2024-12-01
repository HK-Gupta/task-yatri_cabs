import 'dart:async';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yatri_cabs/config/assets_path.dart';
import 'package:yatri_cabs/config/my_colors.dart';
import 'package:yatri_cabs/presentation/cab_booking_widget.dart';

final homeScreenProvider = StateProvider<int>((ref) => 0);
final categoryProvider = StateProvider<int>((ref) => 0);
final imageBannerProvider = StateNotifierProvider<ImageBannerNotifier, int>((ref) {
  return ImageBannerNotifier();
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(categoryProvider);
    final selectedTripType = ref.watch(homeScreenProvider);
    final width = MediaQuery.of(context).size.width;

    print("Selcted C: ${selectedCategory} T: ${selectedTripType}");

    // Start automatic sliding when the widget is built
    Future.delayed(Duration.zero, () {
      ref.read(imageBannerProvider.notifier).startAutoSlide();
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildAppBar(),
              _buildHeaderText(),
              _buildImageBanner(width, ref),
              const SizedBox(height: 10),
              _buildCategoryRow(ref),
              const SizedBox(height: 12),
              selectedCategory == 0 ? _buildTripTypeSelector(ref, width) : const SizedBox(),
              const SizedBox(height: 12),
              CabBookingWidget(
                context: context,
                selectedCategory: selectedCategory,
                selectedTripType: selectedTripType,
              ),
              _buildBottomAds(width),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          ImagePath.logo,
          height: 74,
        ),
        const Icon(
          Icons.notifications_active,
          size: 38,
          color: Colors.white,
        )
      ],
    );
  }

  Widget _buildHeaderText() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Text(
        "India’s Leading Inter-City One Way Cab Service Provider",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: MyColors.textColor,
        ),
      ),
    );
  }

  Widget _buildCategoryRow(WidgetRef ref) {
    final selectedCategory = ref.watch(categoryProvider);
    final categories = [
      {'icon': ImagePath.locationPoint, 'label': 'Outstation Trip'},
      {'icon': ImagePath.train, 'label': 'Local Trip'},
      {'icon': ImagePath.transfer, 'label': 'Airport Transfer'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: categories.asMap().entries.map((entry) {
        final index = entry.key;
        final category = entry.value;
        final isSelected = selectedCategory == index;

        return Expanded(
          child: GestureDetector(
            onTap: () => ref.read(categoryProvider.notifier).state = index,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: isSelected ? Colors.green : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  category['icon'] is String
                      ? Image.asset(
                    category['icon'] as String,
                    height: 40,
                    width: 40,
                    color: isSelected ? Colors.white : Colors.black,
                  )
                      : const SizedBox(),
                  Text(
                    category['label'] as String,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTripTypeSelector(WidgetRef ref, double width) {
    final selectedIndex = ref.watch(homeScreenProvider);
    final options = ['One-way', 'Round Trip'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: options.asMap().entries.map((entry) {
        final index = entry.key;
        final text = entry.value;
        final isSelected = selectedIndex == index;

        return GestureDetector(
          onTap: () => ref.read(homeScreenProvider.notifier).state = index,
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.green : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 28,
            width: width * 0.3,
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomAds(double width) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(
        ImagePath.bottomAds,
        width: width,
        height: 180,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildImageBanner(double width, WidgetRef ref) {
    final currentPage = ref.watch(imageBannerProvider);
    final pageController = PageController();

    // Automatically scroll images
    // Timer.periodic(const Duration(seconds: 5), (Timer timer) {
    //   int nextPage = currentPage + 1;
    //   if (nextPage >= 4) nextPage = 0;
    //   pageController.animateToPage(
    //     nextPage,
    //     duration: const Duration(milliseconds: 300),
    //     curve: Curves.easeInOut,
    //   );
    //   ref.read(imageBannerProvider.notifier).setCurrentPage(nextPage);
    // });

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: 130, // Set desired height for the banner
            child: PageView.builder(
              controller: pageController,
              itemCount: 4, // Update this if you have more images
              onPageChanged: (index) {
                ref.read(imageBannerProvider.notifier).setCurrentPage(index);
              },
              itemBuilder: (context, index) {
                return Image.asset(ImagePath.cab, fit: BoxFit.cover, width: width);
              },
            ),
          ),
        ),
        Positioned(
          bottom: 10, // Position dots closer to the bottom of the image
          child: DotsIndicator(
            dotsCount: 4, // Update this if you have more images
            position: currentPage.toInt(),
            decorator: const DotsDecorator(
              size: Size.square(9.0),
              activeSize: Size(18.0, 9.0),
              color: Colors.black,
              activeColor: MyColors.primary,
              spacing: EdgeInsets.symmetric(horizontal: 4.0),
            ),
          ),
        ),
      ],
    );
  }
}

class ImageBannerNotifier extends StateNotifier<int> {
  ImageBannerNotifier() : super(0);

  void setCurrentPage(int index) {
    state = index;
  }

  void startAutoSlide() {
    // Auto slide logic handled in the widget itself
  }
}
