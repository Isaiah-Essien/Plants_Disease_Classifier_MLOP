import 'package:flutter/material.dart';
import 'package:plantvillage/utils/constants/colors.dart';

// Create a reusable ElevatedButton widget that accepts text as an argument
class CustomElevatedButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const CustomElevatedButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorResources.PRIMARY, // Purple color
          padding: const EdgeInsets.symmetric(vertical: 15.0), // Padding adjusted
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9.0), // Rounded corners
          ),
        ),
        onPressed: onPressed, // Action when button is pressed
        child: Text(
          buttonText, // Display the provided text
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white, // White text color
          ),
        ),
      ),
    );
  }
}
