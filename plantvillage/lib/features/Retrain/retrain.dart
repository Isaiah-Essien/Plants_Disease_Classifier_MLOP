import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../utils/alerts/alerts.dart';
import '../../utils/constants/appbar.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/custom_elevated_button.dart';
import '../../utils/constants/custom_outlined_button.dart';

class Retrain extends StatefulWidget {
  const Retrain({super.key});

  @override
  State<Retrain> createState() => _RetrainState();
}

class _RetrainState extends State<Retrain> {
  File? _selectedImage;
  bool _isUploading = false;
  bool _isRetraining = false;
  String? _prediction;
  String? _confidence;

  final ImagePicker _picker = ImagePicker();

  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _prediction = null;
        _confidence = null;
      });
    }
  }

  Future<void> _retrainAndPredict() async {
    if (_selectedImage == null) {
      _showSnackbarWithAlert("Please upload a plant image first.");
      return;
    }

    setState(() {
      _isRetraining = true;
    });

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://plant-disease-classifier-tsau.onrender.com/retrain'),
      );

      request.files.add(await http.MultipartFile.fromPath('file', _selectedImage!.path));

      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final decoded = jsonDecode(respStr);
        setState(() {
          _prediction = decoded['prediction']['class'];
          _confidence = decoded['prediction']['confidence'];
        });

        _showSnackbarWithAlert(
          "Thank you for optimizing our Plant Village by making a prediction. "
              "The plant has $_prediction disease, and the confidence of this prediction is $_confidence. "
              "Image added to dataset and model updated.",
        );
      } else {
        _showSnackbarWithAlert("Error: Failed to retrain and predict.");
      }
    } catch (e) {
      _showSnackbarWithAlert("Error: $e");
    } finally {
      setState(() {
        _isRetraining = false;
      });

      // Clear image and predictions after 7 seconds
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer(const Duration(seconds: 7), () {
      setState(() {
        _prediction = null;
        _confidence = null;
        _selectedImage = null;
      });
    });
  }

  void _showSnackbarWithAlert(String message) {
    final isWarning = message == "Please upload a plant image first.";

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: isWarning
            ? WarningAlert(message: message)
            : SuccessAlert(message: message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 7),
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
        backgroundColor: Colors.transparent, // Transparent background
        elevation: 0, // No shadow
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      backgroundColor: ColorResources.BACKGROUND,
      appBar: const CustomAppBar(
        title: "Optimize Model",
        backgroundColor: ColorResources.PRIMARY,
        titleColor: Colors.white,
        iconColor: Colors.white,
        showBackButton: false,
      ),
      body: Column(
        children: [
          // Causal Slider
          SizedBox(
            height: screenHeight * 0.25,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCausalCard(
                  title: "Old Model",
                  imagePath: "assets/images/plant_train_hist.png",
                  description:
                  "This is the performance of the old model before retraining.",
                ),
                _buildCausalCard(
                  title: "New Model",
                  imagePath: "assets/images/plant_retrain_hist.png",
                  description:
                  "This is the improved perfo rmance of the new model after retraining.",
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    // Placeholder or Uploaded Image
                    Container(
                      width: double.infinity,
                      height: screenHeight * 0.3,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.shade400,
                          width: 2.0,
                        ),
                      ),
                      child: _selectedImage != null
                          ? Image.file(_selectedImage!, fit: BoxFit.cover)
                          : Center(
                        child: Icon(
                          Icons.image,
                          size: screenWidth * 0.1,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    const Text(
                      "Everytime you make predictions, you save a plant's life, and  preserve the ecosystem.",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    // Upload Button
                    CustomElevatedButton(
                      buttonText: _isUploading ? "Uploading..." : "Upload Plant Image",
                      onPressed: () {
                        if (!_isUploading && !_isRetraining) {
                          _pickImage();
                        }
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    // Predict and Retrain Button
                    CustomOutlinedButton(
                      buttonText:
                      _isRetraining ? "Predicting & Retraining..." : "Predict & Retrain",
                      onPressed: () {
                        if (!_isRetraining && !_isUploading) {
                          _retrainAndPredict();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCausalCard({
    required String title,
    required String imagePath,
    required String description,
  }) {
    return Container(
      width: 250,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
