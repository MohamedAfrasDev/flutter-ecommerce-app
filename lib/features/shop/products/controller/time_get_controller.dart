import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TimeGetController extends GetxController{
  static TimeGetController get instance => Get.find();

Future<int> getDeliveryTime() async {
  final supabase = Supabase.instance.client;

  try {
    final response = await supabase
      .from('app_config')
      .select('value')
      .eq('title', 'deliveryInDistrict')
      .maybeSingle();

    if (response == null) {
      print('No config found for deliveryInDistrict');
      return 0; // or some default
    }

    final valueString = response['value']?.toString() ?? '0';
    final deliveryTime = int.tryParse(valueString) ?? 0;

    return await deliveryTime;
  } catch (e) {
    print('📞📞📞 Error: ${e.toString()}');
    return 0; // or handle error accordingly
  }
}
Future<int> getShippingCost() async {
  final supabase = Supabase.instance.client;

  try {
    final response = await supabase
        .from('app_config')
        .select('value')
        .eq('title', 'shippingCostInDistrict')
        .maybeSingle();

    if (response == null) {
      print('No config found for shippingCostInDistrict');
      return 0; // or some default
    }

    final valueString = response['value']?.toString() ?? '0';
    final shippingCost = int.tryParse(valueString) ?? 0;

    return shippingCost;
  } catch (e) {
    print('📞📞📞 Error: ${e.toString()}');
    return 0; // or handle error accordingly
  }
}

}