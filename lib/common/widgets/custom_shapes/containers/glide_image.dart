import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class TImageLoader extends StatelessWidget {
  final String image;
  final bool isNetworkImage;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius borderRadius;

  const TImageLoader({
    super.key,
    required this.image,
    this.isNetworkImage = false,
    this.width = 100,
    this.height = 100,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  Widget build(BuildContext context) {
    final validImage = image.isNotEmpty;

    return ClipRRect(
      borderRadius: borderRadius,
      child: isNetworkImage
          ? (validImage
              ? CachedNetworkImage(
                  imageUrl: image,
                  width: width,
                  height: height,
                  fit: fit,
                  placeholder: (context, url) => Container(
                    width: width,
                    height: height,
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.broken_image),
                  fadeInDuration: const Duration(milliseconds: 300),
                )
              : _placeholder())
          : (validImage
              ? Image.asset(
                  image,
                  width: width,
                  height: height,
                  fit: fit,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                )
              : _placeholder()),
    );
  }

  Widget _placeholder() => Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: const Icon(Icons.image_not_supported),
      );
}
