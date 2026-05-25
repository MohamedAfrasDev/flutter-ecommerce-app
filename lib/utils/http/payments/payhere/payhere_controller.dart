import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PayhereController extends GetxController {
  static PayhereController get instance => Get.find();

  Future<void> getAppPaymentCredentials() async {
    final supabase = Supabase.instance.client;
    final storage = GetStorage();

    try {
      final apiResponse = await supabase
          .from('payment_credentials')
          .select('APIKey')
          .eq('PaymentProvider', 'PayHere')
          .maybeSingle();

      if (apiResponse != null) {
        storage.write('APIKey', apiResponse['APIKey'].toString());
      }
    } catch (e) {
      debugPrint('Error fetching API key: $e');
    }

    try {
      final merchantResponse = await supabase
          .from('payment_credentials')
          .select('MerchantID')
          .eq('PaymentProvider', 'PayHere')
          .maybeSingle();

      if (merchantResponse != null) {
        storage.write('MerchantID', merchantResponse['MerchantID'].toString());
      }
    } catch (e) {
      debugPrint('Error fetching Merchant ID: $e');
    }

    try {
      final sandboxResponse = await supabase
          .from('payment_credentials')
          .select('isSandBox')
          .eq('PaymentProvider', 'PayHere')
          .maybeSingle();

      if (sandboxResponse != null) {
        storage.write('isSandBox', sandboxResponse['isSandBox'] == true);
      }
    } catch (e) {
      debugPrint('Error fetching sandbox config: $e');
    }
  }
}
