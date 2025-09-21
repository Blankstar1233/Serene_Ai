import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../widgets/mood_check_in_widget.dart';
import '../widgets/journey_card_widget.dart';
import '../widgets/suggested_module_widget.dart';

/// Enhanced dashboard with professional design and creative layout
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _breathingAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );
    _breathingController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Consumer<AppStateProvider>(
          builder: (context, appState, child) {
            return CustomScrollView(
              slivers: [
                // Enhanced Hero Header
                SliverToBoxAdapter(
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 220),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.accentPrimary.withOpacity(0.1),
                          AppColors.accentPositive.withOpacity(0.05),
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Background pattern
                        Positioned.fill(
                          child: CustomPaint(
                            painter: WellnessBgPainter(
                              color: AppColors.accentPrimary.withOpacity(0.05),
                            ),
                          ),
                        ),

                        // Content
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 20),

                              // Greeting with profile and streak
                              Row(
                                children: [
                                  // Profile Photo
                                  GestureDetector(
                                    onTap: () =>
                                        _showProfileDialog(context, appState),
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.accentPrimary,
                                          width: 2,
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        radius: 28,
                                        backgroundColor: AppColors.accentPrimary
                                            .withOpacity(0.2),
                                        child:
                                            appState.userProfile?.avatar != null
                                            ? ClipOval(
                                                child: Image.network(
                                                  appState.userProfile!.avatar!,
                                                  width: 56,
                                                  height: 56,
                                                  fit: BoxFit.cover,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) => const Icon(
                                                        Icons.person,
                                                        size: 30,
                                                        color: AppColors
                                                            .accentPrimary,
                                                      ),
                                                ),
                                              )
                                            : const Icon(
                                                Icons.person,
                                                size: 30,
                                                color: AppColors.accentPrimary,
                                              ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          appState.getGreeting(),
                                          style: AppTypography.h2(
                                            color: isDark
                                                ? AppColors.primaryTextDark
                                                : AppColors.primaryText,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.accentPositive
                                                .withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            border: Border.all(
                                              color: AppColors.accentPositive
                                                  .withOpacity(0.3),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.local_fire_department,
                                                size: 20,
                                                color: AppColors.accentPositive,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '${appState.userProgress?.consecutiveDays ?? 0} day streak!',
                                                style: AppTypography.bodyMedium(
                                                  color:
                                                      AppColors.accentPositive,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Breathing animation
                                  AnimatedBuilder(
                                    animation: _breathingAnimation,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: _breathingAnimation.value,
                                        child: Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: RadialGradient(
                                              colors: [
                                                AppColors.accentPrimary
                                                    .withOpacity(0.3),
                                                AppColors.accentPrimary
                                                    .withOpacity(0.1),
                                              ],
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.self_improvement,
                                            size: 40,
                                            color: AppColors.accentPrimary,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // Quick stats
                              Text(
                                'Your Wellness Today',
                                style: AppTypography.h5(
                                  color: isDark
                                      ? AppColors.primaryTextDark
                                      : AppColors.primaryText,
                                ),
                              ),
                              const SizedBox(height: 16),

                              Row(
                                children: [
                                  Expanded(
                                    child: _buildQuickStat(
                                      icon: Icons.favorite,
                                      label: 'Mood',
                                      value: _getMoodText(
                                        appState.latestMoodEntry?.mood,
                                      ),
                                      color: AppColors.accentPositive,
                                      isDark: isDark,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildQuickStat(
                                      icon: Icons.timer,
                                      label: 'Minutes',
                                      value:
                                          '${appState.userProgress?.totalMindfulnessMinutes ?? 0}',
                                      color: AppColors.accentPrimary,
                                      isDark: isDark,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildQuickStat(
                                      icon: Icons.trending_up,
                                      label: 'Sessions',
                                      value:
                                          '${appState.userProgress?.totalSessionsCompleted ?? 0}',
                                      color: AppColors.accentAction,
                                      isDark: isDark,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Quick Actions
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Actions',
                          style: AppTypography.h4(
                            color: isDark
                                ? AppColors.primaryTextDark
                                : AppColors.primaryText,
                          ),
                        ),
                        const SizedBox(height: 16),

                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.8,
                          children: [
                            _buildActionCard(
                              icon: Icons.chat_bubble,
                              title: 'AI Chat',
                              subtitle: 'Talk with your companion',
                              color: AppColors.accentPrimary,
                              onTap: () {
                                // TODO: Navigate to chat
                              },
                              isDark: isDark,
                            ),
                            _buildActionCard(
                              icon: Icons.self_improvement,
                              title: 'Breathe',
                              subtitle: '3-minute session',
                              color: AppColors.accentPositive,
                              onTap: () {
                                // TODO: Start breathing exercise
                              },
                              isDark: isDark,
                            ),
                            _buildActionCard(
                              icon: Icons.book,
                              title: 'Journal',
                              subtitle: 'Reflect on your day',
                              color: AppColors.accentAction,
                              onTap: () {
                                // TODO: Open journal
                              },
                              isDark: isDark,
                            ),
                            _buildActionCard(
                              icon: Icons.explore,
                              title: 'Explore',
                              subtitle: 'Discover new topics',
                              color: AppColors.accentAction,
                              onTap: () {
                                // TODO: Navigate to explore
                              },
                              isDark: isDark,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Main content
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 8),

                      // Today's Journey
                      if (appState.activeJourney != null) ...[
                        Text(
                          'Continue Your Journey',
                          style: AppTypography.h4(
                            color: isDark
                                ? AppColors.primaryTextDark
                                : AppColors.primaryText,
                          ),
                        ),
                        const SizedBox(height: 16),
                        JourneyCardWidget(journey: appState.activeJourney!),
                        const SizedBox(height: 32),
                      ],

                      // Mood Check-in
                      Text(
                        'How Are You Feeling?',
                        style: AppTypography.h4(
                          color: isDark
                              ? AppColors.primaryTextDark
                              : AppColors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const MoodCheckInWidget(),
                      const SizedBox(height: 32),

                      // Suggested for you
                      Text(
                        'Suggested For You',
                        style: AppTypography.h4(
                          color: isDark
                              ? AppColors.primaryTextDark
                              : AppColors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const SuggestedModuleWidget(),
                      const SizedBox(height: 100),
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

  Widget _buildQuickStat({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.secondaryElementDark
            : AppColors.secondaryElement,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.divider,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTypography.h4(
              color: isDark ? AppColors.primaryTextDark : AppColors.primaryText,
            ),
          ),
          Text(
            label,
            style: AppTypography.caption(
              color: isDark
                  ? AppColors.primaryTextDark.withOpacity(0.7)
                  : AppColors.primaryText.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const Spacer(),
            Text(
              title,
              style: AppTypography.h5(
                color: isDark
                    ? AppColors.primaryTextDark
                    : AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 4),
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
      ),
    );
  }

  void _showProfileDialog(BuildContext context, AppStateProvider appState) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final profile = appState.userProfile;

    final nameController = TextEditingController(text: profile?.name ?? '');
    final emailController = TextEditingController(
      text: profile?.preferences['email'] ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark
            ? AppColors.primaryBackgroundDark
            : AppColors.primaryBackground,
        title: Text(
          'Edit Profile',
          style: AppTypography.h4(
            color: isDark ? AppColors.primaryTextDark : AppColors.primaryText,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Profile Photo Section
              GestureDetector(
                onTap: () {
                  // TODO: Implement photo picker
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Photo picker coming soon!')),
                  );
                },
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.accentPrimary.withOpacity(0.2),
                      child: profile?.avatar != null
                          ? ClipOval(
                              child: Image.network(
                                profile!.avatar!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: AppColors.accentPrimary,
                                    ),
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              size: 50,
                              color: AppColors.accentPrimary,
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.accentPrimary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                                ? AppColors.primaryBackgroundDark
                                : AppColors.primaryBackground,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Name Field
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: AppTypography.bodyMedium(
                    color: isDark
                        ? AppColors.primaryTextDark.withOpacity(0.7)
                        : AppColors.primaryText.withOpacity(0.7),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.dividerDark : AppColors.divider,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.accentPrimary,
                    ),
                  ),
                ),
                style: AppTypography.bodyMedium(
                  color: isDark
                      ? AppColors.primaryTextDark
                      : AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 16),

              // Email Field
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: AppTypography.bodyMedium(
                    color: isDark
                        ? AppColors.primaryTextDark.withOpacity(0.7)
                        : AppColors.primaryText.withOpacity(0.7),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.dividerDark : AppColors.divider,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.accentPrimary,
                    ),
                  ),
                ),
                style: AppTypography.bodyMedium(
                  color: isDark
                      ? AppColors.primaryTextDark
                      : AppColors.primaryText,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Additional Options
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.secondaryElementDark
                      : AppColors.secondaryElement,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? AppColors.dividerDark : AppColors.divider,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account Settings',
                      style: AppTypography.h5(
                        color: isDark
                            ? AppColors.primaryTextDark
                            : AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.lock_outline,
                        color: isDark
                            ? AppColors.primaryTextDark
                            : AppColors.primaryText,
                      ),
                      title: Text(
                        'Change Password',
                        style: AppTypography.bodyMedium(
                          color: isDark
                              ? AppColors.primaryTextDark
                              : AppColors.primaryText,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // TODO: Implement password change
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Password change coming soon!'),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.notifications,
                        color: isDark
                            ? AppColors.primaryTextDark
                            : AppColors.primaryText,
                      ),
                      title: Text(
                        'Notification Settings',
                        style: AppTypography.bodyMedium(
                          color: isDark
                              ? AppColors.primaryTextDark
                              : AppColors.primaryText,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // TODO: Implement notification settings
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Notification settings coming soon!'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTypography.bodyMedium(color: AppColors.accentAction),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Update profile
              if (profile != null) {
                final updatedPreferences = Map<String, dynamic>.from(
                  profile.preferences,
                );
                updatedPreferences['email'] = emailController.text;

                final updatedProfile = profile.copyWith(
                  name: nameController.text,
                  preferences: updatedPreferences,
                );

                appState.setUserProfile(updatedProfile);
              }

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated successfully!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  String _getMoodText(dynamic mood) {
    if (mood == null) return 'Check-in';
    switch (mood.toString()) {
      case 'MoodType.happy':
        return 'Happy';
      case 'MoodType.calm':
        return 'Calm';
      case 'MoodType.grateful':
        return 'Grateful';
      case 'MoodType.stressed':
        return 'Stressed';
      case 'MoodType.anxious':
        return 'Anxious';
      case 'MoodType.sad':
        return 'Sad';
      default:
        return 'Check-in';
    }
  }
}

/// Custom painter for wellness background pattern
class WellnessBgPainter extends CustomPainter {
  final Color color;

  WellnessBgPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw flowing lines
    for (int i = 0; i < 5; i++) {
      final path = Path();
      final startX = size.width * (i * 0.2);
      final startY = size.height * 0.3;

      path.moveTo(startX, startY);
      path.quadraticBezierTo(
        startX + size.width * 0.1,
        startY - size.height * 0.1,
        startX + size.width * 0.2,
        startY,
      );

      canvas.drawPath(path, paint);
    }

    // Draw circles
    for (int i = 0; i < 8; i++) {
      final center = Offset(
        size.width * (0.1 + (i * 0.15)),
        size.height * (0.6 + (i % 2) * 0.2),
      );
      canvas.drawCircle(center, 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
