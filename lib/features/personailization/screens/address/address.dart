import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:online_shop/common/widgets/custom_shapes/appbar/appbar.dart';
import 'package:online_shop/features/personailization/controllers/address_add_controller.dart';
import 'package:online_shop/features/personailization/screens/address/add_new_address.dart';
import 'package:online_shop/features/personailization/screens/address/widgets/single_address.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';
import 'package:online_shop/utils/helpers/models/address_model.dart';


class UserAddressScreen extends StatefulWidget {
  const UserAddressScreen({Key? key}) : super(key: key);

  @override
  State<UserAddressScreen> createState() => _UserAddressScreenState();
}

class _UserAddressScreenState extends State<UserAddressScreen> {
  List<AddressModel> savedAddresses = [];
  bool isLoading = true;
  String? selectedAddressId;

  @override
  void initState() {
    super.initState();
    _loadAddressesAndSelectedId();
  }

  Future<void> _loadAddressesAndSelectedId() async {
    final controller = AddressAddController.instance;
    final addresses = await controller.getAddresses();
    final savedId = await controller.loadDefaultAddressId();

    setState(() {
      savedAddresses = addresses;
      selectedAddressId = savedId ?? (addresses.isNotEmpty ? addresses[0].id : null);
      isLoading = false;
    });
  }

  void _selectAddress(AddressModel address) async {
    setState(() {
      selectedAddressId = address.id;
    });
    await AddressAddController.instance.saveDefaultAddressId(address.id);
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Get.to(() => AddNewAddressScreen());
          await _loadAddressesAndSelectedId();
        },
        backgroundColor: TColors.primary,
        child: Icon(Iconsax.add, color: dark ? TColors.dark : TColors.light),
      ),
      appBar: TAppBar(showBackArrrow: true, title: const Text('Address')),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : savedAddresses.isEmpty
                ? const Center(child: Text("No addresses found"))
                : SingleChildScrollView(
                    child: Column(
                      children: savedAddresses.map((address) {
                        return GestureDetector(
                          onTap: () => _selectAddress(address),
                          child: TSingleAddress(
                            address: address,
                            selectedAddress: address.id == selectedAddressId,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
      ),
    );
  }
}
