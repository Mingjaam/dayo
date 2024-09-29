import 'package:flutter/material.dart';
import 'styles.dart';

class LoadingScreen extends StatelessWidget {
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
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppStyles.accentColor),
            ),
          ],
        ),
      ),
    );
  }
}