import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/images_string.dart';

class PlantOnboarding2 extends StatelessWidget { // Updated class name
  const PlantOnboarding2({super.key});

  @override
  Widget build(BuildContext context) {
    // Media query to get screen dimensions
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      backgroundColor: ColorResources.BACKGROUND,
      body: Stack(
        children: [
          // Large Semi-Circle Design on the Top Left (Flipped from the Right)
          Positioned(
            left: screenWidth * -0.74, // Dynamic positioning
            top: screenHeight * -0.77, // Dynamic positioning
            child: Container(
              width: screenWidth * 1.76, // Dynamic width
              height: screenHeight * 1.74, // Dynamic height
              decoration: BoxDecoration(
                color: const Color(0xFFE5F3F3).withOpacity(0.9),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Smaller Circle near woman's head (positioned under medium circle)
          Positioned(
            right: screenWidth * 0.21, // Dynamic right position
            top: screenHeight * 0.15, // Dynamic top position
            child: Container(
              width: screenWidth * 0.19, // Dynamic size for smaller circle
              height: screenWidth * 0.19, // Dynamic size for smaller circle
              decoration: const BoxDecoration(
                color: Color(0xFFBEF2EE), // Updated color for small circle
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Large Rectangular Image with Rounded Corners (Flipped to the Left)
                    Positioned(
                      top: screenHeight * 0.15, // Dynamic top position
                      left: screenWidth * -0.48, // Dynamic left position
                      child: Container(
                        width: screenWidth * 0.75, // Dynamic width
                        height: screenHeight * 0.23, // Dynamic height
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(36),
                          image: const DecorationImage(
                            image: AssetImage(MImages.screenone_1),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    // Small Blurry Dot with Shadow between Large Rectangle and Medium Circle
                    Positioned(
                      right: screenWidth * 0.5, // Dynamically positioned
                      top: screenHeight * 0.29, // Adjusted for dynamic height
                      child: Container(
                        width: screenWidth * 0.021, // Dynamic size
                        height: screenWidth * 0.021, // Dynamic size
                        decoration: BoxDecoration(
                          color: ColorResources.PRIMARY.withOpacity(0.5), // Same color as small circle
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFBEF2EE).withOpacity(0.9),
                              blurRadius: 8,
                              spreadRadius: 10,
                              offset: const Offset(0, 4), // Offset for a shadow effect
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Medium Circle Image
                    Positioned(
                      right: screenWidth * -0.1, // Dynamic right position
                      top: screenHeight * 0.18, // Dynamic top position
                      child: ClipOval(
                        child: Image.asset(
                          MImages.screentwo_2,
                          width: screenWidth * 0.49, // Dynamic width for circle image
                          height: screenWidth * 0.49, // Dynamic height for circle image
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Circular Image Wrapped in a White Background
                    Positioned(
                      top: screenHeight * 0.405, // Dynamic positioning
                      right: screenWidth * 0.39, // Dynamic positioning
                      child: Container(
                        width: screenWidth * 0.23, // Dynamic size
                        height: screenWidth * 0.23, // Dynamic size
                        decoration: const BoxDecoration(
                          color: Colors.white, // White Background
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * 0.05), // Dynamic padding
                          child: ClipOval(
                            child: Image.asset(
                              MImages.screentwo_4,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Small Rounded Square Image Top
                    Positioned(
                      left: screenWidth * 0.23, // Dynamic left position
                      top: screenHeight * 0.063, // Dynamic top position
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          MImages.screentwo_1,
                          width: screenWidth * 0.135, // Dynamic width
                          height: screenWidth * 0.135, // Dynamic height
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Another Small Rounded Square Image middle
                    Positioned(
                      left: screenWidth * 0.33, // Dynamic left position
                      top: screenHeight * 0.212, // Dynamic top position
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          MImages.screentwo_3,
                          width: screenWidth * 0.135, // Dynamic width
                          height: screenWidth * 0.135, // Dynamic height
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
