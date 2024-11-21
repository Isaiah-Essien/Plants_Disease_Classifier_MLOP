import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../utils/constants/appbar.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/custom_outlined_button.dart';
import '../PlantScreens/scanplant.dart';

class HowPlantVillageWorks extends StatefulWidget {
  const HowPlantVillageWorks({super.key});

  @override
  State<HowPlantVillageWorks> createState() => _HowPlantVillageWorksState();
}

class _HowPlantVillageWorksState extends State<HowPlantVillageWorks> {
  late VideoPlayerController _controller;
  double _volume = 0.5;
  bool _showControls = true;
  late Timer _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      'assets/videos/plant_disease.mp4', // Replace with your video path
    )
      ..initialize().then((_) {
        setState(() {}); // Refresh UI after initialization
        Future.delayed(const Duration(milliseconds: 300), () {
          _controller.setVolume(_volume); // Smooth volume adjustment
        });
      });
    _startHideControlsTimer();
  }

  @override
  void dispose() {
    _controller.dispose();
    _hideControlsTimer.cancel();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
        _showControls = false; // Hide controls after play
      }
    });
    _resetHideControlsTimer();
  }

  void _onScreenTap() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _resetHideControlsTimer();
    }
  }

  void _startHideControlsTimer() {
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _showControls = false;
      });
    });
  }

  void _resetHideControlsTimer() {
    _hideControlsTimer.cancel();
    _startHideControlsTimer();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      backgroundColor: ColorResources.BACKGROUND,
      appBar: const CustomAppBar(
        title: "Real-time Detection",
        titleColor: Colors.white,
        iconColor: Colors.white,
        showBackButton: true,
        backgroundColor: ColorResources.PRIMARY,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.05),

            // Instruction Text
            const Text(
              "Watch this short video to see how to scan your plant and get real-time disease analysis:",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF333333),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Video Player with Controls
            GestureDetector(
              onTap: _onScreenTap,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: screenHeight * 0.5,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.black12,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: _controller.value.isInitialized
                          ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                          : const Center(
                        child: CircularProgressIndicator(
                          color: ColorResources.PRIMARY,
                        ),
                      ),
                    ),
                  ),
                  if (_showControls)
                    Positioned.fill(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              _controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 50,
                              color: Colors.white,
                            ),
                            onPressed: _togglePlayPause,
                          ),
                          Slider(
                            value: _controller.value.position.inSeconds
                                .toDouble(),
                            min: 0.0,
                            max: _controller.value.duration.inSeconds
                                .toDouble(),
                            activeColor: Colors.white,
                            inactiveColor: Colors.white.withOpacity(0.5),
                            onChanged: (value) {
                              setState(() {
                                _controller
                                    .seekTo(Duration(seconds: value.toInt()));
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Volume Control
            if (_showControls)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.volume_up,
                        color: ColorResources.PRIMARY),
                    onPressed: () {
                      setState(() {
                        _volume = _volume == 0.0 ? 0.5 : 0.0;
                        _controller.setVolume(_volume);
                      });
                    },
                  ),
                  Expanded(
                    child: Slider(
                      value: _volume,
                      min: 0.0,
                      max: 1.0,
                      activeColor: ColorResources.PRIMARY,
                      inactiveColor: ColorResources.PRIMARY.withOpacity(0.5),
                      onChanged: (value) {
                        setState(() {
                          _volume = value;
                          _controller.setVolume(_volume);
                        });
                      },
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),

            // Outlined Button: Try Scanning
            CustomOutlinedButton(
              buttonText: "Try Scanning",
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScanPlant(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
