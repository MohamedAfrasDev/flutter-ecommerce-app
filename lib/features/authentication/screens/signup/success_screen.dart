import 'package:flutter/material.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:lottie/lottie.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Lottie.asset(
                  TImages.created,
                  width: 250,
                  repeat: false
                ),
              ),
              const SizedBox(height: TSizes.spaceBetwwenItems,),
          
              Text('Your account has been created successfully!', 
                style: Theme.of(context).textTheme.headlineMedium, 
                textAlign: TextAlign.center),
              const SizedBox(height: TSizes.spaceBetwwenItems,),
          
                Text("Welcome to our online shop! You can now start shopping and enjoy our exclusive offers.",
                  style: Theme.of(context).textTheme.labelLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: TSizes.spaceBetwwenItems,),
          
                SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, child: const Text("Continue")),)
          
            ],
          ),
        ),
      ),
    );
  }
}