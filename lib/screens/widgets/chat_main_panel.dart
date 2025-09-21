import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/chat_message.dart';
import 'dart:math' as math;

/// Main chat panel with messages and voice features
class ChatMainPanel extends StatefulWidget {
  final bool isVoiceModeActive;
  final VoidCallback onVoiceModeToggle;
  final VoidCallback onProfileToggle;

  const ChatMainPanel({
    super.key,
    required this.isVoiceModeActive,
    required this.onVoiceModeToggle,
    required this.onProfileToggle,
  });

  @override
  State<ChatMainPanel> createState() => _ChatMainPanelState();
}

class _ChatMainPanelState extends State<ChatMainPanel>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _voiceAnimationController;
  late AnimationController _pulseAnimationController;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _voiceAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _voiceAnimationController.dispose();
    _pulseAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.primaryBackgroundDark
            : AppColors.primaryBackground,
      ),
      child: Column(
        children: [
          // Top bar
          _buildTopBar(),

          // Chat messages or voice interface
          Expanded(
            child: widget.isVoiceModeActive
                ? _buildVoiceInterface()
                : _buildChatInterface(),
          ),

          // Input area
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      height: isMobile ? 56 : 60,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 20),
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
      child: SafeArea(
        child: Row(
          children: [
            // Menu button for mobile sidebar
            if (isMobile)
              IconButton(
                onPressed: () {
                  // This will be handled by the parent chat screen
                  // We need to pass this action up
                },
                icon: Icon(
                  Icons.menu,
                  color: isDark
                      ? AppColors.primaryTextDark
                      : AppColors.primaryText,
                ),
                iconSize: 24,
              ),

            // AI Status - compact on mobile
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 8 : 12,
                vertical: isMobile ? 4 : 6,
              ),
              decoration: BoxDecoration(
                color: AppColors.accentPositive.withOpacity(0.1),
                borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: isMobile ? 6 : 8,
                    height: isMobile ? 6 : 8,
                    decoration: const BoxDecoration(
                      color: AppColors.accentPositive,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: isMobile ? 6 : 8),
                  Text(
                    isMobile ? 'Online' : 'AI Online',
                    style: AppTypography.caption(
                      color: AppColors.accentPositive,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Session info - shortened on mobile
            if (!isMobile)
              Text(
                'Wellness Session',
                style: AppTypography.h5(
                  color: isDark
                      ? AppColors.primaryTextDark
                      : AppColors.primaryText,
                ),
              )
            else
              Text(
                'Serene AI',
                style: AppTypography.h5(
                  color: isDark
                      ? AppColors.primaryTextDark
                      : AppColors.primaryText,
                ),
              ),

            const Spacer(),

            // Voice mode toggle
            IconButton(
              onPressed: () {
                widget.onVoiceModeToggle();
                if (widget.isVoiceModeActive) {
                  _voiceAnimationController.repeat();
                  _pulseAnimationController.repeat();
                } else {
                  _voiceAnimationController.stop();
                  _pulseAnimationController.stop();
                }
              },
              icon: Icon(
                widget.isVoiceModeActive ? Icons.keyboard : Icons.mic,
                color: widget.isVoiceModeActive
                    ? AppColors.accentPrimary
                    : (isDark
                          ? AppColors.primaryTextDark
                          : AppColors.primaryText),
              ),
              iconSize: isMobile ? 22 : 24,
            ),

            // Profile toggle
            IconButton(
              onPressed: widget.onProfileToggle,
              icon: Icon(
                Icons.person,
                color: isDark
                    ? AppColors.primaryTextDark
                    : AppColors.primaryText,
              ),
              iconSize: isMobile ? 22 : 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatInterface() {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final currentSession = appState.currentChatSession;
        final messages = currentSession?.messages ?? [];

        if (messages.isEmpty) {
          return _buildWelcomeMessage();
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(20),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return _buildMessageBubble(messages[index]);
          },
        );
      },
    );
  }

  Widget _buildVoiceInterface() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Voice visualization
          AnimatedBuilder(
            animation: _pulseAnimationController,
            builder: (context, child) {
              return Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accentPrimary.withOpacity(0.1),
                  border: Border.all(
                    color: AppColors.accentPrimary.withOpacity(
                      0.3 + 0.7 * _pulseAnimationController.value,
                    ),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: AnimatedBuilder(
                    animation: _voiceAnimationController,
                    builder: (context, child) {
                      return CustomPaint(
                        size: const Size(120, 60),
                        painter: VoiceWaveformPainter(
                          animationValue: _voiceAnimationController.value,
                          color: AppColors.accentPrimary,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 40),

          // Voice status
          Text(
            'Listening...',
            style: AppTypography.h3(
              color: isDark ? AppColors.primaryTextDark : AppColors.primaryText,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            'Speak naturally with your AI wellness companion',
            style: AppTypography.bodyMedium(
              color: isDark
                  ? AppColors.primaryTextDark.withOpacity(0.7)
                  : AppColors.primaryText.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 40),

          // Voice controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildVoiceControlButton(
                Icons.mic_off,
                'Mute',
                AppColors.accentAction.withOpacity(0.7),
                () {
                  // TODO: Mute microphone
                },
              ),
              const SizedBox(width: 20),
              _buildVoiceControlButton(
                Icons.stop,
                'Stop',
                AppColors.accentAction,
                () {
                  widget.onVoiceModeToggle();
                  _voiceAnimationController.stop();
                  _pulseAnimationController.stop();
                },
              ),
              const SizedBox(width: 20),
              _buildVoiceControlButton(
                Icons.volume_up,
                'Speaker',
                AppColors.accentPrimary,
                () {
                  // TODO: Toggle speaker
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceControlButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback onPressed,
  ) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 1),
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(icon, color: color),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: AppTypography.caption(color: color)),
      ],
    );
  }

  Widget _buildWelcomeMessage() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.accentPrimary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.psychology,
                size: 40,
                color: AppColors.accentPrimary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Hello! I\'m your AI wellness companion',
              style: AppTypography.h3(
                color: isDark
                    ? AppColors.primaryTextDark
                    : AppColors.primaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'I\'m here to support your mental wellness journey. You can chat with me using text or voice - whatever feels more comfortable for you.',
              style: AppTypography.bodyMedium(
                color: isDark
                    ? AppColors.primaryTextDark.withOpacity(0.8)
                    : AppColors.primaryText.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _buildSuggestionChip('How are you feeling today?'),
                _buildSuggestionChip('Start a mindfulness session'),
                _buildSuggestionChip('Help me manage stress'),
                _buildSuggestionChip('Tell me about my progress'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        _messageController.text = text;
        _sendMessage();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.secondaryElementDark
              : AppColors.secondaryElement,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppColors.dividerDark : AppColors.divider,
          ),
        ),
        child: Text(
          text,
          style: AppTypography.bodySmall(
            color: isDark ? AppColors.primaryTextDark : AppColors.primaryText,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isUser = message.type == MessageType.user;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.accentPrimary.withOpacity(0.2),
              child: const Icon(
                Icons.psychology,
                size: 16,
                color: AppColors.accentPrimary,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser
                    ? AppColors.accentPrimary
                    : (isDark
                          ? AppColors.secondaryElementDark
                          : AppColors.secondaryElement),
                borderRadius: BorderRadius.circular(18).copyWith(
                  bottomLeft: isUser
                      ? const Radius.circular(18)
                      : const Radius.circular(4),
                  bottomRight: isUser
                      ? const Radius.circular(4)
                      : const Radius.circular(18),
                ),
                border: !isUser
                    ? Border.all(
                        color: isDark
                            ? AppColors.dividerDark
                            : AppColors.divider,
                        width: 1,
                      )
                    : null,
              ),
              child: Text(
                message.content,
                style: AppTypography.bodyMedium(
                  color: isUser
                      ? Colors.white
                      : (isDark
                            ? AppColors.primaryTextDark
                            : AppColors.primaryText),
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.accentPositive.withOpacity(0.2),
              child: const Icon(
                Icons.person,
                size: 16,
                color: AppColors.accentPositive,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.secondaryElementDark
            : AppColors.secondaryElement,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.dividerDark : AppColors.divider,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Attachment button (hidden on mobile when typing to save space)
            if (!isMobile || !_isTyping)
              IconButton(
                onPressed: () {
                  // TODO: Handle attachments
                },
                icon: Icon(
                  Icons.attach_file,
                  color: isDark
                      ? AppColors.primaryTextDark.withOpacity(0.7)
                      : AppColors.primaryText.withOpacity(0.7),
                ),
                iconSize: isMobile ? 24 : 24,
              ),

            // Text input
            Expanded(
              child: Container(
                constraints: BoxConstraints(
                  minHeight: isMobile ? 44 : 48, // Minimum touch target
                  maxHeight: isMobile ? 120 : 200, // Prevent overflow
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.primaryBackgroundDark
                      : AppColors.primaryBackground,
                  borderRadius: BorderRadius.circular(isMobile ? 20 : 24),
                  border: Border.all(
                    color: isDark ? AppColors.dividerDark : AppColors.divider,
                  ),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: isMobile
                        ? 'Message...'
                        : 'Message your AI companion...',
                    hintStyle: AppTypography.bodyMedium(
                      color: isDark
                          ? AppColors.primaryTextDark.withOpacity(0.5)
                          : AppColors.primaryText.withOpacity(0.5),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 16 : 20,
                      vertical: isMobile ? 10 : 12,
                    ),
                  ),
                  style: AppTypography.bodyMedium(
                    color: isDark
                        ? AppColors.primaryTextDark
                        : AppColors.primaryText,
                  ),
                  maxLines: isMobile ? 3 : null, // Limit lines on mobile
                  textInputAction: TextInputAction.send,
                  onChanged: (text) {
                    setState(() {
                      _isTyping = text.isNotEmpty;
                    });
                  },
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),

            SizedBox(width: isMobile ? 8 : 8),

            // Send/Voice button with larger touch target on mobile
            Container(
              width: isMobile ? 44 : 48,
              height: isMobile ? 44 : 48,
              decoration: BoxDecoration(
                color: _isTyping
                    ? AppColors.accentPrimary
                    : AppColors.accentAction,
                shape: BoxShape.circle,
                boxShadow: isMobile
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: IconButton(
                onPressed: _isTyping ? _sendMessage : _startVoiceInput,
                icon: Icon(
                  _isTyping ? Icons.send : Icons.mic,
                  color: Colors.white,
                  size: isMobile ? 20 : 20,
                ),
                splashRadius: isMobile ? 22 : 24, // Better touch feedback
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: _messageController.text.trim(),
      type: MessageType.user,
      timestamp: DateTime.now(),
    );

    context.read<AppStateProvider>().addMessageToCurrentSession(message);

    _messageController.clear();
    setState(() {
      _isTyping = false;
    });

    // Simulate AI response
    Future.delayed(const Duration(milliseconds: 1500), () {
      final aiResponse = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: _generateAIResponse(message.content),
        type: MessageType.ai,
        timestamp: DateTime.now(),
      );

      context.read<AppStateProvider>().addMessageToCurrentSession(aiResponse);

      // Auto-scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    });
  }

  void _startVoiceInput() {
    widget.onVoiceModeToggle();
    _voiceAnimationController.repeat();
    _pulseAnimationController.repeat();
  }

  String _generateAIResponse(String userMessage) {
    // Simple AI response simulation
    final responses = [
      "I understand how you're feeling. Let's work through this together.",
      "That's a great question! Based on your wellness journey, I'd suggest trying a short breathing exercise.",
      "I'm here to support you. Your mental health is important, and taking time for self-care is wonderful.",
      "It sounds like you're making good progress. Remember, small steps lead to big changes.",
      "Thank you for sharing that with me. How would you like to explore this feeling further?",
    ];

    return responses[math.Random().nextInt(responses.length)];
  }
}

/// Custom painter for voice waveform visualization
class VoiceWaveformPainter extends CustomPainter {
  final double animationValue;
  final Color color;

  VoiceWaveformPainter({required this.animationValue, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final centerY = size.height / 2;
    final barCount = 20;
    final barWidth = size.width / barCount;

    for (int i = 0; i < barCount; i++) {
      final normalizedIndex = i / (barCount - 1);
      final frequency = 2 + i * 0.5;
      final amplitude =
          math.sin(
            animationValue * 2 * math.pi * frequency +
                normalizedIndex * math.pi,
          ) *
          (0.3 +
              0.7 *
                  math.sin(
                    animationValue * 2 * math.pi + normalizedIndex * 4,
                  )) *
          (size.height * 0.4);

      final x = i * barWidth + barWidth / 2;
      final startY = centerY - amplitude.abs();
      final endY = centerY + amplitude.abs();

      canvas.drawLine(Offset(x, startY), Offset(x, endY), paint);
    }
  }

  @override
  bool shouldRepaint(VoiceWaveformPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
