import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/t_rounded_image.dart';
import 'package:online_shop/features/shop/products/controller/time_get_controller.dart';
import 'package:online_shop/features/shop/screens/cart/controller/cart_controller.dart';
import 'package:online_shop/features/shop/screens/checkout/controller/payment_controller.dart';
import 'package:online_shop/features/shop/screens/home/controllers/home_controllers.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';
import 'package:online_shop/utils/http/app/app_config.dart';

class TBillingAmountSections extends StatefulWidget {
  const TBillingAmountSections({
    super.key,
    required this.products,
    this.isFastCheckout = false,
    this.shippingCost,
  });

  final List<dynamic> products;
  final bool isFastCheckout;
  final int? shippingCost;

  @override
  State<TBillingAmountSections> createState() => _TBillingAmountSectionsState();
}

class _TBillingAmountSectionsState extends State<TBillingAmountSections> {
  final paymentController = Get.put(PaymentController());

  var paymentMethod = 'Cash on delivery'.obs;


  final storage = GetStorage();

  var processingFee = 0.0.obs;
  var processingAmount = 0.0.obs;

  var orderAmount = 0.0.obs;

      final cartCon = Get.put(CartController());


  Future<void> _initPaymentDetails(String paymentMethods) async {
    paymentMethod.value = paymentMethods; // 🟩 or get from widget/args
    paymentController.paymentMethod.value = paymentMethods;

    final fee = await paymentController.getProcessingFee(paymentMethod.value);
    final controller = Get.put(CartController());

    orderAmount = controller.totalPrice.obs;

    setState(() {
      processingFee.value = fee.toDouble();
          double totalAmount =
        widget.isFastCheckout
            ? controller.totalPriceFast
            : controller.totalPrice; // Example total amount
    double processingFeeAmount = (totalAmount * processingFee.value) / 100;
    double finalAmount = totalAmount + processingFeeAmount;

    orderAmount.value = finalAmount;
    processingAmount.value = processingFeeAmount.toDouble();

    print("saas $paymentMethods");
    });
  }

  @override
  void initState(){
    super.initState();
        paymentController.paymentMethod.value = paymentMethod.toString();
  if(paymentMethod.toString()=='Cash on delivery'){
    setState(() {
      orderAmount.value = widget.isFastCheckout ? cartCon.totalPriceFast : cartCon.totalPrice;
    });
  } 
  }     

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    final controller = Get.put(CartController());



    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Subtotal', style: Theme.of(context).textTheme.bodyMedium),
            if (!widget.isFastCheckout)
              Text(
                '${storage.read('currency_symbol')} ${controller.subTotal}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            if (widget.isFastCheckout)
              Text(
                '${TAppConfig.currency_symbol} ${controller.subTotalFast}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
          ],
        ),
        const SizedBox(height: TSizes.spaceBetwwenItems / 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Shipping Fee', style: Theme.of(context).textTheme.bodyMedium),
            Text(
              '${storage.read('currency_symbol')} ${widget.shippingCost.toString()}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),

        const SizedBox(height: TSizes.spaceBetwwenItems / 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tax Fee', style: Theme.of(context).textTheme.bodyMedium),
            Text('${storage.read('currency_symbol')} 500', style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
        const SizedBox(height: TSizes.md),
        SizedBox(
          width: 250,
          height: 50,
          child: Obx(() {
            return DropdownButtonFormField<String>(
              value:
                  paymentController.paymentMethod.value.isNotEmpty
                      ? paymentController.paymentMethod.value
                      : null,
              decoration: InputDecoration(
                labelText: 'Payment Method',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color:
                        dark
                            ? Colors.grey.withOpacity(0.5)
                            : TColors.dark.withOpacity(0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color:
                        dark
                            ? Colors.white.withOpacity(1)
                            : TColors.dark.withOpacity(1),
                  ),
                ),
              ),
              items:
                  paymentController.paymentMethods.map((method) {
                    return DropdownMenuItem(
                      value: method,
                      child: Row(
                        children: [
                          TRoundedImage(
                            imageUrl: TImages.appLightLogo,
                            width: 50,
                            fit: BoxFit.cover,
                            backgroundColor: Colors.transparent,
                            isNetworkImage: false,
                            height: 50,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            method,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
              onChanged: (value) {
                if (value != null) {
                  paymentController.paymentMethod.value = value;
                  _initPaymentDetails(value);
                }
              },
            );
          }),
        ),
        const SizedBox(height: TSizes.sm),

        Obx(() {
          if (paymentMethod.value != 'Cash on delivery') {
            return Text(
              'Processing ${processingFee.toString()}%  ${storage.read('currency_symbol')} ${processingAmount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.labelMedium,
            );
          }
          return SizedBox.shrink();
        }),

        const SizedBox(height: TSizes.spaceBetwwenItems),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Order Total', style: Theme.of(context).textTheme.bodyMedium),
            Text(
              '${storage.read('currency_symbol')} ${orderAmount.toString()}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ],
    );
  }
}
