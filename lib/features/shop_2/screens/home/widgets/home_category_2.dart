import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:online_shop/utils/constants/sizes.dart';

class THomeCategories_2 extends StatelessWidget {
  const THomeCategories_2({super.key, required this.image, required this.title});

  final String image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      height: 80,
      child: SizedBox(
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image(image: AssetImage(image), ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBetwwenItems,),
          Text(title),
          ],
        ),
      ),
    );
  }
}