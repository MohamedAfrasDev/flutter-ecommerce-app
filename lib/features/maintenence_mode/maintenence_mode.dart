import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/device/device_utility.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';


class MaintenenceModeScreen extends StatelessWidget {
  const MaintenenceModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Maintenece Mode', style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center,),
            const SizedBox(height: TSizes.spaceBetwwenItems,),

            Lottie.asset(TImages.maintenenceMode, width: TDeviceUtils.getScreenWidth(context) - 10, height: 300, repeat: true),
            Text('Sorry, we are unavailable for the moment', style: Theme.of(context).textTheme.titleSmall,),
            const SizedBox(height: TSizes.spaceBetwwenItems,),

            GestureDetector(
             onTap: () => exit(0),

              child: Container(
                decoration: BoxDecoration(
                  color: TColors.primary,
                  border: Border.all(color: dark ? Colors.grey.withOpacity(0.5) : TColors.dark.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(5)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text('Go back', style: TextStyle(color: Colors.white),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}