import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/wellness_module.dart';
import '../../models/mood_entry.dart';

/// Widget suggesting a wellness module based on user context
class SuggestedModuleWidget extends StatelessWidget {
  const SuggestedModuleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final suggestedModule = _getSuggestedModule(appState);

        if (suggestedModule == null) {
          return const SizedBox.shrink();
        }

        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Card(
          child: InkWell(
            onTap: () {
              // TODO: Navigate to module detail
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
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
                          color: AppColors.accentAction.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Suggested for You',
                          style: AppTypography.caption(
                            color: AppColors.accentAction,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        suggestedModule.category.emoji,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Module title
                  Text(
                    suggestedModule.title,
                    style: AppTypography.cardTitle(
                      color: isDark
                          ? AppColors.primaryTextDark
                          : AppColors.primaryText,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Description
                  Text(
                    suggestedModule.description,
                    style: AppTypography.bodyMedium(
                      color: isDark
                          ? AppColors.primaryTextDark.withOpacity(0.8)
                          : AppColors.primaryText.withOpacity(0.8),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 16),

                  // Module details
                  Row(
                    children: [
                      _buildDetailChip(
                        context,
                        Icons.schedule,
                        '${suggestedModule.durationMinutes} min',
                        AppColors.accentPrimary,
                      ),
                      const SizedBox(width: 12),
                      _buildDetailChip(
                        context,
                        Icons.signal_cellular_alt,
                        suggestedModule.difficulty.label,
                        AppColors.accentPositive,
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: isDark
                            ? AppColors.primaryTextDark.withOpacity(0.5)
                            : AppColors.primaryText.withOpacity(0.5),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailChip(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label, style: AppTypography.caption(color: color)),
        ],
      ),
    );
  }

  WellnessModule? _getSuggestedModule(AppStateProvider appState) {
    final latestMood = appState.latestMoodEntry;

    // Suggest based on latest mood or provide a default
    if (latestMood != null) {
      switch (latestMood.mood) {
        case MoodType.anxious:
        case MoodType.stressed:
          return _createAnxietyReliefModule();
        case MoodType.sad:
          return _createGratitudeModule();
        case MoodType.energetic:
          return _createMindfulMovementModule();
        default:
          return _createBreathingModule();
      }
    }

    // Default suggestion
    return _createBreathingModule();
  }

  WellnessModule _createBreathingModule() {
    return const WellnessModule(
      id: 'breathing_4_7_8',
      title: '4-7-8 Breathing Technique',
      description:
          'A simple breathing exercise to reduce stress and promote relaxation.',
      category: ModuleCategory.breathing,
      difficulty: ModuleDifficulty.beginner,
      durationMinutes: 5,
      benefits: ['Reduces stress', 'Improves focus', 'Promotes relaxation'],
      instructions:
          'Breathe in for 4 counts, hold for 7, exhale for 8. Repeat 4 times.',
    );
  }

  WellnessModule _createAnxietyReliefModule() {
    return const WellnessModule(
      id: 'worry_time_scheduler',
      title: 'Worry Time Scheduler',
      description:
          'Set aside dedicated time for worries to reduce anxiety throughout the day.',
      category: ModuleCategory.anxiety,
      difficulty: ModuleDifficulty.intermediate,
      durationMinutes: 10,
      benefits: ['Reduces anxiety', 'Improves time management', 'Better sleep'],
      instructions:
          'Schedule 10 minutes daily to write down and process your worries.',
    );
  }

  WellnessModule _createGratitudeModule() {
    return const WellnessModule(
      id: 'gratitude_journal',
      title: 'Three Good Things',
      description: 'Reflect on three positive things that happened today.',
      category: ModuleCategory.gratitude,
      difficulty: ModuleDifficulty.beginner,
      durationMinutes: 7,
      benefits: [
        'Improves mood',
        'Increases positivity',
        'Better relationships',
      ],
      instructions:
          'Write down three good things that happened today and why they were meaningful.',
    );
  }

  WellnessModule _createMindfulMovementModule() {
    return const WellnessModule(
      id: 'mindful_stretching',
      title: 'Mindful Stretching',
      description: 'Gentle stretches combined with mindful awareness.',
      category: ModuleCategory.movement,
      difficulty: ModuleDifficulty.beginner,
      durationMinutes: 12,
      benefits: ['Reduces tension', 'Improves flexibility', 'Calms the mind'],
      instructions:
          'Follow along with gentle stretches while focusing on your breath and body sensations.',
    );
  }
}
