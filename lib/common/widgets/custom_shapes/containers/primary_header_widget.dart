import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:online_shop/common/widgets/custom_shapes/curved_shapes/curved_shape_edge_widget.dart';
import 'package:online_shop/utils/constants/colors.dart';

class TPrimaryHeader extends StatelessWidget {
  const TPrimaryHeader({
    super.key, required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TCurvedWidget(
      child: Container(
            color: TColors.primary,
            padding: const EdgeInsets.all(0),
            child: Stack(
                children: [
                  Positioned(top: -150, right: -250,child: TCircularContainer(backgroundColor: TColors.textWhite.withOpacity(0.1),)),
                 Positioned(top: 100, right: -300,child: TCircularContainer(backgroundColor: TColors.textWhite.withOpacity(0.1),)),
                 child,
            
                 
                ],
            ),
          ),
    );
  }
}
