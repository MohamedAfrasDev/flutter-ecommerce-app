import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:online_shop/features/shop/screens/home/widgets/home_categories.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';
import 'package:online_shop/features/shop_2/screens/home/widgets/gl.dart';

class TTabViewICategory extends StatelessWidget {
  const TTabViewICategory({super.key, this.isTab1 = true});

  final bool isTab1;

  // Load all active tabs
  Future<List<Map<String, dynamic>>> loadTabCategories() async {
    final response = await Supabase.instance.client
        .from('tab_config')
        .select()
        .eq('is_active', true)
        .eq('tab_location', isTab1 ? 'home' : 'store')
        .order('order', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  // Load items under each tab
  Widget _buildTabContent(Map<String, dynamic> tabItem) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: Supabase.instance.client
          .from('tab_categories')
          .select()
          .eq('tab_id', tabItem['id']),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No items found"));
        }

        final categories = snapshot.data!;
        return THomeCategories(
          dataList: categories,
          isIcon: tabItem['is_icon'] ?? false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: loadTabCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No categories found"));
        }

        final tabData = snapshot.data!;

        return DefaultTabController(
          length: tabData.length,
          animationDuration: const Duration(milliseconds: 500),
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
                        tabBarTheme: const TabBarTheme(
                          overlayColor: MaterialStatePropertyAll(Colors.transparent),
                          dividerColor: Colors.transparent,
                        ),
                      ),
                      child: WhiteGlassCard(
                        child: TabBar(
                          isScrollable: true,
                          labelColor: TColors.primary,
                          unselectedLabelColor: dark ? Colors.white : Colors.grey,
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
                            color: dark ? TColors.productCardDark : Colors.white,
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          tabs: tabData.map((item) {
                            final title = item['title']?.toString() ?? 'Tab';
                            return Tab(text: title);
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBetwwenItems),
              SizedBox(
                height: 150,
                child: TabBarView(
                  children: tabData.map((item) => _buildTabContent(item)).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
