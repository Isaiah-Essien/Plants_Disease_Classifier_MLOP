import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/images_string.dart';

class PlantOnboarding1 extends StatelessWidget { // Updated class name
  const PlantOnboarding1({super.key});

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
          // Large Semi-Circle Design from the Top Right
          Positioned(
            right: screenWidth * -0.74, // Adjusted for dynamic screen width
            top: screenHeight * -0.77, // Adjusted for dynamic screen height
            child: Container(
              width: screenWidth * 1.67, // Dynamically sized based on screen width
              height: screenHeight * 1.74, // Dynamically sized based on screen height
              decoration: BoxDecoration(
                color: const Color(0xFFE5F3F3).withOpacity(0.9), // Updated Color for Semi-Circle
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Smaller Arc Design on the Top Left (Placed after large semi-circle for correct overlap)
          Positioned(
            left: screenWidth * -0.08, // Adjusted for dynamic width
            top: screenHeight * -0.11, // Adjusted for dynamic height
            bottom: screenHeight * 0.84, // Adjusted for dynamic height
            child: Container(
              width: screenWidth * 0.33, // Dynamic size for smaller arc
              height: screenWidth * 0.33, // Dynamic size for smaller arc
              decoration: const BoxDecoration(
                color: Color(0xFFBEF2EE), // Updated Color for Small Arc
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

                    // Small Dotted Pattern Decoration (5 Rows)
                    Positioned(
                      top: screenHeight * 0.135, // Adjusted for dynamic height
                      right: screenWidth * 0.39, // Adjusted for dynamic width
                      child: Column(
                        children: List.generate(5, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Row(
                              children: List.generate(3, (dotIndex) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                  child: Container(
                                    width: screenWidth * 0.019, // Dynamic size for dots
                                    height: screenWidth * 0.023, // Dynamic size for dots
                                    decoration: const BoxDecoration(
                                      color: ColorResources.PRIMARY,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          );
                        }),
                      ),
                    ),

                    // Large Rectangular Image with Rounded Corners
                    Positioned(
                      top: screenHeight * 0.15, // Adjusted for dynamic height
                      right: screenWidth * -0.31, // Adjusted for dynamic width
                      child: Container(
                        width: screenWidth * 0.75, // Dynamic size for rectangular image
                        height: screenHeight * 0.23, // Dynamic height for rectangular image
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(36),
                          image: const DecorationImage(
                            image: AssetImage(MImages.screenone_1),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    // Small Rounded Square Image top left
                    Positioned(
                      left: screenWidth * 0.264, // Adjusted for dynamic width
                      top: screenHeight * 0.122, // Adjusted for dynamic height
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          MImages.screenone_2,
                          width: screenWidth * 0.137, // Dynamic size
                          height: screenWidth * 0.137, // Dynamic size
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    //Small Rounded Square Image top right
                    Positioned(
                      right: screenWidth * 0.08, // Adjusted for dynamic width
                      top: screenHeight * 0.06, // Adjusted for dynamic height
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          MImages.screenone_3,
                          width: screenWidth * 0.137, // Dynamic size
                          height: screenWidth * 0.137, // Dynamic size
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    //Smaller Rounded Square Image middle right
                    Positioned(
                      right: screenWidth * 0.115, // Adjusted for dynamic width
                      top: screenHeight * 0.355, // Adjusted for dynamic height
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          MImages.screenone_5,
                          width: screenWidth * 0.125, // Dynamic size
                          height: screenWidth * 0.125, // Dynamic size
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
                              MImages.screenone_4,
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
