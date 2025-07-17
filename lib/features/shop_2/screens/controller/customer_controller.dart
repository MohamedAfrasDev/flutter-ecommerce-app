import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_shop/features/authentication/screens/login/login.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/helpers/models/customer_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CustomerController extends GetxController{
  static CustomerController get instance => Get.find();

  final supabase = Supabase.instance.client;

  final user = Rxn<CustomerModel>();

  @override
  void initState(){
    super.onInit();
    getUserDetail(supabase.auth.currentUser!.id);
  }

Future<void> getUserDetail(String id) async {
  try {
    final response = await supabase
        .from('customers')
        .select()
        .eq('customerID', id)
        .maybeSingle();  // Use maybeSingle to get a single record or null

    if (response != null) {
      // Assuming user is an RxMap or Rx<UserModel>
      user.value = CustomerModel.fromJson(response);
      print('🎫🎫🎫 ${user.value!.customerID!}');
    } else {
      print("No user found for the given id and email 🎫🎫.");
    }
  } catch (e) {
    print("🔴🔴🔴 Error fetching user details: $e");
  }
}




Future<void> checkAndCreateCustomer(CustomerModel customer) async {
  try {
    final response = await supabase
        .from('customers')
        .select('customerID')
        .eq('customerID', customer.customerID!)
        .maybeSingle();

    if (response != null) {
      print('🟢 Customer already exists: ${customer.customerID}');
    } else {
      // Insert new customer
      final insertResponse = await supabase
          .from('customers')
          .insert(customer.toJson());

      print('✅ New customer created: ${customer.customerID}');
       Get.offAll(() => LoginScreen());
        Get.snackbar(
          'Sign Up',
          'Sign-up successful! Please verify your email.',
          backgroundColor: TColors.primary,
          colorText: Colors.white,
        );
    }
  } catch (e) {
    print('❌ Error in checkAndCreateCustomer: $e');
  }
}


Future<bool> checkCustomerExist(String id) async {
  final response = await supabase
      .from('customers')
      .select('customerID')
      .eq('customerID', id)
      .maybeSingle();

  return response != null;
}

  Future<void> addCustomer(String id) async {
    final newCustomer = CustomerModel(customerID: id, customerName: 'customerName', customerPhoneNumber: 'customerPhoneNumber', customerEmail: 'customerEmail', totalOrder: 'totalOrder', totalSpent: 'totalSpent', currentOrders: 'currentOrders', created_at: DateTime.now(), customerImage: 'No Image');
print(id);
   try{
 final response = await supabase.from('customers').insert(newCustomer.toJson());
   }catch (e) {
    print("🎫🎫 ${e.toString()}");
   }


  }
}