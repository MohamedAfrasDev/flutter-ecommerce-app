import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/glide_image.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';

class TVerticalImageText extends StatelessWidget {
  const TVerticalImageText({
    super.key,
    required this.image,
    required this.title,
    this.textColor = Colors.black,
    this.backgroundColor,
    this.onTap,
    this.isIcon = false,
    this.isNetworkImage = false,
  });

  final String image, title;
  final Color textColor;
  final Color? backgroundColor;
  final void Function()? onTap;
  final bool isIcon, isNetworkImage;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    final assetImage = AssetImage(image);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 120,
            height: 140,
            padding: const EdgeInsets.all(TSizes.sm),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 3,
                  child: CachedNetworkImage(
                    imageUrl: image,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) {
                      print("Error loading image: $error");
                      return Icon(Icons.error);
                    },
                  ),
                ),
                const SizedBox(height: TSizes.sm),
                Flexible(
                  flex: 2,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: dark ? Colors.white : Colors.black,
                      fontSize: 14,
                    ),
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
