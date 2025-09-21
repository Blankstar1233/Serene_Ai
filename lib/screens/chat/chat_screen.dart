import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/chat_sidebar.dart';
import '../widgets/chat_main_panel.dart';
import '../widgets/profile_panel.dart';

/// Advanced chat screen with three-panel layout
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isVoiceModeActive = false;
  bool _isSidebarCollapsed = false;
  bool _isProfileVisible = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.primaryBackgroundDark
          : AppColors.primaryBackground,
      body: Row(
        children: [
          // Left Sidebar - Chat History & Sessions
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _isSidebarCollapsed ? 60 : 320,
            child: ChatSidebar(
              isCollapsed: _isSidebarCollapsed,
              onToggle: () {
                setState(() {
                  _isSidebarCollapsed = !_isSidebarCollapsed;
                });
              },
            ),
          ),

          // Main Chat Area
          Expanded(
            child: ChatMainPanel(
              isVoiceModeActive: _isVoiceModeActive,
              onVoiceModeToggle: () {
                setState(() {
                  _isVoiceModeActive = !_isVoiceModeActive;
                });
              },
              onProfileToggle: () {
                setState(() {
                  _isProfileVisible = !_isProfileVisible;
                });
              },
            ),
          ),

          // Right Sidebar - Profile & Settings
          if (_isProfileVisible && screenWidth > 1000)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 300,
              child: ProfilePanel(
                isVisible: _isProfileVisible,
                onClose: () {
                  setState(() {
                    _isProfileVisible = false;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}
