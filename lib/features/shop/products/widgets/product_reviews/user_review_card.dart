import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:online_shop/features/shop/products/widgets/product_reviews/t_rating_bar_indicator.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';
import 'package:readmore/readmore.dart';

class UserReviewCard extends StatelessWidget {
  const UserReviewCard({super.key, this.review});

  final Map<String, dynamic>? review;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                   const CircleAvatar(backgroundImage: AssetImage(TImages.appLightLogo),),
                   const SizedBox(width: TSizes.spaceBetwwenItems,),
                   Text('John Doe', style: Theme.of(context).textTheme.titleLarge,),
                ],
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
            ],
          ),
          const SizedBox(height: TSizes.spaceBetwwenItems,),
      
          Row(
            children: [
              RatingBarIndicator(
                                  rating: review!['rating'],
                                  itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                                  itemCount: 5,
                                  itemSize: 20.0,
                                  direction: Axis.horizontal,
                                ),
              const SizedBox(width: TSizes.spaceBetwwenItems,),
              Text('07 Nov, 2008', style: Theme.of(context).textTheme.bodyMedium,),
            ],
          ),
          const SizedBox(height: TSizes.spaceBetwwenItems,),
          ReadMoreText(
            textAlign: TextAlign.start,
            review!['review'],
            trimLines: 2,
            trimExpandedText: 'show less',
            trimCollapsedText: 'show more',
            trimMode: TrimMode.Line,
            moreStyle:  TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: TColors.primary),
            lessStyle:  TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: TColors.primary),
      
          ),
          const SizedBox(height: TSizes.spaceBetwwenItems,),
      
          
        ],
      ),
    );
  }
}