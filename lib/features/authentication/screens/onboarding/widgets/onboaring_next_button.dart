import 'package:flutter/material.dart';
import 'package:online_shop/features/authentication/controllers/onboarding_controller.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/device/device_utility.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';


class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return Positioned(
     right: TSizes.defaultSpace,
     bottom: TDeviceUtils.getBottomNavigationBarHeight(),
     child: ElevatedButton(
       onPressed: () => OnBoardingController.instance.nextPage(),
       style: ElevatedButton.styleFrom(shape: const CircleBorder(), backgroundColor: TColors.primary),
       child: const Icon(Iconsax.arrow_right_3_copy),
     ),
    );
  }
}
