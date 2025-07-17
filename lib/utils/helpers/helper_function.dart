import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_shop/utils/constants/image_strings.dart';

class THelperFunction {

static String getOrderStatus(String value) {
  switch (value) {
    case 'Order Placed':
      return TImages.order_placed_icon; // Indicates start of process
    case 'Confirmed':
      return TImages.order_confirmed_icon; // Confirmed and locked
    case 'Packed':
      return TImages.order_packed_icon; // Ready for shipping
    case 'Shipped':
      return TImages.order_shipped_icon; // On logistics
    case 'On the way':
      return TImages.order_shipped_icon; // En route
    case 'Deliveried':
      return TImages.order_out_for_delivery; // Success, completed
    case 'Cancelled':
      return TImages.order_cancelled; // Optional: add for completeness
    default:
      return TImages.order_deliveried; // Unknown status
  }
}


  static Color? getColor(String value) {


    if(value == 'Green') {
      return Colors.green;
    } else if (value == 'Green') {
      return Colors.green;
    } else if (value == 'Red') {
      return Colors.red;
    } else if (value == 'Blue') {
      return Colors.blue;
    } else if (value == 'Pink') {
      return Colors.pink;
    } else if (value == 'Grey') {
      return Colors.grey;
    }
    return null;
  }

  static void showSnackBar(String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }


  static void showAlert(String title, String message) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Ok')),
          ],
        );
      }
    );
  }

  static void navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength);
    }
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }


  static Size screenSize(){
    return MediaQuery.of(Get.context!).size;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(Get.context!).size.height;
  }

   static double screenWidth(BuildContext context) {
    return MediaQuery.of(Get.context!).size.width;
  }
}