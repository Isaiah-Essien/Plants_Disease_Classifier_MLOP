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

class ScanPlant extends StatefulWidget {
  const ScanPlant({super.key});

  @override
  State<ScanPlant> createState() => _ScanPlantState();
}

class _ScanPlantState extends State<ScanPlant> {
  File? _selectedImage;
  bool _isUploading = false;
  bool _isScanning = false;
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

      // Automatically upload the selected image
      await _uploadImage(_selectedImage!);
    }
  }

  Future<void> _scanPlantDirectly() async {
    setState(() {
      _isScanning = true; // Set scanning state
    });

    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _prediction = null;
          _confidence = null;
        });

        // Automatically upload the scanned image
        await _uploadImage(_selectedImage!, isScanning: true);
      } else {
        _showSnackbarWithAlert("Error: No image captured.");
      }
    } catch (e) {
      _showSnackbarWithAlert("Error: $e");
    } finally {
      setState(() {
        _isScanning = false; // Reset scanning state
      });
    }
  }

  Future<void> _uploadImage(File imageFile, {bool isScanning = false}) async {
    setState(() {
      if (isScanning) {
        _isScanning = true; // Set scanning state
      } else {
        _isUploading = true; // Set uploading state
      }
    });

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://plant-disease-classifier-tsau.onrender.com/predict/upload'),
      );

      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final decoded = jsonDecode(respStr);
        setState(() {
          _prediction = decoded['prediction']['class'];
          _confidence = decoded['prediction']['confidence'];
        });
        _showSnackbarWithAlert(
          "The leaf has $_prediction\nConfidence: $_confidence",
          isError: false,
        );
      } else {
        _showSnackbarWithAlert(
          "Error: Failed to predict. Status code: ${response.statusCode}",
          isError: true,
        );
      }
    } catch (e) {
      _showSnackbarWithAlert("Error: $e", isError: true);
    } finally {
      setState(() {
        if (isScanning) {
          _isScanning = false; // Reset scanning state
        } else {
          _isUploading = false; // Reset uploading state
        }
      });

      // Clear predictions and image after 7 seconds
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

  void _showSnackbarWithAlert(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: isError ? ErrorAlert(message: message) : SuccessAlert(message: message),
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
        title: "Scan Plant",
        backgroundColor: ColorResources.PRIMARY,
        titleColor: Colors.white,
        iconColor: Colors.white,
        showBackButton: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.02),
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
                child: _selectedImage != null
                    ? Image.file(_selectedImage!, fit: BoxFit.cover)
                    : Center(
                  child: Icon(
                    Icons.camera_alt,
                    size: screenWidth * 0.25,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              const Text(
                "Scan the plant leaf directly or upload an image to analyze for diseases.",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.04),
              CustomElevatedButton(
                buttonText: _isUploading ? "Uploading..." : "Upload Plant Image",
                onPressed: () {
                  if (!_isUploading && !_isScanning) {
                    _pickImage();
                  }
                },
              ),
              SizedBox(height: screenHeight * 0.02),
              CustomOutlinedButton(
                buttonText: _isScanning ? "Scanning..." : "Scan Plant Directly",
                onPressed: () {
                  if (!_isScanning && !_isUploading) {
                    _scanPlantDirectly();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
