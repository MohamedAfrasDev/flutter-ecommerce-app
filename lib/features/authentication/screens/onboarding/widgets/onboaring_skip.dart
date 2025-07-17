import 'package:flutter/material.dart';
import 'package:online_shop/features/authentication/controllers/onboarding_controller.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/device/device_utility.dart';


class OnBoardSkip extends StatelessWidget {
  const OnBoardSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(top: TDeviceUtils.getAppBarHeight(), right: TSizes.defaultSpace,child: TextButton(onPressed: () => OnBoardingController.instance.skipPage(), child: const Text('Skip'),));
  }
}