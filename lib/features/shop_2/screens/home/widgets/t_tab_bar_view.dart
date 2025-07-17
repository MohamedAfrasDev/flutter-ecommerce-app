import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:online_shop/features/shop/controllers/home_controller.dart';
import 'package:online_shop/features/shop/screens/home/controllers/home_controllers.dart';
import 'package:online_shop/features/shop/screens/home/widgets/product_slider_category.dart';
import 'package:online_shop/features/shop_2/screens/home/widgets/gl.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';

class TTabViewItems extends StatelessWidget {
  const TTabViewItems({super.key});

  Widget _buildTabContent(Map<String, dynamic> item) {
    return TProductSliderCategory(
      tabId: item['id'] ?? '',
      reverse: false,
      variation: true,
      topRated: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeControllers.instance);
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: controller.loadTabCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No categories found"));
        }

        final tabData = snapshot.data!;

        final dark = THelperFunction.isDarkMode(context);

        return DefaultTabController(
          animationDuration: Duration(milliseconds: 500),
          length: tabData.length,
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: TSizes.sm),
                  Expanded(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        tabBarTheme: TabBarTheme(
                          overlayColor: MaterialStateProperty.all(
                            Colors.transparent,
                          ),
                          dividerColor: Colors.transparent,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              dark
                                  ? Colors.white.withOpacity(0.15)
                                  : Colors.white.withOpacity(0.35),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.2),
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TabBar(
                          tabAlignment: TabAlignment.center,
                          isScrollable: true,

                          labelColor: TColors.primary,
                          unselectedLabelColor:
                              dark ? Colors.white : Colors.grey,
                          labelStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Poppins',
                          ),
                          unselectedLabelStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Poppins',
                          ),
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: TColors.primary),
                            color:
                                dark
                                    ? TColors.dark.withOpacity(0.6)
                                    : Colors.white.withOpacity(0.8),
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          tabs:
                              tabData
                                  .map((item) => Tab(text: item['title']))
                                  .toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBetwwenItems),
              SizedBox(
                height: 320,
                child: TabBarView(
                  children:
                      tabData.map((item) => _buildTabContent(item)).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
