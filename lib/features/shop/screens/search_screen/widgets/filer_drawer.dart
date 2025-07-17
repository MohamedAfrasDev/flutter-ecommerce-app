import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:online_shop/features/shop/screens/search_screen/controller/search_controller.dart';

class FilterDrawer extends StatefulWidget {
  const FilterDrawer({super.key, required this.controller});
  final ProductSearchController controller;

  @override
  State<FilterDrawer> createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  @override
  void initState() {
    super.initState();
    widget.controller.fetchCategories();
    widget.controller.fetchBrands();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Filters', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            const Text('Category'),
            Obx(() => DropdownButton<String>(
              value: widget.controller.selectedCategory.value.isEmpty
                  ? null
                  : widget.controller.selectedCategory.value,
              isExpanded: true,
              hint: const Text('Select category'),
              items: widget.controller.categories
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => widget.controller.updateFilters(category: val),
            )),

            const SizedBox(height: 20),
          const Text('Brand'),
Obx(() {
  final selected = widget.controller.selectedBrand.value;
  final brandItems = widget.controller.brands.toSet().toList(); // removes duplicates

  return DropdownButton<String>(
    value: selected.isEmpty || !brandItems.contains(selected) ? null : selected,
    isExpanded: true,
    hint: const Text('Select brand'),
    items: brandItems
        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
        .toList(),
    onChanged: (val) => widget.controller.updateFilters(brand: val),
  );
}),


            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                widget.controller.fetchSearchResults();
              },
              child: const Text('Apply Filters'),
            )
          ],
        ),
      ),
    );
  }
}
