import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:online_shop/features/authentication/screens/onboarding/widgets/onboaring_skip.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/constants/text_strings.dart';
import 'package:online_shop/utils/device/device_utility.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
    required this.headTitle, this.isRight = false,
  });

  final String image, title, subTitle, headTitle;
  final bool isRight;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Row(
          mainAxisAlignment: isRight ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(isRight)
          SafeArea(child: const OnBoardSkip()),
            Container(
              width: TDeviceUtils.getScreenWidth(context) * 0.8,
              height: TDeviceUtils.getScreenHeight() * 0.35,
              decoration: BoxDecoration(
                color: TColors.primary,
              
                borderRadius: isRight ? BorderRadius.only(bottomLeft: Radius.circular(350)) : BorderRadius.only(bottomRight: Radius.circular(350)),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: TSizes.lg),
                  child: Column(
                    crossAxisAlignment: isRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                       Image(
                        image: AssetImage(
                          dark ? TImages.appDarkLogo : TImages.appLightLogo,
                        ),
                        width: 100,
                        height: 100,
                      ),
                      Text('Purchase Online', style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white),),
                      Text('Your order is our priority', style: Theme.of(context).textTheme.titleMedium,)
                     
                    ],
                  ),
                ),
              ),
            ),
            if(!isRight)
          SafeArea(child: const OnBoardSkip()),
          ],
        ),
        
    
        Lottie.asset(
          image,
          width: screenWidth * 0.8,
          height: screenHeight * 0.4,
          errorBuilder:
              (context, error, stackTrace) =>
                  const Text("Image failed to load"),
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Text(
          subTitle,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
