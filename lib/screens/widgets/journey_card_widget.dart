import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/journey.dart';

/// Widget displaying the current journey task prominently
class JourneyCardWidget extends StatelessWidget {
  final Journey journey;

  const JourneyCardWidget({super.key, required this.journey});

  @override
  Widget build(BuildContext context) {
    final currentTask = journey.currentTask;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.accentPrimary.withOpacity(0.1),
              AppColors.accentPositive.withOpacity(0.05),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentPrimary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Today\'s Journey',
                      style: AppTypography.caption(
                        color: AppColors.accentPrimary,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    journey.type.emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Journey title
              Text(
                journey.title,
                style: AppTypography.cardTitle(
                  color: isDark
                      ? AppColors.primaryTextDark
                      : AppColors.primaryText,
                ),
              ),

              const SizedBox(height: 8),

              // Progress indicator
              Row(
                children: [
                  Text(
                    'Day ${journey.currentDay}',
                    style: AppTypography.bodySmall(
                      color: isDark
                          ? AppColors.primaryTextDark.withOpacity(0.7)
                          : AppColors.primaryText.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: journey.progress,
                      backgroundColor: isDark
                          ? AppColors.dividerDark
                          : AppColors.divider,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.accentPositive,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${(journey.progress * 100).round()}%',
                    style: AppTypography.caption(
                      color: AppColors.accentPositive,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Current task
              if (currentTask != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.secondaryElementDark.withOpacity(0.5)
                        : AppColors.secondaryElement.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.accentPrimary.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.play_circle_outline,
                            color: AppColors.accentPrimary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              currentTask.title,
                              style: AppTypography.h5(
                                color: isDark
                                    ? AppColors.primaryTextDark
                                    : AppColors.primaryText,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accentAction.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${currentTask.durationMinutes} min',
                              style: AppTypography.caption(
                                color: AppColors.accentAction,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentTask.description,
                        style: AppTypography.bodySmall(
                          color: isDark
                              ? AppColors.primaryTextDark.withOpacity(0.8)
                              : AppColors.primaryText.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Start button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Navigate to task detail or start task
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Start Today\'s Practice',
                      style: AppTypography.buttonText(color: Colors.white),
                    ),
                  ),
                ),
              ] else ...[
                // All tasks completed
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.accentPositive.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppColors.accentPositive,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Amazing! You\'ve completed all tasks for this journey.',
                          style: AppTypography.bodyMedium(
                            color: isDark
                                ? AppColors.primaryTextDark
                                : AppColors.primaryText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
