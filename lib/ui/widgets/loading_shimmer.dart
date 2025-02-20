import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: FadeShimmer.round(
                size: 60,
                fadeTheme: FadeTheme.light,
              )),
          Flexible(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FadeShimmer(
                  height: 8,
                  width: 150,
                  radius: 4,
                  fadeTheme: FadeTheme.light,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FadeShimmer(
                  height: 8,
                  width: 250,
                  radius: 4,
                  fadeTheme: FadeTheme.light,
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
