import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QrCodeController extends GetxController{
  static QrCodeController get instance => Get.find();
  final supabase = Supabase.instance.client;

Future<Map<String, dynamic>?> fetchProductByQRCode(String qrCode) async {
  final response = await supabase
      .from('orders')
      .select()
      .eq('orderID', qrCode)
      .maybeSingle();

  if (response == null) {
    print('No product found with QR: $qrCode');
    return null;
  }

  return response as Map<String, dynamic>?;
}


}