import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Right panel showing user profile and settings
class ProfilePanel extends StatefulWidget {
  final bool isVisible;
  final VoidCallback onClose;

  const ProfilePanel({
    super.key,
    required this.isVisible,
    required this.onClose,
  });

  @override
  State<ProfilePanel> createState() => _ProfilePanelState();
}

class _ProfilePanelState extends State<ProfilePanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    if (widget.isVisible) {
      _animationController.reverse();
    }
  }

  @override
  void didUpdateWidget(ProfilePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(300 * _slideAnimation.value, 0),
          child: Container(
            width: 300,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.primaryBackgroundDark
                  : AppColors.primaryBackground,
              border: Border(
                left: BorderSide(
                  color: isDark ? AppColors.dividerDark : AppColors.divider,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProfileSection(),
                        const SizedBox(height: 24),
                        _buildWellnessMetrics(),
                        const SizedBox(height: 24),
                        _buildRecentActivity(),
                        const SizedBox(height: 24),
                        _buildSettings(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.secondaryElementDark
            : AppColors.secondaryElement,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.dividerDark : AppColors.divider,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Profile',
            style: AppTypography.h5(
              color: isDark ? AppColors.primaryTextDark : AppColors.primaryText,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: widget.onClose,
            icon: Icon(
              Icons.close,
              color: isDark ? AppColors.primaryTextDark : AppColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final profile = appState.userProfile;

        return Column(
          children: [
            // Profile picture
            Stack(
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
                    width: 32,
                    height: 32,
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
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Name and status
            Text(
              profile?.name ?? 'Guest',
              style: AppTypography.h4(
                color: isDark
                    ? AppColors.primaryTextDark
                    : AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accentPositive.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Wellness Journey: Day ${DateTime.now().difference(profile?.joinedAt ?? DateTime.now()).inDays + 1}',
                style: AppTypography.caption(color: AppColors.accentPositive),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWellnessMetrics() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Wellness Metrics',
          style: AppTypography.h5(
            color: isDark ? AppColors.primaryTextDark : AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 16),

        // Mood streak
        _buildMetricCard(
          icon: Icons.favorite,
          label: 'Mood Streak',
          value: '7 days',
          color: AppColors.accentPositive,
          isDark: isDark,
        ),
        const SizedBox(height: 12),

        // Meditation time
        _buildMetricCard(
          icon: Icons.self_improvement,
          label: 'Meditation Time',
          value: '2h 15m',
          color: AppColors.accentPrimary,
          isDark: isDark,
        ),
        const SizedBox(height: 12),

        // Journal entries
        _buildMetricCard(
          icon: Icons.book,
          label: 'Journal Entries',
          value: '23',
          color: AppColors.accentAction,
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildMetricCard({
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.divider,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.bodySmall(
                    color: isDark
                        ? AppColors.primaryTextDark.withOpacity(0.7)
                        : AppColors.primaryText.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTypography.h5(
                    color: isDark
                        ? AppColors.primaryTextDark
                        : AppColors.primaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: AppTypography.h5(
            color: isDark ? AppColors.primaryTextDark : AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 16),

        // Activity items
        _buildActivityItem(
          icon: Icons.chat,
          title: 'Chat Session',
          subtitle: 'Discussed stress management',
          time: '2 hours ago',
          color: AppColors.accentPrimary,
          isDark: isDark,
        ),
        const SizedBox(height: 12),

        _buildActivityItem(
          icon: Icons.mood,
          title: 'Mood Check-in',
          subtitle: 'Feeling good (8/10)',
          time: 'This morning',
          color: AppColors.accentPositive,
          isDark: isDark,
        ),
        const SizedBox(height: 12),

        _buildActivityItem(
          icon: Icons.self_improvement,
          title: 'Breathing Exercise',
          subtitle: '10 minutes completed',
          time: 'Yesterday',
          color: AppColors.accentAction,
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required Color color,
    required bool isDark,
  }) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.bodyMedium(
                  color: isDark
                      ? AppColors.primaryTextDark
                      : AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 2),
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
        Text(
          time,
          style: AppTypography.caption(
            color: isDark
                ? AppColors.primaryTextDark.withOpacity(0.5)
                : AppColors.primaryText.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildSettings() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: AppTypography.h5(
            color: isDark ? AppColors.primaryTextDark : AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 16),

        // Notifications
        _buildSettingItem(
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          subtitle: 'Daily reminders and updates',
          trailing: Consumer<AppStateProvider>(
            builder: (context, appState, child) {
              return Switch(
                value:
                    appState.userProfile?.preferences['notifications'] ?? true,
                onChanged: (value) {
                  // TODO: Implement updateUserPreference
                  // appState.updateUserPreference('notifications', value);
                },
                activeColor: AppColors.accentPrimary,
              );
            },
          ),
          isDark: isDark,
        ),

        // Theme
        _buildSettingItem(
          icon: isDark ? Icons.light_mode : Icons.dark_mode,
          title: 'Theme',
          subtitle: isDark ? 'Switch to light mode' : 'Switch to dark mode',
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Implement toggleTheme
            // context.read<AppStateProvider>().toggleTheme();
          },
          isDark: isDark,
        ),

        // Privacy
        _buildSettingItem(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy',
          subtitle: 'Data and privacy settings',
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Navigate to privacy settings
          },
          isDark: isDark,
        ),

        // Help & Support
        _buildSettingItem(
          icon: Icons.help_outline,
          title: 'Help & Support',
          subtitle: 'FAQs and contact support',
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Navigate to help
          },
          isDark: isDark,
        ),

        const SizedBox(height: 24),

        // Sign out button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              // TODO: Implement sign out
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: BorderSide(color: AppColors.accentAction.withOpacity(0.5)),
            ),
            child: Text(
              'Sign Out',
              style: AppTypography.bodyMedium(color: AppColors.accentAction),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
    required bool isDark,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: isDark
            ? AppColors.primaryTextDark.withOpacity(0.7)
            : AppColors.primaryText.withOpacity(0.7),
      ),
      title: Text(
        title,
        style: AppTypography.bodyMedium(
          color: isDark ? AppColors.primaryTextDark : AppColors.primaryText,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTypography.bodySmall(
          color: isDark
              ? AppColors.primaryTextDark.withOpacity(0.7)
              : AppColors.primaryText.withOpacity(0.7),
        ),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
