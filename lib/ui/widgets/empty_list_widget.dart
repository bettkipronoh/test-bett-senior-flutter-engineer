import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'custom_button.dart';

class EmptyWidget extends StatelessWidget {
  final Function? onClick;
  final String description;
  final String? buttonTitle;
  final String image;
  final String? title;
  const EmptyWidget({
    super.key,
    required this.description,
    this.buttonTitle,
    this.onClick,
    required this.image,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        //mainAxisAlignment: MainAxisAlignment.center,
        //shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
                child: Lottie.asset(
              image,
              fit: BoxFit.fitWidth,
              width: MediaQuery.of(context).size.width * 0.6,
            )),
          ),
          if (title != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Center(
                child: Text(
                  "$title",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        height: 1.3,
                      ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(
              16.0,
            ),
            child: Center(
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      height: 1.3,
                    ),
              ),
            ),
          ),
          if (buttonTitle != null && onClick != null)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
              child: CustomButton(
                  title: buttonTitle!, onPressed: () => onClick!()),
            ),
        ],
      ),
    );
  }
}
