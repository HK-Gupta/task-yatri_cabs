import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:riverpod/riverpod.dart';
import 'package:yatri_cabs/config/my_colors.dart';
import 'package:yatri_cabs/presentation/screens/account_screen.dart';
import 'package:yatri_cabs/presentation/screens/home_screen.dart';
import 'package:yatri_cabs/presentation/screens/more_screen.dart';
import 'package:yatri_cabs/presentation/screens/trip_screen.dart';

import '../config/assets_path.dart';

final currentTabIndexProvider = StateProvider<int>((ref) => 0);

class BottomNavigation extends ConsumerWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTabIndex = ref.watch(currentTabIndexProvider);

    // Pages for navigation
    final pages = [
      const HomeScreen(),
      const TripScreen(),
      const AccountScreen(),
      const MoreScreen(),
    ];

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentTabIndex,
          onTap: (int index) {
            // Update the currentTabIndex using Riverpod
            ref.read(currentTabIndexProvider.notifier).state = index;
          },
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                SVGPath.home,
                color: currentTabIndex == 0 ? Colors.black : Colors.white,
              ),
              label: '',
              backgroundColor: MyColors.primary,
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                SVGPath.myTrip,
                color: currentTabIndex == 1 ? Colors.black : Colors.white,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                SVGPath.account,
                color: currentTabIndex == 2 ? Colors.black : Colors.white,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                SVGPath.more,
                color: currentTabIndex == 3 ? Colors.black : Colors.white,
              ),
              label: '',
            ),
          ],
        ),
        body: pages[currentTabIndex],
      ),
    );
  }
}
