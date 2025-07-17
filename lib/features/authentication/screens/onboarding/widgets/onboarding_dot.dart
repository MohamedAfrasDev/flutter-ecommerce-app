import 'package:flutter/material.dart';
import 'package:online_shop/features/authentication/controllers/onboarding_controller.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/device/device_utility.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardDotNavigation extends StatelessWidget {
  const OnBoardDotNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    final controller = OnBoardingController.instance;
    return Positioned(
     bottom: TDeviceUtils.getBottomNavigationBarHeight()  + 25,
     left: TSizes.defaultSpace,
     child: SmoothPageIndicator(controller: controller.pageController,onDotClicked: controller.dotNavigationClick, count: 3,
     effect: ExpandingDotsEffect(activeDotColor: dark ? TColors.light: TColors.dark, dotHeight: 6),));
  }
}

