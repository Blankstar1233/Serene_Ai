/// Model for user's growth journey tasks and progress
enum JourneyType {
  mindfulness('Mindfulness Journey', '🧘‍♀️'),
  stressRelief('Stress Relief Journey', '🌱'),
  sleepImprovement('Better Sleep Journey', '🌙'),
  gratitudePractice('Gratitude Practice Journey', '🙏'),
  anxietyManagement('Anxiety Management Journey', '💚'),
  selfCompassion('Self-Compassion Journey', '🤗');

  const JourneyType(this.displayName, this.emoji);

  final String displayName;
  final String emoji;
}

/// Represents a single task within a journey
class JourneyTask {
  final String id;
  final String title;
  final String description;
  final String instructions;
  final int durationMinutes;
  final bool isCompleted;
  final DateTime? completedAt;
  final int dayNumber;

  const JourneyTask({
    required this.id,
    required this.title,
    required this.description,
    required this.instructions,
    required this.durationMinutes,
    this.isCompleted = false,
    this.completedAt,
    required this.dayNumber,
  });

  JourneyTask copyWith({
    String? id,
    String? title,
    String? description,
    String? instructions,
    int? durationMinutes,
    bool? isCompleted,
    DateTime? completedAt,
    int? dayNumber,
  }) {
    return JourneyTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      instructions: instructions ?? this.instructions,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      dayNumber: dayNumber ?? this.dayNumber,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'instructions': instructions,
      'durationMinutes': durationMinutes,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
      'dayNumber': dayNumber,
    };
  }

  factory JourneyTask.fromJson(Map<String, dynamic> json) {
    return JourneyTask(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      instructions: json['instructions'],
      durationMinutes: json['durationMinutes'],
      isCompleted: json['isCompleted'] ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      dayNumber: json['dayNumber'],
    );
  }
}

/// Represents a complete journey with multiple tasks
class Journey {
  final String id;
  final JourneyType type;
  final String title;
  final String description;
  final List<JourneyTask> tasks;
  final DateTime startedAt;
  final bool isActive;
  final int currentDay;

  const Journey({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.tasks,
    required this.startedAt,
    this.isActive = true,
    this.currentDay = 1,
  });

  int get completedTasksCount => tasks.where((task) => task.isCompleted).length;
  double get progress =>
      tasks.isEmpty ? 0.0 : completedTasksCount / tasks.length;

  JourneyTask? get currentTask {
    try {
      final incompleteTasks = tasks.where((task) => !task.isCompleted).toList();
      return incompleteTasks.isNotEmpty ? incompleteTasks.first : null;
    } catch (e) {
      return null;
    }
  }

  Journey copyWith({
    String? id,
    JourneyType? type,
    String? title,
    String? description,
    List<JourneyTask>? tasks,
    DateTime? startedAt,
    bool? isActive,
    int? currentDay,
  }) {
    return Journey(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      tasks: tasks ?? this.tasks,
      startedAt: startedAt ?? this.startedAt,
      isActive: isActive ?? this.isActive,
      currentDay: currentDay ?? this.currentDay,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'description': description,
      'tasks': tasks.map((task) => task.toJson()).toList(),
      'startedAt': startedAt.toIso8601String(),
      'isActive': isActive,
      'currentDay': currentDay,
    };
  }

  factory Journey.fromJson(Map<String, dynamic> json) {
    return Journey(
      id: json['id'],
      type: JourneyType.values.firstWhere((e) => e.name == json['type']),
      title: json['title'],
      description: json['description'],
      tasks: (json['tasks'] as List)
          .map((taskJson) => JourneyTask.fromJson(taskJson))
          .toList(),
      startedAt: DateTime.parse(json['startedAt']),
      isActive: json['isActive'] ?? true,
      currentDay: json['currentDay'] ?? 1,
    );
  }
}
