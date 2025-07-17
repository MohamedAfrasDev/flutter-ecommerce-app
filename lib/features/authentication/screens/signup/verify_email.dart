import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/features/authentication/screens/login/login.dart';
import 'package:online_shop/features/authentication/screens/signup/success_screen.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: () => Get.offAll(() => const LoginScreen()), icon: const Icon(CupertinoIcons.clear))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              Lottie.asset(
            TImages.verify_email,
            height: 250,
            repeat: false
          ),
                const SizedBox(height: TSizes.spaceBetwwenSections,),

                Text("Verify your email address !", style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
                const SizedBox(height:  TSizes.spaceBetwwenItems),
                Text('mohamedafrasai@gmail.com', style: Theme.of(context).textTheme.labelLarge, textAlign: TextAlign.center,),
                const SizedBox(height:  TSizes.spaceBetwwenItems),
                Text('Congratulations! Your Account Awaits: Verfify Your Email to Start Shopping and Experience a World of Unrivated Deals and Personalized Offers', style: Theme.of(context).textTheme.labelLarge, textAlign: TextAlign.center,),
                const SizedBox(height:  TSizes.spaceBetwwenItems),

                SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Get.to(() => SuccessScreen()), child: const Text('Continue')),),
                const SizedBox(height: TSizes.spaceBetwwenItems,),
                SizedBox(width: double.infinity, child: TextButton(onPressed: () {}, child: const Text('resend email')),)
            ],
          ),
        ),
      ),
    );
  }
}