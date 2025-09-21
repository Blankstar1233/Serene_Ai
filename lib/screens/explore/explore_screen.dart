import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Explore screen for wellness modules and activities
class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Explore',
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
              Icons.explore_outlined,
              size: 64,
              color: AppColors.accentPositive,
            ),
            SizedBox(height: 16),
            Text(
              'Wellness Library',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.accentPositive,
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
