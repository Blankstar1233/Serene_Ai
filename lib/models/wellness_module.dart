/// Model for wellness modules and activities
enum ModuleCategory {
  breathing('Breathing Exercises', '🫁'),
  meditation('Meditation', '🧘‍♂️'),
  journaling('Journaling', '📝'),
  movement('Mindful Movement', '🤸‍♀️'),
  sleep('Sleep & Rest', '💤'),
  gratitude('Gratitude Practice', '🙏'),
  anxiety('Anxiety Relief', '💚'),
  stress('Stress Management', '🌱'),
  selfCare('Self-Care', '🤗');

  const ModuleCategory(this.displayName, this.emoji);

  final String displayName;
  final String emoji;
}

enum ModuleDifficulty {
  beginner('Beginner', 1),
  intermediate('Intermediate', 2),
  advanced('Advanced', 3);

  const ModuleDifficulty(this.label, this.level);

  final String label;
  final int level;
}

/// Represents a wellness module/activity
class WellnessModule {
  final String id;
  final String title;
  final String description;
  final ModuleCategory category;
  final ModuleDifficulty difficulty;
  final int durationMinutes;
  final List<String> benefits;
  final String instructions;
  final String? audioGuideUrl;
  final String? imageUrl;
  final bool isFavorite;
  final int completionCount;
  final double rating;
  final List<String> tags;

  const WellnessModule({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.durationMinutes,
    required this.benefits,
    required this.instructions,
    this.audioGuideUrl,
    this.imageUrl,
    this.isFavorite = false,
    this.completionCount = 0,
    this.rating = 0.0,
    this.tags = const [],
  });

  WellnessModule copyWith({
    String? id,
    String? title,
    String? description,
    ModuleCategory? category,
    ModuleDifficulty? difficulty,
    int? durationMinutes,
    List<String>? benefits,
    String? instructions,
    String? audioGuideUrl,
    String? imageUrl,
    bool? isFavorite,
    int? completionCount,
    double? rating,
    List<String>? tags,
  }) {
    return WellnessModule(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      benefits: benefits ?? this.benefits,
      instructions: instructions ?? this.instructions,
      audioGuideUrl: audioGuideUrl ?? this.audioGuideUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      completionCount: completionCount ?? this.completionCount,
      rating: rating ?? this.rating,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.name,
      'difficulty': difficulty.name,
      'durationMinutes': durationMinutes,
      'benefits': benefits,
      'instructions': instructions,
      'audioGuideUrl': audioGuideUrl,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
      'completionCount': completionCount,
      'rating': rating,
      'tags': tags,
    };
  }

  factory WellnessModule.fromJson(Map<String, dynamic> json) {
    return WellnessModule(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: ModuleCategory.values.firstWhere(
        (e) => e.name == json['category'],
      ),
      difficulty: ModuleDifficulty.values.firstWhere(
        (e) => e.name == json['difficulty'],
      ),
      durationMinutes: json['durationMinutes'],
      benefits: List<String>.from(json['benefits']),
      instructions: json['instructions'],
      audioGuideUrl: json['audioGuideUrl'],
      imageUrl: json['imageUrl'],
      isFavorite: json['isFavorite'] ?? false,
      completionCount: json['completionCount'] ?? 0,
      rating: json['rating']?.toDouble() ?? 0.0,
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
}
