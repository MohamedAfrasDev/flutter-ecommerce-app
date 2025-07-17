import 'package:flutter/material.dart';
import 'package:online_shop/features/authentication/screens/signup/signup.dart';
import 'package:online_shop/navigation_menu.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:get/get.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: TSizes.spaceBetwwenSections,
        ),
        child: Container(
          decoration: BoxDecoration(
            color:
                dark
                    ? Colors.white.withOpacity(0.2)
                    : Colors.white.withOpacity(0.45),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color:
                  dark
                      ? Colors.white.withOpacity(0.2)
                      : Colors.white.withOpacity(0.45),
              width: 0.4,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Iconsax.direct_right),
                    prefixIconColor: dark ? Colors.white : TColors.primary,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color:
                            dark
                                ? Colors.white.withOpacity(0.2)
                                : TColors.dark.withOpacity(1),
                        width: 0.4,
                      ),
                    ),
                    labelText: 'Email',
                  ),
                ),

                const SizedBox(height: TSizes.spaceBetweenInputFields),

                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Iconsax.password_check),
                    labelText: 'Password',
                    prefixIconColor: dark ? Colors.white : TColors.primary,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color:
                            dark
                                ? Colors.white.withOpacity(0.2)
                                : TColors.dark.withOpacity(1),
                        width: 0.4,
                      ),
                    ),
                    suffixIcon: Icon(Iconsax.eye_slash),
                  ),
                ),

                const SizedBox(height: TSizes.spaceBetweenInputFields / 2),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(value: true, onChanged: (value) {}),
                        const Text('Remeber Me'),
                      ],
                    ),

                    TextButton(
                      onPressed: () {},
                      child: const Text('Forgot Password !'),
                    ),
                  ],
                ),

                GestureDetector(
                  onTap: () => Get.to(() => const NavigationMenu()),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: TColors.primary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Login',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium!.apply(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBetwwenItems),

                GestureDetector(
                  onTap: () => Get.to(() => const SignupScreen()),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: TColors.primary.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Create New Account',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium!.apply(color: dark ? Colors.white : Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: TSizes.sm),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
