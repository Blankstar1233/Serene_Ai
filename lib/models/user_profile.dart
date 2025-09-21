import 'mood_entry.dart';
import 'journey.dart';

/// Model for user profile and preferences
class UserProfile {
  final String id;
  final String name;
  final String? avatar;
  final DateTime joinedAt;
  final Map<String, dynamic> preferences;
  final List<String> interests;
  final String? timeZone;

  const UserProfile({
    required this.id,
    required this.name,
    this.avatar,
    required this.joinedAt,
    this.preferences = const {},
    this.interests = const [],
    this.timeZone,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? avatar,
    DateTime? joinedAt,
    Map<String, dynamic>? preferences,
    List<String>? interests,
    String? timeZone,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      joinedAt: joinedAt ?? this.joinedAt,
      preferences: preferences ?? this.preferences,
      interests: interests ?? this.interests,
      timeZone: timeZone ?? this.timeZone,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'joinedAt': joinedAt.toIso8601String(),
      'preferences': preferences,
      'interests': interests,
      'timeZone': timeZone,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      joinedAt: DateTime.parse(json['joinedAt']),
      preferences: json['preferences'] ?? {},
      interests: List<String>.from(json['interests'] ?? []),
      timeZone: json['timeZone'],
    );
  }
}

/// Model for user's overall progress and statistics
class UserProgress {
  final String userId;
  final int totalDaysActive;
  final int consecutiveDays;
  final int totalSessionsCompleted;
  final int totalMindfulnessMinutes;
  final List<MoodEntry> recentMoodEntries;
  final Journey? activeJourney;
  final List<Journey> completedJourneys;
  final Map<String, int> achievementCounts;
  final DateTime lastActiveDate;

  const UserProgress({
    required this.userId,
    this.totalDaysActive = 0,
    this.consecutiveDays = 0,
    this.totalSessionsCompleted = 0,
    this.totalMindfulnessMinutes = 0,
    this.recentMoodEntries = const [],
    this.activeJourney,
    this.completedJourneys = const [],
    this.achievementCounts = const {},
    required this.lastActiveDate,
  });

  UserProgress copyWith({
    String? userId,
    int? totalDaysActive,
    int? consecutiveDays,
    int? totalSessionsCompleted,
    int? totalMindfulnessMinutes,
    List<MoodEntry>? recentMoodEntries,
    Journey? activeJourney,
    List<Journey>? completedJourneys,
    Map<String, int>? achievementCounts,
    DateTime? lastActiveDate,
  }) {
    return UserProgress(
      userId: userId ?? this.userId,
      totalDaysActive: totalDaysActive ?? this.totalDaysActive,
      consecutiveDays: consecutiveDays ?? this.consecutiveDays,
      totalSessionsCompleted:
          totalSessionsCompleted ?? this.totalSessionsCompleted,
      totalMindfulnessMinutes:
          totalMindfulnessMinutes ?? this.totalMindfulnessMinutes,
      recentMoodEntries: recentMoodEntries ?? this.recentMoodEntries,
      activeJourney: activeJourney ?? this.activeJourney,
      completedJourneys: completedJourneys ?? this.completedJourneys,
      achievementCounts: achievementCounts ?? this.achievementCounts,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'totalDaysActive': totalDaysActive,
      'consecutiveDays': consecutiveDays,
      'totalSessionsCompleted': totalSessionsCompleted,
      'totalMindfulnessMinutes': totalMindfulnessMinutes,
      'recentMoodEntries': recentMoodEntries
          .map((entry) => entry.toJson())
          .toList(),
      'activeJourney': activeJourney?.toJson(),
      'completedJourneys': completedJourneys
          .map((journey) => journey.toJson())
          .toList(),
      'achievementCounts': achievementCounts,
      'lastActiveDate': lastActiveDate.toIso8601String(),
    };
  }

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      userId: json['userId'],
      totalDaysActive: json['totalDaysActive'] ?? 0,
      consecutiveDays: json['consecutiveDays'] ?? 0,
      totalSessionsCompleted: json['totalSessionsCompleted'] ?? 0,
      totalMindfulnessMinutes: json['totalMindfulnessMinutes'] ?? 0,
      recentMoodEntries:
          (json['recentMoodEntries'] as List?)
              ?.map((entryJson) => MoodEntry.fromJson(entryJson))
              .toList() ??
          [],
      activeJourney: json['activeJourney'] != null
          ? Journey.fromJson(json['activeJourney'])
          : null,
      completedJourneys:
          (json['completedJourneys'] as List?)
              ?.map((journeyJson) => Journey.fromJson(journeyJson))
              .toList() ??
          [],
      achievementCounts: Map<String, int>.from(json['achievementCounts'] ?? {}),
      lastActiveDate: DateTime.parse(json['lastActiveDate']),
    );
  }
}
