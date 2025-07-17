import 'package:flutter/material.dart';
import 'package:online_shop/features/authentication/controllers/onboarding_controller.dart';
import 'package:online_shop/features/authentication/screens/onboarding/widgets/onboarding_dot.dart';
import 'package:online_shop/features/authentication/screens/onboarding/widgets/onboarding_page.dart';
import 'package:online_shop/features/authentication/screens/onboarding/widgets/onboaring_next_button.dart';
import 'package:online_shop/features/authentication/screens/onboarding/widgets/onboaring_skip.dart';
import 'package:get/get.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/text_strings.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());
    return Scaffold(

      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnBoardingPage(image: TImages.onBoarding1, title: TText.onBoardScreenHead1SubTitile,subTitle: TText.onBoardingScreen1Body, headTitle: TText.onBoardScreenHead1, isRight: false,),
              OnBoardingPage(image: TImages.onBoarding2, title: TText.onBoardScreenHead2SubTitile,subTitle: TText.onBoardingScreen2Body, headTitle: TText.onBoardScreenHead2, isRight: true,),
              OnBoardingPage(image: TImages.onBoarding3, title: TText.onBoardScreenHead3SubTitile,subTitle: TText.onBoardingScreen3Body, headTitle: TText.onBoardScreenHead3, isRight: false,),
 
            ],
          ),

         

         const OnBoardDotNavigation(),

         const OnBoardingNextButton()

        ],
      ),
    );
  }
}

