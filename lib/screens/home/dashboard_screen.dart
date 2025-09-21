import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../widgets/mood_check_in_widget.dart';
import '../widgets/journey_card_widget.dart';
import '../widgets/suggested_module_widget.dart';

/// Dashboard/Home screen with personalized greeting and daily wellness components
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AppStateProvider>(
          builder: (context, appState, child) {
            return CustomScrollView(
              slivers: [
                // App Bar with greeting
                SliverAppBar(
                  expandedHeight: 100,
                  floating: false,
                  pinned: false,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            appState.getGreeting(),
                            style: AppTypography.greeting(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.primaryTextDark
                                  : AppColors.primaryText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getSubtitle(appState),
                            style: AppTypography.bodyMedium(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.primaryTextDark.withOpacity(0.7)
                                  : AppColors.primaryText.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Main content
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Mood Check-in
                      const MoodCheckInWidget(),

                      const SizedBox(height: 24),

                      // Today's Journey Card
                      if (appState.activeJourney != null)
                        JourneyCardWidget(journey: appState.activeJourney!),

                      const SizedBox(height: 24),

                      // Suggested Module
                      const SuggestedModuleWidget(),

                      const SizedBox(height: 24),

                      // Recent Progress Summary
                      _buildProgressSummary(context, appState),

                      const SizedBox(height: 100), // Bottom padding for nav bar
                    ]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _getSubtitle(AppStateProvider appState) {
    final progress = appState.userProgress;
    if (progress != null && progress.consecutiveDays > 0) {
      return '${progress.consecutiveDays} day${progress.consecutiveDays == 1 ? '' : 's'} streak! Keep it up!';
    }
    return 'Ready to start your wellness journey?';
  }

  Widget _buildProgressSummary(
    BuildContext context,
    AppStateProvider appState,
  ) {
    final progress = appState.userProgress;
    if (progress == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Progress',
              style: AppTypography.cardTitle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.primaryTextDark
                    : AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildProgressItem(
                    context,
                    '${progress.consecutiveDays}',
                    'Day Streak',
                    AppColors.accentPositive,
                  ),
                ),
                Expanded(
                  child: _buildProgressItem(
                    context,
                    '${progress.totalMindfulnessMinutes}',
                    'Minutes',
                    AppColors.accentPrimary,
                  ),
                ),
                Expanded(
                  child: _buildProgressItem(
                    context,
                    '${progress.totalSessionsCompleted}',
                    'Sessions',
                    AppColors.accentAction,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressItem(
    BuildContext context,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Center(
            child: Text(value, style: AppTypography.h5(color: color)),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppTypography.caption(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.primaryTextDark.withOpacity(0.7)
                : AppColors.primaryText.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
