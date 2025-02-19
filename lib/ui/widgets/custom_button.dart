import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color? color;
  final Color? disabledColor;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final double? titleFontSize;
  final double? cornerRadius;
  final Widget? child;
  final bool? isLoading;
  final bool? isDisabled;
  const CustomButton(
      {super.key,
      required this.title,
      required this.onPressed,
      this.color,
      this.disabledColor,
      this.padding,
      this.titleFontSize,
      this.cornerRadius,
      this.child,
      this.isLoading,
      this.isDisabled,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (isDisabled != null && isDisabled!) {
          return;
        } else {
          onPressed();
        }
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
            isDisabled != null && isDisabled!
                ? disabledColor ?? Colors.grey.shade400
                : backgroundColor ?? Theme.of(context).primaryColor),
        elevation: WidgetStateProperty.all<double>(0),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            // Change your radius here
            borderRadius: BorderRadius.circular(cornerRadius ?? 56),
          ),
        ),
      ),
      child: Center(
        child: Padding(
          padding: padding != null ? padding! : const EdgeInsets.all(12),
          child: child ??
              Text(
                title,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: color ?? Colors.white,
                      fontSize: 14,
                    ),
                //style: Theme.of(context).textTheme.bodyText2,
              ),
        ),
      ),
    );
  }
}
