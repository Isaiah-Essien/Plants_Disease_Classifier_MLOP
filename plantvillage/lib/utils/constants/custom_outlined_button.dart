import 'package:flutter/material.dart';
import 'package:plantvillage/utils/constants/colors.dart';

// Create a reusable OutlinedButton widget that accepts text as an argument
class CustomOutlinedButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const CustomOutlinedButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Make button fill the width
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15.0), // Button padding
          side: const BorderSide(color: ColorResources.PRIMARY), // Purple border color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9.0), // Rounded corners
          ),
        ),
        onPressed: onPressed, // The function that gets triggered when button is pressed
        child: Text(
          buttonText, // Display the provided text
          style: const TextStyle(
            color: ColorResources.PRIMARY, // Purple text color to match the border
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
