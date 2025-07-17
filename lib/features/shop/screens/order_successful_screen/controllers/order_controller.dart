import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:online_shop/features/shop/screens/order_successful_screen/controllers/monthly_sales_controller.dart';
import 'package:online_shop/utils/helpers/models/order_model.dart';
  import 'package:supabase_flutter/supabase_flutter.dart';

class OrderController extends GetxController {
  static OrderController get to => Get.find();

  final RxList<OrderModel> orders = <OrderModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  RxList<Map<String, dynamic>> shippingAddressList = <Map<String, dynamic>>[].obs;

Future<void> fetchShippingAddress(String orderId) async {
  try {
    final response = await Supabase.instance.client
        .from('orders')
        .select('shippingAddress')
        .eq('orderID', orderId)
        .single();

    if (response != null && response['shippingAddress'] != null) {
      shippingAddressList.value = List<Map<String, dynamic>>.from(response['shippingAddress']);
      print('🟢 Shipping Address loaded: ${shippingAddressList.length}');
    }
  } catch (e, s) {
    print('🔴 Error shippingAddress order: $e\n$s');
  }
}

  Future<void> fetchOrders() async {
    final supabase = Supabase.instance.client;
    final storage = GetStorage();
    try {
      final response = await supabase.from('orders').select().eq('userID', storage.read('UID'));
      orders.value = (response as List)
          .map((json) => OrderModel.fromJson(json as Map<String, dynamic>))
          .toList();

      print('Fetched ${orders.length} orders from Supabase');
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  Future<void> saveOrder(OrderModel order) async {
    final supabase = Supabase.instance.client;
    final montlyStatsController = Get.put(MonthlySalesController());

    try {
      await supabase.from('orders').insert(order.toJson());

      montlyStatsController.updateMonthlySales(order.totalPrice!.toDouble(), orders.length, 1);
      fetchOrders(); // Refresh after saving
    } catch (e) {
      print('Failed to save order: $e');
    }
  }

  Future<void> cancelOrder(OrderModel order) async {
    final supabase = Supabase.instance.client;

    try {
      await supabase.from('orders').update( {'orderStatus': 'cancelled'})
          .eq('orderID', order.orderID as Object);
      fetchOrders(); // Refresh after saving
    } catch (e) {
      print('Failed to save order: $e');
    }
  }

  Future<void> reOrder(OrderModel order) async {
    final supabase = Supabase.instance.client;

    try {
      await supabase.from('orders').update( {'orderStatus': 'placed'})
          .eq('orderID', order.orderID as Object);
      fetchOrders(); // Refresh after saving
    } catch (e) {
      print('Failed to save order: $e');
    }
  }


  Future<void> updateProductStocks(String productID, int selectedStock) async {
    final supabase = Supabase.instance.client;




    final getStock = await supabase.from('products').select('stock').eq('id', productID).maybeSingle();

    final updatedStock = getStock!['stock'] - selectedStock;

       final response = await supabase.from('products').update({'stock' : updatedStock}).eq('id', productID);

  }
}
