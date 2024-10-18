import 'package:flutter/material.dart';
import 'styles.dart';
import 'dart:math' as math;

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'DayO',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: AppStyles.textColor,
                fontFamily: AppStyles.fontFamily,
              ),
            ),
            SizedBox(height: 24),
            CustomLoadingIndicator(controller: _controller),
          ],
        ),
      ),
    );
  }
}

class CustomLoadingIndicator extends StatelessWidget {
  final AnimationController controller;

  CustomLoadingIndicator({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, child) {
        return Transform.rotate(
          angle: controller.value * 2 * math.pi,
          child: Container(
            width: 60,
            height: 60,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: _buildDot(Colors.red),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: _buildDot(Colors.yellow),
                ),
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: _buildDot(Colors.blue),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: _buildDot(Colors.green),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 15,
      height: 15,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
