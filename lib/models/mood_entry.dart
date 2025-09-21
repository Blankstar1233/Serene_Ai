import 'package:flutter/material.dart';

/// Represents different mood states with associated colors and emojis
enum MoodType {
  happy('😊', 'Happy', Color(0xFFFFE066)),
  calm('😌', 'Calm', Color(0xFF82A0D8)),
  sad('😢', 'Sad', Color(0xFF87CEEB)),
  anxious('😰', 'Anxious', Color(0xFFDDA0DD)),
  energetic('⚡', 'Energetic', Color(0xFFFF6B6B)),
  neutral('😐', 'Neutral', Color(0xFFB0B0B0)),
  grateful('🙏', 'Grateful', Color(0xFF7DCEA0)),
  stressed('😵', 'Stressed', Color(0xFFFF9999));

  const MoodType(this.emoji, this.label, this.color);

  final String emoji;
  final String label;
  final Color color;
}

/// Model for tracking user's mood entries
class MoodEntry {
  final String id;
  final MoodType mood;
  final DateTime timestamp;
  final String? note;
  final int intensity; // 1-5 scale

  const MoodEntry({
    required this.id,
    required this.mood,
    required this.timestamp,
    this.note,
    required this.intensity,
  });

  MoodEntry copyWith({
    String? id,
    MoodType? mood,
    DateTime? timestamp,
    String? note,
    int? intensity,
  }) {
    return MoodEntry(
      id: id ?? this.id,
      mood: mood ?? this.mood,
      timestamp: timestamp ?? this.timestamp,
      note: note ?? this.note,
      intensity: intensity ?? this.intensity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mood': mood.name,
      'timestamp': timestamp.toIso8601String(),
      'note': note,
      'intensity': intensity,
    };
  }

  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      id: json['id'],
      mood: MoodType.values.firstWhere((e) => e.name == json['mood']),
      timestamp: DateTime.parse(json['timestamp']),
      note: json['note'],
      intensity: json['intensity'],
    );
  }
}
