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
  var amountIncluded = 0.0.obs;

  final cartCon = Get.put(CartController());

  Future<void> _initPaymentDetails(String paymentMethods) async {
    paymentMethod.value = paymentMethods; // 🟩 or get from widget/args
    paymentController.paymentMethod.value = paymentMethods;

    final fee = await paymentController.getProcessingFee(paymentMethod.value);
    final controller = Get.put(CartController());

    orderAmount = controller.totalPrice.obs;

    amountIncluded = controller.totalPrice.obs;
    paymentController.isPay.value = paymentMethod.value != 'Cash on delivery';

    setState(() {
      processingFee.value = fee.toDouble();
      double totalAmount =
          widget.isFastCheckout
              ? controller.totalPriceFast
              : controller.totalPrice; // Example total amount
      double processingFeeAmount = ((totalAmount * processingFee.value) / 100);
      double finalAmount = (totalAmount + processingFeeAmount);

      amountIncluded.value = totalAmount + storage.read('shippingCost');
      orderAmount.value = finalAmount + storage.read('shippingCost');
      processingAmount.value = processingFeeAmount.toDouble();
      paymentController.isInclude.value = feeStructure.value=='include' ? true : false;

      paymentController.finalAmountt.value = feeStructure.value=='include' ? amountIncluded.value : orderAmount.value;
      print(paymentController.isInclude.value.toString());

      if(paymentController.isInclude.value == true) {
        paymentController.finalAmountt.value = amountIncluded.value;
      } else {
        paymentController.finalAmountt.value == orderAmount.value;
      }
      
      print("saas ${storage.read('shippingCost')}");
    });
  }

  final controller = Get.put(CartController());

  var feeStructure = ''.obs;

  final timeController = Get.put(TimeGetController());

  @override
  void initState() {
    super.initState();

    controller.getProcessingFeeStructure().then((value) {
      feeStructure.value = value.toString().toLowerCase();
      paymentController.isInclude.value = feeStructure.value=='include' ? true : false;
    });

    paymentController.paymentMethod.value = paymentMethod.value;

    if (paymentMethod.value == 'Cash on delivery') {
      paymentController.isPay.value = false;
      orderAmount.value =
          widget.isFastCheckout ? cartCon.totalPriceFast + storage.read('shippingCost') : cartCon.totalPrice + storage.read('shippingCost');
      amountIncluded.value =
          widget.isFastCheckout ? cartCon.totalPriceFast + storage.read('shippingCost'): cartCon.totalPrice + storage.read('shippingCost');
                paymentController.finalAmountt.value = feeStructure.value=='include' ? amountIncluded.value : orderAmount.value;

    } else {
      paymentController.isPay.value = true;
            paymentController.finalAmountt.value = feeStructure.value=='include' ? amountIncluded.value : orderAmount.value;

    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);

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
              '${storage.read('currency_symbol')} ${storage.read('shippingCost')}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),

        const SizedBox(height: TSizes.spaceBetwwenItems / 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tax Fee', style: Theme.of(context).textTheme.bodyMedium),
            Text(
              '${storage.read('currency_symbol')} 500',
              style: Theme.of(context).textTheme.labelLarge,
            ),
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
          if (paymentMethod.value != 'Cash on delivery' &&
              feeStructure.value.toString() == 'exclude') {
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
              paymentController.finalAmountt.value.toString(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ],
    );
  }
}
