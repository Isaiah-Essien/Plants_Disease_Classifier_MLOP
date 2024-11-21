import 'package:flutter/material.dart';
import 'package:plantvillage/utils/constants/appbar.dart';
import 'package:plantvillage/utils/constants/colors.dart';

class TrackerPlaceholder extends StatelessWidget {
  const TrackerPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      backgroundColor: ColorResources.BACKGROUND,
      appBar: const CustomAppBar(
        title: "Plant Disease Tracker",
        titleColor: Colors.white,
        iconColor: Colors.white,
        backgroundColor: ColorResources.PRIMARY,
        showBackButton: false,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: const Text(
            "Plant health recommendations and tracker coming soon",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}