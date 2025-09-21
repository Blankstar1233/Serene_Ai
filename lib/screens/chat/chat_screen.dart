import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/chat_sidebar.dart';
import '../widgets/chat_main_panel.dart';
import '../widgets/profile_panel.dart';
import '../../services/audio_recording_service.dart';
import '../../services/elevenlabs_service.dart';

/// Advanced chat screen with three-panel layout and speech-to-text
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isVoiceModeActive = false;
  bool _isSidebarCollapsed = false;
  bool _isProfileVisible = true;
  bool _isRecording = false;
  bool _isTranscribing = false;
  String? _transcribedText;

  @override
  void initState() {
    super.initState();
    // Initialize ElevenLabs API key on app start
    ElevenLabsService.initializeApiKey();
  }

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
                  isRecording: _isRecording,
                  isTranscribing: _isTranscribing,
                  transcribedText: _transcribedText,
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
                  onStartRecording: _startRecording,
                  onStopRecording: _stopRecording,
                  onTranscriptionReceived: _onTranscriptionReceived,
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

  /// Start audio recording
  Future<void> _startRecording() async {
    try {
      setState(() {
        _isRecording = true;
      });

      final success = await AudioRecordingService.startRecording();
      if (!success) {
        setState(() {
          _isRecording = false;
        });
        _showErrorSnackBar(
          'Failed to start recording. Please check microphone permissions.',
        );
      } else {
        _showInfoSnackBar('Recording started... Release to stop');
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
      _showErrorSnackBar('Error starting recording: $e');
    }
  }

  /// Stop recording and process transcription
  Future<void> _stopRecording() async {
    try {
      setState(() {
        _isRecording = false;
        _isTranscribing = true;
      });

      _showInfoSnackBar('Processing transcription...');

      final recordingPath = await AudioRecordingService.stopRecording();

      if (recordingPath != null) {
        // Send to ElevenLabs for transcription
        final result = await ElevenLabsService.speechToText(recordingPath);

        if (result.isSuccess && result.text != null) {
          // Set transcribed text to pass to ChatMainPanel
          setState(() {
            _transcribedText = result.text!;
          });
          _showSuccessSnackBar('Transcription completed successfully');
        } else {
          _showErrorSnackBar(result.error ?? 'Transcription failed');
        }

        // Clean up the temporary audio file
        await AudioRecordingService.cleanupRecording(recordingPath);
      } else {
        _showErrorSnackBar('No recording found to transcribe');
      }
    } catch (e) {
      _showErrorSnackBar('Error processing recording: $e');
    } finally {
      setState(() {
        _isTranscribing = false;
      });
    }
  }

  /// Handle transcription result
  void _onTranscriptionReceived(String text) {
    // Clear transcribed text after it's been used
    setState(() {
      _transcribedText = null;
    });
  }

  /// Show success message
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.accentPositive,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Show info message
  void _showInfoSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.accentPrimary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Show error message
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.accentNegative,
        duration: const Duration(seconds: 3),
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
