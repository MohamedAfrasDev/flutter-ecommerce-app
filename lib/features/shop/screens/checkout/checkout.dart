import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_shop/common/widgets/custom_shapes/appbar/appbar.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:online_shop/features/personailization/controllers/address_add_controller.dart';
import 'package:online_shop/features/shop/screens/cart/controller/cart_controller.dart';
import 'package:online_shop/features/shop/screens/cart/controller/cart_item_model.dart';
import 'package:online_shop/features/shop/screens/cart/widgets/cart_item_view.dart';
import 'package:online_shop/features/shop/screens/checkout/widgets/billing_address_section.dart';
import 'package:online_shop/features/shop/screens/checkout/widgets/billing_amount_section.dart';
import 'package:online_shop/features/shop/screens/checkout/widgets/billing_payment_section.dart';
import 'package:online_shop/features/shop/screens/checkout/widgets/coupon_code.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';
import 'package:online_shop/utils/helpers/models/address_model.dart';
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

  @override
  void initState() {
    super.initState();
    loadAddresses();
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
        title: Text('Order Overview', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              TCartItemView(showAddRemoveButton: false, products: widget.products),
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
                    TBillingPaymentSection(),
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: GestureDetector(
          onTap: () {
             if (selectedAddress != null) {
              final config = Config(paymentAmount: controller.totalPrice.toString());
              config.startPayment(widget.products, selectedAddress, controller.totalPrice.toString());
            } else {
              Get.snackbar('Address Required', 'Please select a shipping address before checkout.');
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: TColors.primary,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text('Checkout', style: Theme.of(context).textTheme.titleMedium!.apply(color: Colors.white), textAlign: TextAlign.center,),
            ),
          ),
        )
      ),
    );
  }

  void showAddressSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
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
              trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.green) : null,
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
