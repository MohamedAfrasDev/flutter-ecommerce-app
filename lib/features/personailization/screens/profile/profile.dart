import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/custom_shapes/appbar/appbar.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/section_heading.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/t_circular_image.dart';
import 'package:online_shop/features/shop/products/widgets/profile_menu.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:online_shop/utils/helpers/models/customer_model.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.customerModel});

  final CustomerModel customerModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        title: Text('Profile'),
        showBackArrrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const TCircularImage(image: TImages.appLightLogo, width: 80, height: 80,),
                    TextButton(onPressed: () {}, child: const Text('Change Profile Picture'))
                  ],
                ),
              ),

              const SizedBox(height: TSizes.spaceBetwwenItems / 2,),
              const Divider(),
              const SizedBox(height: TSizes.spaceBetwwenItems,),

              const TSectionHeading(title: 'Profile Information', showActionButton: false,),
              const SizedBox(height: TSizes.spaceBetwwenItems,),

              TProfileMenuTitle(title: 'Name', value: customerModel.customerName!, onPressed: () {},),
              TProfileMenuTitle(title: 'Username', value: 'Afras4432', onPressed: () {},),

              const SizedBox(height: TSizes.spaceBetwwenItems,),
              const Divider(),
              const SizedBox(height: TSizes.spaceBetwwenItems,),

              TSectionHeading(title: 'Personal Information', showActionButton: false,),

              const SizedBox(height: TSizes.spaceBetwwenItems,),
              TProfileMenuTitle(title: 'User ID', value: '4432', onPressed: () {},icon: Iconsax.copy_copy,),
              TProfileMenuTitle(title: 'E-mail', value: customerModel.customerEmail!, onPressed: () {},),
              TProfileMenuTitle(title: 'Phone Number', value: customerModel.customerPhoneNumber!, onPressed: () {},),
              TProfileMenuTitle(title: 'Gender', value: 'Male', onPressed: () {},),

              const Divider(),
              const SizedBox(height: TSizes.spaceBetwwenItems,),

              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Close Account', style: TextStyle(color: Colors.red),)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

