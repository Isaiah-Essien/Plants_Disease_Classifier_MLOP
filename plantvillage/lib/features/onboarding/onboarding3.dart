import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/images_string.dart';

class PlantOnboarding3 extends StatelessWidget { // Updated class name
  const PlantOnboarding3({super.key});

  @override
  Widget build(BuildContext context) {
    // Media query to fetch screen dimensions for responsive design
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      backgroundColor: ColorResources.BACKGROUND,
      body: Stack(
        children: [
          // Large Semi-Circle Design on the Top extending down
          Positioned(
            right: screenWidth * -0.27, // Adjusted for dynamic screen width
            left: screenWidth * -0.27, // Adjusted for dynamic screen width
            bottom: screenHeight * -0.037, // Adjusted for dynamic screen height
            child: Container(
              width: screenWidth * 2.31, // Dynamically sized based on screen width
              height: screenHeight * 1.87, // Dynamically sized based on screen height
              decoration: BoxDecoration(
                color: const Color(0xFFE5F3F3).withOpacity(0.9),
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
                    // Small Blurry Dot with Shadow
                    Positioned(
                      right: screenWidth * 0.09, // Dynamically positioned
                      top: screenHeight * 0.2, // Adjusted for dynamic height
                      child: Container(
                        width: screenWidth * 0.021, // Dynamic size
                        height: screenWidth * 0.021, // Dynamic size
                        decoration: BoxDecoration(
                          color: ColorResources.PRIMARY.withOpacity(0.5), // Same color as small circle
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE5F3F3).withOpacity(0.9),
                              blurRadius: 8,
                              spreadRadius: 10,
                              offset: const Offset(0, 4), // Offset for a shadow effect
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Medium Circle Image in the middle
                    Positioned(
                      left: screenWidth * 0.25, // Adjusted for dynamic width
                      top: screenHeight * 0.125, // Adjusted for dynamic height
                      child: ClipOval(
                        child: Image.asset(
                          MImages.screenfour_1,
                          width: screenWidth * 0.47, // Dynamic width
                          height: screenWidth * 0.47, // Dynamic height
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Small Rounded Square Image at the top left
                    Positioned(
                      left: screenWidth * 0.09, // Dynamic positioning
                      top: screenHeight * 0.06, // Dynamic positioning
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          MImages.screenfour_2,
                          width: screenWidth * 0.135, // Dynamic size
                          height: screenWidth * 0.135, // Dynamic size
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Small Rounded Square Image bottom right
                    Positioned(
                      right: screenWidth * 0.16, // Dynamic positioning
                      top: screenHeight * 0.304, // Dynamic positioning
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          MImages.screenfour_3,
                          width: screenWidth * 0.10, // Dynamic size
                          height: screenWidth * 0.10, // Dynamic size
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
                              MImages.screenfour_4,
                              fit: BoxFit.cover,
                            ),
                          ),
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
