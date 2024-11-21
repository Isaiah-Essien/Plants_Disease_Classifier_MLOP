import 'package:flutter/material.dart';
import '../../utils/constants/appbar.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/custom_elevated_button.dart';
import '../../utils/constants/custom_outlined_button.dart';

class ScanPlant extends StatefulWidget {
  const ScanPlant({super.key});

  @override
  State<ScanPlant> createState() => _ScanPlantState();
}

class _ScanPlantState extends State<ScanPlant> {
  bool _isCameraOn = false; // Tracks whether the camera is on

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      backgroundColor: ColorResources.BACKGROUND,
      appBar: const CustomAppBar(
        title: "Scan Plant",
        backgroundColor: ColorResources.PRIMARY,
        titleColor: Colors.white,
        iconColor: Colors.white,
        showBackButton: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Placeholder or Camera Feed
            Container(
              width: double.infinity,
              height: screenHeight * 0.4,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey.shade400,
                  width: 2.0,
                ),
              ),
              child: _isCameraOn
                  ? const Center(
                // TODO: Replace with live camera feed when implemented
                child: Text(
                  "Camera Feed Here",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
                  : Center(
                child: Icon(
                  Icons.camera_alt,
                  size: screenWidth * 0.25, // Large placeholder icon
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04), // Space below the placeholder

            // Instruction Text
            const Text(
              "Scan the plant leaf directly or upload an image to analyze for diseases.",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF333333),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.04), // Space below the text

            // Elevated Button: Upload Image
            CustomElevatedButton(
              buttonText: "Upload Plant Image",
              onPressed: () {
                // TODO: Add API call or file picker functionality here
              },
            ),
            SizedBox(height: screenHeight * 0.02), // Spacing between buttons

            // Outlined Button: Scan Directly
            CustomOutlinedButton(
              buttonText: "Scan Plant Directly",
              onPressed: () {
                setState(() {
                  _isCameraOn = true; // Turn on the camera
                });
                // TODO: Add camera scanning API or CV2 functionality here
              },
            ),
          ],
        ),
      ),
    );
  }
}
