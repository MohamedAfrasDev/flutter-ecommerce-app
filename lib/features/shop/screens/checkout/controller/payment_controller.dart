
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:online_shop/features/shop/screens/checkout/model/payment_add_model.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/helpers/models/order_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class PaymentController extends GetxController {
   var paymentMethods = <String>[].obs;
  var paymentMethod = ''.obs;

  var isPay = false.obs;


  final TextEditingController aPIKeyController = TextEditingController();
  var apiKey = ''.obs;
  final hasAPIChanged = false.obs;
  final TextEditingController merchantIDController = TextEditingController();
  var merchantID = ''.obs;
  final hasMerchantIDChanged = false.obs;
  final TextEditingController paymentMethodController = TextEditingController();
  final hasPaymentMethodChanged = false.obs;
 var isLoading = true.obs;
 var payments = <PaymentAddModel>[].obs;

final isSandBox = false.obs;

final isInclude = false.obs;

final finalAmountt = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPayments();
fetchPaymentMethods();
   
  }


  Future<void> placeOrder(OrderModel order) async {
    final supabase = Supabase.instance.client;

    try{
      final response = await supabase.from('orders').insert(order.toJson());
      
    } catch (e) {
      print("Error ${e.toString()}");
    }
  }


Future<void> fetchPaymentMethods() async {
  final supabase = Supabase.instance.client;

  final response = await supabase
      .from('payment_credentials')
      .select('PaymentProvider');

  if (response.isNotEmpty) {
    paymentMethods.value = List<String>.from(
      response.map((e) => e['PaymentProvider']),
    );
  }

  // Always add COD manually if not present
 if (!paymentMethods.contains('Cash on delivery')) {
  paymentMethods.insert(0, 'Cash on delivery');  // Adds COD to the top of the list
}


  if (paymentMethods.isNotEmpty) {
    paymentMethod.value = paymentMethods.first;
  }
}

  Future<void> fetchPayments() async {
    try {
      final data = await Supabase.instance.client
          .from('payment_credentials')
          .select()
          .order('created_at', ascending: false);

      payments.value =
          (data as List).map((e) => PaymentAddModel.fromJson(e)).toList();
    } catch (e) {
      print('❌ Error fetching payments: $e');
    } finally {
      isLoading.value = false;
    }
  }
  bool isAPI() {
    return aPIKeyController.text != apiKey.value;
  }
bool isProcessing() {
    return processingFeeController.text != processingFee.value;
  }
   bool isMerhchantID() {
    return merchantIDController.text != merchantID.value;
  }




 Future<bool> getSandBoxMode(String paymentMethod) async {
  try {
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('payment_credentials')
        .select('isSandBox')
        .eq('PaymentProvider', paymentMethod)
        .maybeSingle();

    return response?['isSandBox'] == true;
  } catch (e) {
    print('🔴 getSandBoxMode error: $e');
    return false;
  }
}

Future<double> getProcessingFee(String paymentMethod) async {
  try {
    final supabase = Supabase.instance.client;

    final response = await supabase
        .from('payment_credentials')
        .select('processing_fee')
        .eq('PaymentProvider', paymentMethod)
        .maybeSingle();

    return (response != null && response['processing_fee'] != null)
        ? double.tryParse(response['processing_fee'].toString()) ?? 0
        : 0;
  } catch (e) {
    print("🔴 Error: $e");
    return 0;
  }
}


final TextEditingController processingFeeController = TextEditingController();
var processingFee = ''.obs;
final hasProcessingFeeChanged = false.obs;



  
}
