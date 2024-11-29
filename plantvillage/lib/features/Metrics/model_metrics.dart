import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../utils/constants/appbar.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/custom_elevated_button.dart';
import 'how_plant_village_works.dart';

class ModelMetrics extends StatefulWidget {
  const ModelMetrics({super.key});

  @override
  State<ModelMetrics> createState() => _ModelMetricsState();
}

class _ModelMetricsState extends State<ModelMetrics> {
  final List<String> _imagePaths = [
    'assets/images/plant_coff_max.png',
    'assets/images/plant_dist.png',
    'assets/images/sample_data.JPG',
  ];

  final List<String> _descriptions = [
    "This confusion matrix visualizes the performance of a classification model applied to a dataset of plant diseases across various categories, including diseases affecting peppers, potatoes, and tomatoes, as well as their healthy states. ",
    "The dataset contains images of healthy and diseased plants across multiple classes, with significant class imbalance. Some classes, like Tomato__Target_Spot, have over 3000 samples, while others, like Potato___Late_blight, have very few. Healthy plant classes are fewer and less represented compared to diseased classes.",
    "Here is a sample plant image.",
  ];

  int _currentIndex = 0; // Tracks the current slide index

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      backgroundColor: ColorResources.BACKGROUND,
      appBar: const CustomAppBar(
        title: "Model Evaluation",
        titleColor: Colors.white,
        showBackButton: false,
        backgroundColor: ColorResources.PRIMARY,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header section with title and description
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.04,
                horizontal: screenWidth * 0.05,
              ),
              color: const Color(0xFFF1F8F6),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Visualizations",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Here are the metrics and visualizations of dataset and prediction model.",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Image slider for displaying model metrics
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: CarouselSlider.builder(
                options: CarouselOptions(
                  height: screenHeight * 0.35,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 500),
                  viewportFraction: 0.8,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index; // Update the current index
                    });
                  },
                ),
                itemCount: _imagePaths.length,
                itemBuilder: (context, index, realIndex) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 5,
                      ),
                      image: DecorationImage(
                        image: AssetImage(_imagePaths[index]),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ColorResources.PRIMARY.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Dynamic description below the slider
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: Text(
                  _descriptions[_currentIndex],
                  key: ValueKey<int>(_currentIndex), // Unique key for the text
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Elevated Button: Check How PlantVillage Works
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: CustomElevatedButton(
                buttonText: "Watch is a plant disease?",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HowPlantVillageWorks(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
