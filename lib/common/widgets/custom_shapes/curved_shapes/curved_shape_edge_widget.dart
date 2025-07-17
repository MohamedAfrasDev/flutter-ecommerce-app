import 'package:flutter/material.dart';
import 'package:online_shop/common/widgets/custom_shapes/curved_shapes/curved_shape.dart';

class TCurvedWidget extends StatelessWidget {
  const TCurvedWidget({
    super.key, this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TCustomCurvedShape(),
      child: child,
    );
  }
}

