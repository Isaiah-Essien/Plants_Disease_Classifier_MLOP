import 'package:flutter/material.dart';
import 'package:plantvillage/utils/constants/colors.dart';

import 'features/controller/onboarding_controller.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {

    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inverse',
      themeMode: ThemeMode.system,
      home:  const OnboardingScreensController(),
      theme: ThemeData(
          primarySwatch: ColorResources.getMaterialColor(ColorResources.PRIMARY),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Montserrat'
      ),
    );
  }
}
