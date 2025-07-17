import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:online_shop/common/styles/layouts/grid_view_layout.dart';
import 'package:online_shop/common/widgets/custom_shapes/appbar/appbar.dart';
import 'package:online_shop/common/widgets/custom_shapes/appbar/tabbar.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/products/product_card_vertical.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/t_rounded_image.dart';
import 'package:online_shop/common/widgets/custom_shapes/search_bar/search_container.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/products/t_brand_card.dart';
import 'package:online_shop/features/shop/products/product_detail.dart';
import 'package:online_shop/features/shop/screens/home/widgets/cart_menu.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/section_heading.dart';
import 'package:online_shop/features/shop/screens/store/widgets/category_tab.dart';
import 'package:online_shop/features/shop/screens/store/widgets/featured_brand.dart';
import 'package:online_shop/features/shop/screens/store/widgets/featured_brands_slider.dart';
import 'package:online_shop/features/shop/screens/store/widgets/product_grid_item.dart';
import 'package:online_shop/features/shop/screens/wishlists/controller/whishlist_controller.dart';
import 'package:online_shop/features/shop_2/screens/home/widgets/t_tab_bar_view.dart';
import 'package:online_shop/features/shop_2/screens/home/widgets/t_tab_bar_view_cat.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/constants/text_strings.dart';
import 'package:online_shop/utils/device/device_utility.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:online_shop/utils/helpers/models/category_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  Future<List<CategoryModal>> fetchCategories() async {
    final response =
        await Supabase.instance.client
            .from('Category') // your table name
            .select();

    final data = response as List<dynamic>;
    return data.map((item) => CategoryModal.fromJson(item)).toList();
  }

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    final controller = Get.put(WishlistController());

    return Scaffold(
      body: Container(
        height: TDeviceUtils.getScreenHeight(),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0.5, 0.5),
            radius: 1.8,
            colors: [
              dark
                  ? TColors.primary.withOpacity(0.7)
                  : TColors.primary.withOpacity(0.7),
              dark
                  ? TColors.accent.withOpacity(0.7)
                  : TColors.accent.withOpacity(0.7),
              dark
                  ? TColors.accent.withOpacity(0.4)
                  : TColors.accent.withOpacity(0.4),
              dark
                  ? TColors.primary.withOpacity(0.2)
                  : TColors.primary.withOpacity(0.2),
              dark
                  ? Colors.black.withOpacity(0.05)
                  : Colors.white.withOpacity(0.05),
            ],
          ),
        ),

        child: SingleChildScrollView(
          child: Column(
  children: [
    const SizedBox(height: TSizes.spaceBetwwenSections),
    Padding(
      padding: const EdgeInsets.only(left: TSizes.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            TText.third_screen_text,
            style: Theme.of(context).textTheme.headlineMedium!.apply(
              color: dark ? TColors.primary : null,
            ),
          ),
          Icon(Iconsax.shopping_cart_copy),
        ],
      ),
    ),

    SizedBox(
      height: TDeviceUtils.getScreenHeight(),  // Give appropriate height
      child: Obx(() {
        return ListView.builder(
          itemCount: controller.wishlist.length,
          itemBuilder: (context, index) {
            final product = controller.wishlist[index];
            return GestureDetector(
               onTap:
          () => Get.to(
            () => ProductDetailScreen(
            
             productModel: product,
            ),
          ),
              child: ListTile(
                title: Row(
                  children: [
                    TRoundedImage(imageUrl: product.thumbnail!, width: 50, height: 50, isNetworkImage: true, backgroundColor: Colors.transparent,),
                    const SizedBox(width: TSizes.spaceBetwwenItems,),
                    Flexible(child: Text(product.title ?? 'No Title', style: Theme.of(context).textTheme.titleMedium, overflow: TextOverflow.ellipsis, softWrap: true,)),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => controller.removeFromWishlist(
                    product.id ?? '',
                  ),
                ),
              ),
            );
          },
        );
      }),
    ),

  
    const SizedBox(height: TSizes.spaceBetwwenItems),
  ],
),

        ),
      ),
    );
  }
}
