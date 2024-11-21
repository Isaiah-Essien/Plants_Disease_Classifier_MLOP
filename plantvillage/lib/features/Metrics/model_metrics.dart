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
    'assets/images/metric_graph_1.png',
    'assets/images/metric_graph_2.png',
    'assets/images/metric_graph_3.png',
  ];

  final List<String> _descriptions = [
    "Accuracy over training epochs for plant disease detection.",
    "Precision and recall trends for the model's predictions.",
    "Confusion matrix visualization for classification performance.",
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
                    "Model Performance",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Here are the metrics and visualizations of your plant disease prediction model.",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
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
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Elevated Button: Check How PlantVillage Works
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: CustomElevatedButton(
                buttonText: "How it works",
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
