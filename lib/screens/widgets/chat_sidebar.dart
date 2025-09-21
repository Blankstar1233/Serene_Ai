import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/chat_message.dart';

/// Left sidebar with chat history, sessions, and current tasks
class ChatSidebar extends StatefulWidget {
  final bool isCollapsed;
  final VoidCallback onToggle;

  const ChatSidebar({
    super.key,
    required this.isCollapsed,
    required this.onToggle,
  });

  @override
  State<ChatSidebar> createState() => _ChatSidebarState();
}

class _ChatSidebarState extends State<ChatSidebar> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.secondaryElementDark
            : AppColors.secondaryElement,
        border: Border(
          right: BorderSide(
            color: isDark ? AppColors.dividerDark : AppColors.divider,
            width: 1,
          ),
        ),
      ),
      child: widget.isCollapsed
          ? _buildCollapsedSidebar()
          : _buildFullSidebar(),
    );
  }

  Widget _buildCollapsedSidebar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Toggle button
        Container(
          height: 60,
          child: Center(
            child: IconButton(
              onPressed: widget.onToggle,
              icon: Icon(
                Icons.menu,
                color: isDark
                    ? AppColors.primaryTextDark
                    : AppColors.primaryText,
              ),
            ),
          ),
        ),
        const Divider(height: 1),

        // Collapsed navigation icons
        Expanded(
          child: Column(
            children: [
              _buildCollapsedNavItem(Icons.chat_bubble_outline, 0),
              _buildCollapsedNavItem(Icons.history, 1),
              _buildCollapsedNavItem(Icons.task_alt, 2),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCollapsedNavItem(IconData icon, int index) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = _selectedTab == index;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: IconButton(
        onPressed: () {
          setState(() {
            _selectedTab = index;
          });
        },
        icon: Icon(
          icon,
          color: isSelected
              ? AppColors.accentPrimary
              : (isDark
                    ? AppColors.primaryTextDark.withOpacity(0.7)
                    : AppColors.primaryText.withOpacity(0.7)),
        ),
      ),
    );
  }

  Widget _buildFullSidebar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Header with toggle
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                'Serene AI',
                style: AppTypography.h4(
                  color: isDark
                      ? AppColors.primaryTextDark
                      : AppColors.primaryText,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: widget.onToggle,
                icon: Icon(
                  Icons.chevron_left,
                  color: isDark
                      ? AppColors.primaryTextDark
                      : AppColors.primaryText,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // Tab navigation
        Container(
          height: 50,
          child: Row(
            children: [
              _buildTabButton('Chats', 0, Icons.chat_bubble_outline),
              _buildTabButton('History', 1, Icons.history),
              _buildTabButton('Tasks', 2, Icons.task_alt),
            ],
          ),
        ),
        const Divider(height: 1),

        // Content area
        Expanded(
          child: IndexedStack(
            index: _selectedTab,
            children: [
              _buildChatsList(),
              _buildHistoryList(),
              _buildTasksList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabButton(String label, int index, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = _selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.accentPrimary.withOpacity(0.1)
                : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: isSelected
                    ? AppColors.accentPrimary
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? AppColors.accentPrimary
                    : (isDark
                          ? AppColors.primaryTextDark.withOpacity(0.7)
                          : AppColors.primaryText.withOpacity(0.7)),
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: AppTypography.caption(
                  color: isSelected
                      ? AppColors.accentPrimary
                      : (isDark
                            ? AppColors.primaryTextDark.withOpacity(0.7)
                            : AppColors.primaryText.withOpacity(0.7)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatsList() {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final sessions = appState.chatSessions;

        if (sessions.isEmpty) {
          return _buildEmptyState(
            'No conversations yet',
            'Start a new chat to begin',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            final session = sessions[index];
            return _buildChatItem(session);
          },
        );
      },
    );
  }

  Widget _buildChatItem(ChatSession session) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.accentPrimary.withOpacity(0.2),
          child: const Icon(
            Icons.chat_bubble_outline,
            size: 16,
            color: AppColors.accentPrimary,
          ),
        ),
        title: Text(
          session.title,
          style: AppTypography.bodySmall(
            color: isDark ? AppColors.primaryTextDark : AppColors.primaryText,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: session.messages.isNotEmpty
            ? Text(
                session.messages.last.content,
                style: AppTypography.caption(
                  color: isDark
                      ? AppColors.primaryTextDark.withOpacity(0.6)
                      : AppColors.primaryText.withOpacity(0.6),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: Text(
          _formatTime(session.lastMessageAt),
          style: AppTypography.caption(
            color: isDark
                ? AppColors.primaryTextDark.withOpacity(0.5)
                : AppColors.primaryText.withOpacity(0.5),
          ),
        ),
        onTap: () {
          // TODO: Load selected chat session
        },
      ),
    );
  }

  Widget _buildHistoryList() {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        _buildHistoryItem('Today', '3 conversations'),
        _buildHistoryItem('Yesterday', '5 conversations'),
        _buildHistoryItem('This Week', '12 conversations'),
        _buildHistoryItem('Last Week', '8 conversations'),
      ],
    );
  }

  Widget _buildHistoryItem(String period, String count) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      dense: true,
      leading: Icon(
        Icons.folder_outlined,
        color: isDark
            ? AppColors.primaryTextDark.withOpacity(0.7)
            : AppColors.primaryText.withOpacity(0.7),
      ),
      title: Text(
        period,
        style: AppTypography.bodySmall(
          color: isDark ? AppColors.primaryTextDark : AppColors.primaryText,
        ),
      ),
      subtitle: Text(
        count,
        style: AppTypography.caption(
          color: isDark
              ? AppColors.primaryTextDark.withOpacity(0.6)
              : AppColors.primaryText.withOpacity(0.6),
        ),
      ),
      onTap: () {
        // TODO: Show history for period
      },
    );
  }

  Widget _buildTasksList() {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final journey = appState.activeJourney;
        final currentTask = journey?.currentTask;

        return ListView(
          padding: const EdgeInsets.all(8),
          children: [
            if (currentTask != null) ...[
              _buildTaskItem(
                'Today\'s Practice',
                currentTask.title,
                currentTask.durationMinutes,
                false,
              ),
            ],
            _buildTaskItem('Morning Meditation', 'Completed', 10, true),
            _buildTaskItem('Gratitude Journal', 'Pending', 5, false),
            _buildTaskItem('Evening Reflection', 'Scheduled', 8, false),
          ],
        );
      },
    );
  }

  Widget _buildTaskItem(
    String category,
    String title,
    int duration,
    bool isCompleted,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: isCompleted
              ? AppColors.accentPositive.withOpacity(0.2)
              : AppColors.accentAction.withOpacity(0.2),
          child: Icon(
            isCompleted ? Icons.check : Icons.schedule,
            size: 16,
            color: isCompleted
                ? AppColors.accentPositive
                : AppColors.accentAction,
          ),
        ),
        title: Text(
          category,
          style: AppTypography.caption(
            color: isDark
                ? AppColors.primaryTextDark.withOpacity(0.7)
                : AppColors.primaryText.withOpacity(0.7),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.bodySmall(
                color: isDark
                    ? AppColors.primaryTextDark
                    : AppColors.primaryText,
              ),
            ),
            Text(
              '${duration}min',
              style: AppTypography.caption(
                color: isDark
                    ? AppColors.primaryTextDark.withOpacity(0.5)
                    : AppColors.primaryText.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 48,
              color: isDark
                  ? AppColors.primaryTextDark.withOpacity(0.3)
                  : AppColors.primaryText.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTypography.bodyMedium(
                color: isDark
                    ? AppColors.primaryTextDark.withOpacity(0.7)
                    : AppColors.primaryText.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: AppTypography.caption(
                color: isDark
                    ? AppColors.primaryTextDark.withOpacity(0.5)
                    : AppColors.primaryText.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }
}
