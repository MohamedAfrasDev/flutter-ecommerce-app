import 'package:flutter/material.dart';
import 'package:online_shop/utils/constants/colors.dart';
class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 24, height: 24, child: Checkbox(value: true, onChanged: (value){})),
        Text.rich(
          maxLines: 1,
          TextSpan(children: [
            TextSpan(text: 'I agree to ', style: Theme.of(context).textTheme.bodySmall),
            TextSpan(text: 'Privacy Policy', style: Theme.of(context).textTheme.bodyMedium!.apply(
              color: dark ? TColors.textWhite : Colors.blue,
              decoration: TextDecoration.underline,
              decorationColor: dark ? TColors.textWhite : Colors.blue,
            )),
              TextSpan(text: ' and ', style: Theme.of(context).textTheme.bodySmall),
            TextSpan(text: 'Terms of use', style: Theme.of(context).textTheme.bodyMedium!.apply(
              color: dark ? TColors.textWhite : Colors.blue,
              decoration: TextDecoration.underline,
              decorationColor: dark ? TColors.textWhite : Colors.blue,
            )),
          ])
        )
      ],
    );
  }
}
