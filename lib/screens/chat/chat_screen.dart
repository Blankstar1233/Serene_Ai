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

    // Responsive breakpoints
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;
    final isDesktop = screenWidth >= 1024;

    // Auto-collapse sidebar on mobile and tablet
    if (isMobile || isTablet) {
      _isSidebarCollapsed = true;
      _isProfileVisible = false;
    }

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.primaryBackgroundDark
          : AppColors.primaryBackground,
      body: Stack(
        children: [
          Row(
            children: [
              // Left Sidebar - Chat History & Sessions
              if (!isMobile || _isSidebarCollapsed)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _isSidebarCollapsed
                      ? (isMobile ? 0 : 60)
                      : (isMobile ? screenWidth * 0.8 : (isTablet ? 280 : 320)),
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
                    if (isMobile) {
                      // On mobile, show profile as modal
                      _showMobileProfileModal(context);
                    } else {
                      setState(() {
                        _isProfileVisible = !_isProfileVisible;
                      });
                    }
                  },
                ),
              ),

              // Right Sidebar - Profile & Settings (Desktop only)
              if (_isProfileVisible && isDesktop)
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

          // Mobile Sidebar Overlay
          if (isMobile && !_isSidebarCollapsed)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isSidebarCollapsed = true;
                  });
                },
                child: Container(
                  color: Colors.black54,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: screenWidth * 0.8,
                      height: double.infinity,
                      child: ChatSidebar(
                        isCollapsed: false,
                        onToggle: () {
                          setState(() {
                            _isSidebarCollapsed = !_isSidebarCollapsed;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showMobileProfileModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.primaryBackgroundDark
                : AppColors.primaryBackground,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ProfilePanel(
                  isVisible: true,
                  onClose: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
