import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../models/journey.dart';
import '../../models/mood_entry.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'dart:math' as math;

/// Comprehensive progress screen with charts, achievements, and wellness journey visualization
class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with TickerProviderStateMixin {
  late AnimationController _chartController;
  late Animation<double> _chartAnimation;

  @override
  void initState() {
    super.initState();
    _chartController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _chartAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _chartController, curve: Curves.easeInOut),
    );
    _chartController.forward();
  }

  @override
  void dispose() {
    _chartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Consumer<AppStateProvider>(
          builder: (context, appState, child) {
            final progress = appState.userProgress;

            return CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.accentAction.withOpacity(0.1),
                          AppColors.accentPrimary.withOpacity(0.05),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Progress',
                          style: AppTypography.h2(
                            color: isDark
                                ? AppColors.primaryTextDark
                                : AppColors.primaryText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Track your wellness journey and celebrate achievements',
                          style: AppTypography.bodyMedium(
                            color: isDark
                                ? AppColors.primaryTextDark.withOpacity(0.8)
                                : AppColors.primaryText.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Progress Overview Cards
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.2,
                      children: [
                        _buildProgressCard(
                          title: 'Streak',
                          value: '${progress?.consecutiveDays ?? 0}',
                          subtitle: 'days in a row',
                          icon: Icons.local_fire_department,
                          color: AppColors.accentPositive,
                          isDark: isDark,
                        ),
                        _buildProgressCard(
                          title: 'Total Sessions',
                          value: '${progress?.totalSessionsCompleted ?? 0}',
                          subtitle: 'completed',
                          icon: Icons.psychology,
                          color: AppColors.accentPrimary,
                          isDark: isDark,
                        ),
                        _buildProgressCard(
                          title: 'Mindfulness',
                          value: '${progress?.totalMindfulnessMinutes ?? 0}',
                          subtitle: 'minutes',
                          icon: Icons.timer,
                          color: AppColors.accentAction,
                          isDark: isDark,
                        ),
                        _buildProgressCard(
                          title: 'Active Days',
                          value: '${progress?.totalDaysActive ?? 0}',
                          subtitle: 'total',
                          icon: Icons.calendar_today,
                          color: Color(0xFF9C88FF),
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),
                ),

                // Wellness Journey Visualization
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Wellness Journey',
                          style: AppTypography.h4(
                            color: isDark
                                ? AppColors.primaryTextDark
                                : AppColors.primaryText,
                          ),
                        ),
                        const SizedBox(height: 16),

                        if (appState.activeJourney != null)
                          _buildJourneyProgress(
                            appState.activeJourney!,
                            isDark,
                          ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 32)),

                // Mood Chart
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mood Trends',
                          style: AppTypography.h4(
                            color: isDark
                                ? AppColors.primaryTextDark
                                : AppColors.primaryText,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildMoodChart(appState.moodEntries, isDark),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 32)),

                // Achievements
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Achievements',
                          style: AppTypography.h4(
                            color: isDark
                                ? AppColors.primaryTextDark
                                : AppColors.primaryText,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildAchievements(progress, isDark),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProgressCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.secondaryElementDark
            : AppColors.secondaryElement,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.divider,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTypography.h2(
              color: isDark ? AppColors.primaryTextDark : AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTypography.h5(
              color: isDark ? AppColors.primaryTextDark : AppColors.primaryText,
            ),
          ),
          Text(
            subtitle,
            style: AppTypography.bodySmall(
              color: isDark
                  ? AppColors.primaryTextDark.withOpacity(0.7)
                  : AppColors.primaryText.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyProgress(Journey journey, bool isDark) {
    final currentDay = journey.currentDay;
    final totalTasks = journey.tasks.length;
    final completedTasks = journey.tasks
        .where((task) => task.isCompleted)
        .length;
    final progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.secondaryElementDark
            : AppColors.secondaryElement,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.divider,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      journey.title ?? 'Mindfulness Journey',
                      style: AppTypography.h5(
                        color: isDark
                            ? AppColors.primaryTextDark
                            : AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Day $currentDay of 7',
                      style: AppTypography.bodyMedium(
                        color: isDark
                            ? AppColors.primaryTextDark.withOpacity(0.7)
                            : AppColors.primaryText.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              CircularProgressIndicator(
                value: progress,
                backgroundColor: (isDark
                    ? AppColors.dividerDark
                    : AppColors.divider),
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.accentPrimary,
                ),
                strokeWidth: 6,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Progress dots
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final isCompleted = index < completedTasks;
              final isCurrent = index == currentDay - 1;

              return Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.accentPrimary
                      : (isCurrent
                            ? AppColors.accentPrimary.withOpacity(0.3)
                            : (isDark
                                  ? AppColors.dividerDark
                                  : AppColors.divider)),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: AppTypography.bodySmall(
                      color: isCompleted || isCurrent
                          ? Colors.white
                          : (isDark
                                ? AppColors.primaryTextDark
                                : AppColors.primaryText),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodChart(List<dynamic> moodEntries, bool isDark) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.secondaryElementDark
            : AppColors.secondaryElement,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.divider,
        ),
      ),
      child: AnimatedBuilder(
        animation: _chartAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: MoodChartPainter(
              moodEntries: moodEntries,
              animationValue: _chartAnimation.value,
              isDark: isDark,
            ),
            size: const Size(double.infinity, 150),
          );
        },
      ),
    );
  }

  Widget _buildAchievements(dynamic progress, bool isDark) {
    final achievements = [
      Achievement(
        title: 'First Steps',
        description: 'Complete your first session',
        icon: Icons.star,
        isUnlocked: (progress?.totalSessionsCompleted ?? 0) >= 1,
        color: AppColors.accentPositive,
      ),
      Achievement(
        title: 'Week Warrior',
        description: 'Maintain a 7-day streak',
        icon: Icons.local_fire_department,
        isUnlocked: (progress?.consecutiveDays ?? 0) >= 7,
        color: AppColors.accentAction,
      ),
      Achievement(
        title: 'Mindful Master',
        description: 'Complete 50 minutes of mindfulness',
        icon: Icons.psychology,
        isUnlocked: (progress?.totalMindfulnessMinutes ?? 0) >= 50,
        color: AppColors.accentPrimary,
      ),
      Achievement(
        title: 'Journey Seeker',
        description: 'Complete your first journey',
        icon: Icons.route,
        isUnlocked: false, // TODO: Check for completed journeys
        color: Color(0xFF9C88FF),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.3,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.secondaryElementDark
                : AppColors.secondaryElement,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: achievement.isUnlocked
                  ? achievement.color.withOpacity(0.5)
                  : (isDark ? AppColors.dividerDark : AppColors.divider),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: achievement.isUnlocked
                      ? achievement.color.withOpacity(0.1)
                      : (isDark
                            ? AppColors.dividerDark.withOpacity(0.3)
                            : AppColors.divider.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  achievement.icon,
                  color: achievement.isUnlocked
                      ? achievement.color
                      : (isDark
                            ? AppColors.primaryTextDark.withOpacity(0.3)
                            : AppColors.primaryText.withOpacity(0.3)),
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                achievement.title,
                style: AppTypography.bodyMedium(
                  color: achievement.isUnlocked
                      ? (isDark
                            ? AppColors.primaryTextDark
                            : AppColors.primaryText)
                      : (isDark
                            ? AppColors.primaryTextDark.withOpacity(0.5)
                            : AppColors.primaryText.withOpacity(0.5)),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                achievement.description,
                style: AppTypography.caption(
                  color: isDark
                      ? AppColors.primaryTextDark.withOpacity(0.7)
                      : AppColors.primaryText.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}

class Achievement {
  final String title;
  final String description;
  final IconData icon;
  final bool isUnlocked;
  final Color color;

  Achievement({
    required this.title,
    required this.description,
    required this.icon,
    required this.isUnlocked,
    required this.color,
  });
}

/// Custom painter for mood chart visualization
class MoodChartPainter extends CustomPainter {
  final List<dynamic> moodEntries;
  final double animationValue;
  final bool isDark;

  MoodChartPainter({
    required this.moodEntries,
    required this.animationValue,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (moodEntries.isEmpty) {
      _drawEmptyState(canvas, size);
      return;
    }

    final paint = Paint()
      ..color = AppColors.accentPrimary
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final pointPaint = Paint()
      ..color = AppColors.accentPrimary
      ..style = PaintingStyle.fill;

    // Simple line chart simulation
    final path = Path();
    final points = <Offset>[];

    for (int i = 0; i < math.min(7, moodEntries.length); i++) {
      final x = (size.width / 6) * i;
      final y = size.height * (0.8 - (i % 3) * 0.2); // Simulated mood values
      points.add(Offset(x, y));

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Draw animated line
    final animatedPath = _createAnimatedPath(path, animationValue);
    canvas.drawPath(animatedPath, paint);

    // Draw points
    for (int i = 0; i < points.length; i++) {
      if (i / points.length <= animationValue) {
        canvas.drawCircle(points[i], 6, pointPaint);
      }
    }
  }

  void _drawEmptyState(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? AppColors.primaryTextDark : AppColors.primaryText)
          .withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw placeholder chart
    final path = Path();
    path.moveTo(0, size.height * 0.5);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.2,
      size.width,
      size.height * 0.7,
    );

    canvas.drawPath(path, paint);

    // Draw "No data" text
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Start tracking your mood to see trends',
        style: TextStyle(
          color: (isDark ? AppColors.primaryTextDark : AppColors.primaryText)
              .withOpacity(0.5),
          fontSize: 14,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2,
      ),
    );
  }

  Path _createAnimatedPath(Path originalPath, double animationValue) {
    return Path()..addPath(originalPath, Offset.zero);
  }

  @override
  bool shouldRepaint(MoodChartPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.moodEntries != moodEntries;
  }
}
