import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:online_shop/features/authentication/screens/login/login.dart';
import 'package:online_shop/features/authentication/screens/onboarding/onBoarding.dart';
import 'package:online_shop/navigation_menu.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/constants/text_strings.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}




class _SplashScreenState extends State<SplashScreen> {
      final supabase = Supabase.instance.client;

final storage = GetStorage();
    @override
  void initState() {
    super.initState();


    // Simulate initialization delay
    Timer(const Duration(seconds: 3), () {
      // Navigate to Home Screen
      Get.offAll(() => supabase.auth.currentUser != null ? NavigationMenu() : (storage.read("IsFirstTime") != true ?   const LoginScreen() : const OnBoardingScreen()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(TImages.app_animation, width: 200, height: 200),
            const SizedBox(height: TSizes.spaceBetwwenItems,),
            Text(TText.appName, style: Theme.of(context).textTheme.titleLarge,)
          ],
        ),
      ),
    );
  }
}