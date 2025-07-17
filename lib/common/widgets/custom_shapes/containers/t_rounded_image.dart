import 'package:flutter/material.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:uuid/uuid.dart';

class TRoundedImage extends StatelessWidget {
  const TRoundedImage({
    super.key,
    this.width,
    this.height,
    required this.imageUrl,
    this.applyImageRadius = false,
    this.border,
    this.backgroundColor = TColors.light,
    this.fit = BoxFit.contain,
    this.padding,
    this.isNetworkImage = false,
    this.onPressed,
    this.borderRadius = TSizes.md,
  });

  final double? width, height;
  final String imageUrl;
  final bool applyImageRadius;
  final BoxBorder? border;
  final Color backgroundColor;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final bool isNetworkImage;
  final VoidCallback? onPressed;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,

        height: height,
        padding: padding,
        decoration: BoxDecoration(
          border: border,
          color: backgroundColor,
          borderRadius: BorderRadius.circular(TSizes.md),
        ),
        child: Hero(
          tag: '4432'+Uuid().v4(),
          child: ClipRRect(
            borderRadius:
                applyImageRadius
                    ? BorderRadius.circular(borderRadius)
                    : BorderRadius.circular(borderRadius),
            child: FadeInImage(
  fit: BoxFit.contain,
  image: isNetworkImage
      ? NetworkImage(imageUrl)
      : AssetImage(imageUrl) as ImageProvider,
  placeholder: AssetImage(TImages.placeholder_image),
  placeholderColor: Colors.grey,
  imageErrorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
),

          ),
        ),
      ),
    );
  }
}
