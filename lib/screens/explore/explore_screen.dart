import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Comprehensive explore screen with wellness topics and Manas helpline
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<ExploreCategory> _categories = [
    ExploreCategory(
      id: 'anxiety',
      title: 'Anxiety & Stress',
      description: 'Techniques to manage anxiety and stress',
      icon: Icons.psychology,
      color: AppColors.accentAction,
      topics: [
        'Deep Breathing Exercises',
        'Progressive Muscle Relaxation',
        'Cognitive Behavioral Techniques',
        'Mindfulness for Anxiety',
        'Stress Management at Work',
      ],
    ),
    ExploreCategory(
      id: 'depression',
      title: 'Depression Support',
      description: 'Resources for understanding and managing depression',
      icon: Icons.favorite,
      color: AppColors.accentPositive,
      topics: [
        'Understanding Depression',
        'Building Daily Routines',
        'Social Connection Tips',
        'Exercise for Mental Health',
        'Professional Help Resources',
      ],
    ),
    ExploreCategory(
      id: 'mindfulness',
      title: 'Mindfulness & Meditation',
      description: 'Guided practices for present-moment awareness',
      icon: Icons.self_improvement,
      color: AppColors.accentPrimary,
      topics: [
        'Beginner Meditation Guide',
        'Body Scan Meditation',
        'Walking Meditation',
        'Loving-Kindness Practice',
        'Mindful Eating',
      ],
    ),
    ExploreCategory(
      id: 'sleep',
      title: 'Sleep & Rest',
      description: 'Improve your sleep quality and rest',
      icon: Icons.nightlight,
      color: Color(0xFF9C88FF),
      topics: [
        'Sleep Hygiene Tips',
        'Bedtime Routines',
        'Dealing with Insomnia',
        'Relaxation Techniques',
        'Creating Sleep Environment',
      ],
    ),
    ExploreCategory(
      id: 'relationships',
      title: 'Relationships',
      description: 'Building healthy connections with others',
      icon: Icons.people,
      color: Color(0xFFFF8A80),
      topics: [
        'Communication Skills',
        'Setting Boundaries',
        'Conflict Resolution',
        'Building Trust',
        'Family Relationships',
      ],
    ),
    ExploreCategory(
      id: 'selfcare',
      title: 'Self-Care',
      description: 'Practices for taking care of yourself',
      icon: Icons.spa,
      color: Color(0xFF80CBC4),
      topics: [
        'Daily Self-Care Rituals',
        'Emotional Self-Care',
        'Physical Self-Care',
        'Mental Self-Care',
        'Time Management',
      ],
    ),
  ];

  List<ExploreCategory> get _filteredCategories {
    if (_searchQuery.isEmpty) return _categories;

    return _categories.where((category) {
      final matchesTitle = category.title.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final matchesDescription = category.description.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final matchesTopics = category.topics.any(
        (topic) => topic.toLowerCase().contains(_searchQuery.toLowerCase()),
      );

      return matchesTitle || matchesDescription || matchesTopics;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header with search
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(24),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Explore Wellness',
                      style: AppTypography.h2(
                        color: isDark
                            ? AppColors.primaryTextDark
                            : AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Discover resources, topics, and support for your mental health journey',
                      style: AppTypography.bodyMedium(
                        color: isDark
                            ? AppColors.primaryTextDark.withOpacity(0.8)
                            : AppColors.primaryText.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Search bar
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.secondaryElementDark
                            : AppColors.secondaryElement,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? AppColors.dividerDark
                              : AppColors.divider,
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText:
                              'Search topics, techniques, or resources...',
                          hintStyle: AppTypography.bodyMedium(
                            color: isDark
                                ? AppColors.primaryTextDark.withOpacity(0.5)
                                : AppColors.primaryText.withOpacity(0.5),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: isDark
                                ? AppColors.primaryTextDark.withOpacity(0.7)
                                : AppColors.primaryText.withOpacity(0.7),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                        style: AppTypography.bodyMedium(
                          color: isDark
                              ? AppColors.primaryTextDark
                              : AppColors.primaryText,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Manas Helpline (Prominent placement)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.red.withOpacity(0.1),
                        Colors.orange.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.red.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.phone,
                              color: Colors.red,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Manas Helpline',
                                  style: AppTypography.h4(color: Colors.red),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '24/7 Mental Health Support',
                                  style: AppTypography.bodyMedium(
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
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Need immediate help?',
                              style: AppTypography.h5(
                                color: isDark
                                    ? AppColors.primaryTextDark
                                    : AppColors.primaryText,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Call: 08046110007',
                              style: AppTypography.h4(color: Colors.red),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Free, confidential, 24/7 treatment referral service',
                              style: AppTypography.bodySmall(
                                color: isDark
                                    ? AppColors.primaryTextDark.withOpacity(0.8)
                                    : AppColors.primaryText.withOpacity(0.8),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Implement call functionality
                              },
                              icon: const Icon(Icons.phone),
                              label: const Text('Call Now'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // TODO: Open chat support
                              },
                              icon: const Icon(Icons.chat),
                              label: const Text('Chat Support'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Categories grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.9,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final category = _filteredCategories[index];
                  return _buildCategoryCard(category, isDark);
                }, childCount: _filteredCategories.length),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(ExploreCategory category, bool isDark) {
    return GestureDetector(
      onTap: () {
        _showTopicsDialog(category);
      },
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: category.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(category.icon, color: category.color, size: 30),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: Text(
                category.title,
                style: AppTypography.h5(
                  color: isDark
                      ? AppColors.primaryTextDark
                      : AppColors.primaryText,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                category.description,
                style: AppTypography.bodySmall(
                  color: isDark
                      ? AppColors.primaryTextDark.withOpacity(0.7)
                      : AppColors.primaryText.withOpacity(0.7),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: category.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${category.topics.length} topics',
                style: AppTypography.caption(color: category.color),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTopicsDialog(ExploreCategory category) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.primaryBackgroundDark
              : AppColors.primaryBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.dividerDark : AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: category.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(category.icon, color: category.color, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.title,
                          style: AppTypography.h4(
                            color: isDark
                                ? AppColors.primaryTextDark
                                : AppColors.primaryText,
                          ),
                        ),
                        Text(
                          category.description,
                          style: AppTypography.bodySmall(
                            color: isDark
                                ? AppColors.primaryTextDark.withOpacity(0.7)
                                : AppColors.primaryText.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Topics list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: category.topics.length,
                itemBuilder: (context, index) {
                  final topic = category.topics[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.secondaryElementDark
                          : AppColors.secondaryElement,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? AppColors.dividerDark
                            : AppColors.divider,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: category.color.withOpacity(0.1),
                        child: Icon(
                          Icons.article,
                          color: category.color,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        topic,
                        style: AppTypography.bodyMedium(
                          color: isDark
                              ? AppColors.primaryTextDark
                              : AppColors.primaryText,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: isDark
                            ? AppColors.primaryTextDark.withOpacity(0.5)
                            : AppColors.primaryText.withOpacity(0.5),
                      ),
                      onTap: () {
                        // TODO: Navigate to topic details
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Opening: $topic'),
                            backgroundColor: category.color,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExploreCategory {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> topics;

  ExploreCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.topics,
  });
}
