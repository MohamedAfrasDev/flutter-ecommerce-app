import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:online_shop/common/styles/layouts/grid_view_layout.dart';
import 'package:online_shop/common/widgets/custom_shapes/search_bar/search_container.dart';
import 'package:online_shop/common/widgets/icons/circular_icons.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/section_heading.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/t_promo_slider.dart';
import 'package:online_shop/features/maintenence_mode/maintenence_mode.dart';
import 'package:online_shop/features/shop/products/controller/time_get_controller.dart';
import 'package:online_shop/features/shop/products/product_detail.dart';
import 'package:online_shop/features/shop/screens/home/widgets/cart_menu.dart';
import 'package:online_shop/features/shop/screens/home/widgets/product_slider_category.dart';
import 'package:online_shop/features/shop/screens/search_screen/search_screen.dart';
import 'package:online_shop/features/shop/screens/store/controller/store_controller.dart';
import 'package:online_shop/features/shop/screens/store/widgets/product_grid_item.dart';
import 'package:online_shop/features/shop_2/screens/controller/customer_controller.dart';
import 'package:online_shop/features/shop_2/screens/controller/home_slider_product.dart';
import 'package:online_shop/features/shop_2/screens/controller/qr_code_controller.dart';
import 'package:online_shop/features/shop_2/screens/home/widgets/qr_code_scanner.dart';
import 'package:online_shop/features/shop_2/screens/home/widgets/t_tab_bar_view.dart';
import 'package:online_shop/features/shop_2/screens/home/widgets/t_tab_bar_view_cat.dart';
import 'package:online_shop/navigation_menu.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:online_shop/features/shop/controllers/home_controller.dart';
import 'package:online_shop/features/shop/screens/home/controllers/home_controllers.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/products/product_card_vertical.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen_2 extends StatefulWidget {
  const HomeScreen_2({super.key});

  @override
  State<HomeScreen_2> createState() => _HomeScreen_2State();
}

class _HomeScreen_2State extends State<HomeScreen_2> {
  final StoreController storeController = Get.put(StoreController());
  final QrCodeController qrCodeController = Get.put(QrCodeController());
  final sliderController = Get.put(SliderProductController());
  final homeController = Get.put(HomeControllers());
  final customerController = Get.put(CustomerController());

  final timeController = Get.put(TimeGetController());

  bool _isLoading = true;

  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    storeController.fetchProducts(); // ✅ Initial product load
    homeController.getUser(Supabase.instance.client.auth.currentUser!.id);
         customerController.getUserDetail(Supabase.instance.client.auth.currentUser!.id);
homeController.getAppReviewEnabled().then((enabled) {
  print('🔴🔴🔴 Review Enabled: $enabled');
});

homeController.getAppMaintenenceEnabled().then((enable) {
  if(enable==true) {
    Get.offAll(() => const MaintenenceModeScreen());
  }
});

homeController.getAppCurrencySymbol().then((value) {
  setState(() {
    storage.write('currency_symbol', value);
  });
});



timeController.getShippingCost().then((cost) {
  setState(() { 
    print('cost✨✨✨ ad ${cost}');
    storage.write('shippingCost', cost);
  });
});


