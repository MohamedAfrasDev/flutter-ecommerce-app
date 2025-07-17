import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/t_circular_image.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:get/get.dart';
import 'package:online_shop/features/personailization/screens/profile/profile.dart';
import 'package:online_shop/features/shop_2/screens/controller/customer_controller.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TUserProfileTitle extends StatefulWidget {
  const TUserProfileTitle({
    super.key,
  });

  @override
  State<TUserProfileTitle> createState() => _TUserProfileTitleState();
}

class _TUserProfileTitleState extends State<TUserProfileTitle> {
    final controller = Get.put(CustomerController());
    final storage = GetStorage();



  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: TCircularImage(image: controller.user.value!.customerImage == 'No Image' ? TImages.appLightLogo : controller.user.value!.customerImage!, width: 50, height: 50, padding: 0, isNetworkImage: controller.user.value!.customerImage == 'No Image' ? false : true,),
      title: Text(controller.user.value!.customerName ?? 'Unknown', style: Theme.of(context).textTheme.headlineSmall!.apply(color: Colors.white),),
      subtitle: Text(controller.user.value!.customerEmail ?? 'Unknown', style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white),),
      trailing: IconButton(onPressed: () => Get.to(() =>  ProfileScreen(customerModel: controller.user.value!,)), icon: Icon(Iconsax.edit_copy, color: Colors.white,)),
    );
  }
}