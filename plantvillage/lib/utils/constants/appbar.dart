import 'package:flutter/material.dart';

import 'colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title; // Nullable title
  final Color backgroundColor;
  final Color titleColor;
  final Color iconColor;
  final VoidCallback? onPressed;
  final bool showBackButton; // New parameter to control back button visibility

  const CustomAppBar({
    super.key,
    this.title, // Optional title
    this.backgroundColor = ColorResources.BACKGROUND,
    this.titleColor = Colors.black,
    this.iconColor = Colors.black,
    this.onPressed,
    this.showBackButton = true, // Defaults to true to show the back button
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: showBackButton // Conditionally display the back button
            ? Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: iconColor,
            ),
            onPressed: onPressed ??
                    () {
                  Navigator.pop(context); // Default back action
                },
          ),
        )
            : null, // No leading widget if back button is not shown
        title: title != null
            ? Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Text(
            title!,
            style: TextStyle(
              color: titleColor,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        )
            : null, // Show title only if provided
        centerTitle: true,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
