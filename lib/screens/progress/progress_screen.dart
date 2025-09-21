import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Progress screen with zen garden visualization
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Journey',
          style: AppTypography.h4(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.primaryTextDark
                : AppColors.primaryText,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.trending_up_outlined,
              size: 64,
              color: AppColors.accentAction,
            ),
            SizedBox(height: 16),
            Text(
              'Progress Visualization',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.accentAction,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Coming Soon',
              style: TextStyle(fontSize: 16, color: AppColors.primaryText),
            ),
          ],
        ),
      ),
    );
  }
}
