import 'package:flutter/material.dart';
import 'package:plantvillage/utils/constants/colors.dart';

class CustomDotNavigation extends StatelessWidget {
  const CustomDotNavigation({
    super.key,
    required this.currentPageIndex,
  });

  final int currentPageIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 3.0),
          width: index == currentPageIndex ? 24.0 : 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            color: index == currentPageIndex
                ? ColorResources.PRIMARY
                : Colors.grey,
            borderRadius: BorderRadius.circular(8.0),
          ),
        );
      }),
    );
  }
}
