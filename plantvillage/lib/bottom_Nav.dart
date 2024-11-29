import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import 'features/Metrics/model_metrics.dart';
import 'features/PlantScreens/scanplant.dart';
import 'features/Retrain/retrain.dart';
class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0; // Tracks the currently selected tab

  // List of screens for each tab
  final List<Widget> _screens = [
    const ScanPlant(), // Home screen linked to ScanPlant
    const ModelMetrics(), // ModelMetrics screen
    const Retrain(), // Updated Tracker screen to Retrain
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the selected index
          });
        },
        backgroundColor: const Color(0xFFF1F8F6), // Background color
        selectedItemColor: ColorResources.PRIMARY, // Active icon color
        unselectedItemColor: Colors.grey, // Inactive icon color
        showSelectedLabels: true, // Display labels for selected items
        showUnselectedLabels: true, // Display labels for unselected items
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: "Metrics",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes),
            label: "Retrain", // Updated label for Retrain
          ),
        ],
      ),
    );
  }
}
