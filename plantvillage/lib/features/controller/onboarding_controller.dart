import 'package:flutter/material.dart';
import 'package:plantvillage/utils/constants/colors.dart';

import '../../bottom_Nav.dart';
import '../../utils/constants/dot_navigation.dart';
import '../onboarding/onboarding1.dart';
import '../onboarding/onboarding2.dart';
import '../onboarding/onboarding3.dart';

class OnboardingScreensController extends StatefulWidget {
  const OnboardingScreensController({super.key});

  @override
  _OnboardingScreensControllerState createState() =>
      _OnboardingScreensControllerState();
}

class _OnboardingScreensControllerState
    extends State<OnboardingScreensController> {
  final PageController _pageController = PageController();
  int currentPageIndex = 0;

  // Titles and subtitles for each onboarding screen
  final List<Map<String, String>> onboardingText = [
    {
      "title": "Welcome to Plant Health Assistant",
      "subtitle": "Your go-to app for diagnosing plant diseases. Keep your crops thriving with AI-powered insights."
    },
    {
      "title": "Fast & Accurate Scanning",
      "subtitle": "Use your camera to scan plant leaves in real-time or upload an image to detect potential issues instantly."
    },
    {
      "title": "Track & Improve Plant Health",
      "subtitle": "Monitor disease trends, get tailored recommendations, and boost your crop productivity effortlessly."
    },
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return Scaffold(
      body: Stack(
        children: [
          // PageView for sliding through the onboarding screens
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            children: const [
              PlantOnboarding1(), // First screen
              PlantOnboarding2(), // Second screen
              PlantOnboarding3(), // Third and last screen
            ],
          ),
          // Positioned: Dot indicator, Titles, Subtitles, and Buttons at the bottom
          Positioned(
            bottom: screenHeight * 0.04, // Adjust position relative to screen height
            left: screenWidth * 0.05, // Adjust left padding based on screen width
            right: screenWidth * 0.05, // Adjust right padding based on screen width
            child: Column(
              children: [
                // Dot indicator
                CustomDotNavigation(currentPageIndex: currentPageIndex),
                SizedBox(height: screenHeight * 0.026), // Adjust vertical spacing
                // Title
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Text(
                    onboardingText[currentPageIndex]['title']!,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01), // Adjust vertical spacing
                // Subtitle
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Text(
                    onboardingText[currentPageIndex]['subtitle']!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF333333),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: screenHeight * 0.05), // Adjust vertical spacing
                // Continue or Get Started Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorResources.PRIMARY,
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9.0),
                      ),
                    ),
                    onPressed: () {
                      if (currentPageIndex == 2) {
                        // If it's the last screen, navigate to the GetStartedScreen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BottomNavigation(),
                          ),
                        );
                      } else {
                        // Otherwise, go to the next screen
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Text(
                      currentPageIndex == 2 ? "Get Started" : "Continue",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01), // Adjust vertical spacing
                // Skip Button with horizontal lines on the sides
                currentPageIndex != 2
                    ? Row(
                  children: [
                    // Left Line
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(right: 12.0),
                        height: 1.0,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                    // Skip Button Text
                    TextButton(
                      onPressed: () {
                        // Skip directly to the last onboarding screen
                        _pageController.animateToPage(
                          2, // Index of the last screen
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Text(
                        "Skip this step",
                        style: TextStyle(
                          color: ColorResources.PRIMARY,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // Right Line
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 12.0),
                        height: 1.0,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                  ],
                )
                    : const SizedBox(), // Empty container on the last page
              ],
            ),
          ),
        ],
      ),
    );
  }
}
