import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:online_shop/common/widgets/custom_shapes/appbar/appbar.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:online_shop/features/personailization/controllers/address_add_controller.dart';
import 'package:online_shop/features/shop/products/controller/time_get_controller.dart';
import 'package:online_shop/features/shop/screens/cart/controller/cart_controller.dart';
import 'package:online_shop/features/shop/screens/cart/controller/cart_item_model.dart';
import 'package:online_shop/features/shop/screens/cart/widgets/cart_item_view.dart';
import 'package:online_shop/features/shop/screens/checkout/controller/payment_controller.dart';
import 'package:online_shop/features/shop/screens/checkout/widgets/billing_address_section.dart';
import 'package:online_shop/features/shop/screens/checkout/widgets/billing_amount_section.dart';
import 'package:online_shop/features/shop/screens/checkout/widgets/billing_payment_section.dart';
import 'package:online_shop/features/shop/screens/checkout/widgets/coupon_code.dart';
import 'package:online_shop/features/shop/screens/order_successful_screen/order_successful.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';
import 'package:online_shop/utils/helpers/models/address_model.dart';
import 'package:online_shop/utils/helpers/models/order_model.dart';
import 'package:online_shop/utils/http/payments/payhere/config.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key, this.products = const []});

  final List<CartItem> products;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  List<AddressModel> addresses = [];
  AddressModel? selectedAddress;

  final paymentController = Get.put(PaymentController());
  var isPayTo = false.obs;

  final timeController = Get.put(TimeGetController());

  var shippingCost = 0.obs;

  @override
  void initState() {
    super.initState();
    loadAddresses();
    timeController.getShippingCost().then((cost) {
      setState(() {
        shippingCost.value = cost;
      });
    });
    ever(paymentController.isPay, (value) {
      print('🔄 isPay changed to: $value');
      paymentController.isPay.value = value;
    });
  }

  Future<void> loadAddresses() async {
    final loadedAddresses = await AddressAddController.instance.getAddresses();
    setState(() {
      addresses = loadedAddresses;
      if (addresses.isNotEmpty) {
        selectedAddress ??= addresses.first;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    final controller = Get.put(CartController());

    return Scaffold(
      appBar: TAppBar(
        showBackArrrow: true,
        title: Text(
          'Order Overview',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              TCartItemView(
                showAddRemoveButton: false,
                products: widget.products,
              ),
              const SizedBox(height: TSizes.spaceBetwwenSections),
              const TCouponCode(),
              const SizedBox(height: TSizes.spaceBetwwenSections),
              TRoundedContainer(
                padding: const EdgeInsets.all(TSizes.md),
                showBorder: true,
                width: double.infinity,
                backgroundColor: dark ? TColors.dark : TColors.textWhite,
                child: Column(
                  children: [
                    TBillingAmountSections(products: widget.products),
                    const Divider(height: 30),
                    const SizedBox(height: TSizes.spaceBetwwenItems),

                    /// Show selected address
                    if (selectedAddress != null)
                      TBillingAddress(
                        name: selectedAddress!.name,
                        address: selectedAddress!.street,
                        email: selectedAddress!.phone,
                        phoneNumer: selectedAddress!.phone,
                        onPressed: () => showAddressSelector(context),
                      )
                    else
                      TextButton.icon(
                        icon: const Icon(Icons.location_on),
                        label: const Text("Select Shipping Address"),
                        onPressed: () => showAddressSelector(context),
                      ),

                    const SizedBox(height: TSizes.spaceBetwwenItems),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(() {
        if (paymentController.isPay.value == true) {
          return Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: GestureDetector(
              onTap: () {
                if (selectedAddress != null) {

                  print(paymentController.finalAmountt.value.toString());
                  final config = Config(
                    paymentAmount: paymentController.finalAmountt.value.toString(),
                  );
                  config.startPayment(
                    widget.products,
                    selectedAddress,
                    controller.totalPrice.toString(),
                  );
                } else {
                  Get.snackbar(
                    'Address Required',
                    'Please select a shipping address before checkout.',
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: TColors.primary,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Pay & Place Order',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium!.apply(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: GestureDetector(
              onTap: () {
                if (selectedAddress != null) {
                  final storage = GetStorage();
                  
                  final payCont = Get.put(PaymentController());

                  double totalPrice = payCont.finalAmountt.value.toDouble();

                  print("sa ${payCont.finalAmountt.value.toString()}");

                  final orderID = generateOrderID();
                  final order = OrderModel(
                    orderID: orderID,
                    userID: storage.read('UID'),
                    orderStatus: 'placed',
                    paymentMethod: 'PayHere',
                    paymentStatus: 'Paid',
                    shippingAddress: [selectedAddress!],
                    billingAddress: [selectedAddress!],
                    totalPrice: totalPrice,
                    shippingCost: shippingCost.toDouble(),
                    subTotal: controller.totalPrice.toDouble(),
                    taxFee: 0,
                    currencySymbol: storage.read('currency_symbol'),
                    orderDate: DateTime.now(),
                    products:
                        widget.products.map((item) => item.toJson()).toList(),
                    couponCode: null,
                    note: null,
                  );

                  final paymentController = Get.put(PaymentController());
                  paymentController.placeOrder(order);
                  Get.offAll(
                    () => OrderSuccessfulScreen(
                      products: widget.products,
                      paymentID: 'No Payment ID',
                      addressModel:selectedAddress,
                      totalPayment: totalPrice.toString(),
                      orderID: orderID,
                    ),
                  );
                } else {
                  Get.snackbar(
                    'Address Required',
                    'Please select a shipping address before checkout.',
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: TColors.primary,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Place Order',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium!.apply(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        }
      }),
    );
  }

  String generateOrderID() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'ORDER-$timestamp';
  }

  void showAddressSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (_) => SafeArea(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              itemCount: addresses.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, index) {
                final address = addresses[index];
                final isSelected = selectedAddress?.id == address.id;

                return ListTile(
                  title: Text(address.name),
                  subtitle: Text('${address.street}, ${address.city}'),
                  trailing:
                      isSelected
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                  onTap: () {
                    setState(() => selectedAddress = address);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
    );
  }
}
