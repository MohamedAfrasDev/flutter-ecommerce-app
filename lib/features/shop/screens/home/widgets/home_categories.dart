import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/vertical_image.dart';
import 'package:online_shop/features/shop/screens/sub_category/sub_categories.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';

class THomeCategories extends StatelessWidget {
  const THomeCategories({
    super.key,
    required this.dataList,
    this.isIcon = false,
  });

  final List<Map<String, dynamic>> dataList;
  final bool isIcon;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);

    if (dataList.isEmpty) {
      return const Center(child: Text("No categories found"));
    }

    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          final item = dataList[index];
          return Padding(
            padding: const EdgeInsets.only(left: TSizes.defaultSpace),
            child: Container(
              decoration: BoxDecoration(
                color: dark
                    ? TColors.textWhite.withOpacity(0.15)
                    : TColors.textWhite.withOpacity(0.55),
                border: Border.all(
                  color: dark
                      ? Colors.white.withOpacity(0.2)
                      : TColors.textWhite.withOpacity(0.55),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TVerticalImageText(
                image: item['image_url'],
                title: item['title'],
                isIcon: isIcon,
                isNetworkImage: true,
                onTap: () => Get.to(() => SubCategoriesScreen(
                      text: item['title'],
                      categoryID: item['id'],
                      image: item['image_url'] ?? item['image'],
                    )),
              ),
            ),
          );
        },
      ),
    );
  }
}
