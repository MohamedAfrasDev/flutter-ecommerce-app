import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PayhereController extends GetxController {
  static PayhereController get instance => Get.find();

  Future<void> getAppPaymentCredentials() async {
    final supabase = Supabase.instance.client;
    final storage = GetStorage();

    try {
      final API =
          await supabase
              .from('payment_credentials')
              .select('APIKey')
              .eq('PaymentProvider', 'PayHere')
              .maybeSingle();

      print('🟢 Supabase check resasa🎫🎫sult: $API');

      API?['APIKey'].toString();


      storage.write('APIKey', API!['APIKey'].toString());
            print('APKI 🧑🏻‍💻🧑🏻‍💻 ${storage.read('APIKey')}');

    } catch (e) {
      print('🔴 Error fetching review config: ${e.toString()}');
    }

    try {
      final MerchantID =
          await supabase
              .from('payment_credentials')
              .select('MerchantID')
              .eq('PaymentProvider', 'PayHere')
              .maybeSingle();

      print('🟢 Supabase check resasa🎫🎫sult: $MerchantID');

      MerchantID?['MerchantID'].toString();
      storage.write('MerchantID', MerchantID!['MerchantID'].toString());
            print('MERCHANT 🧑🏻‍💻🧑🏻‍💻 ${storage.read('MerchantID')}');

    } catch (e) {
      print('🔴 Error fetching review config: ${e.toString()}');
    }



     try {
      final checkSandbox =
          await supabase
              .from('payment_credentials')
              .select('isSandBox')
              .eq('PaymentProvider', 'PayHere')
              .maybeSingle();

      print('🟢 Supabase check resasa🎫🎫sult: $checkSandbox');

      checkSandbox?['APIKey'].toString();

      bool isCheck = checkSandbox!['isSandBox'] == true ? true : false;


      storage.write('isSandBox', isCheck);
            print('isSandBox 🧑🏻‍💻🧑🏻‍💻 ${storage.read('isSandBox')}');

    } catch (e) {
      print('🔴 Error fetching review config: ${e.toString()}');
    }
  }
}
