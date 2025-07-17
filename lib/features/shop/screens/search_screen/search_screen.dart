import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:online_shop/features/shop/screens/search_screen/controller/search_controller.dart';
import 'package:online_shop/features/shop/screens/search_screen/widgets/filer_drawer.dart';
import 'package:online_shop/features/shop/screens/search_screen/widgets/product_item_search.dart';
import 'package:online_shop/features/shop/screens/store/widgets/product_grid_item.dart';
import 'package:online_shop/utils/constants/image_strings.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final controller = Get.put(ProductSearchController());
  

@override
void initState() {
  super.initState();
  controller.fetchCategories();
}


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = 2;
    final itemWidth = (screenWidth) / crossAxisCount; // 12 padding + 16 spacing
    final itemHeight = 360; // Approximate height your card content needs

    return Scaffold(
      endDrawer: FilterDrawer(controller: controller),
      appBar: AppBar(
        title: TextField(
          onChanged: controller.updateSearch,
          decoration: const InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.searchResults.isEmpty) {
          return  SingleChildScrollView(
            child: Column(
              children: [
                Lottie.asset(TImages.search_animation, width: 400, height: 400),
                Text('Search Anything', style: Theme.of(context).textTheme.bodyLarge,)
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(12),
          child: GridView.builder(
            itemCount: controller.searchResults.length,
            physics: const BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: itemWidth / itemHeight,
            ),
            itemBuilder: (context, index) {
              final product = controller.searchResults[index];
              return TProductItemSearch(
               
                productModel: product,
              );
            },
          ),
        );
      }),
    );
  }
}
