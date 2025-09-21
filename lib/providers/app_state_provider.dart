import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../models/journey.dart';
import '../models/mood_entry.dart';
import '../models/chat_message.dart';
import '../models/wellness_module.dart';

/// Central state management for Serene AI app
class AppStateProvider extends ChangeNotifier {
  // Theme management
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  // User data
  UserProfile? _userProfile;
  UserProfile? get userProfile => _userProfile;

  void setUserProfile(UserProfile profile) {
    _userProfile = profile;
    notifyListeners();
  }

  // Current journey
  Journey? _activeJourney;
  Journey? get activeJourney => _activeJourney;

  void setActiveJourney(Journey? journey) {
    _activeJourney = journey;
    notifyListeners();
  }

  // Mood tracking
  List<MoodEntry> _moodEntries = [];
  List<MoodEntry> get moodEntries => List.unmodifiable(_moodEntries);

  void addMoodEntry(MoodEntry entry) {
    _moodEntries.add(entry);
    _moodEntries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    notifyListeners();
  }

  MoodEntry? get latestMoodEntry =>
      _moodEntries.isNotEmpty ? _moodEntries.first : null;

  // Chat sessions
  final List<ChatSession> _chatSessions = [];
  List<ChatSession> get chatSessions => List.unmodifiable(_chatSessions);

  ChatSession? _currentChatSession;
  ChatSession? get currentChatSession => _currentChatSession;

  void startNewChatSession() {
    final session = ChatSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Chat ${_chatSessions.length + 1}',
      messages: [],
      createdAt: DateTime.now(),
      lastMessageAt: DateTime.now(),
    );
    _chatSessions.insert(0, session);
    _currentChatSession = session;
    notifyListeners();
  }

  void addMessageToCurrentSession(ChatMessage message) {
    if (_currentChatSession == null) {
      startNewChatSession();
    }

    final updatedMessages = List<ChatMessage>.from(
      _currentChatSession!.messages,
    )..add(message);

    final updatedSession = _currentChatSession!.copyWith(
      messages: updatedMessages,
      lastMessageAt: DateTime.now(),
    );

    _currentChatSession = updatedSession;
    final sessionIndex = _chatSessions.indexWhere(
      (s) => s.id == updatedSession.id,
    );
    if (sessionIndex != -1) {
      _chatSessions[sessionIndex] = updatedSession;
    }

    notifyListeners();
  }

  // Wellness modules
  List<WellnessModule> _wellnessModules = [];
  List<WellnessModule> get wellnessModules =>
      List.unmodifiable(_wellnessModules);

  void setWellnessModules(List<WellnessModule> modules) {
    _wellnessModules = modules;
    notifyListeners();
  }

  // Progress tracking
  UserProgress? _userProgress;
  UserProgress? get userProgress => _userProgress;

  void setUserProgress(UserProgress progress) {
    _userProgress = progress;
    notifyListeners();
  }

  void updateConsecutiveDays(int days) {
    if (_userProgress != null) {
      _userProgress = _userProgress!.copyWith(consecutiveDays: days);
      notifyListeners();
    }
  }

  // Initialize demo data
  void initializeDemoData() {
    // Create demo user profile
    _userProfile = UserProfile(
      id: 'demo_user',
      name: 'Alex',
      joinedAt: DateTime.now().subtract(const Duration(days: 30)),
      preferences: {
        'notifications': true,
        'reminderTime': '09:00',
        'preferredSessionLength': 10,
      },
      interests: ['mindfulness', 'stress relief', 'better sleep'],
    );

    // Create demo journey
    _activeJourney = Journey(
      id: 'mindfulness_journey_1',
      type: JourneyType.mindfulness,
      title: '7-Day Mindfulness Starter',
      description:
          'Begin your mindfulness journey with simple daily practices.',
      startedAt: DateTime.now().subtract(const Duration(days: 4)),
      currentDay: 5,
      tasks: [
        JourneyTask(
          id: 'task_1',
          title: '3-Minute Breathing Space',
          description: 'A simple breathing exercise to center yourself.',
          instructions:
              'Find a comfortable position and focus on your breath for 3 minutes.',
          durationMinutes: 3,
          dayNumber: 1,
          isCompleted: true,
          completedAt: DateTime.now().subtract(const Duration(days: 4)),
        ),
        JourneyTask(
          id: 'task_2',
          title: 'Body Scan Meditation',
          description: 'Connect with your body through mindful awareness.',
          instructions:
              'Lie down comfortably and slowly scan through each part of your body.',
          durationMinutes: 10,
          dayNumber: 2,
          isCompleted: true,
          completedAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        JourneyTask(
          id: 'task_3',
          title: 'Mindful Walking',
          description: 'Practice mindfulness while walking.',
          instructions:
              'Walk slowly and pay attention to each step and breath.',
          durationMinutes: 15,
          dayNumber: 3,
          isCompleted: true,
          completedAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        JourneyTask(
          id: 'task_4',
          title: 'Gratitude Reflection',
          description: 'Reflect on things you are grateful for.',
          instructions: 'Think of three things you are grateful for today.',
          durationMinutes: 5,
          dayNumber: 4,
          isCompleted: true,
          completedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        JourneyTask(
          id: 'task_5',
          title: 'Loving-Kindness Meditation',
          description: 'Send kind thoughts to yourself and others.',
          instructions:
              'Start with yourself, then extend loving-kindness to loved ones, neutral people, and all beings.',
          durationMinutes: 12,
          dayNumber: 5,
          isCompleted: false,
        ),
      ],
    );

    // Add some mood entries
    _moodEntries = [
      MoodEntry(
        id: 'mood_1',
        mood: MoodType.calm,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        intensity: 4,
        note: 'Feeling peaceful after meditation',
      ),
      MoodEntry(
        id: 'mood_2',
        mood: MoodType.grateful,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        intensity: 5,
        note: 'Had a wonderful day with family',
      ),
    ];

    // Initialize progress
    _userProgress = UserProgress(
      userId: 'demo_user',
      totalDaysActive: 5,
      consecutiveDays: 5,
      totalSessionsCompleted: 4,
      totalMindfulnessMinutes: 33,
      recentMoodEntries: _moodEntries,
      activeJourney: _activeJourney,
      lastActiveDate: DateTime.now(),
    );

    notifyListeners();
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    final name = _userProfile?.name ?? 'Friend';

    if (hour < 12) {
      return 'Good morning, $name';
    } else if (hour < 17) {
      return 'Good afternoon, $name';
    } else {
      return 'Good evening, $name';
    }
  }
}
