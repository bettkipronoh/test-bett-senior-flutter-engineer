import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget? child;
  final double? height;
  final double? width;
  final Color? color;
  final Alignment? alignment;
  final bool? hasShadow;
  final bool? hasRadius;
  final bool? hasBorder;
  final double? padding;
  final BoxShape? shape;
  final BorderRadius? radius;
  const CustomCard({
    Key? key,
    this.child,
    this.radius,
    this.hasRadius = true,
    this.width,
    this.height,
    this.color,
    this.alignment,
    this.hasShadow,
    this.padding,
    this.shape,
    this.hasBorder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      alignment: alignment,
      padding: padding != null ? EdgeInsets.all(padding!) : null,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).cardTheme.color,
        borderRadius: shape == null && hasRadius!
            ? radius ?? BorderRadius.circular(12)
            : null,
        shape: shape ?? BoxShape.rectangle,
        border: hasBorder != null && hasBorder!
            ? Border.all(
                width: 0.1,
                color: Colors.grey,
              )
            : null,
        boxShadow: [
          if (hasShadow != null && hasShadow!)
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 0.5,
              blurRadius: 0.05,
              offset: const Offset(0, 0), // changes position of shadow
            ),
        ],
      ),
      child: child,
    );
  }
}
