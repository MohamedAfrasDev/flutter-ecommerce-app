import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:online_shop/features/authentication/screens/product_review_screen/product_review_screen.dart';
import 'package:online_shop/features/shop/products/product_detail.dart';
import 'package:online_shop/features/shop_2/screens/controller/qr_code_controller.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/helpers/models/order_model.dart';

class QRScannerScreen extends StatefulWidget {
  final Function(String) onScan;

  const QRScannerScreen({Key? key, required this.onScan}) : super(key: key);

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final QrCodeController qrCodeController = Get.put(QrCodeController());
  final MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal, // Default speed
    facing: CameraFacing.back,
    returnImage: false,
    detectionTimeoutMs: 250,
  );

  bool _scanned = false;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _handleBarcode(BarcodeCapture capture) async {
    if (_scanned) return;

    final String? code = capture.barcodes.first.rawValue;
    if (code != null) {
      _scanned = true;
      widget.onScan(code);
      Navigator.pop(context);
      await Future.delayed(const Duration(milliseconds: 200)); // <-- Add delay
      final productData = await qrCodeController.fetchProductByQRCode(code);
final orderModel = OrderModel.fromJson(productData!);

      if (productData != null) {
        Get.to(
          () =>  ProductReviewScreen(orderModel: orderModel),
        );
      } else {
        // Handle no product found
        print('No product found with code:🔴🔴🔴🔴 $code');
        // Show snackbar, dialog, or toast here as feedback
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: Stack(
        children: [
         Text('Scan the QR Code to to review the product', style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center,),
         const SizedBox(height: TSizes.spaceBetwwenItems,),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child:  MobileScanner(controller: cameraController, onDetect: _handleBarcode),
            ),
          ),
        ],
      ),
    );
  }
}
