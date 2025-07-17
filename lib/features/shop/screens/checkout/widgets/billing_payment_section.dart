import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/section_heading.dart';
import 'package:online_shop/utils/constants/colors.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:online_shop/utils/helpers/helper_function.dart';

class TBillingPaymentSection extends StatelessWidget {
  const TBillingPaymentSection({super.key});
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return Column(
      children: [
        TSectionHeading(
          title: 'Payment Method', buttonTitle: 'Change',showActionButton: true, onPressed: (){},),
          const SizedBox(height: TSizes.spaceBetwwenItems / 2,),
          TPaymentWidget(paymentMethod: 'PayPal',),
          TPaymentWidget(paymentMethod: 'Pay Here',),
          TPaymentWidget(paymentMethod: 'Cash on Delivery',)
      ],
    );
  }
}

class TPaymentWidget extends StatelessWidget {
  const TPaymentWidget({
    super.key, this.paymentMethod,
  });

 final String? paymentMethod;
  

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);
    return Row(
      children: [
        TRoundedContainer(
          width: 60,
          height: 60,
          backgroundColor: dark ? TColors.light : TColors.textWhite,
          padding: const EdgeInsets.all(TSizes.sm),
          child:  Image(image: AssetImage(paymentMethod=='PayPal' ? TImages.paypal_icon : paymentMethod=='Pay Here' ? TImages.pay_here_icon : paymentMethod=='Cash on Delivery' ? TImages.homeCategory2 : ''), fit: BoxFit.contain,),
        ),
        const SizedBox(width: TSizes.spaceBetwwenItems / 2,),
        Text(paymentMethod!, style: Theme.of(context).textTheme.bodyLarge,)
      ],
    );
  }
}