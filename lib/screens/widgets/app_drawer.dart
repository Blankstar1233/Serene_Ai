import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// App drawer with navigation and settings
class AppDrawer extends StatelessWidget {
  final int currentIndex;
  final Function(int) onNavigate;

  const AppDrawer({
    super.key,
    required this.currentIndex,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor: isDark
          ? AppColors.primaryBackgroundDark
          : AppColors.primaryBackground,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.accentPrimary,
                    AppColors.accentPrimary.withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.psychology,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Serene AI',
                    style: AppTypography.h3(color: Colors.white),
                  ),
                  Text(
                    'Your wellness companion',
                    style: AppTypography.bodySmall(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            // Navigation Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildNavItem(
                    context,
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    title: 'Dashboard',
                    index: 0,
                    isDark: isDark,
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.chat_bubble_outline,
                    activeIcon: Icons.chat_bubble,
                    title: 'AI Chat',
                    index: 1,
                    isDark: isDark,
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.explore_outlined,
                    activeIcon: Icons.explore,
                    title: 'Explore',
                    index: 2,
                    isDark: isDark,
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.trending_up_outlined,
                    activeIcon: Icons.trending_up,
                    title: 'Progress',
                    index: 3,
                    isDark: isDark,
                  ),

                  const Divider(height: 32),

                  // Theme Toggle
                  Consumer<AppStateProvider>(
                    builder: (context, appState, child) {
                      return ListTile(
                        leading: Icon(
                          isDark ? Icons.light_mode : Icons.dark_mode,
                          color: isDark
                              ? AppColors.primaryTextDark
                              : AppColors.primaryText,
                        ),
                        title: Text(
                          isDark ? 'Light Mode' : 'Dark Mode',
                          style: AppTypography.bodyMedium(
                            color: isDark
                                ? AppColors.primaryTextDark
                                : AppColors.primaryText,
                          ),
                        ),
                        onTap: () {
                          appState.toggleTheme();
                        },
                        trailing: Switch(
                          value: isDark,
                          onChanged: (_) {
                            appState.toggleTheme();
                          },
                          activeColor: AppColors.accentPrimary,
                        ),
                      );
                    },
                  ),

                  // Settings
                  ListTile(
                    leading: Icon(
                      Icons.settings_outlined,
                      color: isDark
                          ? AppColors.primaryTextDark
                          : AppColors.primaryText,
                    ),
                    title: Text(
                      'Settings',
                      style: AppTypography.bodyMedium(
                        color: isDark
                            ? AppColors.primaryTextDark
                            : AppColors.primaryText,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navigate to settings
                    },
                  ),

                  // Help & Support
                  ListTile(
                    leading: Icon(
                      Icons.help_outline,
                      color: isDark
                          ? AppColors.primaryTextDark
                          : AppColors.primaryText,
                    ),
                    title: Text(
                      'Help & Support',
                      style: AppTypography.bodyMedium(
                        color: isDark
                            ? AppColors.primaryTextDark
                            : AppColors.primaryText,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navigate to help
                    },
                  ),
                ],
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        size: 16,
                        color: AppColors.accentPositive,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Made with care for your wellness',
                        style: AppTypography.caption(
                          color: isDark
                              ? AppColors.primaryTextDark.withOpacity(0.7)
                              : AppColors.primaryText.withOpacity(0.7),
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
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String title,
    required int index,
    required bool isDark,
  }) {
    final isActive = currentIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isActive
            ? AppColors.accentPrimary.withOpacity(0.1)
            : Colors.transparent,
      ),
      child: ListTile(
        leading: Icon(
          isActive ? activeIcon : icon,
          color: isActive
              ? AppColors.accentPrimary
              : (isDark ? AppColors.primaryTextDark : AppColors.primaryText),
        ),
        title: Text(
          title,
          style: AppTypography.bodyMedium(
            color: isActive
                ? AppColors.accentPrimary
                : (isDark ? AppColors.primaryTextDark : AppColors.primaryText),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          onNavigate(index);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
