// lib/features/search/controllers/search_controller.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_shop/utils/repository/product_model/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductSearchController extends GetxController {
  final searchText = ''.obs;
  final RxList<ProductModel> searchResults = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;

  // Filter fields
  final selectedCategory = ''.obs;
  final selectedBrand = ''.obs;
  final RangeValues priceRange = const RangeValues(0, 10000);

  void updateSearch(String query) {
    searchText.value = query;
    fetchSearchResults();
  }

void updateFilters({String? category, String? brand}) {
  if (category != null) {
    selectedCategory.value = category;
  } else if (category == '') {
    selectedCategory.value = '';
  }

  if (brand != null) {
    selectedBrand.value = brand;
  } else if (brand == '') {
    selectedBrand.value = '';
  }

  fetchSearchResults();
}
Future<void> fetchSearchResults() async {
  isLoading.value = true;

  try {
    final client = Supabase.instance.client;
    var query = client.from('products').select();

    if (searchText.value.isNotEmpty) {
      query = query.ilike('title', '%${searchText.value}%');
    }

    if (selectedCategory.value.isNotEmpty) {
      query = query.filter(
        'categories',
        'cs',
        jsonEncode([{"title": selectedCategory.value}]),
      );
    }

    if (selectedBrand.value.isNotEmpty) {
      query = query.filter(
        'brand->>title', // <-- here, to filter by brand title inside JSON
        'eq',
        selectedBrand.value,
      );
    }

    final data = await query.limit(20);

    final results = (data as List)
        .map((json) => ProductModel.fromJson(json))
        .toList();

    searchResults.assignAll(results);
  } catch (e) {
    print('Search error: $e');
  } finally {
    isLoading.value = false;
  }
}



  final RxList<String> categories = <String>[].obs;

Future<void> fetchCategories() async {
  try {
    final data = await Supabase.instance.client
        .from('tab_categories') // your table name
        .select('title');   // or 'name' depending on your column

    final List<String> fetchedCategories =
        (data as List).map((e) => e['title'].toString()).toList();

    categories.assignAll(fetchedCategories);
  } catch (e) {
    print('Error fetching categories: $e');
  }
}
final RxList<String> brands = <String>[].obs;

Future<void> fetchBrands() async {
  try {
    final data = await Supabase.instance.client
        .from('brands') // table name
        .select('title');

    final List<String> fetchedBrands =
        (data as List).map((e) => e['title'].toString()).toList();

    brands.assignAll(fetchedBrands);
  } catch (e) {
    print('Error fetching brands: $e');
  }
}


}
