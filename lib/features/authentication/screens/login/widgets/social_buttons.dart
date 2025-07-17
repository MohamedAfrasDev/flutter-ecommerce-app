import 'package:flutter/material.dart';
import 'package:online_shop/utils/constants/sizes.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(100)),
          child: IconButton(
          onPressed: () {},
          icon: const Image(
            width: TSizes.iconMd,
            height: TSizes.iconMd,
            image: AssetImage('assets/icons/google.png'),
          )),
        ),
        const SizedBox(width: TSizes.spaceBetwwenItems),
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(100)),
          child: IconButton(
          onPressed: () {},
          icon: const Image(
            width: TSizes.iconMd,
            height: TSizes.iconMd,
            image: AssetImage('assets/icons/facebook.png'),
          )),
        ),
      ],
    );
  }
}

