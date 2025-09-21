import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/mood_entry.dart';

/// Widget for quick mood check-in with emoji selection
class MoodCheckInWidget extends StatefulWidget {
  const MoodCheckInWidget({super.key});

  @override
  State<MoodCheckInWidget> createState() => _MoodCheckInWidgetState();
}

class _MoodCheckInWidgetState extends State<MoodCheckInWidget> {
  MoodType? _selectedMood;
  int _intensity = 3;
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How are you feeling right now?',
              style: AppTypography.cardTitle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.primaryTextDark
                    : AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 16),

            // Mood options
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: MoodType.values.take(6).map((mood) {
                final isSelected = _selectedMood == mood;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMood = mood;
                      _showDetails = true;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? mood.color.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? mood.color : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(mood.emoji, style: const TextStyle(fontSize: 24)),
                        const SizedBox(height: 4),
                        Text(
                          mood.label,
                          style: AppTypography.caption(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? AppColors.primaryTextDark
                                : AppColors.primaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            // Intensity slider and submit (show only when mood is selected)
            if (_showDetails && _selectedMood != null) ...[
              const SizedBox(height: 20),
              Text(
                'How intense is this feeling? (1-5)',
                style: AppTypography.bodySmall(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.primaryTextDark.withOpacity(0.8)
                      : AppColors.primaryText.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 8),
              Slider(
                value: _intensity.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                label: _intensity.toString(),
                activeColor: _selectedMood!.color,
                onChanged: (value) {
                  setState(() {
                    _intensity = value.round();
                  });
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitMood,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedMood!.color,
                  ),
                  child: Text(
                    'Check In',
                    style: AppTypography.buttonText(color: Colors.white),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _submitMood() {
    if (_selectedMood == null) return;

    final moodEntry = MoodEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      mood: _selectedMood!,
      timestamp: DateTime.now(),
      intensity: _intensity,
    );

    context.read<AppStateProvider>().addMoodEntry(moodEntry);

    // Reset form
    setState(() {
      _selectedMood = null;
      _intensity = 3;
      _showDetails = false;
    });

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Mood check-in recorded! Thank you for sharing.',
          style: AppTypography.bodyMedium(color: Colors.white),
        ),
        backgroundColor: AppColors.accentPositive,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