    _getGreeting();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {
      _precacheImages();
    }
  }

  Future<void> _precacheImages() async {
    final jsonString = await rootBundle.loadString(
      'assets/category_items.json',
    );
    final List<dynamic> jsonData = json.decode(jsonString);

    for (var item in jsonData) {
      final imagePath = item['image'] as String;
      await precacheImage(AssetImage(imagePath), context);
    }

    setState(() => _isLoading = false);
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning!';
    } else if (hour < 17) {
      return 'Good Afternoon!';
    } else {
      return 'Good Evening!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    final controller = Get.put(HomeController());
    final controllerNav = Get.put(NaviagtionController());

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            focal: const Alignment(0.5, 0.4),
            radius: 2,
            colors: [
              dark
                  ? TColors.primary.withOpacity(0.5)
                  : TColors.primary.withOpacity(0.5),
              dark
                  ? TColors.accent.withOpacity(0.5)
                  : TColors.accent.withOpacity(0.4),
              dark
                  ? TColors.primary.withOpacity(0.1)
                  : TColors.primary.withOpacity(0.01),
              dark
                  ? Colors.black.withOpacity(0.1)
                  : Colors.white.withOpacity(0.1),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: TSizes.defaultSpace),
              const SizedBox(height: TSizes.spaceBetwwenSections),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    child: Row(
                      children: [
                        TCircularIcon(icon: Iconsax.user_copy),
                        const SizedBox(width: TSizes.spaceBetwwenItems),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getGreeting(),
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Obx(() {
                              final user = homeController.user.value;
                              if (user == null) {
                                return Text(
                                  'Loading...',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .apply(color: TColors.primary),
                                );
                              }

                              return Text(
                                user.customerName ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .apply(color: TColors.primary),
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: TCartCounterIcon(
                      onPressed: () {},
                      iconColor: TColors.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: TSizes.spaceBetwwenItems),

              // Search Bar
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.to(() => SearchScreen()),
                      child: TSearchContainer(text: 'Search Products'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: TCircularIcon(
                      icon: Iconsax.code,
                      onPressed:
                          () => Get.to(
                            () => QRScannerScreen(
                              onScan: (String qr) async {
                                print('Scanned QR: 👍👍👍 $qr');
                              },
                            ),
                          ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: TSizes.sm),

              // Promo Slider
              Padding(
                padding: const EdgeInsets.all(TSizes.sm),
                child: Obx(() {
                  return controller.banners.isEmpty
                      ? const CircularProgressIndicator()
                      : RepaintBoundary(child: TPromoSlider(isPadding: false));
                }),
              ),

              // Category Tabs
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.defaultSpace,
                ),
                child: TSectionHeading(
                  title: 'What are you looking for ?',
                  onPressed: () => controllerNav.selectedIndex.value = 1,
                  showActionButton: false,
                ),
              ),
              const TTabViewICategory(isTab1: true),
              const SizedBox(height: TSizes.spaceBetwwenItems),
              TTabViewItems(),

              const SizedBox(height: TSizes.spaceBetwwenSections),

              Padding(
                padding: const EdgeInsets.only(left: TSizes.lg),
                child: TSectionHeading(title: 'Similar Products', showActionButton: false,),
              ),
              const SizedBox(height: TSizes.spaceBetwwenItems),
              TProductSliderCategory(
                reverse: true,
                variation: true,
                topRated: true,
              ),
              const SizedBox(height: TSizes.spaceBetwwenSections),

              Padding(
                padding: const EdgeInsets.only(left: TSizes.lg),
                child: TSectionHeading(title: 'Featured for you', showActionButton: false,),
              ),
              // ✅ Product Grid View
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Obx(() {
                  if (storeController.isLoading.value &&
                      storeController.products.isEmpty) {
                    return const CircularProgressIndicator();
                  } else if (storeController.products.isEmpty) {
                    return Text(
                      'No Products Found',
                      style: Theme.of(context).textTheme.bodyLarge,
                    );
                  } else {
                    return GridViewLayout(
                      itemCount: storeController.products.length,
                      itemBuilder: (_, index) {
                        final product = storeController.products[index];

                        return TProductGridItem(productModel: product);
                      },
                      shrinkWrap: true,
                    );
                  }
                }),
              ),

              // Load More Button
              const SizedBox(height: TSizes.spaceBetwwenItems),
              Obx(() {
                return Column(
                  children: [
                    if (storeController.hasMore.value &&
                        !storeController.isLoading.value)
                      GestureDetector(
                        onTap:
                            () => storeController.fetchProducts(loadMore: true),
                        child: Container(
                          decoration: BoxDecoration(
                            color: TColors.primary,
                            border: Border.all(
                              color:
                                  dark
                                      ? Colors.grey.withOpacity(0.5)
                                      : TColors.dark.withOpacity(0.2),
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Load More',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    if (!storeController.hasMore.value)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'No more products',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    if (storeController.isLoading.value &&
                        storeController.page > 0)
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                  ],
                );
              }),
              const SizedBox(height: TSizes.spaceBetwwenSections),
            ],
          ),
        ),
      ),
    );
  }
}
